%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is to find the specific line where the specific boundary name
 %  is. Programmed by Ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function loc_output = findTextLineLocation(fid,string1,string2)
loc = 1;
while ~feof(fid)
    lineString    = fgetl(fid);
    location1     = strfind(lineString,string1);
    location2     = strfind(lineString,string2);
    location3     = strfind(lineString,'neighbourPatch');
    strCompare    = isempty(location1)*isempty(location2)+~isempty(location3);
    if strCompare == 1
        loc = loc+1;
    elseif strCompare == 0
            loc_output = loc;
    end
end
end