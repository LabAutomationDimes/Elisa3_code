function index = maxIndex(paths,xInitials,start,r)
    if start>=size(paths{1},2)
        index=size(paths{1},2);
        return
    end

    index=start-2;
    cond=true;
    while index+2<=size(paths{1},2)-1 && cond
        index=index+1;
        for j=1:size(paths,2)
            if norm(xInitials(1:2,j)-paths{j}(:,index+1))>r
                cond=false;
                break
            end
        end
    end
    if index<start
%         error('errore maxIndex')
        index=start;
    end
    if index<=0
        index=1;
    end
%     if ~cond
% %         xInitial
% %         index
% %         start
% %         error('errore')
%         index=start;
%     end
end