function [ R_peak_index, R_peak_amp , RR_interval ] = PanTompkins( signal, fs  )
%PANTOMPKINS Summary of this function goes here
%   Detailed explanation goes here



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

