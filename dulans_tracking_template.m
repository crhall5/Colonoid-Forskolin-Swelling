% clear all
%For w=1:3
%load 'Users/DulanAdmin/Documents/UNC2 Research/Data with new cells-start July 2015/12-05-2015 to 2001-16-2015/12-14-2015 20forskolin/Hoechst stiched/Well'num2str(w)'
startt=1;
endt=27;
for timepoint=startt:endt
    %% read stitch intensity image for timepoint t
    I=imread(['./Stitched Data 2-14-16/Well1Stitch Time' num2str(timepoint) '.png']);
    figure(1), imshow(I, [])
    drawnow
    images=cell(27,1);
    images{timepoint}=I;
    %% make stitched mask
    %one way: graythresh to get threshold, then im2bw to apply threshold
    %another way: multithresh to get the thrshold and imquantize to apply
    %threshold
    thresh=multithresh(I,1);
    mask=logical(imquantize(I,thresh)-1);
    mask=imclose(mask,strel('disk',3));
    mask=bwareaopen(mask,70);
    mask=imfill(mask,'holes');

    %% tracking
    s=regionprops(mask,I,'MeanIntensity','Area','Centroid','PixelValues');%stores pixel values of each region but doesn't use it?
    C=vertcat(s.Centroid);
    A=[s.Area]';
    IN=[s.MeanIntensity]';
    IM=[zeros(length(A),1)];
    tempcolonoids=[C A IN IM zeros(length(A),1)];
    if timepoint==startt
        colonoids{timepoint}(:,:)=tempcolonoids;
    else
        colonoids=trackOrganoids(timepoint,colonoids,tempcolonoids); % make sure to start at timepoint 1
    end
end

% re-organizing data into matrices of size N_colonoids x N_timepoints (row
% x column)
AS=zeros(size(colonoids{end},1),length(colonoids)); %areas
CX=zeros(size(colonoids{end},1),length(colonoids)); % x-coordinate of centroid
CY=zeros(size(colonoids{end},1),length(colonoids)); % y-coordinate of centroid
INTS=zeros(size(colonoids{end},1),length(colonoids)); %mean intensity
IMS=zeros(size(colonoids{end},1),length(colonoids)); %blank
for ii=1:length(colonoids) %27?
    totransferAS=colonoids{:,ii}(:,3);
    totransferCX=colonoids{:,ii}(:,1);
    totransferCY=colonoids{:,ii}(:,2);
    totransferINTS=colonoids{:,ii}(:,4);
    totransferIMS=colonoids{:,ii}(:,5);
    AS(1:length(totransferAS),ii)= totransferAS;
    CX(1:length(totransferCX),ii)= totransferCX;
    CY(1:length(totransferCY),ii)= totransferCY;
    INTS(1:length(totransferINTS),ii)= totransferINTS;
    IMS(1:length(totransferIMS),ii)= totransferIMS;
end
AS=AS*2*2*1.607*1.607;
CX=CX*2*1.607;
CY=CY*2*1.607; %why x2? 


%saving data to current directory to a file called data.mat
save('data.mat','AS','CX','CY')

% Calculating aboslute difference
for i=1:size(AS,1) %each object
    temp=AS(i,:);%1x27 
    maxd=max(temp);%largest area of each object
    ini=temp(1);
    d(i)=100*(maxd-ini)/ini;
end
save('datatreated.mat','d')

b=find(d~=inf); %...anything started with a 0 is out
d=(d(b));
% boxplotting absolute difference
figure, boxplot(d)
ylabel('Area Difference (µm^2)')
%%
limits=[0 30 0 3e+05];
figure, plot(AS(2,:))
axis(limits)
ylabel('Total Area (um^2)')
xlabel('Timepoint')
%%
img=cell(27,1);
v = VideoWriter('Well1Stitched.avi');
v.FrameRate=15;
open(v)
for timepoint=1:27
    img{timepoint}=imread(['./Stitched Data 2-14-16/Well1Stitch Time' num2str(timepoint) '.png']);
    img{timepoint}=uint8(255*mat2gray(img{timepoint}));
    img{timepoint}=imresize(img{timepoint},0.5);
    writeVideo(v,img{timepoint});
    timepoint=timepoint+1;
end    
close(v)

    