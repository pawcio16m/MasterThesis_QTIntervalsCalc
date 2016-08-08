function [signalFiltered_out, R_index_out, QRS_Onset_out, QRS_End_out, T_Max_out, T_End_out, QT_Interval_out, Stats_out] = MainApp(patientNumber, draw, formula)
%function [signalFiltered_out, R_index_out, QRS_Onset_out, QRS_End_out, T_Max_out, T_End_out, QT_Interval_out, Stats_out] = MainApp(patientNumber, draw, formula)
%The function execute whole program
%
%Inputs:
%   - patientNumber - patient numberr from PTB database
%   - draw - a flag to plot figures (1- plot, other no plot)
%   - formula - choose formula to calculate QT interval ('Bazetta', 'Fridericia' or 'Framigham','no correction')
%
%Outputs:
%   - signalFiltered - lowpass and highpass filtering aplyied
%   - R_index_out- matrix (1xN) with new R Peak indexes
%   - QRS_Onset_out - matrix (1xN) with QRS Onset indexes
%   - QRS_End_out - matrix (1xN) with QRS End indexes
%   - T_Max_out - matrix (1xN) with T wave max indexes
%   - T_End_out - matrix (1xN) with T wave end indexes
%   - QT_Interval_out - smatrix (1xN) with QT intervals 
%   - Stats_out - struct with QT interval statistics


    %clc    
    close all
    
    display(sprintf('QT analysis program starts for patient %d\n',patientNumber));
    tstart = tic;
    %File reading
    %filepath for patient 
    filepath = strcat('newptbdb/ptbdb/patient',sprintf('%03d',patientNumber));
    %choose first .dat file in the patient folder
    datFiles = dir(strcat(filepath,'/*.hea'));
    for i=1:length(datFiles)
        filepath1 = strcat(filepath,'/',datFiles(i).name);
        display('-------------------------------------------------------------------------');
        display(sprintf('Load signal for patient %d, filename: %s from PTB database at Physionet.org',patientNumber,datFiles(i).name));
        [time,signal] = rdsamp(filepath1);   
        [signalFiltered_out, R_index_out, QRS_Onset_out, QRS_End_out, T_Max_out, T_End_out, QT_Interval_out, Stats_out] = QT_Interval(time,signal,patientNumber,datFiles(i).name,draw,formula);        
    end
    display('-------------------------------------------------------------------------');
    display(' ');
    telapsed = toc(tstart);
    display(sprintf('This app duration is %0.3f seconds',telapsed));
    display('Program exited');
    
    
   




end