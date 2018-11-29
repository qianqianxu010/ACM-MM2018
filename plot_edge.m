function [BG,score,ids] = plot_edge(s,lambda)
[ss,ix] = sort(s,'descend');
ids = cellstr(num2str(ix));
cm = repmat(ss,1,16);
cm = cm - cm';
cm = cm>lambda;
for i = 1:length(ss)
    ind = min(find(cm(i,:)==1));
    if ~isempty(ind)
        cm(i,:) = cm(i,:) - cm(ind,:);
    end
end
BG = biograph(cm,ids);
h = view(BG);
set(h.Nodes(:),'shape','circle')