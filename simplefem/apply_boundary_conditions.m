function [Ki,fi]=apply_boundary_conditions( K, f, g, P_B, P_I, varargin )

options=varargin2options( varargin{:} );
%[s,options]=get_option( options, 'scaling', 1 );
check_unsupported_options( options, mfilename );

if true
    m=tensor_operator_size(K)/size(P_B,2);
    I_S=speye(m);
    
    % Ki=P_IS*K*P_IS';
    Ki=tensor_operator_compose( {P_I, I_S}, K );
    Ki=tensor_operator_compose( Ki, {P_I', I_S} );
    
    % fi=P_IS*(f-K*P_BS'*P_BS*g);
    fi=tensor_operator_apply( {P_I, I_S}, f );
    g=tensor_operator_apply( {P_B'*P_B, I_S}, g );
    g=tensor_operator_apply( K, g );
    gi=tensor_operator_apply( {P_I, I_S}, g );
    if iscell(f)
        %fi=tensor_add( fi, gi, -1, 'reduce', {} );
        fi=tensor_add( fi, gi, -1 );
        %fi=tensor_reduce( fi );
    else
        fi=fi-gi;
    end
    return

end


if isnumeric(K)
    m=size(K,1)/size(P_B,2);
    I_S=speye(m);

    P_IS=tkron(P_I,I_S);
    P_BS=tkron(P_B,I_S);
    Ki=P_IS*K*P_IS';
    fi=P_IS*(f-K*P_BS'*P_BS*g);
else
    m=size(K{1,2},1);
    I_S=speye(m);

    Ki=K;
    for i=1:size(K,1)
        Ki{i,1}=linear_operator_compose( Ki{i,1}, P_I' );
        Ki{i,1}=linear_operator_compose( P_I, Ki{i,1} );
    end
    
    fi=tensor_operator_apply( {P_I, I_S}, f );
    g=tensor_operator_apply( {P_B'*P_B, I_S}, g );
    g=tensor_operator_apply( K, g );
    gi=tensor_operator_apply( {P_I, I_S}, g );
    if iscell(f)
        fi=tensor_add( fi, gi, -1 );
        fi=tensor_reduce( fi );
    else
        fi=fi-gi;
    end
end

