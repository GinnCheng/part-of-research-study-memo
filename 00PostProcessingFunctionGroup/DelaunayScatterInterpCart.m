%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is for on-time mapfields the mesh results for Cartisien Coord
 %  coded by ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [DelaunayMatrix,weightCoeff,new_coord,fieldIndx,nanIndx] = DelaunayScatterInterpCart(old_coord,new_coord,file_location)
global needToOverWriteDT roughWallOrNot R_over_h lambda_over_R Re_tau R 
% define the wavelength and height of the roughness
hh    = R/R_over_h*(180/Re_tau);
gamma = R*lambda_over_R*(180/Re_tau);

%% firstly we need to get Delaunay coeff matrix for old_coord
%  do we need to overwrite delaunay matrix?
disp('Start Delaunay Triangulation (might be slow in the first time)');
if (exist([file_location,'/00DelaunayInterpCart'],'dir') == 0)
    mkdir([file_location,'/00DelaunayInterpCart']);
end

if needToOverWriteDT == 0
%  whether Delaunay Triangle Coeff exists
    if (exist([file_location,'/00DelaunayInterpCart/DelaunayMatrix.mat'],'file') +...
        exist([file_location,'/00DelaunayInterpCart/surroundPoints.mat'],'file') +...
        exist([file_location,'/00DelaunayInterpCart/weightCoeff.mat'],'file')    +...
        exist([file_location,'/00DelaunayInterpCart/new_coord.mat'],'file')      == 0)
        % create Delaunay transfer matrix
        DelaunayMatrix = delaunayTriangulation(old_coord);
        % secondly we need to use DelaunayMatrix to create surroundPoints and weightCoeff
        [surroundPoints,weightCoeff]   = pointLocation(DelaunayMatrix,new_coord);       
        % now we need to remove the NaN points
        [nanIndx, ~]  = find(isnan(surroundPoints));
        % we also need to remove points outside the roughness domain set
        % set those points NaN
        if roughWallOrNot == 1
            [temp_TH, temp_R, temp_Z] = cart2pol(new_coord(:,1),new_coord(:,2),new_coord(:,3));
            temp = temp_R - (R + hh.*cos(2.*pi.*temp_Z./gamma).*cos(2.*pi.*R.*temp_TH./gamma));
            outsideDomainIndx = find(temp >= 0);
            nanIndx           = unique(cat(1,nanIndx,outsideDomainIndx));
            clear temp_R temp_TH temp_Z
        end 
        % based on the nanIndx we record the field indx
        fieldIndx = [1:length(surroundPoints)]';
        fieldIndx(nanIndx) = [];
        
        % reshaper all matrix
        surroundPoints(nanIndx,:) = [];
        weightCoeff(nanIndx,:)    = [];
        
        % squeeze Delaunay Matrix so that the storage size is minimal
        DelaunayMatrix  =  DelaunayMatrix.ConnectivityList(surroundPoints,:);
        % output those mat
        save([file_location,'/00DelaunayInterpCart/DelaunayMatrix.mat'],'DelaunayMatrix');
        save([file_location,'/00DelaunayInterpCart/surroundPoints.mat'],'surroundPoints');
        save([file_location,'/00DelaunayInterpCart/weightCoeff.mat'],'weightCoeff');
        save([file_location,'/00DelaunayInterpCart/new_coord.mat'],'new_coord');
        save([file_location,'/00DelaunayInterpCart/fieldIndx.mat'],'fieldIndx');
        save([file_location,'/00DelaunayInterpCart/nanIndx.mat'],'nanIndx');
    else
        disp('File already exists, loading');
        DelaunayMatrix = load([file_location,'/00DelaunayInterpCart/DelaunayMatrix.mat']);
        DelaunayMatrix = DelaunayMatrix.DelaunayMatrix;
        weightCoeff    = load([file_location,'/00DelaunayInterpCart/weightCoeff.mat']);
        weightCoeff    = weightCoeff.weightCoeff;
        new_coord      = load([file_location,'/00DelaunayInterpCart/new_coord.mat']);
        new_coord      = new_coord.new_coord;
        fieldIndx      = load([file_location,'/00DelaunayInterpCart/fieldIndx.mat']);
        fieldIndx      = fieldIndx.fieldIndx;
        nanIndx        = load([file_location,'/00DelaunayInterpCart/nanIndx.mat']);
        nanIndx        = nanIndx.nanIndx;
    end
else
    
    % create Delaunay transfer matrix
    DelaunayMatrix = delaunayTriangulation(old_coord);
    % secondly we need to use DelaunayMatrix to create surroundPoints and weightCoeff
    [surroundPoints,weightCoeff]   = pointLocation(DelaunayMatrix,new_coord);
    % now we need to remove the NaN points
    [nanIndx, ~]  = find(isnan(surroundPoints));
    % we also need to remove points outside the roughness domain set
    % set those points NaN
    if roughWallOrNot == 1
        [temp_TH, temp_R, temp_Z] = cart2pol(new_coord(:,1),new_coord(:,2),new_coord(:,3));
        temp = temp_R - (R + hh.*cos(2.*pi.*temp_Z./gamma).*cos(2.*pi.*R.*temp_TH./gamma));
        outsideDomainIndx = find(temp >= 0);
        nanIndx           = unique(cat(1,nanIndx,outsideDomainIndx));
        clear temp_R temp_TH temp_Z
    end 
    
    % based on the nanIndx we record the field indx
    fieldIndx = [1:length(surroundPoints)]';
    fieldIndx(nanIndx) = [];
    
    % reshaper all matrix
    surroundPoints(nanIndx,:) = [];
    weightCoeff(nanIndx,:)    = [];
    
    % squeeze Delaunay Matrix so that the storage size is minimal
    DelaunayMatrix  =  DelaunayMatrix.ConnectivityList(surroundPoints,:);
    % output those mat
    save([file_location,'/00DelaunayInterpCart/DelaunayMatrix.mat'],'DelaunayMatrix');
    save([file_location,'/00DelaunayInterpCart/surroundPoints.mat'],'surroundPoints');
    save([file_location,'/00DelaunayInterpCart/weightCoeff.mat'],'weightCoeff');
    save([file_location,'/00DelaunayInterpCart/new_coord.mat'],'new_coord');
    save([file_location,'/00DelaunayInterpCart/fieldIndx.mat'],'fieldIndx');
    save([file_location,'/00DelaunayInterpCart/nanIndx.mat'],'nanIndx');
end

disp('Finish Delaunay Triangulation');
end
