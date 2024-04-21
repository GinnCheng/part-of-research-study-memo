function [DelaunayMatrix,weightCoeff,new_coord] = DelaunayInterpAssembler(sub_oldCoord,sub_newCoord,sub_oldCoord_indx,sub_newCoord_indx)

temp_DelaunayMatrix = [];
temp_weightCoeff    = [];
temp_new_coord      = [];
temp_new_coordIndx  = [];

%% do interpolation piece by piece and assemble them
for kk = 1:length(sub_newCoord)
[sub_DelaunayMatrix,sub_weightCoeff,sub_nanIndx] = SubDelaunayInterpolation(sub_oldCoord{kk},sub_newCoord{kk});

disp(['Finish partial Delaunay Interp ',num2str(kk),'/',num2str(length(sub_newCoord))]);

temp_DelaunayMatrix = cat(1,temp_DelaunayMatrix,sub_oldCoord_indx{kk}(sub_DelaunayMatrix));
temp_weightCoeff    = cat(1,temp_weightCoeff,sub_weightCoeff);
temptemp            = sub_newCoord{kk};
temptemp(sub_nanIndx,:) = [];
temp_new_coord      = cat(1,temp_new_coord,temptemp);
temptemp            = sub_newCoord_indx{kk};
temptemp(sub_nanIndx,:) = [];
temp_new_coordIndx  = cat(1,temp_new_coordIndx,temptemp);
end

%% now reorder the points order back to the original order
[~,reoder_indx,~]   = unique(temp_new_coordIndx);
DelaunayMatrix      = temp_DelaunayMatrix(reoder_indx,:);
weightCoeff         = temp_weightCoeff(reoder_indx,:);
new_coord           = temp_new_coord(reoder_indx,:);

% save(['/media/ginn/data/new_coord'],'new_coord','-v7.3');
end
