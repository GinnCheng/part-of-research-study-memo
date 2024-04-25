%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is a function to display the information
 %  coded by Ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function infoDisplay
global file_location pulsatileOrNot roughWallOrNot Re_tau U_tau nu R pipeLength R_over_h lambda_over_R omega
disp(['Now postprocess the case in ',file_location])
disp(['Re_tau is ',num2str(Re_tau)])
disp(['Pipe length is ',num2str(pipeLength)])
if roughWallOrNot == 1
    disp(['Roughness parameter is ',num2str(round(R/R_over_h*U_tau/nu)),'_',num2str(round(lambda_over_R*R*U_tau/nu))])
else
    disp('Smooth pipe')
end
if pulsatileOrNot == 1
    disp(['Pulsation parameter is ',num2str(omega*nu/U_tau^2)])
else
    disp('Non-pulsatile flow')
end
