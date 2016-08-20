function [ TMaxIndex, type] = tMax( signal, QRS_End, Fs )
%function [ TMaxIndex, type] = tMax( signal, QRS_End, Fs )
%The function calculate T wave max index in filtered ECG signal
%
%Inputs:
%   - signal - filtered ECG signal
%   - QRS_End - matrix (1xN) with QRS end indexes
%   - Fs - frequency sampling
%
%Outputs:
%   - TMaxIndex - matrix (1xN) with T wave max indexes
%   - type - a string that inform if T wave is positive or negative

  
    warning('off','signal:findpeaks:noPeaks');
    %T wave max detection    
  
    counter_pos = 0;
    counter_neg = 0;
    
    TMaxNonInv = zeros(1,length(QRS_End));
    TMaxInv = zeros(1,length(QRS_End));
   
    for i=1:length(QRS_End)
        
        zero_index = QRS_End(i)+2;
        correction = 0;
        while(signal(zero_index+1)>signal(zero_index) && correction < round(0.06*Fs))
            zero_index = zero_index+1;
            correction = correction + 1;
        end
   
        signalCut = signal(zero_index : zero_index + round(0.25*Fs));
        signalInv = 1.01*max(signalCut) - signalCut;
        signalAbs = abs(signalCut);
        [~,loc] = findpeaks(signalAbs,'SortStr','descend');
       
        %assume positive T wave
        [~,locNonInvert] = findpeaks(signalCut, 'SortStr', 'descend');
        if(numel(locNonInvert) == 0)
            TMaxNonInv(i) = -1;
        else
            TMaxNonInv(i) = locNonInvert(1) + zero_index;
        end
        
        %assume negative T wave
        [~,locInvert] = findpeaks(signalInv, 'SortStr', 'descend');      
        if(numel(locInvert) == 0)
            TMaxInv(i) = -1;
        else
            TMaxInv(i) = locInvert(1) + zero_index;
        end
       
        %chceck if T wave pos or negative
        if(~isempty(loc))            
            if(signalCut(loc(1))>0)
                counter_pos = counter_pos+1;
            else
                counter_neg = counter_neg+1;
            end
        end
    end
    
    if(counter_pos > counter_neg)
        TMaxIndex = TMaxNonInv;
        type = 'positive';
    else
        TMaxIndex = TMaxInv;
        type = 'negative';
    end
        
end