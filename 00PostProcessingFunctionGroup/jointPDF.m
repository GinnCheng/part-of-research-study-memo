%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is a function for joint probability function
 %  coded by ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [group_u,group_v,PDF_u,PDF_v,JPDF] = jointPDF(u,v,u_mean,v_mean,numOfBins_u,numOfBins_v)
% this function can be either Probability density function or a joint
% disp(['start Joint Probability Density Function analysis of wall normal location of ',num2str(avg_R)])  
%% probability density function
%% get u v prime
u_prime = u-u_mean;
v_prime = v-v_mean;
%% group u_prime and v_prime distribution
max_u = 30;
min_u = -30;
max_v = 15;
min_v = -15;
%% get the distribution
% number of inner region points
% numOfPoints_u = round((max_u - min_u)./numOfBins);
% numOfPoints_v = round((max_v - min_v)./numOfBins);
% create u and v array for inner region
group_u       = cat(2,linspace(min_u,0,round(numOfBins_u/2)),linspace(0,max_u,round(numOfBins_u/2)));
group_v       = cat(2,linspace(min_v,0,round(numOfBins_v/2)),linspace(0,max_v,round(numOfBins_v/2)));
group_u       = unique(group_u);
group_v       = unique(group_v);
% create front point and rare point just like FDM
Xedges        = [group_u(1),(group_u(1:end-1)+group_u(2:end))./2,group_u(end)];
Yedges        = [group_v(1),(group_v(1:end-1)+group_v(2:end))./2,group_v(end)];

%% create PDF
[PDF_u,~]  = histcounts(u_prime,Xedges);
[PDF_v,~]  = histcounts(v_prime,Yedges);
PDF_u      = PDF_u./size(u_prime,1)./size(u_prime,2);
PDF_v      = PDF_v./size(v_prime,1)./size(v_prime,2);
    
%% get joint pdf
[JPDF,~,~] = histcounts2(u_prime,v_prime,Xedges,Yedges);
JPDF       = JPDF./size(u_prime,1)./size(u_prime,2);  % havent transpose the matrix

if(abs(sum(PDF_u) - 1) > 1e-8)
    disp(['Sum of PDF(u'') = ',num2str(sum(PDF_u))])
    error('Sum of probability distribution U is not 1')
end
    
if(abs(sum(PDF_v) - 1) > 1e-8)
    disp(['Sum of PDF(v'') = ',num2str(sum(PDF_v))])
    error('Sum of probability distribution V is not 1')
end
    
if(abs(sum(sum(JPDF)) - 1) > 1e-8)
    disp(['Sum of JPDF = ',num2str(sum(sum(JPDF)))])
    error('Sum of probability distribution JPDF is not 1')
end
     
% disp(['finish joint probability analysis of wall normal location of ',num2str(avg_R)])
end
