%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Fluid Post Processing tool by Ginn
 %%%  Through select same radius
  %   create radius group for various 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function binNekPostProcessing(sample_R,sample_TH,sample_Z,num_of_z_mesh)
%% Declare global constants 
global pulsatileOrNot
global file_location viscous_unit omega
global coord_location
global total_initial_t total_final_t
global numOfCycles phase numOfPhases U_tau
global velocityPostprocess velocity_RMS_PDF_Skewness outputStreaks spaceSpectraAnalysis calUcTauWall lambda2Criterion QCriterion
global pressurePostprocess pressure_RMS_PDF_skewness SpaceTimeDiagram corrContour multiMode

%% some confinement
if ((velocityPostprocess == 0) && ((velocity_RMS_PDF_Skewness + outputStreaks + spaceSpectraAnalysis) > 0))
    disp({'If you are post processing velocity profiles, switch on "velocityPostProcess"';'You might also have to choose one switch to postprocessing velocity profiles'})
    error('post processing stop')
end

if ((pressurePostprocess == 0) ~= (pressure_RMS_PDF_skewness == 0))
    disp({'If you are post processing pressure profiles, switch on "pressurePostProcess"';'You might also have to choose one switch to postprocessing pressure profiles'})
    error('post processing stop')
end

%% cd to the direction
% cd(file_location)

%% Importing the coordinates
% OpenFOAM Mode reading coordinate file
[coord,uniqueIndx,numOfNodes]               = NekCoordReadingFunction(coord_location);
%% interpolate by delaunay triangulation so that the results can be mapped to a cylindrical coordinate
% create new cylindrical coord
new_coord                                   = InterpCylindricalCoordGenerator(sample_R,sample_TH,sample_Z);
% expanded old coord
[coord,extended_indx]                       = DelaunayMeshCoordExtender(coord,num_of_z_mesh);
% create delaunay coeff for linear interp
[DelaunayMatrix,weightCoeff,new_coord]      = DelaunayScatterInterpN(coord,new_coord,coord_location,num_of_z_mesh);
% replace coord with new_coord
coord = new_coord;
clear new_coord;

%% Convert the coordinates from Cartesian to Polar based on Quadrant
% number of cells of the entire mesh
theta       = atan2(coord(:,2),coord(:,1));
% convert x y coordinate into radius
rCoord      = sqrt(coord(:,1).^2+coord(:,2).^2);
zCoord      = coord(:,3);

%% screen radius, theta and z so that the num of point we need to read is not so many
[avg_R,loc_r_group,num_r_group]             = group_coord(rCoord,sample_R);
[avg_th,loc_th_group,num_th_group]          = group_coord(theta,sample_TH);
[avg_z,loc_z_group,num_z_group]             = group_coord(zCoord,sample_Z);

%% Importing the velocity field data from each time directory
%   convert ux uy to ur utheta and record uz for all time steps
%   record ur utheta and uz for each time step
if(velocityPostprocess + lambda2Criterion + QCriterion + velocity_RMS_PDF_Skewness + outputStreaks + SpaceTimeDiagram + corrContour > 0)
[ur,uth,uz,p,timePeriod] = NekVelocityPressureFieldReadingFunction(file_location,numOfNodes,theta,DelaunayMatrix,weightCoeff,extended_indx,uniqueIndx);
end
% %   record lambda2 criterion
% if (lambda2Criterion == 1)
% lambda2                    = ofLambda2ReadingFunction(folder,numOfCells,file_location,DelaunayMatrix,weightCoeff,extended_indx);
% end
% %   record Q criterion
% if (QCriterion == 1)
% Q                          = ofQReadingFunction(folder,numOfCells,file_location,DelaunayMatrix,weightCoeff,extended_indx);
% end
% %   record pressure for each time step
% if (pressurePostprocess == 1)
% p                          = ofPressureReadingFunction(folder,numOfCells,file_location,DelaunayMatrix,weightCoeff,extended_indx);
% end

clear coord DelaunayMatrix surroundPoints weightCoeff;

%% get the interplated phase time
disp(['START from t = ',num2str(timePeriod(1)),' to t = ',num2str(timePeriod(end)),' s'])
    %% pulsatile parameters
    if (pulsatileOrNot == 1)           
        %% screen the accordinate phase
        [actual_t,timePeriod,phaseTimeIndx] = pulsatile_phase_decomposition_nearest(timePeriod,omega,phase,numOfPhases,numOfCycles);
        if (phase > numOfPhases - 1)
            error('WARNING! phase exceeds!')
        end
        disp(['we have ',num2str(length(actual_t)),' cycles for phase ',num2str(phase),' of ',num2str(numOfPhases)])
        %% pickout the certain phase
        ur  = ur(:,phaseTimeIndx);
        uth = uth(:,phaseTimeIndx);
        uz  = uz(:,phaseTimeIndx);
        p   = p(:,phaseTimeIndx);
    else
        disp(['we have ',num2str(length(timePeriod)),' timesteps'])
    end

%% save all files into a result directory
% cd('/media/ginn/data/post_processing_tools')
if(multiMode == 0)
    if(pulsatileOrNot == 0)
        temp_dir = ['00result_',num2str(total_initial_t),'s_',num2str(total_final_t),'s'];
        temp_dir = [file_location,'/',temp_dir,'/'];
        if -exist(temp_dir,'dir') == 0
            mkdir(temp_dir);
        end
    else
        temp_dir = ['00result_',num2str(total_initial_t),'s_',num2str(total_final_t),'s_',num2str(numOfCycles),'_cycles'];
        temp_dir = [file_location,'/',temp_dir,'/'];
        if -exist(temp_dir,'dir') == 0
            mkdir(temp_dir);
        end    
    end
else
    if(pulsatileOrNot == 0)
        temp_dir = ['00result_',num2str(total_initial_t),'s_',num2str(total_final_t),'s_',num2str(omega*viscous_unit*1000,'%03.0f')];
        temp_dir = [file_location,'/',temp_dir,'/'];
        if -exist(temp_dir,'dir') == 0
            mkdir(temp_dir);
        end
    else
        temp_dir = ['00result_',num2str(total_initial_t),'s_',num2str(total_final_t),'s_',num2str(numOfCycles),'_cycles_',num2str(omega*viscous_unit*1000,'%03.0f')];
        temp_dir = [file_location,'/',temp_dir,'/'];
        if -exist(temp_dir,'dir') == 0
            mkdir(temp_dir);
        end    
    end
end


newtimePeriod = timePeriod;

%% OUTPUT selected timeslots
if (pulsatileOrNot == 0)
    save([temp_dir,'selected_t_slot.mat'],'newtimePeriod');
else
    save([temp_dir,'selected_t_slot_phase_',num2str(phase),'_of_',num2str(numOfPhases),'.mat'],'newtimePeriod');
end

clear rCoord
clear theta
clear zCoord

%% start post processing
% wall normal locations defination
y_plus_log        = wallNormalLocationCoordOutput(avg_z,avg_R,avg_th,num_z_group,num_r_group,num_th_group,U_tau,temp_dir);

%% calculate centreline velocity and bulk velcity
if sum(strcmp(calUcTauWall,'tau_w')) > 0
    [~,tau_w,~,~]                 = frictionVelocityCalculator(file_location,newtimePeriod,temp_dir); 
end
if sum(strcmp(calUcTauWall,'ub')) > 0
    [ub_z_spAvg,~]                = bulkVelocityCalculator(file_location,newtimePeriod,temp_dir);
end
if sum(strcmp(calUcTauWall,'tau_w')) + sum(strcmp(calUcTauWall,'ub')) + sum(strcmp(calUcTauWall,'Cf')) > 2
    [~,~]                         = skinFrictionCoeffCalculator(tau_w,ub_z_spAvg,temp_dir);
end
if sum(strcmp(calUcTauWall,'Uc')) > 0
    [uz_spAvg,~,~,uz_sptime_avg,~,~] = velocitySpatialTimeAverage(uz,ur,uth,loc_r_group,newtimePeriod,y_plus_log,U_tau,temp_dir);
    centrelineVelocityAndShearStress(uz_spAvg,uz_sptime_avg,avg_R,temp_dir);
end

%% velocity postprocessing group
% find the mean velocity profile
if (velocityPostprocess == 1)
    [~,~,~,uz_sptime_avg,ur_sptime_avg,uth_sptime_avg] = velocitySpatialTimeAverage(uz,ur,uth,loc_r_group,newtimePeriod,y_plus_log,U_tau,temp_dir);
end

% find RMS quadrant Analysis pdf skewness
if (velocity_RMS_PDF_Skewness == 1)
    velocityRMS_quadrantAnalysis_skewness(uz,ur,uth,uz_sptime_avg,ur_sptime_avg,uth_sptime_avg,loc_r_group,y_plus_log,U_tau,avg_R,temp_dir);
end

% find the streaks of each plane
if(outputStreaks == 1)
    velocityStreakDataOutput(ur,uth,uz,avg_R,avg_th,avg_z,loc_r_group,loc_th_group,loc_z_group,temp_dir);
end

% find fft analysis
if(spaceSpectraAnalysis == 1)
    velocityWaveNumber1DSpatialSpectra(avg_R,avg_th,avg_z,loc_r_group,loc_th_group,uz,ur,uth,uz_sptime_avg,ur_sptime_avg,uth_sptime_avg,1,temp_dir);  
    velocityWaveNumber2DSpatialSpectra(avg_R,avg_th,avg_z,loc_r_group,loc_th_group,uz,ur,uth,uz_sptime_avg,ur_sptime_avg,uth_sptime_avg,1,temp_dir); 
end

% % find the correlation
% if(selfCorrelation == 1)
%     velocity_spatial_correlation(ur,uth,uz,ur_sptime_avg,uth_sptime_avg,uz_sptime_avg,avg_R,avg_th,avg_z,loc_r_group,loc_th_group,loc_z_group,newtimePeriod,temp_dir);
% end
% 

% % pipe length analysis
% if(pipeLengthCorr == 1)
%     pipeLength_correlation(ur,uth,uz,avg_R,avg_th,avg_z,loc_r_group,loc_th_group,loc_z_group,temp_dir);
% end

%% lambda2 criterion postprocessing group
if (lambda2Criterion == 1)
    lambda2CriterionPostProcessing(lambda2,uz,ur,uth,avg_R,avg_th,avg_z,loc_r_group,loc_th_group,loc_z_group,temp_dir);
end

%% Q Cirterion postprocessing group
if (QCriterion == 1)
    QCriterionPostProcessing(Q,uz,ur,uth,avg_R,avg_th,avg_z,loc_r_group,loc_th_group,loc_z_group,temp_dir);
end

%% space-time diagram
if (SpaceTimeDiagram == 1)
    velocityTimeSpaceDiagram(ur,uz,avg_R,avg_z,loc_r_group,loc_th_group,loc_z_group,temp_dir);
end

%% correlation contour
if (corrContour == 1)
    velocityCorrContour(ur,uth,uz,avg_R,avg_th,avg_z,loc_r_group,loc_th_group,loc_z_group,newtimePeriod,temp_dir);
end

%% pressure post processing group
if(pressurePostprocess == 1)
% calculate mean pressure at all wall-normal locations
[p_spAvg,p_sptime_avg] = pressureSpatialTimeAverage(p,loc_r_group,newtimePeriod,y_plus_log,U_tau,temp_dir);
end

if(pressure_RMS_PDF_skewness == 1)
% calculate pressure RMS at all wall-normal locations
pressureRMS_quadrantAnalysis_skewness(p,p_sptime_avg,loc_r_group,y_plus_log,U_tau,avg_R,temp_dir);
end
        
disp ('Note! This is for cylinder pipe.')
cd(temp_dir)
end