function colonoids=trackOrganoids(i,colonoids,tempcolonoids)
%compare to initial
colonoids{i}=zeros(size(colonoids{i-1})); %makes a 0s array the length of previous colonoids rows (# of objects)
for ii=1:size(tempcolonoids,1)%same thing running loop from 1 to 106
    diff= abs(bsxfun(@minus,colonoids{i-1}(:,1:5),tempcolonoids(ii,1:5)));%comparing centroid, area and intensity for all objects
    dist=sqrt((diff(:,1).^2)+(diff(:,2).^2)); %centroid position
    adist=diff(:,3)./tempcolonoids(ii,3);%pixel area
    distid=find( dist<15 & adist<0.25);%why 15 and 25% finding all of the matches
    if isempty(distid) % none of the objects matched to original objects????
        %make new
        if i>3 %i is timepoint, ii is object
            %check before making new     initial - current thing looking at
            %(rows, cols)
            diff= abs(bsxfun(@minus,colonoids{i-2}(:,1:5),tempcolonoids(ii,1:5)));
            dist=sqrt((diff(:,1).^2)+(diff(:,2).^2));
            adist=diff(:,3)./tempcolonoids(ii,3);
            distid=find( dist<15 & adist<0.25);
            if isempty(distid)
                colonoids{i}=[colonoids{i}; [tempcolonoids(ii,1:5) size(colonoids{i-1},1)+1]];
            elseif length(distid)<2
                %unambiguous
                colonoids{i}(distid,:)=[tempcolonoids(ii,1:5) distid];
            else
                %find best candidate
                [md,id1]=min(dist(distid));
                [mad,id2]=min(adist(distid));
                if id1==id2
                    %unambiguous
                    colonoids{i}(distid(id1),:)=[tempcolonoids(ii,1:5) distid(id1)];
                elseif md<40
                    colonoids{i}(distid(id1),:)=[tempcolonoids(ii,1:5) distid(id1)];
                elseif mad<0.02
                    colonoids{i}(distid(id2),:)=[tempcolonoids(ii,1:5) distid(id1)];
                else
                    'ambiguous'
                    dist(distid)
                    adist(distid)
                    %'ambiguous'
                end
            end
        else
            colonoids{i}=[colonoids{i}; [tempcolonoids(ii,1:5) size(colonoids{i-1},1)+1]];
        end
    elseif length(distid)<2
        %unambiguous
        colonoids{i}(distid,:)=[tempcolonoids(ii,1:5) distid];
    else
        %find best candidate
        [md,id1]=min(dist(distid));
        [mad,id2]=min(adist(distid));
        if id1==id2
            %unambiguous
            colonoids{i}(distid(id1),:)=[tempcolonoids(ii,1:5) distid(id1)];
        elseif md<40
            colonoids{i}(distid(id1),:)=[tempcolonoids(ii,1:5) distid(id1)];
        elseif mad<0.02
            colonoids{i}(distid(id2),:)=[tempcolonoids(ii,1:5) distid(id1)];
        else
            'ambiguous'
            dist(distid)
            adist(distid)
            %'ambiguous'
        end
    end  
end

