%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is a function to postprocess RMS skewness and quadrant analysis
 %  code by ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pressureRMS_quadrantAnalysis_skewness(p,p_sptime_avg,loc_r_group,y_plus_log,U_tauAvg,avg_R,temp_dir)
global R U_tau viscous_unit pulsatileOrNot phase numOfPhases

%%  group velocity profile for each r location
p_rms                  = zeros(size(loc_r_group));

%% Joint probability density function
group_p_prime   = cell(size(loc_r_group));
p_pdf           = cell(size(loc_r_group));

%% skewness 
S_p          = zeros(size(loc_r_group));
pos_S_p      = zeros(size(loc_r_group));
neg_S_p      = zeros(size(loc_r_group));

%% start post processing
disp('start postprocessing pressure including Q-analysis, skewness and pdf');

for i_group = 1:length(loc_r_group)
    indx_r  = loc_r_group{i_group};
    % using root mean square RMS
    p_rms(i_group)                                = rootMeanSquare(p(indx_r),p_sptime_avg(i_group));
    
    % calculate skewness
    [S_p(i_group),pos_S_p(i_group),neg_S_p(i_group)]  = skewness_decomposition(p(indx_r),p_sptime_avg(i_group));
    
    % joint probability density function
    [group_p_prime{i_group},~,p_pdf{i_group},~,~]     = jointPDF(p(indx_r),p(indx_r),p_sptime_avg(i_group),p_sptime_avg(i_group),40); 
end

disp('finish postprocessing pressure including Q-analysis, skewness and pdf');   

%%  devided by U_tau
TI_p                    = p_rms./U_tauAvg^2;
S_p                     = S_p./U_tauAvg^6;
pos_S_p                 = pos_S_p./U_tauAvg^6;
neg_S_p                 = neg_S_p./U_tauAvg^6;

%% plot figures
%% for non-pulsatile case
if (pulsatileOrNot == 0)    
%  plot figures
hFig = figure('visible','off');
plot(y_plus_log,TI_p,'bo-')
grid on
xlabel('y^+')
ylabel('p RMS')
title('p RMS')
% Set CreateFcn callback
set(hFig, 'CreateFcn', 'set(gcbo,''Visible'',''on'')'); 
temp_name = ['p_RMS.fig'];
savefig(hFig,[temp_dir,temp_name])
close

%% save data .mat files
save([temp_dir,'TI_p.mat'],'TI_p');
save([temp_dir,'group_p_prime.mat'],'group_p_prime');
save([temp_dir,'p_pdf.mat'],'p_pdf');
save([temp_dir,'S_p.mat'],'S_p');
save([temp_dir,'pos_S_p.mat'],'pos_S_p');
save([temp_dir,'neg_S_p.mat'],'neg_S_p');

end

%% for pulsatile case 
if (pulsatileOrNot == 1)
hFig = figure('visible','off');
plot(y_plus_log,TI_p,'bo-')
grid on
xlabel('y^+')
ylabel('p RMS')
title('p RMS')
% Set CreateFcn callback
set(hFig, 'CreateFcn', 'set(gcbo,''Visible'',''on'')'); 
temp_name = ['p_RMS_phase_',num2str(phase),'_of_',num2str(numOfPhases),'.fig'];
savefig(hFig,[temp_dir,temp_name])
close

%% save data .mat files
save([temp_dir,'TI_p_phase_',num2str(phase),'_of_',num2str(numOfPhases),'.mat'],'TI_p');
save([temp_dir,'group_p_prime_phase_',num2str(phase),'_of_',num2str(numOfPhases),'.mat'],'group_p_prime');
save([temp_dir,'p_pdf_phase_',num2str(phase),'_of_',num2str(numOfPhases),'.mat'],'p_pdf');
save([temp_dir,'S_p_phase_',num2str(phase),'_of_',num2str(numOfPhases),'.mat'],'S_p');
save([temp_dir,'pos_S_p_phase_',num2str(phase),'_of_',num2str(numOfPhases),'.mat'],'pos_S_p');
save([temp_dir,'neg_S_p_phase_',num2str(phase),'_of_',num2str(numOfPhases),'.mat'],'neg_S_p');

end

end

