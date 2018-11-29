function [S,lambda,output] = MLE_GTM(data,model)
%Use cvx to compute maximum likelihood scale values assuming Generalized Thurstone's model.
%S = argmin ?log P(data|S)
%Assume that mean(S)=0.
assert(all((data(:,3) == 0) | (data(:,3) ==1)), 'data(:,3) must be 0 or 1');
data_uniq = unique(data,'rows');
n = max(data_uniq(:));
m = length(data_uniq);
count = zeros(m,1);
for i = 1:m
    count(i) = sum(ismember(data,data_uniq(i,:),'rows'));
end

d0 = sparse([1:m,1:m],[data_uniq(:,1);data_uniq(:,2)],[ones(1,m),-ones(1,m)],m,n);
d1 = [d0,-ones(m,1)];
d2 = [d0,ones(m,1)];
if model == 1
    Phi = @(x) 1./(1+exp(-x));
elseif model == 2
    Phi = @(x) normcdf(x);
elseif model == 3
    L = 1;
    Phi = @(x) (x+1)/2;
else
    error('model must be in {1,2,3}')
end
fun = @(x) -sum(count.*log((-1+2*data_uniq(:,3)).*Phi(d1*x) + (1-data_uniq(:,3)).*Phi(d2*x)));
options = optimoptions('fmincon','Algorithm','sqp');
A = []; B = [];
if model>2
    A = [d1;-d1;d2(count==0,:);-d2(count==0,:)];
    B = ones(size(A,1),1)*L;
end
[X,fmin,exitflag,output] = fmincon(fun,[zeros(n,1);0.1],A,B,[ones(1,n),0],0,[-ones(1,n)*Inf,0],[],[],options);
S = X(1:n);
lambda = X(n+1);
