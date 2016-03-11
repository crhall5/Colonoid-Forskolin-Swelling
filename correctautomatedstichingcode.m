load('FScanData.mat')
warning('off','all');
for t=1:1
    image{t}=zeros(1300,1600);
    startimage= [1,25,49,73,97,121];
    stopimage=[24,48,72,96,120,144];
    for w=1:3
        %if w==1
            %X1=x(1:15);
            %Y1=y(1:15);
            res_factor=1.607;
            image{t}=stitcher2(x,y,res_factor,startimage(w), stopimage(w), t);
            imwrite(image{t},['./Stitched Data 2-14-16/Well' num2str(w) 'Stitch Time' num2str(t) '.png']);
        %end
        %if w==2
            %X2=x(16:30);
            %Y2=y(16:30);
            %image{t}=stitcher2(X2,Y2,rf,16,30,t);
            %imwrite(image{t},['Well' num2str(w) 'Stitch Time' num2str(t) '.png']);
        %end
        
        %if w==3
            %X3=x(31:45);
            %Y3=y(31:45);
            %image{t}=stitcher2(X3,Y3,rf,31,45,t);
            %imwrite(image{t},['Well' num2str(w) 'Stitch Time' num2str(t) '.png']);
        %end
        
        %if w==4
            %%X4=x(46:60);
            %Y4=y(46:60);
            %image{t}=stitcher2(X4,Y4,rf,46,60,t);
            %imwrite(image{t},['Well' num2str(w) 'Stitch Time' num2str(t) '.png']);
        %end
    end
end


