%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is mesh constraints finder for Delaunay constraints
 %  coded by Ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function DelaunayConstraints = DelaunayConstraintsFinder(file_location)
temp_location = [file_location,'/constant/polyMesh/'];
%% first we need to find the ID of boundary faces
%  read boundary file (Note! Only suit for Leon Mesh)
filename      = [temp_location,'boundary'];
fid           = fopen(filename, 'rt');
locWall       = findBCName(fid,'FIXEDWALLS','FIXEDWALLS');
%  find boundary name location in the text
frewind(fid);
nFacesWall    = textscan(fid,'nFaces          %f',1,'HeaderLines',locWall+2);
startFaceWall = textscan(fid,'startFace       %f',1,'HeaderLines',1);
frewind(fid);
startFaceWall = cell2mat(startFaceWall);
nFacesWall    = cell2mat(nFacesWall);
%% now we read the faces file
disp('now reading boundary constraints');
filename      = [temp_location,'faces'];
fid           = fopen(filename, 'r');
faceIDs       = textscan(fid, '4(%f %f %f %f)','HeaderLines',20);
fclose(fid);
% FaceIDs
faceIDs       = cell2mat(faceIDs);
% squeeze faceIDs so that only keep the boundary faces
faceIDs       = faceIDs([startFaceWall:startFaceWall+nFacesWall-1],:);
if size(faceIDs,1) ~= nFacesWall
    error('Size of faceIDs doesnt match nFacesWall!')
end
%% now we need to create constraint edges according to faceIDs
DelaunayConstraints = faceIDs(:,[1,2]);
DelaunayConstraints = cat(1,DelaunayConstraints,faceIDs(:,[2,3]));
DelaunayConstraints = cat(1,DelaunayConstraints,faceIDs(:,[3,4]));
DelaunayConstraints = cat(1,DelaunayConstraints,faceIDs(:,[4,1]));
clear faceIDs
DelaunayConstraints
disp('finish boundary constraints creation')
end

