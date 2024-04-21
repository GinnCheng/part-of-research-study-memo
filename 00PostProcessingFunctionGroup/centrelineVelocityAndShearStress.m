%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% function to calculate centreline velocity, wall shear stress
 %  coded by ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function centrelineVelocityAndShearStress(uz_spAvg,uz_sptime_avg,avg_R,temp_dir)
global phase numOfPhases pulsatileOrNot
%% Calculate the bulk velocity and centreline velocity
uc_z_spAvg      = centrelineVelocityCalculator(uz_spAvg,avg_R);
uc_z_sptimeAvg  = centrelineVelocityCalculator(uz_sptime_avg,avg_R);

if (pulsatileOrNot == 0)
    save([temp_dir,'uc_z_spAvg.mat'],'uc_z_spAvg');
    save([temp_dir,'uc_z_sptimeAvg.mat'],'uc_z_sptimeAvg');
else
    save([temp_dir,'uc_z_spAvg_phase_',num2str(phase),'_of_',num2str(numOfPhases),'.mat'],'uc_z_spAvg');
    save([temp_dir,'uc_z_sptimeAvg_phase_',num2str(phase),'_of_',num2str(numOfPhases),'.mat'],'uc_z_sptimeAvg'); 
end

function u_c = centrelineVelocityCalculator(u_z,avg_R)
%% find the indx of centreline velocity
[~,indx] = min(abs(avg_R));
u_c      = u_z(indx,:);
end

end