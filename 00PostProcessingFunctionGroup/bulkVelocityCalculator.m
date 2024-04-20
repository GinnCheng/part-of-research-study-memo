%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% This is for calculating the bulk velocity by integrating the mean
 %%%  velocity profile of the flow
  %   coded by Ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ub_z_spAvg,ub_z_sptimeAvg] = bulkVelocityCalculator(file_location,timeSpan,temp_dir)
global phase numOfPhases pulsatileOrNot

%% read the file
filename      = [file_location,'/sumAvgUbulk'];
fid           = fopen(filename, 'r');
tempDataU     = textscan(fid, '%f %f');
fclose(fid);

timePoint     = tempDataU{1};
ub            = tempDataU{2};

%% find the indx of the corresponding wall shear stress
timeSpan      = timeSpan(timeSpan >= timePoint(1) & timeSpan <= timePoint(end));
ub_z_spAvg    = interp1(timePoint,ub,timeSpan);

%% calculate average U_tau
ub_z_sptimeAvg     = mean(ub_z_spAvg);

if (pulsatileOrNot == 0)
    save([temp_dir,'ub_z_spAvg.mat'],'ub_z_spAvg');
    save([temp_dir,'ub_z_sptimeAvg.mat'],'ub_z_sptimeAvg');
    save([temp_dir,'timeSpanUbulk.mat'],'timeSpan');
else
    save([temp_dir,'ub_z_spAvg_phase_',num2str(phase),'_of_',num2str(numOfPhases),'.mat'],'ub_z_spAvg');
    save([temp_dir,'ub_z_sptimeAvg_phase_',num2str(phase),'_of_',num2str(numOfPhases),'.mat'],'ub_z_sptimeAvg');
    save([temp_dir,'timeSpanUbulk_phase_',num2str(phase),'_of_',num2str(numOfPhases),'.mat'],'timeSpan');
end  

end
