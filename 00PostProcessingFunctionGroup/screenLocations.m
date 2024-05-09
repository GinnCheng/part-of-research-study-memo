%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% functions for partially screen locations of r instead of pick em all
 %  coded by Ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [screenLoc] = screenLocations(original_r,min_r,medium_r,max_r,numOfPoints_innerRegion,numOfPointsOuterRegion)
selected_loc = [logspace(min_r,medium_r,numOfPoints_innerRegion),...
                logspace(medium_r,max_r,numOfPointsOuterRegion)];

% find the closest points already exsisted in original_r 
for i = 1:length(selected_loc)
    temp_diff          = abs(original_r - selected_loc(i));
    [~,screenLoc(i),~] = find(temp_diff == min(temp_diff));
end
screenLoc = unique(screenLoc);
end