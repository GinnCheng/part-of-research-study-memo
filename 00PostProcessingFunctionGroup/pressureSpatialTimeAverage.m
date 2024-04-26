%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is a function to postprocess mean pressure
 %  code by ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [p_spAvg,p_sptime_avg] = pressureSpatialTimeAverage(p,loc_r_group,timePeriod,y_plus_log,U_tauAvg,temp_dir)
global pulsatileOrNot phase numOfPhases

p_spAvg            = zeros(length(loc_r_group),length(timePeriod));

%%  find space average for veloctiy of each location of r
for i_group = 1:length(loc_r_group)
    p_spAvg(i_group,:)     = mean(p(cell2mat(loc_r_group(i_group)),:),1);
end

%  find space-time average
p_sptime_avg               = mean(p_spAvg,2);

%% plot figure and save data
p_over_U_tau_square           = p_sptime_avg./U_tauAvg^2;

if (pulsatileOrNot == 0)  
    hFig = figure('visible','off');
    semilogx(y_plus_log,p_over_U_tau_square,'ro-','linewidth',1.5)
    hold on
    grid on
    xlabel('yU_\tau/\nu')
    ylabel('p/U^2_\tau')
    title('streamwise mean pressure')
    % Set CreateFcn callback
    set(hFig, 'CreateFcn', 'set(gcbo,''Visible'',''on'')'); 
    temp_name = ['p_over_U_tau_square.fig'];
    savefig(hFig,[temp_dir,temp_name])
    close
    
    save([temp_dir,'p_over_U_tau_square.mat'],'p_over_U_tau_square');
end

if (pulsatileOrNot == 1)
    %  plot figures
    hFig = figure('visible','off');
    semilogx(y_plus_log,p_over_U_tau_square,'ro-','linewidth',1.5)
    hold on
    grid on
    xlabel('yU_\tau/\nu')
    ylabel('p/U^2_\tau')
    title('streamwise mean pressure')
    % Set CreateFcn callback
    set(hFig, 'CreateFcn', 'set(gcbo,''Visible'',''on'')'); 
    temp_name = ['p_over_U_tau_square_phase_',num2str(phase),'_of_',num2str(numOfPhases),'.fig'];
    savefig(hFig,[temp_dir,temp_name])
    close

    save([temp_dir,'p_over_U_tau_square_phase_',num2str(phase),'_of_',num2str(numOfPhases),'.mat'],'p_over_U_tau_square');
end

end
