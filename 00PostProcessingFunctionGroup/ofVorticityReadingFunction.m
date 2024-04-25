%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is a function to read openfoam U p files
 %  coded by ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Ohm_z,Ohm_r,Ohm_th,Ohm_mag] = ofVorticityReadingFunction(t,numOfCells,theta,file_location,DelaunayMatrix,weightCoeff,extended_indx)
%   convert ux uy to ur utheta and record uz for all time steps
Ohm_z     = zeros(numOfCells, length(t));
Ohm_r     = zeros(numOfCells, length(t));
Ohm_th    = zeros(numOfCells, length(t));
Ohm_mag   = zeros(numOfCells, length(t));
%   record ur utheta and uz for each time step
for k = 1:length(t)
    disp(['now reading Vorticity time = ',num2str(t(k),'%.16g')]);
    % import velocity data for each time step
    temp_location = [file_location,'/%.16g/%s'];
    filename      = sprintf(temp_location,t(k),'vorticity');
    fid           = fopen(filename, 'r');
    tempDataU     = textscan(fid, '(%f %f %f)','HeaderLines',22);
    fclose(fid);
    % Instantaneous velocity
    temp             = tempDataU{1}(extended_indx);
    triVals          = temp(DelaunayMatrix);
    Ohm_x            = weightCoeff.*triVals*[1;1;1;1];
    temp             = tempDataU{2}(extended_indx);
    triVals          = temp(DelaunayMatrix);
    Ohm_y            = weightCoeff.*triVals*[1;1;1;1];
    temp             = tempDataU{3}(extended_indx);
    triVals          = temp(DelaunayMatrix);
    Ohm_z(:,k)       = weightCoeff.*triVals*[1;1;1;1];
    % Decomposing the velocity to ur and uth 
    % to meet the coordinate with boundary layer, ur is towards centre
    % ur is not towards wall, so ur is opposite
    Ohm_r(:,k)       = -Ohm_x.*cos(theta)-Ohm_y.*sin(theta);
    Ohm_th(:,k)      =  Ohm_y.*cos(theta)-Ohm_x.*sin(theta);
    
    % import pressure data for each time step
    filename      = sprintf(temp_location,t(k),'magVorticity');
    fid           = fopen(filename, 'r');
    tempDataP     = textscan(fid, '%f','HeaderLines',22);
    fclose(fid);
    % Instantaneous pressure
    temp          = tempDataP{1}(extended_indx);
    triVals       = temp(DelaunayMatrix);
    Ohm_mag(:,k)  = weightCoeff.*triVals*[1;1;1;1];
   
    clear tempDataU;
    clear tempDataP;
   
end
end