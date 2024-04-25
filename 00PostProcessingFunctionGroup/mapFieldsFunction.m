%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is a function to calculate mapfield fluid fields
 %  coded by Ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mapFieldsFunction(originalMeshLocation,originalMeshName,originalResultsLocation,originalResultsName,originalMeshOrder,...
                           targetMeshLocation,targetMeshName,targetResultsLocation,targetResultsName,targetMeshOrder)
%% parameters
t_start          = tic;
dim_3_0          = (1+2^(originalMeshOrder-1))^3; % numOfPointsPerElement
dim_3_1          = (1+2^(targetMeshOrder-1))^3; % numOfPointsPerElement
%% Read Original File
% info             = hdf5info([originalMeshLocation,'pipe3d.pyfrm']);
% info2            = hdf5info([targetResultsLocation,'pipe3d_00.pyfrs']);
Coord0             = pyfrmReader([originalMeshLocation,originalMeshName],'hex',originalMeshOrder);
[p0,u0,v0,w0]      = pyfrsReader([originalResultsLocation,originalResultsName],'hex');
disp('Finish original files reading')
%% Read Target File
Coord1           = pyfrmReader([targetMeshLocation,targetMeshName],'hex',targetMeshOrder);
disp('Finish target mesh reading')
%% mapFields through interpolation
interPFunc       = scatteredInterpolant(Coord0(:,1),Coord0(:,2),Coord0(:,3),p0);
p                = interPFunc(Coord1(:,1),Coord1(:,2),Coord1(:,3));
% p                = p + 1e4;
interPFunc       = scatteredInterpolant(Coord0(:,1),Coord0(:,2),Coord0(:,3),u0);
u                = interPFunc(Coord1(:,1),Coord1(:,2),Coord1(:,3));
interPFunc       = scatteredInterpolant(Coord0(:,1),Coord0(:,2),Coord0(:,3),v0);
v                = interPFunc(Coord1(:,1),Coord1(:,2),Coord1(:,3));
interPFunc       = scatteredInterpolant(Coord0(:,1),Coord0(:,2),Coord0(:,3),w0);
w                = interPFunc(Coord1(:,1),Coord1(:,2),Coord1(:,3));
clear p0 u0 v0 w0 Coord0 Coord1 interPFunc
disp('Finish interpolation. Ready to overwrite.')
%% Write the mapped solution to the new mesh
solnDim  = [round(length(p)/dim_3_1),4,dim_3_1];
hex_soln = zeros(solnDim(1),solnDim(2),solnDim(3));
%  map the solution into hex_soln
for i = 1:solnDim(1)
    hex_soln(i,1,:) = p(1+dim_3_1*(i-1):i*dim_3_1);
    hex_soln(i,2,:) = u(1+dim_3_1*(i-1):i*dim_3_1);
    hex_soln(i,3,:) = v(1+dim_3_1*(i-1):i*dim_3_1);
    hex_soln(i,4,:) = w(1+dim_3_1*(i-1):i*dim_3_1);
end
clear p u v w
disp(['Finished the data reshape, start to write, solution size ',num2str(solnDim(1)),'x',num2str(solnDim(2)),'x',num2str(solnDim(3))])
h5write([targetResultsLocation,targetResultsName],'/soln_hex_p0',hex_soln);
disp(['Finish mapfields from',originalResultsLocation,originalResultsName,' to '...
      targetResultsLocation,targetResultsName])
t_elp  = toc(t_start);
disp(['Total time elapse ',num2str(t_elp),' seconds'])
end