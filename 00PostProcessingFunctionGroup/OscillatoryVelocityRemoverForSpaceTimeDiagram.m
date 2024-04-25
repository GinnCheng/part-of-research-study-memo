%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Oscillatory Velocity Remover
 %  coded by Ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [interpDataT,interp_ur,interp_uz] = OscillatoryVelocityRemoverForSpaceTimeDiagram(ur,uz)
global omega timePeriod
%% firstly find the periodic DeltaT
T_cycle      = 2*pi/omega; % pulsatile period in time
uniqueDataT  = timePeriod';
dT           = timePeriod(2) - timePeriod(1);
Np_per_cycle = floor(T_cycle/dT); % num of points per cycle in interger
N_cycle      = floor((uniqueDataT(end) - uniqueDataT(1))./T_cycle); % num of cycles that we can have
% set actual_t
interpDataT  = [];
for i = 1:Np_per_cycle
    [actual_t,~,~,~,~,~] = pulsatile_phase_decomposition(timePeriod,omega,i-1,Np_per_cycle,N_cycle);
    if i == 1
        actual_t_0 = min(actual_t);
    end
    interpDataT = cat(2,interpDataT,actual_t);
end
interpDataT = sort(interpDataT,'ascend');
interpDataT = interpDataT';
% start interplation
disp(['We have ',num2str(N_cycle),' cycles']);
if length(interpDataT) ~= Np_per_cycle*N_cycle
    error('num of points is not interger of cycles')
end
% interp data
interp_ur   = interp1(uniqueDataT,ur',interpDataT);
interp_uz   = interp1(uniqueDataT,uz',interpDataT);

%% remove phase averaged velocity
for i = 1:Np_per_cycle
    indx_in_sameT = Np_per_cycle .* [0:N_cycle-1] + i;
    phaseAvg_uz   = mean(interp_uz(indx_in_sameT,:),1);
    for j = 1:N_cycle
        interp_uz(indx_in_sameT(j),:) = interp_uz(indx_in_sameT(j),:) - phaseAvg_uz;
    end
end

%% pick num of cycles
numOfCycles  = N_cycle - 1;

interp_uz    = interp_uz([interpDataT >= actual_t_0],:);
interp_ur    = interp_ur([interpDataT >= actual_t_0],:);
interpDataT  = interpDataT(interpDataT >= actual_t_0);

interpDataT  = interpDataT([1:numOfCycles*Np_per_cycle]);
interp_uz    = interp_uz([1:numOfCycles*Np_per_cycle],:);
interp_ur    = interp_ur([1:numOfCycles*Np_per_cycle],:);

%% reorder interp_uz and interp_ur
interp_uz    = interp_uz';
interp_ur    = interp_ur';

end
