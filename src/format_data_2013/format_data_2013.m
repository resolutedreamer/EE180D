function format_data_2013(file)
% Instruction: 
% put this function and your data file 
% (for example, "BlueRadios_61AE_1374518263244.txt") under the same directory,
% type "format_data_2013('BlueRadios_61AE_1374518263244.txt')" in your command window,
% press "enter\return" to run the function,
% and the function will generate a new file called "FireFly-61AE_1374518263244.txt".
% This new file is compatible with the WHSFT.
% However since the sensor doesn't have an active magnetometer, the last three
% columns of the new data file will be all 0.
% original version downloaded 10/10/2013
% new version created 11/26/2013 by Anthony Nguyen

data = BluestoFire(file);
display('Now exporting to file');
loc = strfind(file, '_');
name = file(loc(1)+1:loc(2)-1);
time = file(loc(2)+1:end);
file1 = strcat('FireFly-', name, '_', time);
fid = fopen(file1, 'w');
for i = 1:length(data(:,1))
    fprintf(fid, '%s\n', num2str(data(i,:)));
end
fclose(fid);
end

function data = BluestoFire(file)    
%% Preprocessor
% inputs: the name of the bluesradio file,
% outputs: the data in it in the FireFly format
as = 2048;       % sensitivity of 16g accelerometer
gs = 16.4;       % sensitivity of gyroscope
qs = 1073741824; % sensitivity of quaternion

display('Importing BlueRadios data');
%% load the BluesRadio file into memory
fdata = csvread(file,1);
%% build the index
count = 0;
index = zeros(size(fdata,1),1);
for i = 1:size(fdata,1)
        count = count + 1;
        if (count == 5001)
            count = 1;
        end
        index(i) = count;
end
%% Convert the BluesRadio data in memory into the FireFly data format
if ~isempty(fdata)
    fdata(:,2) = -fdata(:,2);
    fdata(:,3) = -fdata(:,3);
    acc = fdata(:,2:4)/as*256;
    gyro = fdata(:,5:7)/gs;
    q = fdata(:,8:11)/qs;
    
    t = fdata(:,1);
    data = [t index acc gyro ones(length(t),3)];
else
    display('Failure!');
    data = [];
end
display('BlueRadios data has been converted to Firefly format');
end