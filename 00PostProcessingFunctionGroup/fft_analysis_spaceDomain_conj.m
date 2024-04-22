%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is function for fft the fluctuation domain
 %  coded by ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Phi_all = fft_analysis_spaceDomain_conj(dataU,dataV,meanU,meanV,eff_fft_indx,N_signal_piece,N_sampling)

temp_dataU    = dataU - meanU;
temp_dataV    = dataV - meanV;
     
temp_FFT_U    = fft(temp_dataU,N_sampling);
temp_FFT_V    = fft(temp_dataV,N_sampling);
    
temp_FFT_Phi  = abs(2.*temp_FFT_U./N_signal_piece.*conj(temp_FFT_V./N_signal_piece));
Phi_all       = mean(temp_FFT_Phi(eff_fft_indx,:),2);     
Phi_all       = Phi_all';

end
