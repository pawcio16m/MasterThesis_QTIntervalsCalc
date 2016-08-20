function [signalFiltered_out, R_index_out, QRS_Onset_out, QRS_End_out, T_Max_out, T_End_out, QT_Interval_out, Stats_out] = MainApp(patientNumber, draw, formula)
%function [signalFiltered_out, R_index_out, QRS_Onset_out, QRS_End_out, 
%T_Max_out, T_End_out, QT_Interval_out, Stats_out] = 
%MainApp(patientNumber, draw, formula)
%
%The function execute whole program for detection and analysis QT interval
%in ECG signal and generate figure with characteristic points indexes and
%text file with summary. The output contains indexes for each patient's record 
%
%Inputs:
%   - patientNumber - patient number from PTB database
%   - draw - a flag to plot all figures (1- plot, other no plot)
%   - formula - choose formula to calculate QT interval ('Bazetta', 
%     'Fridericia' or 'Framigham','no correction')
%
%Outputs:
%   - signalFiltered_out - signal with lowpass and highpass filtering aplyied
%   - R_index_out- arrary with matrix (1xN) with new R Peak indexes
%   - QRS_Onset_out - arrary with matrix (1xN) with QRS Onset indexes
%   - QRS_End_out - arrary with (1xN) with QRS End indexes
%   - T_Max_out - arrary with (1xN) with T wave max indexes
%   - T_End_out - arrary with (1xN) with T wave end indexes
%   - QT_Interval_out - arrary with (1xN) with QT intervals 
%   - Stats_out - arrary with struct with QT interval statistics


    %clc    
    close all
    
    display(sprintf('QT analysis program starts for patient %d\n',patientNumber));
    %start a clock
    tstart = tic;
    %File reading
    %filepath for patient 
    filepath = strcat('newptbdb/ptbdb/patient',sprintf('%03d',patientNumber));
    %choose first .dat file in the patient folder
    datFiles = dir(strcat(filepath,'/*.hea'));
    %Create a cell array with output 
    Stats_out = cell(1,length(datFiles));
    signalFiltered_out = cell(1,length(datFiles));
    R_index_out = cell(1,length(datFiles));
    QRS_Onset_out = cell(1,length(datFiles));
    QRS_End_out = cell(1,length(datFiles));
    T_Max_out = cell(1,length(datFiles));
    T_End_out = cell(1,length(datFiles));
    QT_Interval_out = cell(1,length(datFiles));
    %call function QT_Interval for each patient's record and create and
    %output
    for i=1:length(datFiles)
        filepath1 = strcat(filepath,'/',datFiles(i).name);
        display('-------------------------------------------------------------------------');
        display(sprintf('Load signal for patient %d, filename: %s from PTB database at Physionet.org',patientNumber,datFiles(i).name));
        [time,signal] = rdsamp(filepath1);   
        [signalFiltered_temp, R_index_temp, QRS_Onset_temp, QRS_End_temp, T_Max_temp, T_End_temp, QT_Interval_temp, Stats_temp] = QT_Interval(time,signal,patientNumber,datFiles(i).name,draw,formula); 
        Stats_temp.filename = datFiles(i).name;
        Stats_out{i} = Stats_temp;
        signalFiltered_out{i} = signalFiltered_temp;
        R_index_out{i} = R_index_temp;
        QRS_Onset_out{i} = QRS_Onset_temp;
        QRS_End_out{i} = QRS_End_temp;
        T_Max_out{i} = T_Max_temp;
        T_End_out{i} = T_End_temp;
        QT_Interval_out{i} = QT_Interval_temp;
    end
    display('-------------------------------------------------------------------------');
    display(' ');
    telapsed = toc(tstart);
    %Program exited and print the app duration
    display(sprintf('This app duration is %0.3f seconds',telapsed));
    display('Program exited');

end