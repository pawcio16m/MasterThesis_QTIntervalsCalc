function [ Stats ] = calculateStats( QTinterval, fid, drainNumber)
%function [ Stats ] = calculateStats( QTinterval, fid, drainNumber )
%The function calculate QT interval statistics
%
%Inputs:
%   - QTinterval - matrix (1xN) with QT intervals 
%   - fid - file descriptor
%   - drainNumber - a number which inform about drain name
%Outputs:
%   - Stats - struct with QT interval stats 
%  
%   Detailed explanation goes here
%
%  
    fprintf(fid,'Statistics\n');
    Names = {'I','II','III','aVR','aVL','aVF','V1','V2','V3','V4','V5','V6'};
    i=1;
%     for i=1:length(qtInterval)
%         if(i==1)
%             QTinterval = qtInterval{i};
%             Stats = struct('DrainName',Names{i},'All_Intervals',length(QTinterval),'Mean',mean(QTinterval),'Median',median(QTinterval),'StandardDeviation',std(QTinterval),'MinValue',min(QTinterval),'MaxValue',max(QTinterval),'Percentage450',length(find(QTinterval>450)));
%             display(Stats);
%         else
    Stats = struct();
    Stats(i).DrainName = Names{drainNumber};
    Stats(i).All_Intervals = length(QTinterval);
    Stats(i).Mean = mean(QTinterval);
    Stats(i).Median = median(QTinterval);
    Stats(i).StandardDeviation = std(QTinterval);
    Stats(i).MinValue = min(QTinterval);
    Stats(i).MaxValue = max(QTinterval);
    Stats(i).Percentage450 = ((length(find(QTinterval>450)))/length(QTinterval))*100;
    display(Stats);
%         end        
    fprintf(fid,'--------------------------------------------\n');
    fprintf(fid,strcat('DrainName:\t\t\t\t', Stats(i).DrainName,'\n')); 
    fprintf(fid,'All_Intervals:\t\t %0.2f \n', Stats(i).All_Intervals);
    fprintf(fid,'Mean:\t\t\t\t %0.2f\t[ms] \n', Stats(i).Mean);
    fprintf(fid,'Median:\t\t\t\t %0.2f\t[ms]\n', Stats(i).Median);
    fprintf(fid,'StandardDeviation:\t %0.2f\t[ms]\n', Stats(i).StandardDeviation);
    fprintf(fid,'MinValue:\t\t\t %0.2f\t[ms]\n', Stats(i).MinValue);
    fprintf(fid,'MaxValue:\t\t\t %0.2f\t[ms]\n', Stats(i).MaxValue);
    fprintf(fid,'Percentage450:\t\t %0.2f\n', Stats(i).Percentage450);
     
%     end
    fprintf(fid,'--------------------------------------------\n\n');
   

end