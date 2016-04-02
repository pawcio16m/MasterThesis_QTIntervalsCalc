function [signalFiltered_out, R_index_out, QRS_Onset_out] = QT_Interval(patientNumber, draw)
%function [ signalFiltered , R_index, QRS_Onset] = qrsOnset( patientNumber, plot )
%The function execute whole program
%
%Inputs:
%   - patientNumber - patient numberr from PTB database
%   - draw - a flag to plot figures (1- plot, other no plot)
%
%Outputs:
%   - signalFiltered - lowpass and highpass filtering aplyied
%   - QRS_Onset - matrix (1xN) with QRS Onset indexes
%   - R_index- matrix (1xN) with new R Peak indexes
  

    %clear command window and workspace 

%     clear
    close all
    clc

    display('QT analysis program starts');


    %Global variables

    drainNumber = 1;
    Fc_Hp = 3;  %Hz
    Fc_Lp = 40; %Hz
    Fs = 1000;  %Hz
    Lp = myfilterdesign(1,Fs,Fc_Lp,30,'Blackman');
    filterOrder = 1;
    % patientNumber = 5;


    %reading signal from file PTB database from Physionet.org

    % [time,signal] = rdsamp('ptbdb/patient002/s0015lre.hea');
    %filepath for patient 
    display(sprintf('Load signal for patient %d from PTB database at Physionet.org',patientNumber));
    filepath = strcat('ptbdb/patient',sprintf('%03d',patientNumber));
    %choose first .dat file in the patient folder
    datFiles = dir(strcat(filepath,'/*.hea'));
    filepath = strcat(filepath,'/',datFiles(1).name);
    [time,signal] = rdsamp(filepath); 
    %choose all .dat files in the patient folder
    % length(datFiles)
    % for i=1:length(datFiles)
    %     [time,signal,Fs] = rdsamp(datFiles(i).name);   
    % end


    %signal operation

    numberOfSamples = length(signal);
    signalFromOneDrain = signal(:,drainNumber);
    signalSample = signalFromOneDrain(1:numberOfSamples);
    timeSample = time(1:numberOfSamples);


    %show raw signal
    if(draw == 1)
        figure();
        plot(timeSample,signalSample);
        title('Raw signal');
        xlabel('time [s]');
        ylabel('Amplitude');
        legend('Signal');
    end
   

    %filtering

    display(sprintf('Signal filtering highpass Butterworth filter with Fc = %d Hz and lowpass FIR filter with Blackman window Fc = %d Hz',Fc_Hp,Fc_Lp));
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

    signalFiltered = myfilter(signalFiltered,Lp);
    if(draw == 1)
        figure();
        plot(timeSample,signalFiltered);
        title('Signal after low-pass filter');
        xlabel('time [s]');
        ylabel('Amplitude');
        legend('Signal');
    end
 


    %PanTompkins algorithm

    display('Pan Tompkins algorithm to find QRS complex and R peaks');
    tic
    [WaveAmpl,R_index,delay] = pan_tompkin(signalFiltered,Fs,0);
    toc
    display(sprintf('%d R peaks detected in signal',length(R_index)));
    if(draw == 1)
        figure();
        plot(timeSample,signalFiltered,'b',timeSample(R_index),signalFiltered(R_index),'xr');
        title('Signal with R peaks detection');
        xlabel('time [s]');
        ylabel('Amplitude');
        legend('signal','R-peak');
    end
 


    %QRS_Onset detection

    display('QRS Onset finder algorithm');
    tic
    [QRS_Onset,newR_Peak] = qrsOnset(signalFiltered,1000,R_index);
    toc
    if(draw == 1)
        figure()
        plot(time,signalFiltered,'b',time(newR_Peak),signalFiltered(newR_Peak),'or',time(QRS_Onset),signalFiltered(QRS_Onset),'og');
        title('Signal with new R peaks detection and QRS Onset');
        xlabel('time [s]');
        ylabel('Amplitude');
        legend('Signal','R-Peak','QRS Onset');
    end
  

    %T_End detection


    %QT_calculation


    %QT interval statistics


    %end 
    signalFiltered_out = signalFiltered;
    R_index_out = R_index;
    QRS_Onset_out = QRS_Onset;
    display('Program exited');

end
