%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Function for reading Nek results
 %  coded by Ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [coord,uniqueIndx,numOfNodes] = NekCoordReadingFunction(file_location)
addpath('/media/ginn/data/post_processing_tools/00PostProcessingFunctionGroup/00nekmatlab')
disp(['Reading Nek coordinate files ...']);

%% check the files in the directory
filenames = dir([file_location,'/*0.f*']);

%% read the first file to make sure the size
[data,~,~,~,~,~,~,~,~,~,~,~,~,~,~]  = readnek([file_location,'/',filenames(1).name]);
if size(data,2) <= 4
    error('Invalid coord file! Must contain (x,y,z) location.')
end
numOfNodes                          = size(data,1)*size(data,2);
data                                = reshape(data,[numOfNodes,size(data,3)]);
coord                               = data(:,[1:3]);  % load the Cartesian coordinate
coord                               = round(coord,8);
%%% remove the overlaped coordinate
[coord,uniqueIndx,~]                = unique(coord,'rows');

end