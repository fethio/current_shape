
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
%vvvvvvvvvvvvvvvvvvvv Read Eigenvalue from output file vvvvvvvvvvvvvvvvvvvv
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
function eigenvalue = readf_eig(file_nm)
if (nargin<1), file_nm = 'Obase_single40se'; end

fileID_s = fopen(file_nm,'r');
dummy_lns = fgetl(fileID_s);
while ischar(dummy_lns)
    old_result = dummy_lns;
    dummy_lns = fgetl(fileID_s);
    if size(old_result,2)>36
        f_ch = strcmp(old_result(1:37),...
            '  N o d a l   E i g e n v e c t o r s');
        if f_ch, eigenvalue = dummy_lns; end
    end
end; try fclose(fileID_s); catch, warning('Read error'), end

eigenvalue = sqrt(str2num(eigenvalue(55:66)))/(2*pi); % in hz

end
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv