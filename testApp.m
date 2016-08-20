%This script is responsilbe for testing app

clear 
clc
close all

%Here we delete output folder
delete('output/*');
%create file to write results
fid = fopen('output/TestResults.txt','w+');
fprintf(fid,'Filename  \t\t\t\t\t\t Median [ms] \n');
count = 0;
%here we write patient number which we don't want to test
patientFilter = [124,132,134,161];
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