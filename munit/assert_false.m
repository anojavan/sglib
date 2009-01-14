function assert_false( bool_val, message, assert_id, options )
% ASSERT_FALSE Asserts that the given condition is false.
%   ASSERT_FALSE( BOOL_VAL, MESSAGE, ASSERT_ID, OPTIONS ) checks that
%   the condition given in BOOL_VAL is false; otherwise issues an
%   assertion. A message telling the user what went wrong can be passed in
%   MESSAGE. For a description of OPTIONS see ASSERT.
%
% Example
%   assert_false( x<0, 'x may not be negative', 'non_negative' );
%
% See also ASSERT, ASSERT_TRUE, ASSERT_EQUALS

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


switch nargin
    case 1
        assert( ~bool_val );
    case 2
        assert( ~bool_val, message );
    case 3
        assert( ~bool_val, message, assert_id );
    case 4
        assert( ~bool_val, message, assert_id, options );
    otherwise
        error( 'wrong argument count' );
end