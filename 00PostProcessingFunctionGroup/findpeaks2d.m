%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% function for finding peaks and vills in a sinusoidal rough wall
 %  coded by Ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [peaks, locs, rough_front, rough_back, rough_side_l, rough_side_r]  =  findpeaks2d(data,min_height,fronAndBackCoeff,sideCoeff)
k = 1;
desiTemp = 1;
for i = 1:size(data,1)
    for j = 1:size(data,2)
        for m = 1 : 3
            temp = (data(i,j) >= data(cycx(i-m),cycy(j)))*...
                   (data(i,j) >= data(cycx(i-m),cycy(j)))*...
                   (data(i,j) >= data(cycx(i),cycy(j-m)))*...
                   (data(i,j) >= data(cycx(i),cycy(j+m)))*...
                   (data(i,j) >= min_height);
            desiTemp = desiTemp*temp;
        end

        if (desiTemp == 1)
           peaks(k)      = data(i,j);
           locs(k,:)     = [i,j];
           k             = k+1;
        end
        
        desiTemp = 1;
    end
end

% find peak distance in both directions
peak_distance_z       =  max(locs(2:end,1)-locs(1:end-1,1));
peak_distance_theta   =  max(locs(2:end,2)-locs(1:end-1,2));
% so that we can find the front, back, and sides
rough_front           =  [round(locs(2:end,1)-fronAndBackCoeff*peak_distance_z),locs(2:end,2)];
rough_back            =  [round(locs(1:end-1,1)+fronAndBackCoeff*peak_distance_z),locs(1:end-1,2)];
rough_side_l          =  [locs(2:end,1),round(locs(2:end,2)-sideCoeff*peak_distance_theta)];
rough_side_r          =  [locs(1:end-1,1),round(locs(1:end-1,2)+sideCoeff*peak_distance_theta)];
% delete exceeded elements
[loc_delete,~,~]           =  find(rough_front(:,1) < 1 | rough_front(:,1) > size(data,1));
rough_front(loc_delete,:)  = [];
[loc_delete,~,~]           =  find(rough_back(:,1) < 1 | rough_back(:,1) > size(data,1));
rough_back(loc_delete,:)   = [];
[loc_delete,~,~]           =  find(rough_side_l(:,2) < 1 | rough_side_l(:,2) > size(data,2));
rough_side_l(loc_delete,:) = [];
[loc_delete,~,~]           =  find(rough_side_r(:,2) < 1 | rough_side_r(:,2) > size(data,2));
rough_side_r(loc_delete,:) = [];

function y = cycx(x)
         y = (x<1)*(x+size(data,1))+(x>=1)*(x<=size(data,1))*x...
            +(x>size(data,1))*(x-size(data,1));
end
function y = cycy(x)
         y = (x<1)*(x+size(data,2))+(x>=1)*(x<=size(data,2))*x...
            +(x>size(data,2))*(x-size(data,2));
end        
end        