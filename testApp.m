clear 
clc
close all

% delete('output/*');

patientFilter = [124,132,134,161,];
display('Test starts...');
for i=104:294
    if(~ismember(i,patientFilter))
        patientNumber = i;
        display(sprintf('Test for patient:\t %d',patientNumber)); 
        display(' ');
        display(' ');
        display('-------------------------------------------------------------------------');
        display(' ');
        display(' ');
        MainApp(patientNumber,0,'Bazetta');
    end
end
display('Test finished.');