function signalFiltered = filtering(signalSample,timeSample,filterOrder,Fc_Hp,Fc_Lp,Fs,draw)

%function [ Stats ] = calculateStats( qtInterval )
%The function calculate QT interval statistics
%
%Inputs:
%   - signal - matrix with signal from all drains
%   - QRS_Onset - matrix with QRS Onset indexes
%   - T_Max - matrix with T wave max indexes
%   - T_End - matrix with global T wave end indexes
%   - Fs - sampling frequency
%   - type - T wave type ('positive' or 'negative')
%Outputs:
%   - T_End_local - matrix with T wave end local indexes (for all drains) 
%  
%   Detailed explanation goes here
%
% 

    %High-pass filtering - IIR Butterworth 1st. order, Fc = 3 Hz 
    [B,A] = butter(filterOrder,Fc_Hp/(Fs/2),'high');    
    signalFiltered = filter(B,A,signalSample);
    if(draw == 1)
        figure();
        plot(timeSample,signalFiltered);
        title('Signal after high-pass filter');
        xlabel('time [s]');
        ylabel('Amplitude');
        legend('Signal');
    end  
    %Low-pass filtering - Blackman window, Fc = 40 Hz
    Lp = myfilterdesign(1,Fs,Fc_Lp,30,'Blackman');
    signalFiltered = myfilter(signalFiltered,Lp);
    if(draw == 1)
        figure();
        plot(timeSample,signalFiltered);
        title('Signal after low-pass filter');
        xlabel('time [s]');
        ylabel('Amplitude');
        legend('Signal');
    end



end