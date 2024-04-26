%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% This is a function for creating pseudo mesh for interpolating 
 %%%  mesh data results
  %   coded by ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pseudoCoord = pseudoMeshGenerator(r,theta,l,R,R_over_h,lambda_over_R,scaleFactor)
global smoothOrNot
x      = zeros();
y      = zeros();
z      = zeros();

a1            = R/R_over_h*scaleFactor; %for a_plus = 10.0 @re_tau = 180
% lambda_z1   = D*(2*pi/(16*(re_tau/180))); %x wavelength
lambda_z1     = lambda_over_R*R*scaleFactor; %x wavelength
phase_z1      = 0; %x phase
phase_theta1  = 0; %azimuthal phase
lambda_theta1 = lambda_z1; %azimuthal wavelength
Ncells = 1;
for i = 1:length(r)
    for k = 1:length(l)
        if (r(i) == 0)
            x(Ncells) = 0;
            y(Ncells) = 0;
            z(Ncells) = l(k);
            Ncells = Ncells + 1; 
        else
            
            for j = 1:length(theta)
                if(smoothOrNot == 0)
                wavy_1 = ((a1.*cos(phase_theta1 + (2*pi*theta(j)*R./lambda_theta1))).*cos(phase_z1 + (2*pi*l(k)./lambda_z1)));
                if (r(i) <= R + wavy_1)
                    x(Ncells) = r(i).*cos(theta(j));
                    y(Ncells) = r(i).*sin(theta(j));
                    z(Ncells) = l(k);
                    Ncells = Ncells + 1;
                end
                else
                    x(Ncells) = r(i).*cos(theta(j));
                    y(Ncells) = r(i).*sin(theta(j));
                    z(Ncells) = l(k);
                    Ncells = Ncells + 1;
                end
            end
        end
    end
end
pseudoCoord = cat(1,x,y,z);
pseudoCoord = pseudoCoord';
end




