%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
function wfilename = fun_sh_mod_se(filename,shp_fun)
if nargin<1
    filename = 'vBASE40'; % load one unit mesh
    shp_fun = @(x)(1-(x/110).^0.5);   % Any assured contour function
end
[node,genn,varx,vary,varz] = import_feap_mesh_3x13_se(filename);%, 2, num_np+1);
node_spc = (1:size(node,1))';
node_sel = ~(node == node_spc);
the_node = node_spc(node_sel);  % the first element is not included
num_np = the_node(1)-1;%n_end set

qxx = varx(1:num_np);
qzz = vary(1:num_np);
qyy = varz(1:num_np);
unit_mesh = [qyy,qzz,qxx];

if nargout<1
    figure; grid; hold on
    xlabel('x'),ylabel('y'),zlabel('z')
    plot3(unit_mesh(:,3),unit_mesh(:,1),unit_mesh(:,2),'b.')
    plot3(unit_mesh(:,3),unit_mesh(:,1).*shp_fun(qxx),unit_mesh(:,2),'r*')
end

mesh_points = [unit_mesh(:,3),unit_mesh(:,2),unit_mesh(:,1).*shp_fun(qxx)];
write_point = [node(1:num_np),genn(1:num_np),mesh_points];
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

fileID = fopen(filename,'r');
dummy_lns = fgetl(fileID);
wfilename = ['w',filename];
file_id = fopen(wfilename,'w');
fprintf(file_id,[dummy_lns,char(10)]);
for mi = 1:num_np
    dummy_lns = fgetl(fileID);
    fprintf(file_id,'%4i %4i %15f %15f %15f\n',write_point(mi,:));
end;

for mi = (num_np+1):(size(node,1)+1)
    dummy_lns = fgetl(fileID);
    fwrite(file_id,[dummy_lns,char(10)]);
end;

fclose(fileID)
fclose(file_id)

end
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
