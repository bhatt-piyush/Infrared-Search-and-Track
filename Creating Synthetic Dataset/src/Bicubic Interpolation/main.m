clc;
close all;
clear all
strDir = 'Y:/read only/Final Year Proj/Targets/';
files = {'1.bmp', '2.bmp', '3.bmp', '4.bmp'};
    
    for i=1:length(files)
        E=imread([strDir files{i}]);
        [x,y]=size(E);
        am=min(x,y);
        for j=2:21
            O=imresize(E,j/am);
            imwrite(O,[strDir int2str(i) '/' int2str(j) '.bmp']);
        end
    end
    
