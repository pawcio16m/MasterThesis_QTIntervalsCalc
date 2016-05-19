clc
clear
close all


load QRS_END;
load QRS_ONSET;
load SIGNAL;
load R_PEAK;
load TIME;
load T_MAX;
type = 'negative';

figure()
plot(time,signal,'b',time(R_Peak),signal(R_Peak),'or',time(QRS_Onset),signal(QRS_Onset),'og',time(QRS_End),signal(QRS_End),'oy',time(tmax),signal(tmax),'ok');
title('Signal with R peaks detection QRS Onset and QRS End');
xlabel('time [s]');
ylabel('Amplitude');
legend('Signal filtered','R-Peak','QRS Onset','QRS End','T Max');
   

Fs = 1000;
time_slope = []
maxslope =[]
for i=1:40
    time_slope(i) =i;
end
switch(type)
    case 'negative'
        disp('T wave negative');
       
        for i=1:length(tmax)
            maxslope = [];
            ypoints = signal(tmax(i):tmax(i)+39);
            ypoints_diff = diff(ypoints);
            [y,indexes] = sort(ypoints_diff,'descend');
            for j=1:20
                maxslope(j) = tmax(i)+indexes(j);
            end
            yfit = signal(maxslope);
           
            yfit = yfit';            
            maxSlope = [ones(length(maxslope'),1) maxslope'];
            coeff = maxSlope\yfit;
            T_End(i) = round(-1*(coeff(1))/coeff(2));
%             figure()
%             plot(time_slope,ypoints,time_slope(indexes(1,1:20)),ypoints(indexes(1,1:20)),'or');
            
        end
            
    case 'positive'

            
    otherwise
        disp('Unknown method');
        
end