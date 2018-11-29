refnum = 1;
load(strcat('ref',num2str(refnum),'.mat'));
data = ref(:,2:4);
data(:,1:2) = data(:,1:2) - 16*(refnum-1);
N = size(data,1);
train = rand(1,N)<0.8;
test = ~train;
data_train = data(train,:);
data_test = data(test,:);

%%model must be in {1,2,3}
model = 1; 
[s,lambda,output] = MLE_GTM(data_train,model);
BG = plot_edge(s,lambda);
[completeness,correctness,hist] = comcor(data_test,s,lambda);
plot(hist.com,hist.cor,'b.')
xlabel('completeness');
ylabel('correctness');

hold on;plot(completeness,correctness,'ro')