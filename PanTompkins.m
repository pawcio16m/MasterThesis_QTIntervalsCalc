% function [ R_peak_index, R_peak_amp , RR_interval ] = PanTompkins( signal, fs  )
%PANTOMPKINS Summary of this function goes here
%   Detailed explanation goes here
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
% 
[time,signal] = rdsamp('102.hea');
signal_V5 = signal(:,1);
signal_V2 = signal(:,2);

numberOfSamples = 5000;
signal_sample = signal_V5(1:numberOfSamples);
tm_samp = time(1:numberOfSamples);
Fs = 360;
fs = Fs;

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




signal = signal_sample;
%signal filtering
LP_numerator = [1 0 0 0 0 0 -2 0 0 0 0 0 1];
LP_denominator = [32 -64 32];
HP_numerator = [-1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 32 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1];
HP_denominator = [1 1];

SignalFiltered = filter(HP_numerator, HP_denominator,filter(LP_numerator, LP_denominator,signal));

figure(2);

subplot(511);
plot(signal);
title('Input signal'); 
xlabel('Samples');
ylabel('Amplitude');

subplot(512);
plot(SignalFiltered);
title('Signal after bandpass filtering'); 
xlabel('Samples');
ylabel('Amplitude');

%signal differentiation

H = [-1 -2 0 2 1]*(1/8); %1/8*fs
SignalDifferetive = conv (SignalFiltered,H);
SignalDifferetive = SignalDifferetive/max(SignalDifferetive);

subplot(513);
plot(SignalDifferetive);
title('Signal after differention'); 
xlabel('Samples');
ylabel('Amplitude');

%signal powering 

SignalSquered = SignalDifferetive.^2;

subplot(514);
plot(SignalSquered);
title('Signal after powering'); 
xlabel('Samples');
ylabel('Amplitude');

%signal integration

SignalIntegrated = conv(SignalSquered ,ones(1 ,round(0.150*fs))/round(0.150*fs));

subplot(515);
plot(SignalIntegrated);
title('Signal after integration'); 
xlabel('Samples');
ylabel('Amplitude');




% end

