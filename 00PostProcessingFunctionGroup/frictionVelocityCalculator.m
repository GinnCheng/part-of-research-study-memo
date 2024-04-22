%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is a function to read the wallShearStress file and calculate Utau
 %  coded by Ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [UtauAvg,tau_w,tau_wAvg,timeSpan] = frictionVelocityCalculator(file_location,timeSpan,temp_dir)
global pipeLength R phase numOfPhases pulsatileOrNot
%% get surface area
surfA         = 2*pi*R*pipeLength;

%% read the file
filename      = [file_location,'/sumAvgTotalDrag'];
fid           = fopen(filename, 'r');
tempDataU     = textscan(fid, '%f %f %f %f');
fclose(fid);

timePoint     = tempDataU{1};
% tau_w         = tempDataU{2};
% drag_p        = tempDataU{3};
tot_drag      = tempDataU{4}./surfA;

%% find the indx of the corresponding wall shear stress
timeSpan      = timeSpan(timeSpan >= timePoint(1) & timeSpan <= timePoint(end));
tau_w         = interp1(timePoint,tot_drag,timeSpan);

%% calculate average U_tau
UtauAvg     = round(mean(tau_w)/abs(mean(tau_w))).*sqrt(abs(mean(tau_w)));
tau_wAvg    = mean(tau_w);

if (pulsatileOrNot == 0)
    save([temp_dir,'UtauAvg.mat'],'UtauAvg');
    save([temp_dir,'tau_w.mat'],'tau_w');
    save([temp_dir,'tau_wAvg.mat'],'tau_wAvg');
    save([temp_dir,'timeSpanUtau.mat'],'timeSpan');
else
    save([temp_dir,'UtauAvg_phase_',num2str(phase),'_of_',num2str(numOfPhases),'.mat'],'UtauAvg');
    save([temp_dir,'tau_w_phase_',num2str(phase),'_of_',num2str(numOfPhases),'.mat'],'tau_w');
    save([temp_dir,'tau_wAvg_phase_',num2str(phase),'_of_',num2str(numOfPhases),'.mat'],'tau_wAvg');
    save([temp_dir,'timeSpanUtau_phase_',num2str(phase),'_of_',num2str(numOfPhases),'.mat'],'timeSpan');
end    
    
end