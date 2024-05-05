%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% postProcessing Q criterion
 %  coded by ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function QCriterionPostProcessing(Q,uz,ur,uth,avg_R,avg_th,avg_z,loc_r_group,loc_th_group,loc_z_group,temp_dir)
global pulsatileOrNot phase numOfPhases
%% first we need to get Q for every level
%% set flow field signal indices
flowField_indx = streamwiseFieldIndexSorter(avg_R,avg_th,avg_z,loc_r_group,loc_th_group);
%% streaks th x plane
disp('start mapping the Q structure in the entire domain');
%% check whether instant flow is already there
if (pulsatileOrNot == 0) 
    if (exist([temp_dir,'domainInstantVelocity.mat'],'file') ~= 0)
        InstantVelocityOrNot = 1;
    else
        InstantVelocityOrNot = 0;
    end
else
    if (exist([temp_dir,'domainInstantVelocity_phase_',num2str(phase),'_of_',num2str(numOfPhases),'.mat'],'file') ~= 0)
        InstantVelocityOrNot = 1;
    else
        InstantVelocityOrNot = 0;
    end
end
%% now find structure while interpolating
domain_Q  = Q(flowField_indx);
if InstantVelocityOrNot == 0
   domain_uz        = uz(flowField_indx);
   domain_ur        = ur(flowField_indx);
   domain_uth       = uth(flowField_indx);
end

disp('finish Qstrucutre remapping for the entire domain');

%% save it to mat file
if (pulsatileOrNot == 0)    
    save([temp_dir,'QCriterion.mat'],'domain_Q');
    if InstantVelocityOrNot == 0
        save([temp_dir,'domainInstantVelocity.mat'],'domain_uz','domain_ur','domain_uth');
    end
else
    save([temp_dir,'QCriterion_phase_',num2str(phase),'_of_',num2str(numOfPhases),'.mat'],'domain_Q');
    if InstantVelocityOrNot == 0
        save([temp_dir,'domainInstantVelocity_phase_',num2str(phase),'_of_',num2str(numOfPhases),'.mat'],'domain_uz','domain_ur','domain_uth');
    end
end
end