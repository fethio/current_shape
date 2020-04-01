%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
%vv Calls for sh_opt_slv_se in fminsearch with different mass values vv
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
mt_list = [0,1,2.5,5,10,20,50]*1e-3; % List of tip masses
for i=1:size(mt_list,2)
    sv_names = ['sh_opt_res_',num2str(i)];
    feap_prm.m = mt_list(i); tic	% m holds for mass in feap inpput file.
    save('feap_prm','feap_prm'),	opt_prms = [0.5,0.5,0.5]; %to run opts.
    try
        fminsearch(@sh_opt_slv_se,opt_prms,optimset('disp','iter'))%,'MaxFunEvals',3))
    catch
        load('last_op_srch.mat'),warning('Second try')
        fminsearch(@sh_opt_slv_se,opt_prms,optimset('disp','iter'))%,'MaxFunEvals',3))
    end;	load('last_op_srch.mat')
    save(sv_names,'dist_astrsd','opt_prms','eigenvalue','result')
    disp(['Opt; ',num2str(i),'/',num2str(size(mt_list,2)),' solved']); toc
end, % vtu_plot_4_se
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
for i=1:size(mt_list,2) % Second part to estimate rct and tri vals
    feap_prm.m = mt_list(i); tic	% m holds for mass in feap inpput file.    
    sv_names = ['sh_tria_res_',num2str(i)];    
    save('feap_prm','feap_prm'),	opt_prms = [1.5,0.5,1.5]; %to run opts.
    sh_opt_slv_se_3_2(opt_prms),    load('last_op_srch.mat')
    save(sv_names,'dist_astrsd','opt_prms','eigenvalue','result')
    sv_names = ['sh_rct_res_',num2str(i)];
    save('feap_prm','feap_prm'),	opt_prms = [0.5,0.5,0.5]; %to run opts.
    sh_opt_slv_se_3_2(opt_prms),    load('last_op_srch.mat')
    save(sv_names,'dist_astrsd','opt_prms','eigenvalue','result')
    disp(['rctr; ',num2str(i),'/',num2str(size(mt_list,2)),' solved']); toc
end, % vtu_plot_4_se
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
tbl_nms = {'Tip mass','Opt dist','Eig1 hz','Tria dist','Rct dist',...
    'Tria eig1','Rct eig1','Opt_(1)','Opt_(2)','Opt_(3)'}'; %,'The_func'}';
res_tbls = cell(size(tbl_nms,1),size(mt_list,2)); res_tbls(:,1) = tbl_nms;
for i=1:size(mt_list,2)
    sv_names = ['sh_opt_res_',num2str(i)];
    load(sv_names,'dist_astrsd','opt_prms','eigenvalue','result')
    % vtu_plot % eigenvalue, disp(num2str(dist_astrsd))
    res_tbls{1,i+1} = mt_list(i);
    res_tbls{2,i+1} = dist_astrsd;
    res_tbls{3,i+1} = eigenvalue;
    res_tbls{8,i+1} = opt_prms(1);
    res_tbls{9,i+1} = opt_prms(2);
    res_tbls{10,i+1} = opt_prms(3);
    %res_tbls{10,i+1} = @(x)(1-sign(opt_prms(1))*(x/(210+opt_prms(2))).^(0.5+opt_prms(3)));
    load(['sh_tria_res_',num2str(i)],'dist_astrsd','eigenvalue','result')
    res_tbls{4,i+1} = dist_astrsd;  res_tbls{6,i+1} = eigenvalue;
    load(['sh_rct_res_',num2str(i)],'dist_astrsd','eigenvalue','result')
    res_tbls{5,i+1} = dist_astrsd;	res_tbls{7,i+1} = eigenvalue;
end,res_tbls, % vtu_plot_4_se
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
shape_spc = []; % lgnds_spc = [];
for i=1:size(mt_list,2)
    opt_prms = cell2mat(res_tbls(8:10,i+1));
    shp_fun = @(x)(1-sign(opt_prms(1))*(x/(210+opt_prms(2))).^(0.5+opt_prms(3)));
    shape_spc = [shape_spc,shp_fun(0:200)'];
end,figure; hold on; grid;  % > i < is being reused in ploting below !
plot([meshgrid(0:200,1:i),meshgrid(0:200,1:i)]',20*[shape_spc;-shape_spc],'.')
legend(num2str(cell2mat(res_tbls(1,2:end)')))
xlabel('X (mm)'),ylabel('Y (mm)'),title('OPT shape plots with tipmass (Kg)')
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
