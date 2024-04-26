%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% pyfr mesh reader to read pyfrs
 %  coded by ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [p,u,v,w] = pyfrsReader(pyfrs_file,meshType,indxOfSelectedCells)
%% this function is currently for hex mesh
if meshType == 'hex'
hexSoln     = hdf5read(pyfrs_file,'/soln_hex_p0');
dim_1       = size(hexSoln,1); % number of elements
% dim_2       = size(hexSoln,2); % p u v w
dim_3       = size(hexSoln,3); % number of points each element

p = zeros(dim_1*dim_3,1);
u = zeros(dim_1*dim_3,1);
v = zeros(dim_1*dim_3,1);
w = zeros(dim_1*dim_3,1);
for i = 1:dim_1
    p(1+dim_3*(i-1):dim_3*i,1) = permute(hexSoln(i,1,:),[1 3 2]);
    u(1+dim_3*(i-1):dim_3*i,1) = permute(hexSoln(i,2,:),[1 3 2]);
    v(1+dim_3*(i-1):dim_3*i,1) = permute(hexSoln(i,3,:),[1 3 2]);
    w(1+dim_3*(i-1):dim_3*i,1) = permute(hexSoln(i,4,:),[1 3 2]);
%     if(i <= round(0.25*dim_1) && i+1 > round(0.25*dim_1))
%         disp('Finish 25% of solution reading')
%     end
%     if(i <= round(0.5*dim_1) && i+1 > round(0.5*dim_1))
%         disp('Finish 50% of solution reading')
%     end
%     if(i <= round(0.75*dim_1) && i+1 > round(0.75*dim_1))
%         disp('Finish 75% of solution reading')
%     end
%     if(i == dim_1)
%         disp('Finish 100% of solution reading')
%     end    
end
p = p(indxOfSelectedCells);
u = u(indxOfSelectedCells);
v = v(indxOfSelectedCells);
w = w(indxOfSelectedCells);
else
    error('mesh type should be "hex"')
end
end