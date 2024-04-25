%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Mean flow calculator
 %%%  to calculate the mean flow of the average of all phases
  %   coded by ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [U_z_est,U_r_est,U_th_est,P_est] = mean_flow_field_calculator(theta,numOfCells,indxOfSelectedCells,timespan)
global file_location pyFRorNot
uz  = zeros(numOfCells, length(timespan));
ur  = zeros(numOfCells, length(timespan));
uth = zeros(numOfCells, length(timespan));
p   = zeros(numOfCells, length(timespan));
disp('now calculate average field for following phase interpolation')
if pyFRorNot == 0
for k = 1:length(timespan)
    % import velocity data for each time step
    temp_location = [file_location,'/%g/%s'];
    filename      = sprintf(temp_location,timespan(k),'U');
    fid           = fopen(filename, 'rt');
    tempDataU     = textscan(fid, '(%f %f %f)','HeaderLines',22);
    fclose(fid);
    % Instantaneous velocity
    temp          = tempDataU{1};
    ux            = temp(indxOfSelectedCells);
    temp          = tempDataU{2};
    uy            = temp(indxOfSelectedCells);
    temp          = tempDataU{3};
    uz(:,k)       = temp(indxOfSelectedCells);
    % Decomposing the velocity to ur and uth  
    ur(:,k)       = ux.*cos(theta)+uy.*sin(theta);
    uth(:,k)      = uy.*cos(theta)-ux.*sin(theta);
    
    % import pressure data for each time step
    filename      = sprintf(temp_location,timespan(k),'p');
    fid           = fopen(filename, 'rt');
    tempDataP     = textscan(fid, '%f','HeaderLines',22);
    fclose(fid);
    % Instantaneous pressure
    temp          = tempDataP{1};
    p(:,k)        = temp(indxOfSelectedCells);
   
    clear tempDataU;
    clear tempDataP;
    disp(['now reading time = ',num2str(timespan(k))]);
end
else
    for k = 1:length(timespan)
    temp_location = pyfrs_name;
    filename      = sprintf(temp_location,timespan(k));
%     cd ('/media/ginn/data/post_processing_tools')
    [p(:,k),ux,uy,uz(:,k)]  = pyfrsReader(filename,'hex',indxOfSelectedCells);
    ur(:,k)       = ux.*cos(theta)+uy.*sin(theta);
    uth(:,k)      = uy.*cos(theta)-ux.*sin(theta);    
    disp(['now reading time = ',num2str(timespan(k))]);
    end
end
U_z_est  = mean(uz,2);
U_r_est  = mean(ur,2);
U_th_est = mean(uth,2);
P_est    = mean(p,z);
end