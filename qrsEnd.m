function [ qrsEndIndex] = qrsEnd( signal,R_Peak )
%function [ qrsOnsetIndex , newR_Peak] = qrsEnd( signal,Fs,R_Peak )
%The function calculate QRS End index in filtered ECG signal
%
%Inputs:
%   - signal - filtered ECG signal
%   - R_Peak - matrix (1xN) with R Peak indexes 
%
%Outputs:
%   - qrsEndIndex - matrix (1xN) with QRS End indexes
%   Detailed explanation goes here
%
%  
  
    %QRS_End detection    
    qrsEndIndex = zeros(1,length(R_Peak));
    for i=1:length(R_Peak)
        r_peak = R_Peak(i)+2;
        while(signal(r_peak+1)<signal(r_peak))
            r_peak = r_peak+1;
            
        end
        qrsEndIndex(i) = r_peak;
    end
        
end