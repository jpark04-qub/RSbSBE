clear all;
close all;

addpath('MI');
addpath('RSbSBE');

% Configuration
cfg.classifier = 'svm';
cfg.k = 5;  % kNN
cfg.n = 1; % Percentage of final selection <= 100;

% NIPS 2003 Feature Selection Challenge Dataset Madelon
load 'madelon.mat'
dataset={'Madelon'};  

data_name=dataset{1}; 
fprintf('\n-- %s data loaded --\n', upper(data_name));
    
% Setup dataset
N = length(Y_train);  
indices = 1:N;    
idx1 = indices(1:round(N/2));  
idx2 = indices((round(N/2)+1):end);   

Y_train(Y_train==-1) = 2;
x_t = X_train(idx1, :);
x_v = X_train(idx2, :);
y_t = Y_train(idx1);
y_v = Y_train(idx2);

% feature selection
[fid, Prog, Fnum] = RSbSBE(cfg, @classifier, x_t, x_v, y_t, y_v);

plot(Fnum, Prog);
xlabel("number of features");
ylabel("accuracy");
ylim([52,  62]);




