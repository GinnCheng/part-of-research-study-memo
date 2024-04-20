%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is for bin the radius after you have sorted all coord
 %  coded by Ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function coord = binLocation(coord,avg_loc,loc_group)
for i = 1:length(loc_group)
    temp        = cell2mat(loc_group(i));
    coord(temp) = avg_loc(i);
end
end