%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% add probe in runTime
 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function probeFileCreator(probe_locations,cylinderOrNot,channelOrNot)
fid = fopen('probe','wt');
fprintf(fid,'functions\n');
fprintf(fid,'{\n');

if (cylinderOrNot == 1)
    channelOrNot = 0;
for i = 1:size(probe_locations,3)
    for j = 1:size(probe_locations,1)
%% create probe file
        temp_name = ['_r_',num2str(sqrt(probe_locations(j,1,i)^2+probe_locations(j,2,i)^2)),...
                     '_z_',num2str(probe_locations(j,3,i))];
                 
        fprintf(fid,'    probes\n');
        fprintf(fid,'    {\n');
        fprintf(fid,'        functionObjectLibs ( "libsampling.so" );\n\n');
        fprintf(fid,'        type probes;\n\n');
        fprintf(fid,['        name probes',temp_name,';\n\n']);
        fprintf(fid,'        outputControl timeStep;\n');
        fprintf(fid,'        //outputInterval 1;\n\n');
        fprintf(fid,'        fields\n');
        fprintf(fid,'        (\n');
        fprintf(fid,'            p U\n');
        fprintf(fid,'        );\n\n');
        fprintf(fid,'        probeLocations\n');
        fprintf(fid,'        (\n');
        fprintf(fid,['            ( ',num2str(probe_locations(j,1,i)),',',...
                                      num2str(probe_locations(j,2,i)),',',...
                                      num2str(probe_locations(j,3,i)),' )\n']);
fprintf(fid,'        );\n');
fprintf(fid,'    }\n');
    end
end
disp('Probes created for Cylinder')
end

if (channelOrNot == 1)
for i = 1:size(probe_locations,3)
    for j = 1:size(probe_locations,1)
%% create probe file
        temp_name = ['_y_',num2str(probe_locations(j,2,i)),...
                     '_z_',num2str(probe_locations(j,3,i))];
                 
        fprintf(fid,'    probes\n');
        fprintf(fid,'    {\n');
        fprintf(fid,'        functionObjectLibs ( "libsampling.so" );\n\n');
        fprintf(fid,'        type probes;\n\n');
        fprintf(fid,['        name probes',temp_name,';\n\n']);
        fprintf(fid,'        outputControl timeStep;\n');
        fprintf(fid,'        //outputInterval 1;\n\n');
        fprintf(fid,'        fields\n');
        fprintf(fid,'        (\n');
        fprintf(fid,'            p U\n');
        fprintf(fid,'        );\n\n');
        fprintf(fid,'        probeLocations\n');
        fprintf(fid,'        (\n');
        fprintf(fid,['            ( ',num2str(probe_locations(j,1,i)),',',...
                                      num2str(probe_locations(j,2,i)),',',...
                                      num2str(probe_locations(j,3,i)),' )\n']);
fprintf(fid,'        );\n');
fprintf(fid,'    }\n');
    end
end
disp('Probes created for Channel')
end

fprintf(fid,'}\n');
fclose(fid);
end