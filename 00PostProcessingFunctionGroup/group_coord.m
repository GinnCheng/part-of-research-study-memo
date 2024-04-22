%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Function for sort polar coordinate points of a cylinder mesh
 %  so that each cylinder surface with same radius can be recorded
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTE! This group coord is for Delaunay Triangulation but not for bin
% method !!!
function [avg_R,loc_group,num_group] = group_coord(rCoord,sample_r)
%% find rCoord corresponding to each sample r location
if length(sample_r) == 1
    avg_R       = sample_r;
    indx_rCoord = 1:size(rCoord,1);
    loc_group   = {indx_rCoord};
    num_group   = size(rCoord,1);
else
min_dr       = 1.25*abs(sample_r(2)   - sample_r(1));
max_dr       = 1.25*abs(sample_r(end) - sample_r(end-1));
% create edges for histocounts
edge_r    = sort([sample_r(1) - min_dr, (sample_r(1:end-1) + sample_r(2:end))./2, sample_r(end) + max_dr],'ascend');
%% create a series of group r locations
avg_R     = zeros();
% loc_group = cell(1,length(peak_loc));
num_group = zeros();
num_of_avg_r = 1;
sum_of_indx  = 0;
for i = 1:length(sample_r)
    if i <= length(sample_r) - 1
        [indx_rCoord,~] = find(rCoord >= edge_r(i) & rCoord < edge_r(i+1));
    else
        [indx_rCoord,~] = find(rCoord >= edge_r(i) & rCoord <= edge_r(i+1));
    end
    if isempty(indx_rCoord) == 0
        avg_R(num_of_avg_r)     = sample_r(i);
        loc_group(num_of_avg_r) = {indx_rCoord};
        num_group(num_of_avg_r) = length(indx_rCoord);
        num_of_avg_r            = num_of_avg_r + 1;
        sum_of_indx             = sum_of_indx + length(indx_rCoord);
    end
end

if sum_of_indx ~= length(rCoord)
    error('Coord number is not consistent during grouping coord')
end
end
end
