function cmds=run_example( cmd )
% RUN_EXAMPLE Runs the example for a command.
%   If the help output for CMD contains an example section, running
%   RUN_EXAMPLE( CMD ) will extract this section and run it in the current
%   workspace. This feature be can also directly included in the command
%   help. E.g. if you specify:
%
%     %  Example (<a href="matlab:run_example CMD">run</ a>)
%     %     now come the example commands ...
%
%   in your help file, the user can click directly on (run), which is
%   displayed as link, and invoke the example (Note: remove the blank in 
%   </ a>).
% 
% Example (<a href="matlab:run_example run_example">run</a>)
%     disp( 'running the example section of erase_print:' );
%     run_example erase_print
% 
% See also HELP

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

s=help(cmd);

[x1,x2]=regexp( s, '\n *Example.*?\n' );
if isempty(x1); 
    warning( 'run_example:not_found', 'No sample section found in: %s', cmd );
    return; 
end
s=s(x2(1)+1:end);

x1=regexp( s, '\n *(See also|Run)' );
if ~isempty(x1)
    s=s(1:x1(1)-1);
end
%evalin( 'base', s );
evalin( 'caller', s );

if nargout==1
    cmds=s;
end