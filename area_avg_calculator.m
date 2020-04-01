% Function that calculates the average stress of an element, 
% where four node locations and their respective nodal stresses are given:
function [area,avg_s] = area_avg_calculator(x1,y1,s1,x2,y2,s2,x3,y3,s3,x4,y4,s4)


    function res = calc_tri_area(Ax,Ay,Bx,By,Cx,Cy) 
        res = 0.5*abs(Ax*(By-Cy)+Bx*(Cy-Ay)+Cx*(Ay-By));
    end

tmp_x_ar = [x1;x2;x3;x4];
tmp_y_ar = [y1;y2;y3;y4];
tmp_s_ar = [s1;s2;s3;s4];

[min_s,min_index] = min(tmp_s_ar);

x = [tmp_x_ar(min_index);...
        tmp_x_ar(mod((min_index),4)+1);...
        tmp_x_ar(mod((min_index+1),4)+1);...
        tmp_x_ar(mod((min_index+2),4)+1)];

y = [tmp_y_ar(min_index);...
        tmp_y_ar(mod((min_index),4)+1);...
        tmp_y_ar(mod((min_index+1),4)+1);...
        tmp_y_ar(mod((min_index+2),4)+1)];

s = [tmp_s_ar(min_index);...
        tmp_s_ar(mod((min_index),4)+1);...
        tmp_s_ar(mod((min_index+1),4)+1);...
        tmp_s_ar(mod((min_index+2),4)+1)];
    
s = s - min_s; 



area1 = calc_tri_area(x(1),y(1),x(3),y(3),x(4),y(4));
area2 = calc_tri_area(x(1),y(1),x(2),y(2),x(3),y(3));

vol = (1/3)*(area1*(s(3)+s(4))+area2*(s(3)+s(2)));
area = area1+area2;
avg_s = vol/area + min_s;


end
