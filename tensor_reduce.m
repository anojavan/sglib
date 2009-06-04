function [T_k,sigma,k]=tensor_reduce( T, varargin )
% TENSOR_REDUCE Computes a reduced rank tensor product.
%
% Example (<a href="matlab:run_example tensor_reduce">run</a>)
%   % still to come
%
% See also TENSOR_ADD

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options( varargin{:} );
[M1,options]=get_option( options, 'M1', [] );
[M2,options]=get_option( options, 'M2', [] );
[p,options]=get_option( options, 'p', 2 );
[k_max,options]=get_option( options, 'k_max', inf );
[eps,options]=get_option( options, 'eps', 0 );
[relcutoff,options]=get_option( options, 'relcutoff', true );
check_unsupported_options( options, mfilename );


if iscell(T)
    [Q1,R1]=qr_internal(T{1},M1);
    [Q2,R2]=qr_internal(T{2},M2);
    [U,S,V]=svd(R1*R2',0);
else
    [U,S,V]=svd(T,0);
end

sigma=diag(S);
k=schattenp_truncate( sigma, eps, relcutoff, p );
k=min(k,k_max);

U_k=U(:,1:k);
S_k=S(1:k,1:k);
V_k=V(:,1:k);

if iscell(T)
    T_k={Q1*U_k*S_k,Q2*V_k};
else
    T_k=U_k*S_k*V_k';
end


function [Q,R]=qr_internal( A, M )
if isempty(M)
    [Q,R]=qr(A,0);
else
    [Q,R]=gram_schmidt(A,M,false,1);
end

function k=schattenp_truncate( sigma, eps, rel, p )

if isfinite(p)
    csp=cumsum(sigma.^p);
    if rel; eps=eps*csp(end); end
    k=find(csp(end)-csp<=eps^p,1,'first');
else
    if rel; eps=eps*sigma(end); end
    k=sum(sigma>=eps);
end
