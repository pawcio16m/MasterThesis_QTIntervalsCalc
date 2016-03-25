function Y = myfilterdesign(typ_filtra, fs, fc, M, typ_okna)
    
    
    Fs = fs; 
    dt = 1/Fs;
    Fc = fc; 
    Fc_norm = (Fc/Fs)/2;
    N = M;
    y =[];
    Y = [];
    time = linspace(-20,20,N); 
    
    %filter choice
    if typ_filtra == 1
        %low-pass filter

        for i=1:N
            if time(i) == 0 
                y(1,i) = 2*Fc_norm;
            else
                y(1,i) = (sin(2*pi*Fc_norm*time(1,i)))/(pi*time(1,i));
            end

        end


    end



    if typ_filtra == 2
        %high-pass filter
        for i=1:N
            if time(i) == 0 
                y(1,i) = 1 - 2*Fc_norm;
            else
                y(1,i) = (-sin(2*pi*Fc_norm*time(1,i)))/(pi*time(1,i));
            end

        end


    end
    
    %windowing
    n=[0:1:N-1];
    w_prostokatne = ones(1,N);
    w_Bartletta = 1-(2*abs(n-N/2)/N);
    w_Hamminga = 0.54-0.46*cos((2*pi*n)/N);
    w_Blackmana = 0.42-0.5*cos((2*pi*n)/N)+0.08*cos((4*pi*n)/N);
    w = [];
    if(strcmpi(typ_okna,'Prostokatne'))
        w = w_prostokatne;
    elseif(strcmpi(typ_okna,'Bartletta'))
        w = w_Bartletta;
    elseif(strcmpi(typ_okna,'Hamminga'))
        w = w_Hamminga;
    elseif(strcmpi(typ_okna,'Blackmana'))
        w = w_Blackmana;
    else
        w = w_prostokatne;
    end
    Y = w.*y;

end