%     clear
    close all
    clc

    display('QT analysis program starts');
    patientNumber = 3;
    draw = 0;


    %Global variables

    drainNumber = 1;
    Fc_Hp = 3;  %Hz
    Fc_Lp = 40; %Hz
    Fs = 1000;  %Hz
    Lp = myfilterdesign(1,Fs,Fc_Lp,30,'Blackman');
    filterOrder = 1;
    % patientNumber = 5;


    %reading signal from file PTB database from Physionet.org

%     % [time,signal] = rdsamp('ptbdb/patient002/s0015lre.hea');
%     %filepath for patient 
%     display(sprintf('Load signal for patient %d from PTB database at Physionet.org',patientNumber));
%     filepath = strcat('ptbdb/patient',sprintf('%03d',patientNumber));
%     %choose first .dat file in the patient folder
%     datFiles = dir(strcat(filepath,'/*.hea'));
%     filepath = strcat(filepath,'/',datFiles(1).name);
%     [time,signal] = rdsamp(filepath); 
%     %choose all .dat files in the patient folder
%     % length(datFiles)
%     % for i=1:length(datFiles)
%     %     [time,signal,Fs] = rdsamp(datFiles(i).name);   
%     % end


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
%     [WaveAmpl,R_index,delay] = pan_tompkin(signalFiltered,Fs,0);
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
%     [QRS_Onset,newR_Peak] = qrsOnset(signalFiltered,1000,R_index);
    toc
    if(draw == 1)
        figure()
        plot(time,abs(signalFiltered),'-r',time,signalFiltered,'b',time(newR_Peak),signalFiltered(newR_Peak),'or',time(QRS_Onset),signalFiltered(QRS_Onset),'og');
        title('Signal with new R peaks detection and QRS Onset');
        xlabel('time [s]');
        ylabel('Amplitude');
        legend('Abs signal','Signal','R-Peak','QRS Onset');
    end

    for i=1:length(R_index)-1
        signal_temp = signalFiltered(R_index(i)+round(0.1*Fs):R_index(i+1)-round(0.2*Fs));
        
        
%         figure()
%         subplot(211)
%         plot(signal_temp);
%         subplot(212)
%         plot(abs(signal_temp))
        [pks,loc] = findpeaks(abs(signal_temp));
        new_pks = [];
        new_loc = [];
        max_pks = max(pks);
        for j=1:length(pks)
            if pks(j) > 0.5*max_pks
                new_pks = [new_pks,pks(j)];
                new_loc = [new_loc,loc(j)];
            end
        end
        tosort = [new_pks;new_loc];
        [val , ind] = sort(tosort(1,:),'descend');
        sorted_table = tosort(:,ind);
        T_max = [];
        if length(sorted_table) > 2
            sorted_table = sorted_table(:,[1 2 ]);
        end
        
%         if(length(sorted_table) == 4)
%         
%         if(length(sorted_table) == 3)
%             amp = sorted_table(1,:);
%             ind = sorted_table(2,:);
%             if(ind(1) > round(0.13*Fs))
%                 if((ind(1) < ind(2)) && (ind(i) <ind(3))) 
%                     T_Max(i) = ind(1);
%                 else
%                     
%                 end
%             else
%                 
%             end
        amp = sorted_table(1,:);
        ind = sorted_table(2,:);  
        
        if(length(amp) == 2) 
          
            if((ind(1) <  ind(2)) && (ind(1) > round(0.1*Fs)) && ((ind(2) - ind(1)) < round(0.12*Fs) ))
                T_Max(i) =R_index(i) + round(0.1*Fs) + ind(1);
            else
                T_Max(i) =R_index(i) + round(0.1*Fs) + ind(2);
            end
            
        elseif(length(amp) == 1)
            T_Max(i) = R_index(i) + round(0.1*Fs) + sorted_table(2,1);            
        end
%         hold on
%         plot(new_loc,new_pks,'or');
        
    end
    
       figure()
        plot(time(T_Max),signalFiltered(T_Max),'oy',time,signalFiltered,'b',time(newR_Peak),signalFiltered(newR_Peak),'or',time(QRS_Onset),signalFiltered(QRS_Onset),'og');
        title('Signal with new R peaks detection and QRS Onset');
        xlabel('time [s]');
        ylabel('Amplitude');
        legend('T-Max','Signal','R-Peak','QRS Onset');