%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is for integrating the data
 %  coded by Ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% integrate all windows
function dataIntegrator(needToIntegrateWindows)
global pulsatileOrNot timeRange
if (needToIntegrateWindows == 1)
     %%  for steady cases
    if (pulsatileOrNot == 0)
    y_plus = cell(1,length(timeRange) -1);
    u_plus = cell(1,length(timeRange) -1);
    u_rms  = cell(1,length(timeRange) -1);
    v_rms  = cell(1,length(timeRange) -1);
    w_rms  = cell(1,length(timeRange) -1);
%     N_r    = zeros(length(timeRange) -1);
    U_tauAvg = zeros(1,length(timeRange) -1);
    timeSpan = zeros(1,length(timeRange) -1);
    for i = 1:length(timeRange) -1
        temp        = load([file_location,'/00result_',num2str(timeRange(i)),'s_',num2str(timeRange(i+1)),'s/y_plus_log.mat']);
        y_plus(i)   = {temp.y_plus_log};
        temp        = load([file_location,'/00result_',num2str(timeRange(i)),'s_',num2str(timeRange(i+1)),'s/U_over_U_tau_z.mat']);
        u_plus(i)   = {temp.U_over_U_tau_z};
        temp        = load([file_location,'/00result_',num2str(timeRange(i)),'s_',num2str(timeRange(i+1)),'s/TI_r.mat']);
        u_rms(i)    = {temp.TI_r};
        temp        = load([file_location,'/00result_',num2str(timeRange(i)),'s_',num2str(timeRange(i+1)),'s/TI_th.mat']);
        v_rms(i)    = {temp.TI_theta};
        temp        = load([file_location,'/00result_',num2str(timeRange(i)),'s_',num2str(timeRange(i+1)),'s/TI_z.mat']);
        w_rms(i)    = {temp.TI_z};
        temp        = load([file_location,'/00result_',num2str(timeRange(i)),'s_',num2str(timeRange(i+1)),'s/windowSize.mat']);
        N_r(:,:,i)  = temp.N_r;        
        temp        = load([file_location,'/00result_',num2str(timeRange(i)),'s_',num2str(timeRange(i+1)),'s/U_tauAvg.mat']);
        U_tauAvg(i) = temp.U_tauAvg;
        temp        = load([file_location,'/00result_',num2str(timeRange(i)),'s_',num2str(timeRange(i+1)),'s/timeSpan.mat']);
        timeSpan(i) = temp.timeSpan;
    end
    %% Now to integrate all windows
%     cd ('/media/ginn/data/post_processing_tools')
    total_u_plus = total_mean_integrator(u_plus,N_r,U_tauAvg,timeSpan);
    total_u_rms  = total_RMS_integrator(u_rms,N_r,U_tauAvg,timeSpan);
    total_v_rms  = total_RMS_integrator(v_rms,N_r,U_tauAvg,timeSpan);
    total_w_rms  = total_RMS_integrator(w_rms,N_r,U_tauAvg,timeSpan);
    total_y_plus = cell2mat(y_plus(1));
    
    %% plot all figures
   
    %  create files folder
    cd(file_location)
    temp_dir = ['00InteResult_',num2str(total_initial_t),'s_',num2str(total_final_t),'s'];
    if -exist(temp_dir,'dir') == 0
        mkdir(temp_dir);
    end
    temp_dir = [file_location,'/',temp_dir,'/'];
%     cd(temp_dir)

    %  plot figures
    figure()
    semilogx(total_y_plus,total_u_plus,'r^','linewidth',1.5)
    hold on
    grid on
    xlabel('yU_\tau/\nu')
    ylabel('u/U_\tau')
    title('streamwise mean velocity')
    temp_name = ['log_law_z.fig'];
    savefig([temp_dir,temp_name])
    close

    figure()
    plot(total_y_plus,total_w_rms,'b^')
    grid on
    xlabel('y^+')
    ylabel('u_z RMS')
    title('u_z RMS')
    temp_name = ['u_z_RMS.fig'];
    savefig([temp_dir,temp_name])
    close

    figure()
    plot(total_y_plus,total_u_rms,'b^')
    grid on
    xlabel('y^+')
    ylabel('u_r RMS')
    title('u_r RMS')
    temp_name = ['u_r_RMS.fig'];
    savefig([temp_dir,temp_name])
    close

    figure()
    plot(total_y_plus,total_v_rms,'b^')
    grid on
    xlabel('y^+')
    ylabel('u_\theta RMS')
    title('u_\theta RMS')
    temp_name = ['u_theta_RMS.fig'];
    savefig([temp_dir,temp_name])
    close
    end
    
    %%  for pulsatile cases
    if (pulsatileOrNot == 1)
    y_plus = cell(1,length(timeRange) -1);
    u_plus = cell(1,length(timeRange) -1);
    u_rms  = cell(1,length(timeRange) -1);
    v_rms  = cell(1,length(timeRange) -1);
    w_rms  = cell(1,length(timeRange) -1);
%     N_r    = zeros(length(timeRange) -1);
    U_tauAvg = zeros(1,length(timeRange) -1);
    timeSpan = zeros(1,length(timeRange) -1);
    for i = 1:length(timeRange) -1
        temp        = load([file_location,'/00result_',num2str(timeRange(i)),'s_',num2str(timeRange(i+1)),'s','/y_plus_log_phase_',num2str(phase),'.mat']);
        y_plus(i)   = {temp.y_plus_log};
        temp        = load([file_location,'/00result_',num2str(timeRange(i)),'s_',num2str(timeRange(i+1)),'s','/U_over_U_tau_z.mat']);
        u_plus(i)   = {temp.U_over_U_tau_z};
        temp        = load([file_location,'/00result_',num2str(timeRange(i)),'s_',num2str(timeRange(i+1)),'s','/TI_r.mat']);
        u_rms(i)    = {temp.TI_r};
        temp        = load([file_location,'/00result_',num2str(timeRange(i)),'s_',num2str(timeRange(i+1)),'s','/TI_th.mat']);
        v_rms(i)    = {temp.TI_th};
        temp        = load([file_location,'/00result_',num2str(timeRange(i)),'s_',num2str(timeRange(i+1)),'s','/TI_z.mat']);
        w_rms(i)    = {temp.TI_z};       
        temp        = load([file_location,'/00result_',num2str(timeRange(i)),'s_',num2str(timeRange(i+1)),'s','/windowSize.mat']).windowSize;
        N_r(:,:,i)  = temp.N_r;
        temp        = load([file_location,'/00result_',num2str(timeRange(i)),'s_',num2str(timeRange(i+1)),'s','/U_tauAvg.mat']);
        U_tauAvg(i) = temp.U_tauAvg;
        temp        = load([file_location,'/00result_',num2str(timeRange(i)),'s_',num2str(timeRange(i+1)),'s','/timeSpan.mat']);
        timeSpan(i) = temp.timeSpan;
    end
    %% Now to integrate all windows
    cd ('/media/ginn/data/post_processing_tools')
    total_u_plus = total_mean_integrator(u_plus,N_r,U_tauAvg,timeSpan);
    total_u_rms  = total_RMS_integrator(u_rms,N_r,U_tauAvg,timeSpan);
    total_v_rms  = total_RMS_integrator(v_rms,N_r,U_tauAvg,timeSpan);
    total_w_rms  = total_RMS_integrator(w_rms,N_r,U_tauAvg,timeSpan);
    total_y_plus = cell2mat(y_plus(1));
    
    %% plot all figures
    
    %  create files folder
    cd(file_location)
    temp_dir = ['00InteResult_',num2str(total_initial_t),'s_',num2str(total_final_t),'s'];
    if -exist(temp_dir,'dir') == 0
        mkdir(temp_dir);
    end
    temp_dir = [file_location,'/',temp_dir,'/'];
%     cd(temp_dir)

    %  plot figures
    figure()
    semilogx(total_y_plus,total_u_plus,'r^','linewidth',1.5)
    hold on
    grid on
    xlabel('yU_\tau/\nu')
    ylabel('u/U_\tau')
    title('streamwise mean velocity')
    temp_name = ['log_law_z_phase_',num2str(phase),'.fig'];
    savefig([temp_dir,temp_name])
    close

    figure()
    plot(total_y_plus,total_w_rms,'b^')
    grid on
    xlabel('y^+')
    ylabel('u_z RMS')
    title('u_z RMS')
    temp_name = ['u_z_RMS_phase_',num2str(phase),'.fig'];
    savefig([temp_dir,temp_name])
    close

    figure()
    plot(total_y_plus,total_u_rms,'b^')
    grid on
    xlabel('y^+')
    ylabel('u_r RMS')
    title('u_r RMS')
    temp_name = ['u_r_RMS_phase_',num2str(phase),'.fig'];
    savefig([temp_dir,temp_name])
    close

    figure()
    plot(total_y_plus,total_v_rms,'b^')
    grid on
    xlabel('y^+')
    ylabel('u_\theta RMS')
    title('u_\theta RMS')
    temp_name = ['u_theta_RMS_phase_',num2str(phase),'.fig'];
    savefig([temp_dir,temp_name])
    close
    end
    cd(temp_dir)
end