function [ xInitials ] = getX0(agents,index)

    xInitials=zeros(size(agents{1},1),size(agents,2));
    for i=1:size(agents,2)
        xInitials(:,i)=agents{i}(:,index);
    end

end

