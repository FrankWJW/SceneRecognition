q=0;
file = fopen('cv3.txt','wt');
for i=1315:numel(fileNames)
oq=imread(strcat(num2str(q),'.jpg'));
category = classify(myNet,oq);
fprintf(file,'%s\t%s',strcat(num2str(q),'.jpg'),char(category));
fprintf(file,'\n');
q=q+1;
end
fclose(file);