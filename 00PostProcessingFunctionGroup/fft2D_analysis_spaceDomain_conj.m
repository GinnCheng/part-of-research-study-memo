%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is function for fft the fluctuation domain
 %  coded by ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Phi2d_all = fft2D_analysis_spaceDomain_conj(dataU,dataV,meanU,meanV,eff_fft_indx_x,eff_fft_indx_th,N_signal_piece_x,N_signal_piece_th,N_sampling_x,N_sampling_th)

temp_dataU      = dataU - meanU;
temp_dataV      = dataV - meanV;
     
temp_FFT2d_U    = fft2(temp_dataU,N_sampling_th,N_sampling_x);
temp_FFT2d_V    = fft2(temp_dataV,N_sampling_th,N_sampling_x);
    
temp_FFT_Phi2d  = abs(4.*temp_FFT2d_U./(N_signal_piece_x*N_signal_piece_th).*conj(temp_FFT2d_V./(N_signal_piece_x*N_signal_piece_th)));
Phi2d_all       = temp_FFT_Phi2d(eff_fft_indx_th,eff_fft_indx_x);     
% Phi2d_all       = Phi2d_all';

end
