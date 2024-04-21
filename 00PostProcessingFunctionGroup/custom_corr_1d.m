%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% signal correlation
 %%%  coded by Ginn
  %  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function corr_1d = custom_corr_1d(signal_x,signal_y)
%% find standard deviation
signal_x = signal_x - mean(signal_x);
signal_y = signal_y - mean(signal_y);
%% corr
corr_1d = mean(signal_x.*signal_y)./std(signal_x)./std(signal_y)./(length(signal_x)-1).*length(signal_x);
end