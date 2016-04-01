%clear command window and workspace 

clear
close all
clc


%reading signal from file PTB database from Physionet.org

[time,signal] = rdsamp('ptbdb/patient002/s0015lre.hea');


%Global variables

drainNumber = 1;
Fc_Hp = 3;  %Hz
Fc_Lp = 40; %Hz
Fs = 1000;  %Hz
numberOfSamples = 100000;
Lp = myfilterdesign(1,Fs,Fc_Lp,30,'Blackman');


%signal operation

signalFromOneDrain = signal(:,drainNumber);
signalSample = signalFromOneDrain(1:numberOfSamples);
timeSample = time(1:numberOfSamples);


%filepath for patient 
% patientNumber = 150;
% filepath = strcat('ptbdb/patient',sprintf('%03d',patientNumber));
% 
% 
% %choose all .dat files in the patient folder
% datFiles = dir(strcat(filepath,'/*.hea'));
% length(datFiles)
% for i=1:length(datFiles)
%     [time,signal,Fs] = rdsamp(datFiles(i).name);   
% end


%show raw signal
figure(1);
plot(timeSample,signalSample);
title('Raw signal');
xlabel('time [s]');
ylabel('Amplitude');


%filtering

%High-pass filtering - IIR Butterworth 1st. order, Fc = 3 Hz 

[B,A] = butter(1,3/(Fs/2),'high');    
signalFiltered = filter(B,A,signalSample);
figure(2);
plot(timeSample,signalFiltered);
title('Signal after high-pass filter');
xlabel('time [s]');
ylabel('Amplitude');

%Low-pass filtering - Blackman window, Fc = 40 Hz

signalFiltered = myfilter(signalFiltered,Lp);
figure(3);
plot(timeSample,signalFiltered);
title('Signal after low-pass filter');
xlabel('time [s]');
ylabel('Amplitude');


%PanTompkins algorithm
[WaveAmpl,R_index,delay] = pan_tompkin(signalFiltered,Fs,0);
figure(4);
plot(timeSample,signalFiltered,'b',timeSample(R_index),signalFiltered(R_index),'xr');
title(sprintf('Signal with QRS detection'));
xlabel('time [s]');
ylabel('Amplitude');
legend('signal','R-peak');

%QRS_Onset detection

%T_End detection

%QT_calculation


%QT interval statistics




