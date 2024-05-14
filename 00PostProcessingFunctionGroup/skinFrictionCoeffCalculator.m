%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculate Skin friction coeff
 %  coded by ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Cf,CfAvg] = skinFrictionCoeffCalculator(tau_w,U_b,temp_dir)
global phase numOfPhases pulsatileOrNot

%% calculate skin friction Coeff
Cf      = tau_w./(U_b.^2./2);
CfAvg   = mean(Cf);

if (pulsatileOrNot == 0)
    save([temp_dir,'Cf.mat'],'Cf');
    save([temp_dir,'CfAvg.mat'],'CfAvg');
else
    save([temp_dir,'Cf_phase_',num2str(phase),'_of_',num2str(numOfPhases),'.mat'],'Cf');
    save([temp_dir,'CfAvg_phase_',num2str(phase),'_of_',num2str(numOfPhases),'.mat'],'CfAvg');
end  

end