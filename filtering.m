function signalFiltered = filtering(signalSample,timeSample,filterOrder,Fc_Hp,Fc_Lp,Fs,draw)
%function signalFiltered = filtering(signalSample,timeSample,filterOrder,Fc_Hp,Fc_Lp,Fs,draw)
%
%The function exacute a filering function to a signal
%
%Inputs:
%   - signalSampe - matrix with signal
%   - timeSample - matrix with time
%   - filterOrder - highpass filter order
%   - Fc_Hp - frequency cut for highpass filter
%   - Fc_Lp - frequency cut for lowpass filter
%   - Fs - sampling frequency
%   - draw - flag which inform to draw figures
%
%Outputs:
%   - signalFiltered - matrix with T wave end local indexes (for all drains) 
 

    %High-pass filtering - IIR Butterworth 1st. order, Fc = 3 Hz 
    
    [B,A] = butter(filterOrder,Fc_Hp/(Fs/2),'high');    
    signalFiltered = filter(B,A,signalSample);
    if(draw == 1)
        figure();
        plot(timeSample,signalFiltered);
        title('Signal after high-pass filter');
        xlabel('time [s]');
        ylabel('Amplitude [mV]');
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
        ylabel('Amplitude [mV]');
        legend('Signal');
    end

end