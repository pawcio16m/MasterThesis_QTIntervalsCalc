function [ TEndIndex] = tEnd( signal, QRS_Onset, T_Max, Fs, type )
%function [ TEndIndex] = tEnd( signal, QRS_Onset, T_Max, Fs, tpye )
%The function calculate T wave end index in filtered ECG signal
%
%Inputs:
%   - signal - filtered ECG signal
%   - T_Max - matrix (1xN) with T wave max indexes
%   - QRS_Onset - matrix (1xN) with QRS Onset indexes
%   - Fs - frequency sampling
%   - type - T wave type ('positive' or 'negative')
%
%Outputs:
%   - TEndIndex - matrix (1xN) with T wave end indexes
%  
%   Detailed explanation goes here
%
%  
    T_end_offset = 0.2;   %200 ms
    npointsToSlope = round(0.05*Fs);
    npointsToFit = round(npointsToSlope/2);
    T_End = zeros(1,length(T_Max));
    xfit = zeros(1,npointsToFit);      
    switch(type)
        case 'negative'
            disp('T wave negative');            
            for i=1:length(T_Max)    
                if(T_Max(i) == -1)
                    T_End(i) = -1;
                else                    
                    ypoints = signal(1,T_Max(i):T_Max(i)+npointsToSlope-1);
                    ypoints_diff = diff(ypoints);
                    [~,indexes] = sort(ypoints_diff,'descend');
                    for j=1:npointsToFit
                        xfit(j) = T_Max(i)+indexes(j);
                    end
                    yfit = signal(xfit);
                    yfit = yfit';                       
                    Xfit = [ones(length(xfit),1), xfit'];
                    if (i==length(T_Max))
                        baseline = median(signal(1,T_Max(i):T_Max(i)+round(0.3*Fs)));
                    else
                        baseline = median(signal(1,T_Max(i):QRS_Onset(i+1)));
                    end               
                    coeff = Xfit\yfit;
                    tend = round((baseline-coeff(1))/coeff(2))+indexes(1);
                    if ((tend > T_Max(i)+ T_end_offset*Fs) || (tend < T_Max(i)) || (isnan(tend)))
                        T_End(i) = -1;       %wrong detection
                    else
                        T_End(i) = tend;
                    end
                end                
            end
        case 'positive'
            disp('T wave positive');
            for i=1:length(T_Max) 
                if(T_Max(i) == -1)
                    T_End(i) = -1;
                else     
                    ypoints = signal(T_Max(i):T_Max(i)+npointsToSlope-1);
                    ypoints_diff = diff(ypoints);
                    [~,indexes] = sort(ypoints_diff,'ascend');                
                    for j=1:npointsToFit
                        xfit(j) = T_Max(i)+indexes(j);
                    end
                    yfit = signal(xfit);
                    yfit = yfit';                       
                    Xfit = [ones(length(xfit),1) xfit'];
                    if (i==length(T_Max))
                        baseline = median(signal(1,T_Max(i):T_Max(i)+round(0.3*Fs)));     
                    else
                        baseline = median(signal(1,T_Max(i):QRS_Onset(i+1)));
                    end   
                    coeff = Xfit\yfit;
                    tend = round((baseline-coeff(1))/coeff(2))+indexes(1);
                    if ((tend > T_Max(i)+ T_end_offset*Fs) || (tend < T_Max(i)) || (isnan(tend)))
                        T_End(i) = -1;       %wrong detection
                    else
                        T_End(i) = tend;
                    end
                end
            end
        otherwise 
            disp('Unknown method');       
    end
    TEndIndex = T_End;
end

