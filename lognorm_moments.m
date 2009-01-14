function [mean,var,skew,kurt]=lognorm_moments(mu,sigma)
% LOGNORM_MOMENTS Compute moments of the lognormal distribution.
%   [VAR,MEAN,SKEW,KURT]=LOGNORM_MOMENTS( MU, SIGMA ) computes the moments of the
%   lognormal distribution. 
%
% Source: 
%   http://en.wikipedia.org/wiki/Log-normal_distribution
%   http://mathworld.wolfram.com/LogNormalDistribution.html
%
% Example
%   [mean,var]=lognorm_moments(mu,sigma);
%
% See also LOGNORM_CDF, LOGNORM_PDF
% 

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


mean=exp(mu+sigma^2/2);
if nargout>=2
    var=(exp(sigma^2)-1)*exp(2*mu+sigma^2);
end
if nargout>=3
    %The following from wikipedia is probably buggy
    % skew=exp(-mu-sigma^2/2)*(exp(sigma^2)+2)*sqrt(exp(sigma^2)-1);
    %The next from mathworld performs better
    skew=(exp(sigma^2)+2)*sqrt(exp(sigma^2)-1);
end
if nargout>=4
    kurt=exp(4*sigma^2)+2*exp(3*sigma^2)+3*exp(2*sigma^2)-6;
end