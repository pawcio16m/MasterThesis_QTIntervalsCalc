close all
clc


tm_samp = time;
Fc = 3;
Fs = 1000;
Lp = myfilterdesign(1,Fs,40,30,'Blackman');
for a=1:12
    %figure();
%     subplot(411)
    
    signal_drain = signal(:,a);
%     plot(signal_drain);
%     title('Raw signal');
%     subplot(412)   
  
%     plot(sig_filt);
%     title(sprintf('Highpasss filter'));
%     subplot(413);
    sig_filt = myfilter(sig_filt,Lp);
%     plot(sig_filt);
%     title('Low pass');   
    [amp_wave,R_index,delay] = pan_tompkin(sig_filt,1000,0);

	figure();
	plot(tm_samp,sig_filt,'b',tm_samp(R_index),sig_filt(R_index),'xr');
    title(sprintf('Signal with QRS detection'));
    xlabel('time [s]');
    ylabel('Amplitude');
    legend('signal','R-peak');
end