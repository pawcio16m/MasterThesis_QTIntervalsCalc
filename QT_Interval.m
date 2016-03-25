%clear command window and workspace 
% clear
close all
clc

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

% [time,signal] = rdsamp('102.hea');
% signal_V5 = signal(:,1);
% signal_V2 = signal(:,2);

numberOfSamples = 5000;
signal_sample = signal_V5(1:numberOfSamples);
tm_samp = time(1:numberOfSamples);
Fs = 360;

%filtering
Fc_lp = 40;
Fc_hp = 5;

%Lp, Hp - lowpass and highpass coefficiants
Lp = myfilterdesign(1,Fs,Fc_lp,30,'Blackman');
Hp = myfilterdesign(2,Fs,Fc_hp,7,'Prostokatne');

sig_filt = myfilter(signal_sample,Lp);

figure(1)
subplot(311)
plot(tm_samp,signal_sample);
title('Raw signal without filter');
xlabel('time [s]');
ylabel('Amplitude');


subplot(312)
plot(tm_samp,sig_filt);
title(sprintf('Signal with lowpass filter Fc %d  Hz',Fc_lp));
xlabel('time [s]');
ylabel('Amplitude');

sig_filt = myfilter(sig_filt,Hp);

subplot(313)
plot(tm_samp,sig_filt);
title(sprintf('Signal with highpass filter Fc %d  Hz',Fc_hp));
xlabel('time [s]');
ylabel('Amplitude');

