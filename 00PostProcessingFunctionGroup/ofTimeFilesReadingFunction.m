%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% function to read time files
 %%%  coded by ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function timefiles = ofTimeFilesReadingFunction(folder_location,ini_t,fin_t)
%% set up a time file array
timefiles = zeros; 

%% get all directories
all_directory = dir(folder_location);
N_t           = 1;

%% check the folder that which one is number
for ii = 1:length(all_directory)
    val = str2double(all_directory(ii).name);
    if isnan(val)
        
    else
        timefiles(N_t) = val;
        N_t            = N_t + 1;
    end
end

timefiles = timefiles(timefiles >= ini_t & timefiles <= fin_t);
timefiles = unique(timefiles);
end

