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
noise_ratios = 0:0.01:0.1;

es_BnB_mean = zeros(length(noise_ratios), 1);
es_BnB_std = zeros(length(noise_ratios), 1);
es_AltMin_mean = zeros(length(noise_ratios), 1);
es_AltMin_std = zeros(length(noise_ratios), 1);
es_GR_mean = zeros(length(noise_ratios), 1);
es_GR_std = zeros(length(noise_ratios), 1);


% load the dataset
n = 3; num_trials=1000;
fn = sprintf('./dataset/dataset_SLR_US_Noise_n=%d_#trials=%d.mat', n, num_trials);
load(fn);

% if you want to run 1 trial:
% num_trials = 1;

for ni = 1:length(noise_ratios)
    noise_ratio = noise_ratios(ni);
    
    es_BnB = zeros(num_trials, 1);
    es_AltMin = zeros(num_trials, 1);    
    es_GR = zeros(num_trials, 1);
    
    parfor triali=1:num_trials          
        y = ys{ni, triali};
        A = As{ni, triali};
        x = xs{ni, triali};
        
        %% Algorithm-A
        [x_hat] = S_BnB_v2(A, y, scale, EM_iter, tolerance, max_iter, depth, time_budget, verbose); 
        es_BnB(triali, 1) = norm(x_hat-x)/norm(x);
                
        %% Algorithm-B
        [x_hat, e_hat] = GeometricReconstruction(A, y);
        es_GR(triali, 1) = norm(x_hat-x)/norm(x);  
        
        %% Haghighatshoar18
        I = sort(datasample(1:m, k, 'Replace', false));
        x_init = A(I,:)\y;
        [x_hat, mle_e] = AltMin(A, y, x_init, EM_iter);
        es_AltMin(triali, 1) = norm(x_hat-x)/norm(x);       

    end    
    es_BnB_mean(ni, 1) = mean(es_BnB);
    es_BnB_std(ni, 1) = std(es_BnB);  
    
    es_AltMin_mean(ni, 1) = mean(es_AltMin);
    es_AltMin_std(ni, 1) = std(es_AltMin);  
    
    es_GR_mean(ni, 1) = mean(es_GR);
    es_GR_std(ni, 1) = std(es_GR);  
        
    disp(sprintf("m=%d,n=%d, noise_ratio=%.2f", m, n, noise_ratio));
    disp(sprintf("\t mean: BnB/AltMin/GR+=%.3f/%.3f/%.3f", ...
        es_BnB_mean(ni, 1), es_AltMin_mean(ni, 1),  es_GR_mean(ni, 1)));
    disp(sprintf("\t std: BnB/AltMin/GR+=%.3f/%.3f/%.3f", ...
        es_BnB_std(ni, 1), es_AltMin_std(ni, 1), es_GR_std(ni, 1)));    
end
clear ys
clear As
clear xs
fn = sprintf('./results/SLR_US_Noise_n=%d_#trials=%d.mat', n, num_trials);
save(fn);