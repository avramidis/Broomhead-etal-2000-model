function [tout,yout]  = broomheadxpp( t, y, p )
%BROOMHEADXPP Integrates the Broomhead et al. (2000) saccadic model using
%XPPAUT
%
%   [tout,yout] = BROOMHEADXPP( t, y, p ) Integrates using XPPAUT the Broomhead et al. (2000)
%   saccadic model for a time span t, with initial conditions y and model
%   parameters p. XPPAUT must be in the PATH.
%
% Syntax:  [tout,yout] = broomheadxpp( t, y, p )
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
%    [tout,yout]  = broomheadxpp( [0 6], [0 0 0 0 0 2], [120 1.5 0.0045 0.05 600 9] )
%    This example integrates the model for 6 seconds with initial
%    conditions [0 0 0 0 0 2] and model parameters [120 1.5 0.0045 0.05 600
%    9].
%
%
% Other m-files required: none
% Subfunctions: nan
% MAT-files required: none
% Other software required: xppaut
%
% See also: none
%
% $Author: Eleftherios Avramidis $
% $Email: el.avramidis@gmail.com $
% $Date: 2015/05/25 $
% $Version: 1.0 $
% Copyright: MIT License

if nargin~=3
    error('Number of inputs must be 3.');
end

if nargout~=2
    error('Number of outputs must be 2.');
end

validateattributes(t,{'numeric'},{'size',[1 1]})
validateattributes(y,{'numeric'},{'size',[1 6]})
validateattributes(p,{'numeric'},{'size',[1 6]})

% create new ode file with x values as parameters
fout = fopen('broomhead_final.ode','wt');
fin = fopen('broomhead.ode','rt');

while ~feof(fin)
    s = fgetl(fin);
    
    s = strrep(s, 'ttime', num2str(t) );
        
    s = strrep(s, 'the_aval', num2str(p(1)) );
    s = strrep(s, 'the_bval', num2str(p(2)) );
    s = strrep(s, 'the_epval', num2str(p(3)) );
    s = strrep(s, 'the_gval', num2str(p(4)) );
    s = strrep(s, 'the_atval', num2str(p(5)) );
    s = strrep(s, 'the_btval', num2str(p(6)) );
    
    s = strrep(s, 'the_g', num2str(y(1)) );
    s = strrep(s, 'the_u', num2str(y(2)) );
    s = strrep(s, 'the_n', num2str(y(3)) );
    s = strrep(s, 'the_r', num2str(y(4)) );
    s = strrep(s, 'the_l', num2str(y(5)) );
    s = strrep(s, 'the_m', num2str(y(6)) );
    
    fprintf(fout,'%s\n',s);
end
fclose(fin);
fclose(fout);

delete('output.dat');

[s w] = dos('xppaut -silent broomhead_final.ode');
if s
    disp('Call to XPP failed')
    return
end

simulated = load('output.dat');
tout=simulated(:, 1);
yout=simulated(:, 2:end);


