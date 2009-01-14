function c=hermite_triple_fast(i,j,k)
% HERMITE_TRIPLE_FAST Cached computation of the expectation of triple products of Hermite polynomials.
%   C=HERMITE_TRIPLE_FAST(I,J,K) computes the value of <H_i H_j H_k>
%   where the H_ijk are the unnormalized (stochastic) Hermite polynomials
%   and the expectation <.> is over a Gaussian measure i.e.
%   <f(X)>=int_-infty^infty f(x) exp(-x^2/2)/sqrt(2*pi) dx
% 
%   The cache has to be set up by a call to hermite_triple_fast with one
%   argument only HERMITE_TRIPLE_FAST(MAX). 
%
% Example
%   c1=hermite_triple_fast(2,3,1);
%   c2=hermite_triple_fast(3,1,4);
%   c3=hermite_triple_fast([2 3],[3 1],[1 4]);
%   disp( sprintf( 'c1=%d, c2=%d, c3=%d=c1*c2=%d', c1, c2, c3, c1*c2 ) );
%
% See also HERMITE, HERMITE_VAL, HERMITE_TRIPLE_PRODUCT

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


%TODO: this file should probably be merged with hermit_triple_product and
%the fastest version selected automatically

persistent triples max_ind;

% Only one argument => do the initialization
if nargin==1
    if isempty(max_ind) || i>max_ind
        max_ind=full(i);
        triples=zeros(max_ind+1,max_ind+1,max_ind+1);
        for i=0:max_ind
            for j=0:i
                % The indexing of the following loop takes into account that
                % the sum i+j+k has to be even and that i,j and k have to
                % fulfill the triangle inequality (not that this optimization
                % would matter in any way...)
                for k=i-j:2:j
                    hijk=hermite_triple_product(i,j,k);
                    if hijk==0; hijk=-1; end
                    triples(i+1,j+1,k+1)=hijk;
                    triples(i+1,k+1,j+1)=hijk;
                    triples(j+1,i+1,k+1)=hijk;
                    triples(j+1,k+1,i+1)=hijk;
                    triples(k+1,i+1,j+1)=hijk;
                    triples(k+1,j+1,i+1)=hijk;
                end
            end
        end
    end
    if nargout>0
        c=triples;
    end
    return
end

% If no output argument is given the current cache is returned. This can
% also be used to check whether the cache is already initialized.
if nargin==0
    c=triples;
    return
end

% Check whether cache is correctly initialized
max_ind_cur=max([i(:); j(:); k(:)]);
if isempty(triples) || max_ind_cur>max_ind
    %warning('hermite_triples_fast:cache', 'Cache has not been set up correctly. Setting up cache...');
    %disp([size(triples),max_ind]);
    hermite_triple_fast( max( max_ind_cur, 15 ) );
end

% Note: multiindices are row vectors => size(i,2)
if size(i,1)>1 || size(j,1)>1
    error([ 'hermite_triple_product: not yet implemented for ' ...
        'vectors of multiindices in i or j (only in k). Maybe you want to pass a row vector?' ]);
end

% Calculation of scalar index (4x faster then sub2ind)
if size(k,1)>1
    i=repmat( i, size(k,1), 1 );
    j=repmat( j, size(k,1), 1 );
end
ind=i+1+j*(max_ind+1)+k*(max_ind+1)^2;
c=prod( triples( ind ), 2 );
