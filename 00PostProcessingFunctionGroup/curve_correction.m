%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is a correction function to compile the circular curvature
 %  and spline, coded by Ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function R_corrected = curve_correction(theta,R,spline_factor,weight_factor)
% the weight factor is to define the weight of circular curvature and 
% spline, the larger the factor is the more the line is close to spline
%% convert coordinate
x1 = R.*cos(theta(1));
x2 = R.*cos(theta(end));
y1 = R.*sin(theta(1));
y2 = R.*sin(theta(end));
x3 = (x1+x2)/2;
y3 = (1+weight_factor.*spline_factor).*(y1+y2)./2;
%% create spline function
coeff        = spline([x1,x3,x2],[0 y1 y3 y2 0]);
coordx       = R.*cos(theta);
spline_curve = ppval(coeff,coordx); % cartetian coordinate
%  convert cartesian coord into polar coord
R_corrected  = (1-weight_factor).*R.*ones(1,length(theta))+weight_factor.*...
               sqrt(coordx.^2+spline_curve.^2);
end