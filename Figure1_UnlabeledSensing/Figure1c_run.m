clear all; close;

% algorithm parameters
EM_iter = 50;
max_iter = inf;
time_budget = inf;
depth = 6;
scale = 6;
tolerance = 0.0001;
verbose = 0;


% result variables
missing_ratios = 0:0.05:0.5;

es_BnB_mean = zeros(length(missing_ratios), 1);
es_BnB_std = zeros(length(missing_ratios), 1);
es_AltMin_mean = zeros(length(missing_ratios), 1);
es_AltMin_std = zeros(length(missing_ratios), 1);
es_GR_mean = zeros(length(missing_ratios), 1);
es_GR_std = zeros(length(missing_ratios), 1);


% load the dataset
n = 3; num_trials=1000;
fn = sprintf('./dataset/dataset_SLR_US_MissingPoints_n=%d_#trials=%d.mat', n, num_trials);
load(fn);

% if you want to run 1 trial:
% num_trials = 1;

for mi = 1:length(missing_ratios)
    missing_ratio = missing_ratios(mi);
    k = int64(m*(1-missing_ratio));
    
    es_BnB = zeros(num_trials, 1);
    es_AltMin = zeros(num_trials, 1);
    es_GR = zeros(num_trials, 1);
    
    parfor triali=1:num_trials          
        y = ys{mi, triali};
        A = As{mi, triali};
        x = xs{mi, triali};
        
        %% Algorithm-A
        [x_hat] = S_BnB_v2(A, y, scale, EM_iter, tolerance, max_iter, depth, time_budget, verbose); 
        es_BnB(triali, 1) = norm(x_hat-x)/norm(x);
        
        %% Algorithm-B      
        [x_hat, e_hat, GR_time] = GeometricReconstruction(A, y);
        es_GR(triali, 1) = norm(x_hat-x)/norm(x);    
        
        %% Haghighatshoar18
        I = sort(datasample(1:m, k, 'Replace', false));
        x_init = A(I, :)\y;
        [x_hat, mle_e] = AltMin(A, y, x_init, EM_iter);
        es_AltMin(triali, 1) = norm(x_hat-x)/norm(x);                                   
    end    
    es_BnB_mean(mi, 1) = mean(es_BnB);
    es_BnB_std(mi, 1) = std(es_BnB);  
    
    es_AltMin_mean(mi, 1) = mean(es_AltMin);
    es_AltMin_std(mi, 1) = std(es_AltMin);  
    
    es_GR_mean(mi, 1) = mean(es_GR);
    es_GR_std(mi, 1) = std(es_GR);  
        
    disp(sprintf("#trial=%d, m=%d,n=%d, missing_ratio=%.2f", num_trials, m, n, missing_ratio));
    disp(sprintf("\t mean: BnB/AltMin/GR+=%.3f/%.3f/%.3f", ...
        es_BnB_mean(mi, 1), es_AltMin_mean(mi, 1), es_GR_mean(mi, 1)));
    disp(sprintf("\t std: BnB/AltMin/GR+=%.3f/%.3f/%.3f", ...
        es_BnB_std(mi, 1), es_AltMin_std(mi, 1), es_GR_std(mi, 1)));    
end
clear ys
clear As
clear xs
fn = sprintf('./results/SLR_US_MissingPoints_n=%d_#trials=%d.mat', n, num_trials);
save(fn);