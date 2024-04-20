%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Fluid Post Processing tool by Ginn
 %%%  Through select same radius
  %   create radius group for various 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function binVorticityPostProcessing(sample_R,sample_TH,sample_Z,num_of_z_mesh)
%% Declare global constants
global pulsatileOrNot 
global file_location
global t_start_sd t_end_sd  
global timePeriod timeRangeUtau
global numOfCycles meanVorticityOutput vorticity_RMS_PDF_cov vorticity_streaks

%% cd to the direction
cd(file_location)
folder          = timePeriod;
newtimePeriod   = timePeriod;

%% import wall shear stress
%%% Importing the wall shear stress from each time directory;
[U_tauAvg,~,timeSpan] = frictionVelocityCalculator(file_location,timeRangeUtau);

%% Importing the coordinates
% OpenFOAM Mode reading coordinate file
coord                                       = ofCellCentresReading(file_location);

%% interpolate by delaunay triangulation so that the results can be mapped to a cylindrical coordinate
% create new cylindrical coord
new_coord                                    = InterpCylindricalCoordGenerator(sample_R,sample_TH,sample_Z);
% expanded old coord
[coord,extended_indx]                        = DelaunayMeshCoordExtender(coord,num_of_z_mesh);
% create delaunay coeff for linear interp
[DelaunayMatrix,weightCoeff,new_coord]       = DelaunayScatterInterpN(coord,new_coord,file_location);
% replace coord with new_coord
clear coord
coord = new_coord;
clear new_coord

%% Convert the coordinates from Cartesian to Polar based on Quadrant
% number of cells of the entire mesh
numOfCells = length(coord(:,1));
theta   = zeros(numOfCells,1);
for j = 1:numOfCells
    theta(j) = atan2(coord(j,2),coord(j,1));
end
% convert x y coordinate into radius
rCoord = sqrt(coord(:,1).^2+coord(:,2).^2);
zCoord = coord(:,3);

%% screen radius, theta and z so that the num of point we need to read is not so many
[avg_R,loc_r_group,num_r_group]             = group_coord(rCoord,sample_R);
[avg_th,loc_th_group,num_th_group]          = group_coord(theta,sample_TH);
[avg_z,loc_z_group,num_z_group]             = group_coord(zCoord,sample_Z);

%% Importing the velocity field data from each time directory
%   convert ux uy to ur utheta and record uz for all time steps
%   record Ohm_r Ohm_theta and Ohm_z for each time step
[Ohm_z,Ohm_r,Ohm_th,~] = ofVorticityReadingFunction(folder,numOfCells,theta,file_location,DelaunayMatrix,weightCoeff,extended_indx);
% if (cleanUselessMemoryOrNot == 1)
% Clear variable for memory
clear coord DelaunayMatrix surroundPoints weightCoeff;
% end

%% save all files into a result directory
% cd('/media/ginn/data/post_processing_tools')
if(pulsatileOrNot == 0)
    temp_dir = ['00result_',num2str(t_start_sd),'s_',num2str(t_end_sd),'s'];
    temp_dir = [file_location,'/',temp_dir,'/'];
    if -exist(temp_dir,'dir') == 0
        mkdir(temp_dir);
    end
else
    temp_dir = ['00result_',num2str(t_start_sd),'s_',num2str(t_end_sd),'s_',num2str(numOfCycles),'_cycles'];
    temp_dir = [file_location,'/',temp_dir,'/'];
    if -exist(temp_dir,'dir') == 0
        mkdir(temp_dir);
    end    
end

clear rCoord
clear theta
clear zCoord

%% start post processing
% output wall-normal location
y_plus_log = wallNormalLocationCoordOutput(avg_z,avg_R,avg_th,num_z_group,num_r_group,num_th_group,U_tauAvg,timeSpan,temp_dir);
% output mean vorticity
if (meanVorticityOutput == 1)
[~,~,~,Ohm_z_sptime_avg,Ohm_r_sptime_avg,Ohm_th_sptime_avg] = vorticitySpatialTimeAverage(Ohm_z,Ohm_r,Ohm_th,loc_r_group,newtimePeriod,y_plus_log,U_tauAvg,temp_dir);
end
% output vorticity RMS covPDF pdf
if (vorticity_RMS_PDF_cov == 1)
vorticityRMS_quadrantAnalysis_skewness(Ohm_z,Ohm_r,Ohm_th,Ohm_z_sptime_avg,Ohm_r_sptime_avg,Ohm_th_sptime_avg,loc_r_group,y_plus_log,U_tauAvg,avg_R,temp_dir);
end
% vorticity streaks
if (vorticity_streaks == 1)
vorticityStreakDataOutput(Ohm_r,Ohm_th,Ohm_z,avg_R,avg_th,avg_z,loc_r_group,loc_th_group,loc_z_group,temp_dir);
end
    
disp ('Note! This is for cylinder pipe.')
cd(temp_dir)
end