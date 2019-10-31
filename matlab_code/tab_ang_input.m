clc

fid = fopen('angulos_input.txt','wt');


for i=0:1:360
    ang = dec2bin(uint32((i/360)*2^32),32);
    fprintf(fid, '%s\n', ang);
end
    

    
fclose(fid);


