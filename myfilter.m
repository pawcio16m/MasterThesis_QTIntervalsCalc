function signal_filtered = myfilter(signal,h)

    K = length(signal);
    M = length(h);
    P = M - 1; 
    L = K + P;
    
    signal_prim = zeros(1,L);
    signal_prim(M:end) = signal;
    signal_prim(1:(M-1)) = repmat(signal(1),1,M-1);
    
    signal_filtered = zeros(1,L);
    
    for i=M:L
        
        for j=1:M
            if((i-j)>0)
          signal_filtered(i) =  signal_filtered(i) + h(j)*signal_prim(i-j);
            end
        end
        
    end
    signal_filtered = signal_filtered(M:end);


end
