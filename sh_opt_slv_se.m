%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

% After you make all arrangements, you should type the following command at the command window:
% fminsearch(@sh_opt_slv_se_3_2,opt_prms,optimset('disp','iter'))
% opt_prms is a 3x1 vector of initial optimization parameters, 
% example: opt_prms = [0.5,0.5,0.5];

function dist_astrsd = sh_opt_slv_se(opt_prms)
if nargin<1
    opt_prms = [0.5,0.5,0.5];
end
%opt_prms = abs(opt_prms);   % !
opt_prms = opt_prms - 0.5;
opt_prms(1) = opt_prms(1);
opt_prms(2) = opt_prms(2)*100;
opt_prms(3) = opt_prms(3)*0.5;
damping_eta = 0.05;
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
shape_file = 'BASE640V2'; % Filename for MESH
eig_f_file = 'Ibase_single640se'; % Filename for modal analysis
cxsol_file = 'Ibase_single640s'; % Filename for harmonic response

shp_fun = @(x)(1-sign(opt_prms(1))*(x/(210+opt_prms(2))).^(0.5+opt_prms(3)));
wfilename = fun_sh_mod_se(shape_file,shp_fun); 
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
% Location of shared folder between host system (Windows) and virtual machine (Linux) 
shf_win = 'D:\Work_folder\virtual_share\input_feb17\'; % Sharef folder location (host)
shf_lin = '/media/sf_virtual_share/input_feb17/'; % Shared folder location (VM)
thi_fnm = 'n_tmp'; % Location of the solution folder, which is located in the shared folder.

load('del_list3.mat') % Delete previous FEAP data, to avoid errors.

for i = 1:12    % there are 10 predefined file created by feap.
    delete([shf_win,thi_fnm,'\',del_list(i,:)])
end; pause(0.1) % wait for folder sync.
copyfile(['w',shape_file],[shf_win,thi_fnm,'\',['w',shape_file]]);pause(0.1)

% Try loading the tip mass value (feap_prm.mat). If such a file does not exist, set the mass as 7 gr:
try load('feap_prm.mat'), catch, feap_prm.m = 7e-3; end % m holds for mass
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
% Connection to FEAP via Matfeap to find eigenvalues:
p_tmp = feapstart([shf_lin,thi_fnm,'/Ibase_single640se'],feap_prm);
feapquit(p_tmp)	%feapcmd(p_tmp,'eigv,1'),
eigenvalue = readf_eig([shf_win,thi_fnm,'\','Obase_single640se']);
delete([shf_win,thi_fnm,'\feapname']);pause(0.1)
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
% Connection to FEAP via Matfeap to find harmonic response at 102% of resonance freq:
p_tmp = feapstart([shf_lin,thi_fnm,'/Ibase_single640s'],feap_prm);

feapcmd(p_tmp,['CXSOLve,,',num2str(eigenvalue*2*pi*1.02),',',num2str(damping_eta)])
feapcmd(p_tmp,'pvie')
% pview file name with full file address to import
[result] = readf_vtu([shf_win,thi_fnm,'\','feap_paraview.vtu']);% p. import
vtu_plot % Obtaining the stress distribution from the results file

dist_astrsd = -abs((aa_cal_str/aa_cal_are)/max_stress); %via vtu_plot

% Harmonic response at 98% of resonance freq:
feapcmd(p_tmp,['CXSOLve,,',num2str(eigenvalue*2*pi*0.98),',',num2str(damping_eta)])
feapcmd(p_tmp,'pvie')
% pview file name with full dile address to import
[result] = readf_vtu([shf_win,thi_fnm,'\','feap_paraview.vtu']);% p. import
vtu_plot % Obtaining the stress distribution from the results file

dist_astrsd = dist_astrsd-abs((aa_cal_str/aa_cal_are)/max_stress); %via vtu_plot_4_so

%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
% The result at resonance is the arithmetic mean of the result at wn*1.02 and wn*0.98:
dist_astrsd = dist_astrsd/2;    feapquit(p_tmp) 
save('last_op_srch','dist_astrsd','opt_prms','eigenvalue','result')


