%%
%enter the path where the file is stored in your system
path = ('D:\Research\ITLab\Transciptomics_data');
%file name
fname = strcat(path,'\transcriptome.v7pm.txt');
%% 
% %we will keep this sectionc ommented out, because parsing the text files 
% %takes a freakin' long time! We will simply load the data in the next 
% %section.
% 
% %creating the data struct, with each field being the column headings the ID
% %and the cond variables are saved as a character array. Thus, to access it,
% %we will need to do something like this : A.ID(i,:).
% tic;
% A = tdfread(fname,'\t');   
% time = toc; 
% %it's a good idea to save this as a mat file so that it's easier to load it
% %and we save a lot of time 
% save('data.mat' , 'A');
% %we are now clear to perform operations on this. 

%%
%this part is just to load the data that we have read in the above section
data = load('data.mat');
A = data.A;





