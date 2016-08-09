clear 
clc
close all

delete('output/*');

fid = fopen('output/TestResults.txt','w+');
fprintf(fid,'Filename  \t\t\t\t\t\t Median [ms] \n');
count = 0;
patientFilter = [4,7,10,25,27,28,30,32,39,40,44,46,47,48,53,58,63,64,68,71,73,76,78,79,86,91,97,101,103,108,111,115,118,123,124,128,129,130,131,132,133,134,136,139,142,144,145,146,148,149,151,161];
display('Test starts...');
display(' ');

for i=1:152
    if(~ismember(i,patientFilter))
        patientNumber = i;
        count = count + 1;
        display(sprintf('Test for patient:\t %d',patientNumber)); 
        display(' ');     
        display('-------------------------------------------------------------------------');        
        [~,~,~,~,~,~,~,Stats] = MainApp(patientNumber,0,'no correction');
        for j=1:length(Stats)
             fprintf(fid,'%s \t\t %0.2f \n',strcat('patient',sprintf('%03d',patientNumber),'/',Stats{j}.filename),Stats{j}.Median);
        end
        display(' ');
    end
end

display(' ');
display(sprintf('There was %d records',count));
fprintf(fid,sprintf('There was %d records',count));
fclose(fid);
display(' ');
display('Test finished.');