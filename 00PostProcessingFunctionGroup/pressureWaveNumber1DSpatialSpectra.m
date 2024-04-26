%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Space Power Density Spectrum
 %  coded by Ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pressureWaveNumber1DSpatialSpectra(avg_R,avg_TH,avg_Z,loc_r_group,loc_th_group,p,avg_p,avg_uz,zeroPaddingRatio,temp_dir)
global viscous_unit R phase numOfPhases pulsatileOrNot pipeLength
%% streaks th x plane
disp('start space pressure spectra analysis');

%% set flow field signal indices
flowField_indx = streamwiseFieldIndexSorter(avg_R,avg_TH,avg_Z,loc_r_group,loc_th_group);

%% get the effective freq range
N_signal_piece      = length(avg_Z);                   % num of signal per interval
eff_fft_indx        = 1:floor(zeroPaddingRatio.*N_signal_piece/2)+1; % effective index of the fft
N_sampling          = zeroPaddingRatio.*N_signal_piece;

%% create the index of all wall-normal locations  
Phi_p               = cell(length(avg_R),1);
fs                  = cell(length(avg_R),1);
y_plus              = zeros(size(avg_R));
k_x                 = 2.*pi.*linspace(0,floor(length(avg_Z)/2),length(eff_fft_indx))./pipeLength; % wavenumber in radiant per meter
lambda_x            = 2.*pi./k_x;                                                            % wavelength in meter
for i = 1:length(avg_R) 
    temp_Phi_p      = zeros;
    %% now we can loop
    % loop theta
    for j = 1:length(avg_TH)                   
        temp_Phi_p   = temp_Phi_p   + fft_analysis_spaceDomain_conj(p(flowField_indx(i,j,:),:),p(flowField_indx(i,j,:),:),avg_p(i),avg_p(i),eff_fft_indx,N_signal_piece,N_sampling);                     
    end
    Phi_p(i)       = {temp_Phi_p./length(avg_TH)};
    y_plus(i)      = (R - avg_R(i))./viscous_unit; 
    fs(i)          = {avg_uz(i)./lambda_x};  % freq in (Hz)
end        
          
%% store data    
if pulsatileOrNot == 0
    save([temp_dir,'spacePressureSpectra.mat'],...
        'y_plus','Phi_p','fs','lambda_x','k_x');   
else
    save([temp_dir,'spacePressureSpectra_phase_',num2str(phase),'_of_',num2str(numOfPhases),'.mat'],...
        'y_plus','Phi_p','fs','lambda_x','k_x');  
end

end