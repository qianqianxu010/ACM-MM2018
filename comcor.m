function [completeness,correctness,hist] = comcor(data_test,s,lambda)
data = data_test(data_test(:,3)==1,1:2);
n = length(s);
N = size(data,1);
deltas = s*ones(1,n) - ones(n,1)*s';
ds = unique(abs(deltas(:)));
L = length(ds)-1;
hist.com = ones(1,L);
hist.cor = zeros(1,L);
right = sum(s(data(:,1)) > s(data(:,2)));
wrong = N - right;
hist.cor(1) = right/N;
for i = 2:L
    [a,b]=find(deltas == ds(i));
    for j = 1:length(a)
        right = right - sum(data(:,1)==a(j)&data(:,2)==b(j));
        wrong = wrong - sum(data(:,2)==a(j)&data(:,1)==b(j));
    end
    hist.cor(i) = right/(right+wrong);
    hist.com(i) = (right+wrong)/N;
end
ind = sum(lambda>ds);
completeness = hist.com(ind);
correctness = hist.cor(ind);