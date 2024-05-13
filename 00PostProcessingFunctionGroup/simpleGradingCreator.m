%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This is a function to create simple grading
 %  Programmed by Ginn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output = simpleGradingCreator(initial_value,length,ratio,numbers,mode)
output = zeros(1,numbers);
if (isstr(mode) == 0)
    error('The argument "mode" should be string !')
end
if (mode == 'Delta')+(mode == 'q') == 0
    error('The argument "mode" should be either Delta or q')
end
if mode == 'q' % a_n = a_0*q^(n-1)
    min_R = length.*(1-ratio)./(1-ratio.^numbers);
    for i = 1:numbers
        if i == 1
            output(i) = initial_value+min_R.*ratio.^(i-1);
        else
            output(i) = output(i-1)+min_R.*ratio.^(i-1);
        end
    end
elseif mode == 'Delta' % a_n = a_0+n*Delta_x
    Delta_x = 2.*length./(numbers.*(numbers+1));
    for i = 1:numbers
        if i == 1
            output(i) = initial_value+Delta_x*(numbers-i+1);
        else
            output(i) = output(i-1)+Delta_x*(numbers-i+1);
        end
    end
end
end
