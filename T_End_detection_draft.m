clc
clear
close all


load QRS_END;
load QRS_ONSET;
load SIGNAL;
load R_PEAK;
load TIME

meanval = mean(signal);
threshold = ones(1,length(time));
threshold = threshold.*meanval;
Fs = 1000;
figure()
% plot(time,signal,'b',time(R_Peak),signal(R_Peak),'or',time(QRS_Onset),signal(QRS_Onset),'og',time(QRS_End),signal(QRS_End),'oy',time,threshold,'--g');
% title('Signal with R peaks detection QRS Onset and QRS End');
% xlabel('time [s]');
% ylabel('Amplitude');
% legend('Signal filtered','R-Peak','QRS Onset','QRS End','Thershold');
DataInv = 1.01*max(signal) - signal;
ivert = false;
startIndexes = [];
counter_pos = 0;
for i=1:length(QRS_End)-1
    zero_index = QRS_End(i)+2;
    while(signal(zero_index+1)>signal(zero_index))
        zero_index = zero_index+1;
    end
%     startIndexes(i) =  zero_index;
%     figure()
%     subplot(211);
    signal_temp = signal(zero_index:zero_index+round(0.25*Fs));
    signal_abs = abs(signal_temp);
    [pks,loc] = findpeaks(signal_abs,'SortStr','descend');
   
    amp(i) = signal_temp(loc(1));
    if(amp(i)>0)
        counter_pos = counter_pos+1;
    end
   
%     plot(signal_temp);
%    
%     subplot(212)
%     signalCut = DataInv(zero_index:zero_index+round(0.25*Fs));
%     plot(signalCut);
%     [pks,ind] = findpeaks(signalCut,'SortStr','descend');
%     hold on
%     plot(ind(1),pks(1),'or');
%     T_Max(i) = ind(1)+zero_index;
end
counter_pos
counter_neg = length(amp) - counter_pos
plot(time,signal,'b',time(R_Peak),signal(R_Peak),'or',time(QRS_Onset),signal(QRS_Onset),'og',time(QRS_End),signal(QRS_End),'oy',time,threshold,'--g',time(T_Max),signal(T_Max),'ok');
title('Signal with R peaks detection QRS Onset and QRS End');
xlabel('time [s]');
ylabel('Amplitude');
legend('Signal filtered','R-Peak','QRS Onset','QRS End','Thershold','T Max');
%     plot(signalCut);
%     title('Signal');
%     subplot(212)
%    
%     signalCut = abs(signalCut);
% 
%     plot(signalCut);
%     title('Abs signal');
%   
%     hold on
% 
%         
%         [pks,loc] = findpeaks(abs(signalCut),'NPEAKS',7);
%         new_pks = [];
%         new_loc = [];
% %         max_pks = max(pks);
% %         for j=1:length(pks)
% %             if pks(j) > 0.3*max_pks
% %                 new_pks = [new_pks,pks(j)];
% %                 new_loc = [new_loc,loc(j)];
% %             end
% %         end
% %         tosort = [new_pks;new_loc];
%         tosort = [pks;loc];
%         [val , ind] = sort(tosort(1,:),'descend');
%         sorted_table = tosort(:,ind);
%         T_max = [];
%         if length(sorted_table) > 4
%             sorted_table = sorted_table(:,[1 2 3 ]);
%         end
%         
%       
%         amp = sorted_table(1,:);
%         ind = sorted_table(2,:);  
%        
%         plot(ind,amp,'or');
%     
% end
% 
% % 
%         new_pks = [];
%         new_loc = [];
%         max_pks = max(pks);
%         for j=1:length(pks)
%             if pks(j) > 0.5*max_pks
%                 new_pks = [new_pks,pks(j)];
%                 new_loc = [new_loc,loc(j)];
%             end
%         end
%         tosort = [new_pks;new_loc];
%         [val , ind] = sort(tosort(1,:),'descend');
%         sorted_table = tosort(:,ind);
%         T_max = [];
%         if length(sorted_table) > 2
%             sorted_table = sorted_table(:,[1 2 ]);
%         end
%         
% %         if(length(sorted_table) == 4)
% %         
% %         if(length(sorted_table) == 3)
% %             amp = sorted_table(1,:);
% %             ind = sorted_table(2,:);
% %             if(ind(1) > round(0.13*Fs))
% %                 if((ind(1) < ind(2)) && (ind(i) <ind(3))) 
% %                     T_Max(i) = ind(1);
% %                 else
% %                     
% %                 end
% %             else
% %                 
% %             end
%         amp = sorted_table(1,:);
%         ind = sorted_table(2,:);  
%         
%         if(length(amp) == 2) 
%           
%             if((ind(1) <  ind(2)) && (ind(1) > round(0.1*Fs)) && ((ind(2) - ind(1)) < round(0.12*Fs) ))
%                 T_Max(i) =R_index(i) + round(0.1*Fs) + ind(1);
%             else
%                 T_Max(i) =R_index(i) + round(0.1*Fs) + ind(2);
%             end
%             
%         elseif(length(amp) == 1)
%             T_Max(i) = R_index(i) + round(0.1*Fs) + sorted_table(2,1);            
%         end
% %         hold on
% %         plot(new_loc,new_pks,'or');
% figure();
% plot(time,signal,time(startIndexes),signal(startIndexes),'or');