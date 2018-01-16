clc;
%this program is the final program for creating the synthetic images
%delete the folder in which images will be stored before running this
%program.
close all;
clear all
strDir = 'Y:/read only/Final Year Proj/Targets/';
strDir2 = 'Y:/read only/Final Year Proj/Backgrounds/';
strDir3 = 'Y:/read only/Final Year Proj/NewDataset/';
tnum=1; %number of targets
x=1;    %backgroound image number
mkdir(strDir3 , int2str(tnum));
images=100;%number of images needed

storex=zeros(images,tnum);%for storing the position of targets
storey=zeros(images,tnum);

for l=1:images 
    B=imread([strDir2 int2str(x) '.bmp']);
    [by,bx]=size(B);
    x=inci(x);
    flag=1; %flag set if any two pixels are withing the range of 20x20(with default value 1)
    
    while(flag==1)      
        %generate random pixel position
        p=randperm(numel(B),tnum);
        v=B(p);
        [y0,x0]=ind2sub(size(B),p);
        %selecting position from atleast a distance of 20 pixels from each boundary for clear targets
        y0(y0<21)=y0(y0<21)+20;
        x0(x0<21)= x0(x0<21)+20;
        x0(x0>(bx-20)) = x0(x0>(bx-20))-20;
        y0(y0>(by-20)) = y0(y0>(by-20))-20;
        
        %verifying that no two targets are within the range of 20x20 pixels
        %for clear targets
        flag=0;
        for ch1=1:tnum
            for ch2=ch1+1:tnum
                if((abs(x0(ch1)-x0(ch2))<20) && (abs(y0(ch1)-y0(ch2))<20))
                    flag=1;
                end
                
            end
        end
    end
    %upto here
    
    storex(l,:)=x0;
    storey(l,:)=y0;

    for pos=1:tnum        
        %select any target randomly
        i=randi(3);
        j=randi([4,10]);

        T=imread([strDir int2str(i) '/' int2str(j) '.bmp']);
        T=mat2gray(T);%normalize the image to (0,1)

        %generate the random value of r lying between [h,255]
        [m,n]=size(T);
        I=imcrop(B,[x0(pos),y0(pos),n,m]);
        h=max(I(:));% h is the maximum pixel value in the background image where target will be placed 
        r=randi([h,255],1);

        %the function f(x,y) from the base paper
        C=zeros(size(B));
        C(y0(pos):(y0(pos)+m-1),x0(pos):(x0(pos)+n-1))=T;
        C=r*C;
        [bm,bn]=size(B);
        C=imcrop(C,[1,1,bn-1,bm-1]);
        C=uint8(C);
        CisBigger = C>B;
        D=B;
        D(CisBigger)=C(CisBigger);
        D=imGaussFilter(D);
        %imshow(D);
        B=D;
    end
    imwrite(D,[strDir3 '/' int2str(tnum) '/' int2str(l) '.bmp']);
end
csvwrite([strDir3 '/' int2str(tnum) '/x_cordinates.csv'],storex);
csvwrite([strDir3 '/' int2str(tnum) '/y_cordinates.csv'],storey);
imshow(B);