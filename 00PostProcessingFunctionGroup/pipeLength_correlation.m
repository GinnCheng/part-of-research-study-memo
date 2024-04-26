%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is a function for spatial correlation
 %  coded by ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pipeLength_correlation(ur,uth,uz,avg_R,avg_TH,avg_Z,loc_r_group,loc_th_group,loc_z_group,temp_dir)
global phase numOfPhases pulsatileOrNot

%% streaks th x plane
disp('start pipe length correlation');
% now find structure while interpolating
% loop radius location
pipe_reordered_indx  = NaN(length(avg_R),length(avg_TH),length(avg_Z));

for i = 1:length(avg_R)     
    %% now we can loop
    % loop theta
    for j = 1:length(avg_TH)
        % find the index of points at each theta location         
        inter_indx_rth   = intersect(loc_th_group{j},loc_r_group{i});
        % loop z
        for k = 1:length(avg_Z)  
            % reorder the velocity data into the streak matrix
            inter_indx   = intersect(inter_indx_rth,loc_z_group{k});
            % to see whether it is empty
            if isempty(inter_indx) == 0
                % for theta z plane
                pipe_reordered_indx(i,j,k) = inter_indx;
            else
                error('Cannot use auto correlation! There is NaN in the index')
            end              
        end
    end
end

%% now correlate the flow field
pipeLengthCorr = zeros(size(avg_Z));
for tt = 1:size(uz,2)
    temp_pipeLengthCorr = zeros(size(avg_Z));
    temp_uz             = uz(:,tt);
    for kk = 1:length(avg_Z)
        temp_pipeLengthCorr(kk) = customCorr2(temp_uz(pipe_reordered_indx(:,:,1)),temp_uz(pipe_reordered_indx(:,:,kk)));
    end
    pipeLengthCorr = pipeLengthCorr + temp_pipeLengthCorr;
end
pipeLengthCorr = pipeLengthCorr./tt;

%% output the results
if pulsatileOrNot == 0
    save([temp_dir,'pipeLengthCorr.mat'],'pipeLengthCorr');
else
    save([temp_dir,'pipeLengthCorr_phase_',num2str(phase),'_of_',num2str(numOfPhases),'.mat'],'pipeLengthCorr');
end

disp('finish pipe length correlation');

function yy = customCorr2(x1,x2)
        x1_prime  = x1 - mean2(x1);
        x2_prime  = x2 - mean2(x2);
        sigma_x1  = sqrt(sum(sum(x1_prime.^2)));
        sigma_x2  = sqrt(sum(sum(x2_prime.^2)));
        sigmax1x2 = sum(sum(x1_prime.*x2_prime));
        yy        = sigmax1x2./(sigma_x1.*sigma_x2);
end
end   
