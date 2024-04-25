%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Function for reading Nek results
 %  coded by Ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ur,uth,uz,p,t_variable] = NekVelocityPressureFieldReadingFunction(file_location,numOfNodes,theta,DelaunayMatrix,weightCoeff,extended_indx,uniqueIndx)
addpath('/media/ginn/data/post_processing_tools/00PostProcessingFunctionGroup/00nekmatlab')
disp(['Reading Nek U and p files ...']);
global total_initial_t total_final_t

%% output data directory how many folders
folder_name  = dir([file_location,'/historyData*']);

%% create empty array to store data
uz          = [];
ur          = [];
uth         = [];
p           = [];
t_variable  = [];

%% loop to create data matrix 
for i_folder  = length(folder_name)    
    %% check the files in the directory
    filenames = dir([file_location,'/',folder_name(i_folder).name,'/*0.f*']);
    
    %% get the total number of time
    temp_t = zeros(1,length(filenames));
    
    %% create value matrix and load
    temp_uz  = zeros(size(weightCoeff,1),length(temp_t));
    temp_ur  = zeros(size(weightCoeff,1),length(temp_t));
    temp_uth = zeros(size(weightCoeff,1),length(temp_t));
    temp_p   = zeros(size(weightCoeff,1),length(temp_t));
    
    for i = 1:length(temp_t)
        [data,~,~,tt,~,~,~,~,~,~,~,~,~,~,~] = readnek([file_location,'/',folder_name(i_folder).name,'/',filenames(i).name]);
        data                                = reshape(data,[numOfNodes,size(data,3)]);
        data                                = data(uniqueIndx,:);
    
        if size(data,2) == 7
            temp            = data(extended_indx,4);
            triVals         = temp(DelaunayMatrix);
            ux              = weightCoeff.*triVals*[1;1;1;1];
            temp            = data(extended_indx,5);
            triVals         = temp(DelaunayMatrix);
            uy              = weightCoeff.*triVals*[1;1;1;1];
            temp            = data(extended_indx,6);
            triVals         = temp(DelaunayMatrix);
            temp_uz(:,i)    = weightCoeff.*triVals*[1;1;1;1];
            temp            = data(extended_indx,7);
            triVals         = temp(DelaunayMatrix);
            temp_p(:,i)     = weightCoeff.*triVals*[1;1;1;1];
    
        elseif size(data,2) == 4
            temp            = data(extended_indx,1);
            triVals         = temp(DelaunayMatrix);
            ux              = weightCoeff.*triVals*[1;1;1;1];
            temp            = data(extended_indx,2);
            triVals         = temp(DelaunayMatrix);
            uy              = weightCoeff.*triVals*[1;1;1;1];
            temp            = data(extended_indx,3);
            triVals         = temp(DelaunayMatrix);
            temp_uz(:,i)    = weightCoeff.*triVals*[1;1;1;1];
            temp            = data(extended_indx,4);
            triVals         = temp(DelaunayMatrix);
            temp_p(:,i)     = weightCoeff.*triVals*[1;1;1;1];
        else
            error(['File format is not expected, data size is ',num2str(size(data,2))])
        end
    
        temp_ur(:,i)         = -ux.*cos(theta)-uy.*sin(theta);
        temp_uth(:,i)        =  uy.*cos(theta)-ux.*sin(theta);
    
        temp_t(i)   = tt;
    end
    clear ux uy data
    
    uz          = cat(2,uz,temp_uz);
    clear temp_uz
    ur          = cat(2,ur,temp_ur);
    clear temp_ur
    uth         = cat(2,uth,temp_uth);
    clear temp_uth
    p           = cat(2,p,temp_p);
    clear temp_p
    t_variable  = cat(2,t_variable,temp_t);
    clear temp_t
    
end

%% now remove overlapped time
[t_variable,uniIndx_t,~]  = unique(t_variable);
uz                        = uz(:,uniIndx_t);
ur                        = ur(:,uniIndx_t);
uth                       = uth(:,uniIndx_t);
p                         = p(:,uniIndx_t);
%% cut off the slot beyond the selected time
selected_indx             = find(t_variable >= total_initial_t & t_variable <= total_final_t);
t_variable                = t_variable(selected_indx);
uz                        = uz(:,selected_indx);
ur                        = ur(:,selected_indx);
uth                       = uth(:,selected_indx);
p                         = p(:,selected_indx);

end