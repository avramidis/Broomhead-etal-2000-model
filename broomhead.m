function [tout,yout]  = broomhead( t, y, p )
%BROOMHEAD Integrates the Broomhead et al. (2000) saccadic model using
%ode15s Matlab ODE solver.
%
%   [tout,yout] = BROOMHEAD( t, y, p ) Integrates the Broomhead et al. (2000)
%   saccadic model for a time span t, with initial conditions y and model
%   parameters p.
%
% Syntax:  [tout,yout] = broomhead( t, y, p )
%
% Inputs:
%    t - Integration time span
%    y - Initial conditions
%    p - Model parameters
%
% Outputs:
%    yout - Time output
%    yout - Model output
%
% Example:
%    [tout,yout]  = broomhead( [0 6], [0 0 0 0 0 2], [120 1.5 0.0045 0.05 600 9] )
%    This example integrates the model for 6 seconds with initial
%    conditions [0 0 0 0 0 2] and model parameters [120 1.5 0.0045 0.05 600
%    9].
%
%
% Other m-files required: none
% Subfunctions: ode_system, jacobian, sburstf, dsburstf1, dsburstf2
% MAT-files required: none
%
% See also: nan
%
% $Author: Eleftherios Avramidis $
% $Email: el.avramidis@gmail.com $
% $Date: 2015/05/13 $
% $Version: 0.1 $
% Copyright: MIT License

if nargin~=3
    error('Number of inputs must be 3.');
end

if nargout~=2
    error('Number of outputs must be 2.');
end

validateattributes(t,{'numeric'},{'size',[1 2]})
validateattributes(y,{'numeric'},{'size',[1 6]})
validateattributes(p,{'numeric'},{'size',[1 6]})

options = odeset('RelTol',1e-8,'AbsTol',[1e-8 1e-8 1e-8 1e-8 1e-8 1e-8],'Jacobian',@(t,y)jacobian(t,y,p));
[tout,yout] = ode15s(@(t,y)ode_system(t,y,p),t,y,options);

end

function yout  = ode_system( t, y,  p )
%ode_system Broomhead et al. (2000) saccadic model equations.

T1=0.15;
T2=0.012;
Tn=25.00;

yout(1,1) = y(2);

yout(2,1) = -(((1.00 / T1) + (1.00 / T2)) * y(2)) - (1.00 / (T1 * T2) * y(1)) + (1.00 / (T1 * T2) * y(3)) + ((1.00 / T1) + (1.00 / T2)) * (y(4) - y(5));

yout(3,1) = -(y(3) / Tn) + (y(4) - y(5));

yout(4,1) = (1.00 / p(3))*(-y(4) - (p(4) * y(4) * ((y(5)^2))) + sburstf(y(6), p(1), p(2), p(5), p(6)));

yout(5,1) = (1.00 / p(3))*(-y(5) - (p(4) * y(5) * ((y(4)^2))) + sburstf(-y(6), p(1), p(2), p(5), p(6)));

yout(6,1) = -(y(4) - y(5));


end

function jac = jacobian(  t, y,  p  )
%JOCABIAN Jacobian matrix of the Broomhead et al. (2000) saccadic model.

T1=0.15;
T2=0.012;
Tn=25.00;

jac(1,1) = 0;
jac(1,2) = 1;
jac(1,3) = 0;
jac(1,4) = 0;
jac(1,5) = 0;
jac(1,6) = 0;

jac(2,1) = -1 / (T1*T2);
jac(2,2) = -(1 / T1) - (1 / T2);
jac(2,3) = 1 / (T1*T2);
jac(2,4) = (1 / T1) + (1 / T2);
jac(2,5) = -(1 / T1) - (1 / T2);
jac(2,6) = 0;

jac(3,1) = 0;
jac(3,2) = 0;
jac(3,3) = -1 / Tn;
jac(3,4) = 1;
jac(3,5) = -1;
jac(3,6) = 0;

jac(4,1) = 0;
jac(4,2) = 0;
jac(4,3) = 0;
jac(4,4) = -(p(4) * (y(5)^ 2) + 1) / p(3);
jac(4,5) = -(2 * p(4) * y(5) * y(4)) / p(3);
jac(4,6) = dsburstf1(y(6), p(1), p(2), p(5), p(6)) / p(3);


jac(5,1) = 0;
jac(5,2) = 0;
jac(5,3) = 0;
jac(5,4) = -(2 * p(4) * y(5) * y(4)) / p(3);
jac(5,5) = -(p(4) * (y(4)^2) + 1) / p(3);
jac(5,6) = dsburstf2(-y(6), p(1), p(2), p(5), p(6)) / p(3);

jac(6,1) = 0;
jac(6,2) = 0;
jac(6,3) = 0;
jac(6,4) = -1;
jac(6,5) = 1;
jac(6,6) = 0;

end

function [ y ] = sburstf( x, aval,  bval,  atval,  btval )
%sburstf Burst responce of burst neurons

if (x > 0.00)
    y=(atval * (1.00 - exp(-x / btval)));
else
    
    y=(-(aval / bval) * x * exp(x / (bval)));
end

end

function [ y ] = dsburstf1( x, aval,  bval,  atval,  btval )
%dsburstf1 Derivative of burst neuron responce

if (x > 0.00)
    y=(atval*exp(-x / btval)) / btval;
else
    
    y=-((aval*exp(x / bval)) / bval + (aval*x*exp(x / bval)) / bval^2);
end

end

function [ y ] = dsburstf2( x, aval,  bval,  atval,  btval )
%dsburstf2 Derivative of burst neuron responce

if (x > 0.00)
    y=-(atval*exp(x / btval)) / btval;
else
    
    y=((aval*exp(-x / bval)) / bval - (aval*x*exp(-x / bval)) / bval^2);
end

end