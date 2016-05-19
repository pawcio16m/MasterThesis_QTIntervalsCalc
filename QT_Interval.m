function [signalFiltered_out, R_index_out, QRS_Onset_out, QRS_End_out, T_Max_out, T_End_out, QT_Interval_out, Stats_out] = QT_Interval(patientNumber, draw, formula)
%function [signalFiltered_out, R_index_out, QRS_Onset_out, QRS_End_out, T_Max_out, T_End_out, QT_Interval_out, Stats_out] = QT_Interval(patientNumber, draw, formula)
%The function execute whole program
%
%Inputs:
%   - patientNumber - patient numberr from PTB database
%   - draw - a flag to plot figures (1- plot, other no plot)
%   - formula - choose formula to calculate QT interval ('Bazetta', 'Fridericia' or 'Framigham')
%
%Outputs:
%   - signalFiltered - lowpass and highpass filtering aplyied
%   - R_index_out- matrix (1xN) with new R Peak indexes
%   - QRS_Onset_out - matrix (1xN) with QRS Onset indexes
%   - QRS_End_out - matrix (1xN) with QRS End indexes
%   - T_Max_out - matrix (1xN) with T wave max indexes
%   - T_End_out - matrix (1xN) with T wave end indexes
%   - QT_Interval_out - struct (1x12) with QT intervals for all drains
%   - Stats_out - struct (1x12) with QT interval statistic to all drains


    %clear command window and workspace 
    close all
    clc
    tstart = tic;        
    fid = fopen(strcat('output\patient',sprintf('%03d',patientNumber),'_raport.txt'),'w+');     %open file to create a raport   
    display('QT analysis program starts');
    fprintf(fid,'Raport for patient %d\n\n',patientNumber);    


    %Global variables

    drainNumber = 1;
    Fc_Hp = 3;  %Hz
    Fc_Lp = 40; %Hz
    Fs = 1000;  %Hz
    Lp = myfilterdesign(1,Fs,Fc_Lp,30,'Blackman');
    filterOrder = 1;
    fprintf(fid,'Parameters\n');
    fprintf(fid,'--------------------------------------------\n');
    fprintf(fid,'Fs:\t\t\t\t\t %d Hz\n',Fs);
    fprintf(fid,'Fc_Hp:\t\t\t\t %d Hz\n',Fc_Hp);
    fprintf(fid,'Fc_Lp:\t\t\t\t %d Hz\n',Fc_Lp);
  
    
    %File reading
    %filepath for patient 
    tic
    display(sprintf('Load signal for patient %d from PTB database at Physionet.org',patientNumber));   
    filepath = strcat('newptbdb/ptbdb/patient',sprintf('%03d',patientNumber));
    %choose first .dat file in the patient folder
    datFiles = dir(strcat(filepath,'/*.hea'));
    filepath = strcat(filepath,'/',datFiles(end).name);
    [time,signal] = rdsamp(filepath); 
    %choose all .dat files in the patient folder
    % length(datFiles)
    % for i=1:length(datFiles)
    %     [time,signal,Fs] = rdsamp(datFiles(i).name);   
    % end
    toc
    

    %signal operation

    numberOfSamples = length(signal);
    fprintf(fid,'Samples:\t\t\t %0.2d\n',numberOfSamples);
    fprintf(fid,'Duration:\t\t\t %0.2f minutes\n',(numberOfSamples/Fs)/60);
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
    tic
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
    toc
    

    %PanTompkins algorithm
    
    tic
    display('Pan Tompkins algorithm to find QRS complex and R peaks');    
    [~,R_index,~] = pan_tompkin(signalFiltered,Fs,0);    
    display(sprintf('%d R peaks detected in signal',length(R_index)));
    if(draw == 1)
        figure();
        plot(timeSample,signalFiltered,'b',timeSample(R_index),signalFiltered(R_index),'xr');
        title('Signal with R peaks detection');
        xlabel('time [s]');
        ylabel('Amplitude');
        legend('signal','R-peak');
    end
    toc
 

    %QRS_Onset detection and R_Peak correction

    tic
    display('QRS Onset finder algorithm');       
    [QRS_Onset,newR_Peak] = qrsOnset(signalFiltered,Fs,R_index);    
    if(draw == 1)
        figure()
        plot(time,signalFiltered,'b',time(newR_Peak),signalFiltered(newR_Peak),'or');
        title('Signal with new R peaks correction');
        xlabel('time [s]');
        ylabel('Amplitude');
        legend('Signal','R-Peak');
        figure()
        plot(time,signalFiltered,'b',time(QRS_Onset),signalFiltered(QRS_Onset),'or');
        title('Signal with QRS Onset indexes');
        xlabel('time [s]');
        ylabel('Amplitude');
        legend('Signal','QRS Onset');
    end
    display(sprintf('%d QRS Onset detected in signal',length(QRS_Onset)));
    fprintf(fid,'R Peak detected:\t %0.2d\n',length(QRS_Onset));   
    fprintf(fid,'--------------------------------------------\n\n');
    fprintf(fid,'Additional information\n');
     fprintf(fid,'--------------------------------------------\n');
    fprintf(fid,'Signal filtering highpass Butterworth filter with Fc = %d Hz and lowpass FIR filter with Blackman window Fc = %d Hz\n',Fc_Hp,Fc_Lp);
    toc
    
    
    %QRS_End detection
  
    tic
    display('QRS End finder algorithm');    
    [QRS_End] = qrsEnd(signalFiltered,newR_Peak);    
    if(draw == 1)
        figure()
        plot(time,signalFiltered,'b',time(QRS_End),signalFiltered(QRS_End),'or');
        title('Signal with QRS End indexes');
        xlabel('time [s]');
        ylabel('Amplitude');
        legend('Signal','QRS End');
    end
    display(sprintf('%d QRS End detected in signal',length(QRS_End)));
    toc
    
    
    %T_Max detection
    
    tic   
    display('T Max finder algorithm');    
    [T_Max, type] = tMax(signalFiltered,QRS_End,Fs);       
    display(sprintf('%d T wave max detected in signal',length(T_Max)));     
    if(draw == 1)
        figure()
        plot(time,signalFiltered,'b',time(T_Max),signalFiltered(T_Max),'or');
        title('Signal with T wave maximum indexes');
        xlabel('time [s]');
        ylabel('Amplitude');
        legend('Signal','T Max');
    end
    toc
    

    %T_End detection
    
    tic
    display('T End finder algorithm');    
    T_End = tEnd(signalFiltered,QRS_Onset,T_Max,Fs,type);    
    display(sprintf('%0.2f percentage of T wave end detected in signal',((length(T_End)-length(find(T_End==-1)))/length(T_End))*100));
    fprintf(fid,'%0.2f percentage of T wave end detected in signal\n',((length(T_End)-length(find(T_End==-1)))/length(T_End))*100);
    if(draw == 1)
        figure()
        plot(time,signalFiltered,'b',time(T_End(T_End~=-1)),signalFiltered(T_End(T_End~=-1)),'or');
        title('Signal with T wave end indexes');
        xlabel('time [s]');
        ylabel('Amplitude');
        legend('Signal','T End');
    end
    toc    


    %Draw all points on one plot
    
    display('Draw a plot with all detected points');    
    fig = figure();
    plot(time,signalFiltered,'b',time(newR_Peak),signalFiltered(newR_Peak),'or',time(QRS_Onset),signalFiltered(QRS_Onset),'og',time(QRS_End),signalFiltered(QRS_End),'oy',time(T_End(T_End~=-1)),signalFiltered(T_End(T_End~=-1)),'ok');
    title('Signal with R peaks detection QRS Onset and QRS End');
    xlabel('time [s]');
    ylabel('Amplitude');
    legend('Signal filtered','R-Peak','QRS Onset','QRS End','T End');
    display('Saving figure to file');
    tic
    saveas(fig,strcat('output\patient',sprintf('%03d',patientNumber),'_plot.fig'));
    toc
    
    
    
    %QT_calculation
    
    tic
    display('Calculate QT intervals');
    QTinterval = qtCalculation(QRS_Onset, T_End, newR_Peak, Fs, formula);
    QTinterval = QTinterval(QTinterval~=0);
    QTInterval = {};
    QTInterval{1} = QTinterval;
    fprintf(fid,['Calculate QT interval according to ',formula,' formula\n']);
    fprintf(fid,'--------------------------------------------\n\n');
    toc
    

    %QT interval statistics
    
    tic
    display('Present QT interval statistics');
    QT_Interval_statistic = calculateStats(QTInterval,fid);    
    toc   
    

    %end 
    
    signalFiltered_out = signalFiltered;
    R_index_out = newR_Peak;
    QRS_Onset_out = QRS_Onset;
    QRS_End_out = QRS_End;
    T_Max_out = T_Max;
    T_End_out = T_End;
    QT_Interval_out = QTInterval;
    Stats_out = QT_Interval_statistic;        
    display('Program exited');
    telapsed = toc(tstart);
    display(sprintf('This analysis took %0.3f seconds',telapsed));
    fprintf(fid,'This analysis wad done on %s and took %0.3f seconds\n\n',datestr(now),telapsed);
    fclose(fid);

end
