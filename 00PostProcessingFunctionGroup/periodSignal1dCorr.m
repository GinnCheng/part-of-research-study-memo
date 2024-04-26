function corr_period = periodSignal1dCorr(signal_x,signal_y)
% %% find the fluctuation
if size(signal_x,1) > size(signal_x,2)
    signal_x = signal_x';
    signal_y = signal_y';
end
% find fluctuations
signal_x     = signal_x - mean(signal_x);
signal_y     = signal_y - mean(signal_y);
% calculate crosscorrelation
signal_x_hat = fft(signal_x);
signal_y_hat = fft(signal_y);

corr_period = ifft(signal_x_hat.*conj(signal_y_hat));

%% cut the corr coeff
corr_period = corr_period./std(signal_x)./std(signal_y)./length(signal_x);

end