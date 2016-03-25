clc
clear
close all
load matlab
% signal
signal1 = sig1;

% [tm,signal,Fs] = rdsamp('rec_11.hea');
%  signal1 = signal(:,1);
% signal2 = signal(:,2);
Fs = 360;

%parameters
NumberOfSample = 10000;
tm = [1:1:NumberOfSample];
tm = tm';

QRS_wide = round(0.2*Fs);
sig_samp = signal1([1:NumberOfSample],1);
tm_samp = tm([1:NumberOfSample],1);

%filter
Fc_lp = 40;
Fc_hp = 5;

RR_t = 0.82;
RR_interval = int32((RR_t*1.3)*Fs);

Lp = myfilterdesign(1,Fs,Fc_lp,30,'Blackman');
Hp = myfilterdesign(2,Fs,Fc_hp,7,'Prostokatne');
sig_filt = myfilter(sig_samp,Lp);
% sig_filt = sig_samp';

figure(1)
subplot(411)
plot(tm_samp,sig_samp);
title('Raw signal without filter');
xlabel('time [s]');
ylabel('Amplitude');


subplot(412)
plot(tm_samp,sig_filt);
title(sprintf('Signal with lowpass filter Fc %d  Hz',Fc_lp));
xlabel('time [s]');
ylabel('Amplitude');

sig_filt = myfilter(sig_filt,Hp);

subplot(413)
plot(tm_samp,sig_filt);
title(sprintf('Signal with highpass filter Fc %d  Hz',Fc_hp));
xlabel('time [s]');
ylabel('Amplitude');

s_Sig = length(sig_filt);


%finding QRS and RR interval
i=1;
start = 1;
koniec = RR_interval;
MaxArray=[];
sigMean = [];
k=1;
RR  = [];
while i<s_Sig+1
    temp = sig_filt(1,start:koniec);
    [y,x] = max(temp);
    
    MaxArray = [MaxArray,(x+start)];
   
    if(k>1)
        RR_interval = MaxArray(k) - MaxArray(k-1);
        sigMean = [sigMean,median(sig_filt(MaxArray(k-1):MaxArray(k)))];
        RR = [RR,RR_interval];
        start = MaxArray(k)+ round(mean(RR)/2);
        koniec = round(start + mean(RR)*1.2);
    else
         sigMean = median(sig_filt(1:start));
         start=koniec;
         koniec=start+RR_interval;
         sigMean = median(sig_filt(1:start));
    end
    k=k+1;
    i=koniec;
    
    
end

subplot(414);
plot(tm_samp,sig_filt,tm_samp(MaxArray,1),sig_filt(1,MaxArray),'*r');
title('QRS index');
xlabel('time [s]');
ylabel('Amplitude');
QRS = MaxArray;
s_RR = length(RR)

s_MaxArray = length(MaxArray)



sig_No_QRS = sig_filt;
%delete QRS
for i=1:s_MaxArray
    xl = MaxArray(1,i)-QRS_wide;
    xr = MaxArray(1,i)+QRS_wide;
    X = [xl:1:xr];
    
    sig_No_QRS(1,X) = sigMean(1,i);
end
figure(2)
plot(sig_No_QRS);
title('Signal without QRS');
xlabel('time [s]');
ylabel('Amplitude');


%find T_max
T_Max =[];
RR_interval =MaxArray(1);
start=MaxArray(1);

 for z=1:length(RR)
    RR_interval = RR(1,z)+RR_interval;
    local = sig_No_QRS(1,start:RR_interval);
    [pks,locals] = max(local);
    T_Max = [T_Max,double(locals+start)];
    start=RR_interval;    
    
 end

figure(3);
plot(tm_samp,sig_filt,tm_samp(T_Max,1),sig_filt(1,T_Max),'r*');
title('Signal with max of T-wave');
xlabel('time [s]');
ylabel('Amplitude');


%T_end detection

s_T_Max = size(T_Max);
s_T_Max = s_T_Max(2)



%     i=19;
%     indexT = T_Max(1,i);
%     indexR = QRS(1,i+1);
%     TR = [indexT:indexT+100];
%     TR_diff = diff(sig_filt(1,TR));
%    
%    
%     figure(4);
%     subplot(311)
%     plot(sig_filt(1,TR))
%     subplot(312)
%     length(TR_diff)
%     t_TR = [1:1:length(TR_diff)];
%     plot(t_TR,TR_diff);
%     subplot(313)
%     TR_diff = diff(TR_diff);
%     plot(TR_diff);
    index_nach = [];
    for j=1:length(T_Max)
        indexT = T_Max(1,j);
        indexP = T_Max(1,j)+50;
        TR = [indexT:indexP];
        TR_diff = diff(sig_filt(1,TR));
        TR_diff = diff(TR_diff);
        for i = 1:length(TR_diff)
            if(TR_diff(i)<0)
                if(TR_diff(i+1)>0)
                    index = T_Max(j)+i+2;
                    if(sig_filt(index)>sig_filt(index+1))
                        index_nach = [index_nach,index];
                        break;
                    end
                end
            end
        end
    end
    y_nach = sig_filt(1,index_nach);
    OneMatrix = 3.*ones(1,length(index_nach));
    X1 = index_nach-OneMatrix;
    X2 = index_nach+OneMatrix;
    Y1 = sig_filt(1,X1);
    Y2 = sig_filt(1,X2);
    x = [];
    y = [];
    F = [];
    for i=1:length(T_Max)
        x = [X1(i), index_nach(i), X2(i)];
        y = [Y1(i) ,y_nach(i), Y2(i)];
        F(:,:,i) = polyfit(x,y,1);
    
    end
   
   
     figure(5)
    plot(tm_samp,sig_filt,tm_samp(index_nach,1),sig_filt(1,index_nach),'r*',tm_samp,zeros(1,length(tm_samp)),'-g');
    title('Signal with max slope of T-wave');
    xlabel('time [s]');
    ylabel('Amplitude');
    length(F)
    F(1,1,1);
    F(1,2,1);
    indexes =[];
    izo = -0.03.*ones(1,length(F));
    for i=1:  length(F)
        A = F(:,:,i);
        B = A;
        A = abs(A(1,1));
        B = B(1,2);
        indexes = [indexes,round((B-izo)./A )];

    end
indexes = abs(indexes);
figure(6)
 plot(tm_samp,sig_filt,tm_samp(indexes,1),sig_filt(1,indexes),'r*');
 title('Signal with T-end');
 xlabel('time [s]');
 ylabel('Amplitude');










