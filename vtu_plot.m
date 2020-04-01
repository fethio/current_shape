%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
%vvvvvvvvvvvvvvvvvvv Plot From The Result of .vtu Reads vvvvvvvvvvvvvvvvvvv
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

beam_nz = 9; % number of nodes on the base beam on "y" direction
beam_nx = 81;% number of nodes on the base beam on "x" direction
beam_np = beam_nz*beam_nx;  % total number of nodes on the base beam
%file_nm = 'feap_paraview5_7_18.vtu';% pview file name to import

%[result] = readf_vtu(file_nm);	% pview file name to import

nodes_a = reshape(result{1,2},3,size(result{1,2},2)/3);     % 3 direction
% displ_c = reshape(result{5,2},6,size(result{5,2},2)/6);     % 6 freedom
allst_r = reshape(result{6,2},24,size(result{6,2},2)/24);   % at 20 sgm_11

beam_nd(:,:,1) = reshape(nodes_a(1,1:beam_np),beam_nx,beam_nz); % p_x
% beam_nd(:,:,2) = reshape(nodes_a(2,1:beam_np),beam_nx,beam_nz); % p_y
beam_nd(:,:,3) = reshape(nodes_a(3,1:beam_np),beam_nx,beam_nz); % p_z

% beam_ds(:,:,1) = reshape(displ_c(1,1:beam_np),beam_nx,beam_nz); % s_x
% beam_ds(:,:,2) = reshape(displ_c(2,1:beam_np),beam_nx,beam_nz); % s_y
% beam_ds(:,:,3) = reshape(displ_c(3,1:beam_np),beam_nx,beam_nz); % s_z

beam_st(:,:,1) = reshape(allst_r(20,1:beam_np),beam_nx,beam_nz); % sgm_11
% beam_st(:,:,2) = reshape(allst_r(21,1:beam_np),beam_nx,beam_nz); % sgm_22
% beam_st(:,:,3) = reshape(allst_r(22,1:beam_np),beam_nx,beam_nz); % sgm_12

%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

% figure; hold on; grid; set(gca,'CameraPosition',[819,-75,254])
% plot3(nodes_a(3,:),nodes_a(1,:),nodes_a(2,:),'r.') % For all nodes
% quiver3(nodes_a(3,:),nodes_a(1,:),nodes_a(2,:),...
%     displ_c(3,:),displ_c(1,:),displ_c(2,:),1) % For all nodes
% pcolor(beam_nd(:,:,3),beam_nd(:,:,1),beam_st(:,:,1)); %specific to the beam
% xlabel('z'),ylabel('x'),zlabel('y'), % (lcolorbar('st_11'))<<not working  
% title('plot for all nodes and contour for the beam') %<-code will edit here

%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
ord_fix = @(x)(x([1,2,4,3])); % 2D to 1D for area base any averaging ops.
beam_ez = beam_nz-1; % number of elm. on the base beam on "y" direction
beam_ex = beam_nx-1; % number of elm. on the base beam on "x" direction
beam_ne = beam_ez*beam_ex;  % total number of elm. on the base beam
total_area = 0; total_astr = 0; max_stress = 0; % initialize those
e_sum_dist = 0; % the simpler dist.cal. for the stress mean on the region.
aa_cal_are = 0; aa_cal_str = 0; % to use with "area_avg_calculator"
for ix = 1:(floor(beam_ex*0.8)) % >>> remember it is for the first %80 !!!
    for iz = 1:beam_ez
        cr_x = ord_fix(beam_nd(ix:(ix+1),iz:(iz+1),1));
        cr_z = ord_fix(beam_nd(ix:(ix+1),iz:(iz+1),3));
        st_1 = ord_fix(beam_st(ix:(ix+1),iz:(iz+1),1));
%         %e_dist = 0; % for the simpler dist.cal.
        for ip = 1:4 % direction depented poly area for 4 point
%             ip_area = (cr_x(ip)*cr_z(1+mod(ip,4))-...
%                 cr_x(1+mod(ip,4))*cr_z(ip))/2; % Nth poly area algorithm
%             ip_astr = (st_1(ip)+st_1(1+mod(ip,4)))/2;% >> Check this << !!!
            max_stress = max(abs(st_1(ip)),max_stress);
%             total_astr = total_astr + ip_area*ip_astr;
%             total_area = total_area + ip_area;
%             %e_dist = e_dist + st_1(ip);     % for the simpler dist.cal.
        end %end of poly run_
%         e_sum_dist = e_sum_dist + mean(st_1); % for the simpler dist.cal.
        [n_area,n_avgs] = area_avg_calculator...
            (cr_x(1),cr_z(1),st_1(1),cr_x(2),cr_z(2),st_1(2),...
            cr_x(3),cr_z(3),st_1(3),cr_x(4),cr_z(4),st_1(4));
        aa_cal_str = aa_cal_str + n_area*n_avgs;
        aa_cal_are = aa_cal_are + n_area;
    end %end of z_
end; e_sum_dist = e_sum_dist/(ix*iz); %end of x_ !!CAUTION!! "for ix * iz".
% mean_astrs = total_astr/total_area; % find the mean stress
% title(['Nodes&Disps, contour is ply-str and sum-str and cal-str = ',char(26),...
%     num2str(mean_astrs/max_stress),' or ',num2str(e_sum_dist/max_stress),...
%     ' or ',num2str((aa_cal_str/aa_cal_are)/max_stress)])
%>>>(aa_cal_str/aa_cal_are)/max_stress
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
% Component Value Description Number Name
% 1 N11 Membrane normal force/unit length
% 2 N22 Membrane normal force/unit length
% 3 N12 Membrane shear force/unit length
% 4 N1 Membrane 1-principal force/unit length
% 5 N2 Membrane 2-principal force/unit length
% 6 M11 Normal bending moment/unit length
% 7 M22 Normal bending moment/unit length
% 8 M12 Shear twist moment/unit length
% 9 M1 1-Principal bending moment/unit length
% 10 M2 2-Principal bending moment/unit length
% 11 11 Normal membrane strain
% 12 22 Normal membrane strain
% 13 12 Shear membrane strain
% 14 11 Normal bending curvature
% 15 22 Normal bending curvature
% 16 12 Shear bending twist
% 17 11 Normal stress at top
% 18 22 Normal stress at top
% 19 12 Shear stress at top
% 20 11 Normal stress at bottom
% 21 22 Normal stress at bottom
% 22 12 Shear stress at bottom
% 23 j1j Maximum 1-principal stress top & bottom
% 24 j2j Minimum 2-principal stress top & bottom
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
