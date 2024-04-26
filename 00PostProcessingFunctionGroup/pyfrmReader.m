%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% pyfr mesh reader to read pyfrm
 %  coded by ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function coord = pyfrmReader(pyfrm_file,meshType,order)
%% this function is currently for hex mesh
if meshType == 'hex'
hexCoord    = hdf5read(pyfrm_file,'/spt_hex_p0');
dim_1       = size(hexCoord,1); % coord of each point
dim_2       = size(hexCoord,2); % number of elements
% dim_3       = size(hexCoord,3); % number of points each element
NPPL        = (1+2^(order-1)); % numOfPointsPerLine
dim_3       = NPPL^3; % number of points each element in orders

% originalCoord    = zeros(8,3); % original 8 points stored in the pyfrm
% orderedCoord     = zeros(dim_3,3); % ordered points based on the original
coord = zeros(dim_2*dim_3,dim_1);  % total coordinates

%% find the knot point on each line
%  create original block 8 (x,y,z)
originalBlock = [0,0,0; 1,0,0; 0,1,0; 1,1,0; 0,0,1; 1,0,1; 0,1,1; 1,1,1]; 
%  create four block for number order, x, y, z
% numOrderBlock = reshpae([1:dim3],[NPPL,NPPL,NPPL]);
xCoordBlock   = zeros(NPPL,NPPL,NPPL);
yCoordBlock   = zeros(NPPL,NPPL,NPPL);
zCoordBlock   = zeros(NPPL,NPPL,NPPL);
%  an array line space anay direction
splitLine     = linspace(0,1,NPPL);
%  give the line space ratio to each block
for kk = 1:NPPL
    xCoordBlock(kk,:,:) = splitLine(kk);
    yCoordBlock(:,kk,:) = splitLine(kk);
    zCoordBlock(:,:,kk) = splitLine(kk);
end
%  now reshape the three block to be three 1-D array
xCoordVector  = reshape(xCoordBlock,[dim_3,1]);
yCoordVector  = reshape(yCoordBlock,[dim_3,1]);
zCoordVector  = reshape(zCoordBlock,[dim_3,1]);

%% using scattered interpolation to get the higher order mesh coordinate
for i = 1:dim_2
    % store original coordinate each element
    originalCoord                  = squeeze(permute(hexCoord(:,i,:),[2 3 1]));
    % expand into ordered coordinate through each surface
    %if order >= 2
    for j = 1:3
        tempfunc = scatteredInterpolant(originalBlock(:,1),originalBlock(:,2),originalBlock(:,3),originalCoord(:,j));
        coord(1+dim_3*(i-1):dim_3*i,j) = tempfunc(xCoordVector,yCoordVector,zCoordVector);
    end
    %end
    if(i <= round(0.25*dim_2) && i+1 > round(0.25*dim_2))
        disp('Finish 25% of mesh reading')
    end
    if(i <= round(0.5*dim_2) && i+1 > round(0.5*dim_2))
        disp('Finish 50% of mesh reading')
    end
    if(i <= round(0.75*dim_2) && i+1 > round(0.75*dim_2))
        disp('Finish 75% of mesh reading')
    end
    if(i == dim_2)
        disp('Finish 100% of mesh reading')
    end
end
else
    error('mesh type should be "hex"')
end
end