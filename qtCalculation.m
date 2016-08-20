function [ QT_Interval ] = qtCalculation( QRS_Onset, T_End, R_Peak, Fs, type )
%function [ QT_Interval ] = qtCalculation( QRS_Onset, T_End, R_Peak, Fs, tpye )
%The function calculate QT interval in filtered ECG signal
%
%Inputs:
%   - QRS_Onset - matrix (1xN) with QRS Onset indexes
%   - T_End - matrix (1xN) with T wave end indexes
%   - R_Peak - matrix (1xN) with R peak indexes
%   - Fs - frequency sampling
%   - type - choose formula to calculate QT interval ('Bazetta' , 'Fridericia' or 'Framigham')
%
%Outputs:
%   - QT_Interval - matrix (1xN-1) with QT interval [ms] 
%  


    QT_Interval = zeros(1,length(R_Peak));
    switch(type)
        case 'Bazetta'
            disp('Calculate QT interval according to Bazetta formula');
            for i=1:length(R_Peak)
                if(T_End(i) ~= -1)
                    %check if T wave end is correct
                    if (i==length(R_Peak))
                        %calculate RR interval when we get last R peak index                                           
                        QT_Interval(i) = ( ((T_End(i)-QRS_Onset(i))/Fs)*1000 ) / ( sqrt((R_Peak(i)-R_Peak(i-1))/Fs) ) ;
                    else
                        QT_Interval(i) = ( ((T_End(i)-QRS_Onset(i))/Fs)*1000 ) / ( sqrt((R_Peak(i+1)-R_Peak(i))/Fs) ) ;
                    end                    
                else
                    QT_Interval(i) = 0;
                end                
            end
        case 'Fridericia'
            disp('Calculate QT interval according to Fridericia formula');
            for i=1:length(R_Peak)
                if(T_End(i) ~= -1)
                    %check if T wave end is correct
                    if (i==length(R_Peak))
                        %calculate RR interval when we get last R peak index                                           
                        QT_Interval(i) = ( ((T_End(i)-QRS_Onset(i))/Fs)*1000 ) / ( power(((R_Peak(i)-R_Peak(i-1))/Fs),1/3) ) ;
                    else
                        QT_Interval(i) = ( ((T_End(i)-QRS_Onset(i))/Fs)*1000 ) / ( power(((R_Peak(i+1)-R_Peak(i))/Fs),1/3) ) ;
                    end                    
                else
                    QT_Interval(i) = 0;
                end                
            end            
        case 'Framigham'
            disp('Calculate QT interval according to Framigham formula');
            for i=1:length(R_Peak)
                if(T_End(i) ~= -1)
                    %check if T wave end is correct
                    if (i==length(R_Peak))
                        %calculate RR interval when we get last R peak index                                           
                        QT_Interval(i) = ( ((T_End(i)-QRS_Onset(i))/Fs)*1000 ) - 0.154*(1-((R_Peak(i)-R_Peak(i-1))/Fs) ) ;
                    else
                        QT_Interval(i) = ( ((T_End(i)-QRS_Onset(i))/Fs)*1000 ) - 0.154*(1-((R_Peak(i+1)-R_Peak(i))/Fs) ) ;
                    end                    
                else
                    QT_Interval(i) = 0;
                end                
            end            
        otherwise
            disp('Calculate QT Interval (without RR correction) in ms');
            for i=1:length(R_Peak)
                if(T_End(i) ~= -1)                    
                    QT_Interval(i) = ( ( T_End(i)-QRS_Onset(i) ) / Fs) * 1000 ;
                else
                    QT_Interval(i) = 0;
                end             
            end            
    end
end