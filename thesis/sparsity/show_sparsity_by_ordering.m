function show_sparsity_by_ordering

p_u=2;
m_k=5; p_k=2*p_u;
m_f=5; p_f=p_u;

multiplot_init(2,2);

for alphasort=[true, false]
    for kfirst=[false, true]
        S=compute_sparsity( m_k, p_k, m_f, p_f, p_u, alphasort, kfirst, false );
        
        multiplot;
        spy2(S);
        save_figure( gca, {'sparsity_ordering_%d_%d', alphasort, kfirst} ) ;
    end
end
