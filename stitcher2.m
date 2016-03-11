function bigi=stitcher2(x,y,res_factor,startimage,stopimage, t)
%general stitcher 11/6/2015, Matthew DiSalvo, Nancy Allbritton Lab

% Uses distance transfer - based alpha blending to form seamless composites

% Inputs:
% x: vector of real-world x cooridates for the image (in microns) where the
% ith element of x is the coordinate of the ith image position

% y: vector of real-world y cooridates for the image (in microns)where the
% ith element of x is the coordinate of the ith image position 

% res_factor: This is the ratio of microns to pixels in your images. I.e.,
% res_factor= microns/ pixels. For my camera at 4x mag, it's 1.607
% um/pixel. If this is not precise your images will not be stitched in the
% right location! Tip: if you don't know the precise number you can guess a
% number, stitch, and adjust it if it's off. 

% Outputs:
% bigi: A big stitched image. Make sure to save! Use imwrite to save (type
% doc imwrite in command window to learn how)

% Additional notes:
% Rename your images to stitch according to this convention: 
% "Pos 1", "Pos 2",.."Pos i",.."Pos N" where N is the total
% number of images and the ith image corresponds to the ith x and y 
% coordinate. When prompted, Select all of your images to stitch at once. 

%% PARAMETERS: Change me as needed!
rf=2; %downsizing factor: decreases final resolution. default: 2 (resulting in 1/2 the final resolution)
%2 returns 1000x1200 uint16, 4 returnes 400x500 uint16
verbose=true; %If true, program illustrates the stitching progress for a slight speed reduction  
%% CODE BODY: Do not alter!
x=x(:)./rf;
y=y(:)./rf;
resizefactor=10;
%[flist f]=uigetfile('Multiselect','on','*');
starti=startimage; 
endi=stopimage;
X=1+round( (x(starti:endi)-min(x(starti:endi)))./res_factor );%1x24 double
Y=1+round( (y(starti:endi)-min(y(starti:endi)))./res_factor );
yl=100*ceil((max(Y)+1040/rf)/100);%1500 when rf=2
xl=100*ceil((max(X)+1392/rf)/100);%1800 when rf=2


bigi=double(zeros(yl,xl));
for j=startimage:stopimage 
    littlei=imresize((double((imread(['./Data 2-14-16/Time ' num2str(t) ' Pos ' num2str(j) ' DAPI.png' ])))),1/rf);
    tempi=double(zeros(yl,xl));
    tempi(Y(j-starti+1) :Y(j-starti+1) +(1040/rf)-1,X(j-starti+1) :X(j-starti+1) + (1392/rf)-1)= littlei;
    maskfl=double((bigi>0)).*imresize(bwdist(~imresize(bigi,1/resizefactor)>0),resizefactor);
    masktemp=double((tempi>0)).*imresize(bwdist(~imresize(tempi,1/resizefactor)>0),resizefactor);
    alpha=masktemp./(masktemp+maskfl); %dtrans1/dtrans1+dtrans2
    alpha(isinf(alpha))=0;
    alpha(isnan(alpha))=0;
    bigi=(alpha).*tempi + (1-alpha).*bigi;
    if verbose
%         imshow(bigi,[])
%         drawnow
    end
end
bigi=(uint16(double(bigi)));


