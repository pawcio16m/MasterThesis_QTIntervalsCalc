function [ qrsOnsetIndex , newR_Peak] = qrsOnset( signal,Fs,R_Peak )
%function [ qrsOnsetIndex , newR_Peak] = qrsOnset( signal,Fs,R_Peak )
%The function calculate QRS Onset index in filtered ECG signal
%
%Inputs:
%   - signal - filtered ECG signal
%   - Fs - frequency sampling in Hz
%   - R_Peak - matrix (1xN) with R Peak indexes 
%
%Outputs:
%   - qrsOnsetIndex - matrix (1xN) with QRS Onset indexes
%   - newR_Peak - matrix (1xN) with new R Peak indexes
%   Detailed explanation goes here
%
%  
  
    %QRS_Onset detection
    
    %set basic const values
    detectedR_Peaks = length(R_Peak)-2;
    maxDelay = round(0.02*Fs); 
    fitSteps = round(maxDelay /2); 
    correction = 0;
    
    %preallocate memory for array
    newR_Peak = zeros(1,detectedR_Peaks);
    xfit = zeros(1,fitSteps);   
    QRS_Onset = zeros(1,detectedR_Peaks);
    
    %find local minima in ecg signal
    %invert data to calculate local minima
    data = 1.01*max(signal) - signal;
    %calculate only important minima in 0.05Fs neighbourhood
    [pks,loc] = findpeaks(data,'minpeakdistance',round(0.05*Fs));
    %go for each R Peak in signal
    for i=2:length(R_Peak)-1
        
        rPeak = R_Peak(i) ;
        %correct R_Peak detection from pantompkins algorithm
        %make sure that R Peak is on increasing slope
        if(signal(rPeak+1)<signal(rPeak))        
            while(signal(rPeak+1)<signal(rPeak) && correction<maxDelay)
                rPeak = rPeak-1;
                correction = correction + 1;
            end        
        else
            while(signal(rPeak+1)>signal(rPeak) && correction<maxDelay)
                rPeak = rPeak+1;
                correction = correction + 1;
            end        
        end
        
        correction = 0;
        newR_Peak(i-1) = rPeak;
        
        for j=fitSteps:-1:1
            xfit((fitSteps+1)-j) = rPeak - j;
        end    
        yfit = signal(xfit);
        coeff = polyfit(xfit,yfit,1);        
        qrs_onset = round(-coeff(2)/coeff(1));
        %find the nearest local minimum to calculated value
        tempQRS = qrs_onset;   
        counterexceed = 0;
        while(signal(tempQRS) > signal(tempQRS - 1))
            tempQRS = tempQRS - 1;
            if(qrs_onset - tempQRS > round(0.06*Fs))
                counterexceed = 1;
                break;
            end
        end
        if(counterexceed == 0)
            qrs_onset = tempQRS;
        end            
                
%         temp = find(loc<qrs_onset);
%         %chcek if this minium is correct - not to far from calculated value
%         if(qrs_onset - loc(temp(end)) > round(0.04*Fs))
%             qrs_onset = loc(temp(end));
%         end
        QRS_Onset(i-1) = qrs_onset;
    end
    qrsOnsetIndex = QRS_Onset;
end

