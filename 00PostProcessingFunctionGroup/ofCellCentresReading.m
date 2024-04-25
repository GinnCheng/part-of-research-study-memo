%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is a function to read cell centres
 %  coded by ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function coord = ofCellCentresReading(file_location)
string = ['x','y','z'];
for k = 1:3
    temp_location = [file_location,'/%g/cc%s'];
    filename      = sprintf(temp_location,0,string(k));
    fid           = fopen(filename,'rt');
    tempDataCoord = textscan(fid,'%f','HeaderLines',22);
    coord(:,k)    = tempDataCoord{1};
    fclose(fid);
end
% Clear variable for memory
clear tempDataCoord;
coord = round(coord,8);
end