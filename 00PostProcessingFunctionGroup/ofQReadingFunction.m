%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Function to read Q files
 %  code by ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Q = ofQReadingFunction(t,numOfCells,file_location,DelaunayMatrix,weightCoeff,extended_indx)
%   convert ux uy to ur utheta and record uz for all time steps
Q     = zeros(numOfCells, length(t));
%   record ur utheta and uz for each time step
for k = 1:length(t)
    disp(['now reading Q time = ',num2str(t(k),'%.16g')]);
    % import velocity data for each time step
    temp_location = [file_location,'/%.16g/%s'];
    filename      = sprintf(temp_location,t(k),'Q');
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
    tempQ   = textscan(fid, '%f','HeaderLines',field_indx+2);
    fclose(fid);
    % Instantaneous lambda2
    temp          = tempQ{1}(extended_indx);
    triVals       = temp(DelaunayMatrix);
    Q(:,k)        = weightCoeff.*triVals*[1;1;1;1];   
end
    clear tempQ temp;
end