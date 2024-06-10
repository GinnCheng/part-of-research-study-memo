%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Function for calculating the circle centre of spline function
 %  programmed by Ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output = SplineFunctionGenerator(coordx,coordy,x1,x2,y1,y2,ratio,arg)
%% p1 p2 are the end points. Based on them create circle function
%% arg is for direction of the spline either x, y or z
if (isstr(arg) == 0)
    error('The argument "arg" should be string !')
end
if (arg == 'x')+(arg == 'y') == 0
    error('The argument "arg" should be either x or y')
end
%% find the third point
if (arg == 'x')
    x3 = (x1+x2)./2;
    y3 = ratio*(y1+y2)./2;
elseif (arg == 'y')
    x3 = ratio*(x1+x2)./2;
    y3 = (y1+y2)./2;
end
% create tempcoord
temp_coord_x = [x1,x3,x2];
temp_coord_y = [y1,y3,y2];
%% now we could based on the circular function spline the mesh
if (arg == 'x')
    % now to make them spline with ends zero gradient
    coeff = spline(temp_coord_x,[0 temp_coord_y 0]);
    output = ppval(coeff,coordx);
elseif (arg == 'y')
    % now to make them spline with ends zero gradient
    coeff  = spline(temp_coord_y,[0 temp_coord_x 0]);
    output = ppval(coeff,coordy);
end
end


