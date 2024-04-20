%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is a temporal sample data location creator
 %  coded by Ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all
clc
%% some parameters
nu    = 0.002778;
U_tau = 1;
viscous_unit = nu/(U_tau^2);
R     = 0.5;
locs  = [0.1,1:18].*10;
%% create sampling locations
fid = fopen('sampleLocations','wt');
for i = 1:length(locs)
    fprintf(fid,['  y_plus_',num2str(locs(i)),'\n']);
    fprintf(fid,'  {\n');
    fprintf(fid,'    type  uniform;\n');
    fprintf(fid,'    axis  z;\n');
    if(abs(R-locs(i).*viscous_unit) > 1e-4)
        fprintf(fid,['    start (0 ',num2str(R-locs(i).*viscous_unit),' 0);\n']);
        fprintf(fid,['    end   (0 ',num2str(R-locs(i).*viscous_unit),' 6.28);\n']);
    else
        fprintf(fid,'    start (0 0 0);\n');
        fprintf(fid,'    end   (0 0 6.28);\n');
    end
    fprintf(fid,'  nPoints 256;\n');
    fprintf(fid,'  }\n');
end
fclose(fid);