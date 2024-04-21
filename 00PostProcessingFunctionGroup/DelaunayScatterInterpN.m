%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is for on-time mapfields the mesh results
 %  coded by ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [DelaunayMatrix,weightCoeff,new_coord] = DelaunayScatterInterpN(old_coord,new_coord,file_location,num_of_z)
global needToOverWriteDT 
%% firstly we need to get Delaunay coeff matrix for old_coord
%  do we need to overwrite delaunay matrix?
disp('Start Delaunay Triangulation (might be slow in the first time)');
if (exist([file_location,'/00DelaunayInterpN'],'dir') == 0)
    mkdir([file_location,'/00DelaunayInterpN']);
end

if needToOverWriteDT == 0
%  whether Delaunay Triangle Coeff exists
    if (exist([file_location,'/00DelaunayInterpN/DelaunayMatrix.mat'],'file') +...
        exist([file_location,'/00DelaunayInterpN/weightCoeff.mat'],'file')    +...
        exist([file_location,'/00DelaunayInterpN/new_coord.mat'],'file')      == 0)
        % split the BIG mesh into small pieces
        [sub_oldCoord,sub_newCoord,sub_oldCoord_indx,sub_newCoord_indx] = subDelaunayMeshSplitter(old_coord,new_coord,num_of_z);
        
        % do the Delaunay matrix interpolation
        [DelaunayMatrix,weightCoeff,new_coord] = DelaunayInterpAssembler(sub_oldCoord,sub_newCoord,sub_oldCoord_indx,sub_newCoord_indx);       

        % output those mat
        save([file_location,'/00DelaunayInterpN/DelaunayMatrix.mat'],'DelaunayMatrix','-v7.3');
        save([file_location,'/00DelaunayInterpN/weightCoeff.mat'],'weightCoeff','-v7.3');
        save([file_location,'/00DelaunayInterpN/new_coord.mat'],'new_coord','-v7.3');
    else
        disp('File already exists, loading');
        DelaunayMatrix = load([file_location,'/00DelaunayInterpN/DelaunayMatrix.mat']);
        DelaunayMatrix = DelaunayMatrix.DelaunayMatrix;
        weightCoeff    = load([file_location,'/00DelaunayInterpN/weightCoeff.mat']);
        weightCoeff    = weightCoeff.weightCoeff;
        new_coord      = load([file_location,'/00DelaunayInterpN/new_coord.mat']);
        new_coord      = new_coord.new_coord;
    end
else
    % split the BIG mesh into small pieces
    [sub_oldCoord,sub_newCoord,sub_oldCoord_indx,sub_newCoord_indx] = subDelaunayMeshSplitter(old_coord,new_coord,num_of_z);
        
    % do the Delaunay matrix interpolation
    [DelaunayMatrix,weightCoeff,new_coord] = DelaunayInterpAssembler(sub_oldCoord,sub_newCoord,sub_oldCoord_indx,sub_newCoord_indx);     

    % output those mat
    save([file_location,'/00DelaunayInterpN/DelaunayMatrix.mat'],'DelaunayMatrix','-v7.3');
    save([file_location,'/00DelaunayInterpN/weightCoeff.mat'],'weightCoeff','-v7.3');
    save([file_location,'/00DelaunayInterpN/new_coord.mat'],'new_coord','-v7.3');
end

disp('Finish Delaunay Triangulation');
end
