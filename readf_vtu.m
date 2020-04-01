%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
%vvvvvvvvvvvvvvvvvvv Read and Convert Function for .vtu vvvvvvvvvvvvvvvvvvv
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
function [result] = readf_vtu(file_nm)
if (nargin<1), file_nm = 'feap_paraview.vtu'; end
xfile = xmlread(file_nm);
VTKFile = xfile.getDocumentElement;
UnstructuredGrid = VTKFile.item(1);
Piece = UnstructuredGrid.item(1);
%Find attributes from a predefined list
Pointz = Piece.item(1);
Cellz = Piece.item(3);
PointData = Piece.item(5);
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
DataArrayOfPointz = str2num(get(Pointz.item(1),'TextContent'));
result{1,1} = char(Pointz.item(1).getAttribute('Name'));
result{1,2} = DataArrayOfPointz;
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
ConnectivityArray = str2num(get(Cellz.item(1),'TextContent'));
OffsetsArray = str2num(get(Cellz.item(3),'TextContent'));
TypesArray = str2num(get(Cellz.item(5),'TextContent'));
result{2,2} = ConnectivityArray;
result{3,2} = OffsetsArray;
result{4,2} = TypesArray;
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
DisplacementsArray = str2num(get(PointData.item(1),'TextContent'));
StressStrainArray = str2num(get(PointData.item(3),'TextContent'));
PrincipalStressArray = str2num(get(PointData.item(5),'TextContent'));
result{5,2} = DisplacementsArray;
result{6,2} = StressStrainArray;
result{7,2} = PrincipalStressArray;
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
result{2,1} = char(Cellz.item(1).getAttribute('Name'));
result{3,1} = char(Cellz.item(3).getAttribute('Name'));
result{4,1} = char(Cellz.item(5).getAttribute('Name'));
result{5,1} = char(PointData.item(1).getAttribute('Name'));
result{6,1} = char(PointData.item(3).getAttribute('Name'));
result{7,1} = char(PointData.item(5).getAttribute('Name'));
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
%vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
