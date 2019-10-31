clc
clear
fileID = fopen('output_sin.txt','r');

a = fscanf(fileID,'%d');
b = (a/32000);
for i=1:1:360
   if(i == 1)
       hold on;
   end
   plot(i,b(i),'x');
   
end
hold off;