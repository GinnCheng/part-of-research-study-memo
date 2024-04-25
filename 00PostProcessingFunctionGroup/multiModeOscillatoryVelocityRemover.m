%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Oscillatory Velocity Remover
 %  coded by Ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [interp_dT,interpDataT,interp_ux,interp_uy,interp_uz] = multiModeOscillatoryVelocityRemover(timePeriod,omega,uniqueDataT,ux,uy,uz)
%% firstly find the periodic DeltaT
dT           = mean(timePeriod(2:end) - timePeriod(1:end-1));
%% the freq omega can be more than one
T_cycle      = 2*pi/omega; % pulsatile period in time
Np_per_cycle = floor(T_cycle/dT); % num of points per cycle in interger
interp_dT    = T_cycle/Np_per_cycle; % interpT
N_cycle      = floor((uniqueDataT(end) - uniqueDataT(1))./T_cycle); % num of cycles that we can have
disp(['We have ',num2str(N_cycle),' cycles']);
% create T range
interpDataT  = linspace(uniqueDataT(1),uniqueDataT(1)+N_cycle*T_cycle,N_cycle*Np_per_cycle + 1);
interpDataT  = interpDataT(1:end-1)';
if length(interpDataT) ~= Np_per_cycle*N_cycle
    error('num of points is not interger of cycles')
end
% interp data
interp_ux   = interp1(uniqueDataT,ux,interpDataT);
interp_uy   = interp1(uniqueDataT,uy,interpDataT);
interp_uz   = interp1(uniqueDataT,uz,interpDataT);

%% remove phase averaged velocity
for i = 1:Np_per_cycle
    indx_in_sameT = Np_per_cycle .* [0:N_cycle-1] + i;
    phaseAvg_uz   = mean(interp_uz(indx_in_sameT,:),1);
    for j = 1:N_cycle
        interp_uz(indx_in_sameT(j),:) = interp_uz(indx_in_sameT(j),:) - phaseAvg_uz;
    end
end

end
