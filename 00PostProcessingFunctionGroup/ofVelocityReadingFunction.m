%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is a function to read openfoam U p files
 %  coded by ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [uz,ur,uth] = ofVelocityReadingFunction(t,numOfCells,theta,file_location,DelaunayMatrix,weightCoeff,extended_indx)
%   convert ux uy to ur utheta and record uz for all time steps
uz  = zeros(numOfCells, length(t));
ur  = zeros(numOfCells, length(t));
uth = zeros(numOfCells, length(t));
%   record ur utheta and uz for each time step
for k = 1:length(t)
    disp(['now reading U time = ',num2str(t(k),'%.16g')]);
    % import velocity data for each time step
    temp_location = [file_location,'/%.16g/%s'];
    filename      = sprintf(temp_location,t(k),'U');
    fid           = fopen(filename, 'r');
    % compare string so that we know it is gpu or cpu OpenFOAM output file
    headStrGPU    = textscan(fid,'| RapidCFD by simFlow (sim-flow.com)  %s','HeaderLines',1);
    headStrCPU    = textscan(fid,'| \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox %s','HeaderLines',2);
    if (isempty(headStrCPU{1}) - 1) + isempty(headStrGPU{1}) == 0 
        field_indx = 16;
    else
        field_indx = 20;
    end
    frewind(fid);
    % now read the data
    tempDataU     = textscan(fid, '(%f %f %f)','HeaderLines',field_indx+2);
    fclose(fid);
    % Instantaneous velocity
    temp          = tempDataU{1}(extended_indx);
    triVals       = temp(DelaunayMatrix);
    ux            = weightCoeff.*triVals*[1;1;1;1];
    temp          = tempDataU{2}(extended_indx);
    triVals       = temp(DelaunayMatrix);
    uy            = weightCoeff.*triVals*[1;1;1;1];
    temp          = tempDataU{3}(extended_indx);
    triVals       = temp(DelaunayMatrix);
    uz(:,k)       = weightCoeff.*triVals*[1;1;1;1];
    % Decomposing the velocity to ur and uth 
    % to meet the coordinate with boundary layer, ur is towards centre
    % ur is not towards wall, so ur is opposite
    ur(:,k)       = -ux.*cos(theta)-uy.*sin(theta);
    uth(:,k)      =  uy.*cos(theta)-ux.*sin(theta);
    
   
end
    clear tempDataU;
end