function merge_datasets(sensorname,file1, file2)
%merge_datasets is a function that will combine two files taken from the
%same sensor during different trials.
%
%the function takes in three arguments:
%merge_datasets(sensorname,file1, file2)
%
%sensorname - the 4 character sensor identifier such as 'EABE'
%file1 - string containing the path to the first dataset
%file2 - string containing the path to the second dataset

f1 = fopen(file1,'r');
f2 = fopen(file2,'r');

%using fopen, open the files inputted by the user, read only.
%file pointers f1 f2 and fdest are now ready to be read from

f1import = fscanf(f1, '%f');
f2import = fscanf(f2, '%f');
%read every decimal value out of each of the two files, store them
%into Nx1 matrix where N is the number of entries of the files

[m,n] = size(f1import);
size_f1import = m;
size_f1data = m/11;
[m,n] = size(f2import);
size_f2import = m;
size_f2data = m/11;
%determine the size of the input files for use

f2data = zeros(size_f2data,11);
fdestdata = zeros((size_f1data+size_f2data),11);
%prepare placeholders that hold the data for processing

display('Data is now processing');

w = 1;
b = 1;
while(w < size_f1import + 1)
    for k = 1:11
    	fdestdata(b,k) = f1import(w,1);
		w = w+1;
    end
	b = b+1;
end

w = 1;
b = 1;
while(w < size_f2import + 1)
    for k = 1:11
    	f2data(b,k) = f2import(w,1);
		w = w+1;
    end
	b = b+1;
end
%copy the data, which are in column vectors, into proper matricies

timedif = f2data(1,1) - fdestdata(size_f1data,1);
%find the difference in timestamp between the first element of data
%collected in the second data file and the the last element of data
%collected in the first data file

b = 1;
while (b < size_f2data + 1)
    f2data(b,1) = f2data(b,1) - timedif;
    b = b+1;
end
%write a for loop, for every 11th element of f2import, subtrapt timedif
%from that element, so that the first column gets aligned properly

indexlast = fdestdata(size_f1data,2);
%find the index between 0 and 5000 of the final entry of data1

indexer = indexlast + 1;
b = 1;
while (b < size_f2data + 1)
    if indexer < 5001
        f2data(b,2) = indexer;
        indexer = indexer + 1;
    else
        f2data(b,2) = 1;
        indexer = 2;
    end
    b = b+1;
end
%write a for loop that for every second row element of second data, that it
%updates the arbitrary index to be the proper value from 1 to 5000,
%compared to where it will be attatched to the end of the first data file

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
destindex = size_f1data +1;
b = 1;
while (destindex < size_f1data + size_f2data +1)
    for k = 1:11
    	fdestdata(destindex,k) = f2data(b,k);
    end
    b = b+1;
	destindex = destindex+1;
end

%figure out the name of sensor and timestamp of second file
filedest = strcat('FireFly-', sensorname,'_1234567890123.txt');
%filedest is the new file that has the combined data of file1 and file2
fdest = fopen(filedest, 'w');


display('Data has been processed, now exporting');
for i = 1:length(fdestdata(:,1))
    fprintf(fdest, '%s\n', num2str(fdestdata(i,:)));
end

fclose(f1);
fclose(f2);
fclose(fdest);
end


