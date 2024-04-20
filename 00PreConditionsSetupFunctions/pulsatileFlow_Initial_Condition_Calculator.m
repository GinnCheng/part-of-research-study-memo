%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Function for calculate the running and output timesteps of pulsatile
 %  flows.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pulsatileFlow_Initial_Condition_Calculator(U_cl_plus,U_cl_ratio,a_uc,nu,U_tau,omega_plus,R,numOfCycles,benchMarkRunTimeStep,expectedStartTime,numOfPointsPerCycle)
%% calculate the pressure grad oscillation
Re_cl       = (U_cl_plus.*U_tau).*R./nu; %centreline Reynolds number
Re_tau      = U_cl_plus.*U_tau.^2./nu;   %Re_tau
Kappa       = 0.35;

for i = 1:length(U_cl_ratio)
    for j = 1:length(omega_plus)
        beta     = U_cl_ratio(i).*omega_plus(j).*(Re_cl.^2)./Re_tau;
%         dpdz_uc  = 0.486.*U_cl_ratio(i).*omega_plus(j).*Re_cl; %pressureGrad amplitude ratio
        dpdz_uc  = 1+beta;
        omega    = omega_plus(j).*U_tau^2./nu;
        freq     = omega./(2*pi);
        T        = 1./freq;
        outputtimestep = T./numOfPointsPerCycle;
        
        %% find the best runtime step
        N_int    = [1:10000];
        optional_runtimeStep = outputtimestep./N_int;
        optional_runtimeStep = optional_runtimeStep(optional_runtimeStep < benchMarkRunTimeStep);
        runtimeStep          = max(optional_runtimeStep);
        runtimeStep          = round(runtimeStep,14); % cut off the number of sig digits
        pointPerCycle        = round(outputtimestep/runtimeStep,0);
        %% get the best runtimestep. calculate the truncational error
        err_trun             = (50 + numOfCycles).*abs(pointPerCycle .* runtimeStep - outputtimestep) .* numOfPointsPerCycle;
        outputtimestep       = pointPerCycle .* runtimeStep;
        T_corrected          = outputtimestep .* numOfPointsPerCycle;
        %% get the start time if we have already a time step 
        restartTime          = 0;
        N_iter               = 1;
        while (restartTime < expectedStartTime)
            restartTime      = N_iter*T_corrected;
            N_iter           = N_iter + 1;
        end
        tempResTimeStep      = (restartTime - expectedStartTime)./[1:1e5];
        tempResTimeStep      = tempResTimeStep(tempResTimeStep <= benchMarkRunTimeStep);
        restartTimeStep      = max(tempResTimeStep);
        
        ls                   = sqrt(2*nu/omega);
        ls_plus              = ls*U_tau/nu;
        lt_plus              = ls_plus*((Kappa*ls_plus/2) + sqrt(1+(Kappa*ls_plus/2)^2));
        
        disp(['Re_tau is ',num2str(U_tau*R/nu,'%.15f')])
        disp(['The case name is ',num2str(round(a_uc*100),'%02d'),'_',num2str(round(omega_plus*1000),'%03d')])
        disp(['pressure gradient is -4 and viscosity nu is ',num2str(nu,'%.15f')])
        disp('-------------------------------------------------')
        disp('---------------PULSATILE SETUPS------------------')
        disp('-------------------------------------------------')
        disp(['omega = ',num2str(omega,'%.15f'),' and frequency = ',num2str(freq,'%.15f'),'Hz and T = ',num2str(T,'%.15f'),'s'])      
        disp(['dpdz = ',num2str(dpdz_uc,'%.15f'),' for U_cl_uc = ',num2str(U_cl_ratio(i)),' and omega_plus = ',num2str(omega_plus(j))]);
        disp('-------------------------------------------------')
        disp('---------------OUTPUT SETUPS------------------')
        disp('-------------------------------------------------')
        disp(['IF YOU HAVE AN EXSISTING TIME FOLDER!!! t = ',num2str(expectedStartTime,'%.15f')])
        disp(['RECOMMEND TO START FROM ',num2str(restartTime,'%.15f'),' to ',num2str(restartTime + (numOfCycles + 1) .* T_corrected,'%.15f')]) 
        disp(['WE NEED A FIRST RUN FROM t = ',num2str(expectedStartTime,'%.15f'),' TO t = ',num2str(restartTime,'%.15f')])
        disp(['SO THE FIRST RUNTIME STEP dt = ',num2str(restartTimeStep,'%.15f')])
        disp(['SO THE FIRST WRITEINTERVAL = ',num2str((restartTime - expectedStartTime),'%.15f')])    
        disp('------------------IF NOT-----------------------')
        disp(['Recommend to start from ',num2str(50 * T_corrected,'%.15f'),' to ',num2str((50 + numOfCycles + 1).*T_corrected,'%.15f')]) 
        disp(['best runTime step dt is ',num2str(runtimeStep,'%.15f')])
        disp(['best writeInterval is ',num2str(outputtimestep,'%.15f')])
        disp(['total number of phase is ',num2str(numOfPointsPerCycle)])
        disp('-------------------------------------------------')      
        disp(['For ',num2str(numOfCycles),' cycles we need ',num2str((numOfCycles + 1).*T_corrected,'%.15f'),'s'])
        disp(['Output time every ',num2str(pointPerCycle,'%.15f'),' steps'])
        disp(['Truncational error of decimal effect is ',num2str(err_trun,'%.15f')])
        disp('-------------------------------------------------')
        disp('----------------FLOW PROPERTIES------------------')
        disp('-------------------------------------------------')
        disp(['Estimated centreline velocity is u_cl = ',num2str(U_cl_plus)])
        disp(['Estimated centreline Reynolds number is Re_cl = ',num2str(Re_cl)])     
        disp(['Stokes layer thickness is l^+_s = ',num2str(ls_plus)])
        disp(['Turbulent stokes layer thickness is l^+_t = ',num2str(lt_plus)])
        disp('-------------------------------------------------')
    end
end
end
