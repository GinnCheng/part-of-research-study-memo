%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is a function to write sampleDict
 %  coded by Ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sampleDictWriter(ourputDir,r,theta,nPoints,sampleRegion)
if strcmp(sampleRegion,'cylinder')
    fid = fopen([ourputDir,'/system/sampleDict'],'wt');
    fprintf(fid,'/*--------------------------------*- C++ -*----------------------------------*\\\n');
    fprintf(fid,'| =========                 |                                                 |\n');
    fprintf(fid,'| \\\\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox           |\n');
    fprintf(fid,'|  \\\\    /   O peration     | Version:  2.2.2                                 |\n');
    fprintf(fid,'|   \\\\  /    A nd           | Web:      www.OpenFOAM.org                      |\n');
    fprintf(fid,'|    \\\\/     M anipulation  |                                                 |\n');
    fprintf(fid,'\\*---------------------------------------------------------------------------*/\n');
    fprintf(fid,'FoamFile\n');
    fprintf(fid,'{\n');
    fprintf(fid,'version      2.0;\n');
    fprintf(fid,'format       ascii;\n');
    fprintf(fid,'class        dictionary;\n');
    fprintf(fid,'location     "system";\n');
    fprintf(fid,'object       sampleDict;\n');
    fprintf(fid,'}\n');
    fprintf(fid,'//***********************************//\n\n');
    fprintf(fid,'interpolationScheme cellPoint;\n');
    fprintf(fid,'setFormat    raw;\n');
    fprintf(fid,'sets\n');
    fprintf(fid,'(\n');
    for i = 1:length(r)
        for j = 1:length(theta)
            fprintf(fid,['  samplecylinder_r_',num2str(i),'_theta_',num2str(j),'\n']);
            fprintf(fid,'  {\n');
            fprintf(fid,'    type uniform;\n');
            fprintf(fid,'    axis z;\n');
            fprintf(fid,['    start (',num2str(r(i).*cos(theta(j))),' ',num2str(r(i).*sin(theta(j))),' 0.01);\n']);
            fprintf(fid,['    end (',num2str(r(i).*cos(theta(j))),' ',num2str(r(i).*sin(theta(j))),' 6.28);\n']);
            fprintf(fid,['    nPoints ',num2str(nPoints),';\n']);
            fprintf(fid,'  }\n');
        end
    end
    fprintf(fid,');\n');
    fprintf(fid,'fields    (U);\n\n');
    fprintf(fid,'//***********************************//');
elseif strcmp(sampleRegion,'section')
    if length(theta) ~= 1
        error ('Choose only one theta!')
    end
    fid = fopen([ourputDir,'/system/sampleDict'],'wt');
    fprintf(fid,'/*--------------------------------*- C++ -*----------------------------------*\\\n');
    fprintf(fid,'| =========                 |                                                 |\n');
    fprintf(fid,'| \\\\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox           |\n');
    fprintf(fid,'|  \\\\    /   O peration     | Version:  2.2.2                                 |\n');
    fprintf(fid,'|   \\\\  /    A nd           | Web:      www.OpenFOAM.org                      |\n');
    fprintf(fid,'|    \\\\/     M anipulation  |                                                 |\n');
    fprintf(fid,'\\*---------------------------------------------------------------------------*/\n');
    fprintf(fid,'FoamFile\n');
    fprintf(fid,'{\n');
    fprintf(fid,'version      2.0;\n');
    fprintf(fid,'format       ascii;\n');
    fprintf(fid,'class        dictionary;\n');
    fprintf(fid,'location     "system";\n');
    fprintf(fid,'object       sampleDict;\n');
    fprintf(fid,'}\n');
    fprintf(fid,'//***********************************//\n\n');
    fprintf(fid,'interpolationScheme cellPoint;\n');
    fprintf(fid,'setFormat    raw;\n');
    fprintf(fid,'sets\n');
    fprintf(fid,'(\n');
    for i = 1:length(r)
        fprintf(fid,['  samplesection_r_',num2str(i),'_theta_1','\n']);
        fprintf(fid,'  {\n');
        fprintf(fid,'    type uniform;\n');
        fprintf(fid,'    axis z;\n');
        fprintf(fid,['    start (',num2str(r(i).*cos(theta)),' ',num2str(r(i).*sin(theta)),' 0.01);\n']);
        fprintf(fid,['    end (',num2str(r(i).*cos(theta)),' ',num2str(r(i).*sin(theta)),' 6.28);\n']);
        fprintf(fid,['    nPoints ',num2str(nPoints),';\n']);
        fprintf(fid,'  }\n');
    end
    fprintf(fid,');\n');
    fprintf(fid,'fields    (U);\n\n');
    fprintf(fid,'//***********************************//');    
else
    error('sampleReion should be either cylinder or section')
end