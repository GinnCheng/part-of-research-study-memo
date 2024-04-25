%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is a function to read openfoam pressure files
 %  coded by ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function p = ofPressureReadingFunction(t,numOfCells,file_location,DelaunayMatrix,weightCoeff,extended_indx)
p   = zeros(numOfCells, length(t));
%   record p for each time step
for k = 1:length(t)
    disp(['now reading p time = ',num2str(t(k),'%.16g')]);
    % import pressure data for each time step
    temp_location = [file_location,'/%.16g/%s'];
    filename      = sprintf(temp_location,t(k),'p');
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
    tempDataP     = textscan(fid, '%f','HeaderLines',field_indx+2);
    fclose(fid);
    % Instantaneous pressure
    temp          = tempDataP{1}(extended_indx);
    triVals       = temp(DelaunayMatrix);
    p(:,k)        = weightCoeff.*triVals*[1;1;1;1];
   
   
end
    clear tempDataP;
end