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
shuffle_ratios = 0:0.1:1;

es_BnB_mean = zeros(length(shuffle_ratios), 1);
es_BnB_std = zeros(length(shuffle_ratios), 1);

es_AIEM_mean = zeros(length(shuffle_ratios), 1);
es_AIEM_std = zeros(length(shuffle_ratios), 1);

es_hardEM_mean = zeros(length(shuffle_ratios), 1);
es_hardEM_std = zeros(length(shuffle_ratios), 1);

es_GR_mean = zeros(length(shuffle_ratios), 1);
es_GR_std = zeros(length(shuffle_ratios), 1);

es_Slawski_mean = zeros(length(shuffle_ratios), 1);
es_Slawski_std = zeros(length(shuffle_ratios), 1);


% load the dataset
n = 3; num_trials = 1000;
fn = sprintf('./dataset/dataset_SLR_shuffles_n=%d_#trials=%d.mat',n,num_trials);
load(fn);

% if you want to run 1 trial:
% num_trials = 1;

tic;
for si = 1:length(shuffle_ratios)
    shuffle_ratio = shuffle_ratios(si);

    es_BnB = zeros(num_trials, 1);
    es_AIEM = zeros(num_trials, 1);   
    es_hardEM = zeros(num_trials, 1);        
    es_GR = zeros(num_trials, 1);      
    es_Slawski= zeros(num_trials, 1);   
    
    parfor triali=1:num_trials    
        y = ys{si, triali};
        A = As{si, triali};
        x = xs{si, triali};
        %% Algorithm-A
        x_hat = S_BnB_v2(A, y, scale, EM_iter, tolerance, max_iter, depth, time_budget, verbose);           
        es_BnB(triali, 1) = norm(x_hat-x)/norm(x);

        %% Algorithm-B
        [x_hat, e_hat] = GeometricReconstruction(A, y);
        es_GR(triali, 1) = norm(x_hat-x)/norm(x);  
        
        %% Tsakiris18
        x_hat= AIEM(A,y,EM_iter);
        es_AIEM(triali, 1) = norm(x_hat-x)/norm(x);
        
        %% Abid18
        [x_hat, mle_e] = SLR_hardEM_v2(A,y,A\y, EM_iter);
        es_hardEM(triali, 1) = norm(x_hat-x)/norm(x);                  
        
        %% Slawski19
        %% It requires to have the CVX toolbox installed to run Slawski19.
        % The CVX toolbox can be obtained from:
        %            http://cvxr.com/cvx/
        
        % umcomment the following line to run Slawski19.
        % x_hat = Slawski(A, y, noise_ratio, shuffle_ratio, true);
        es_Slawski(triali, 1) = norm(x_hat-x)/norm(x);
    end
    es_BnB_mean(si, 1) = mean(es_BnB);
    es_BnB_std(si, 1) = std(es_BnB);
    
    es_AIEM_mean(si, 1) = mean(es_AIEM);
    es_AIEM_std(si, 1) = std(es_AIEM);    
    
    es_hardEM_mean(si, 1) = mean(es_hardEM);
    es_hardEM_std(si, 1) = std(es_hardEM);    
                
    es_GR_mean(si, 1) = mean(es_GR);
    es_GR_std(si, 1) = std(es_GR);    
    
    es_Slawski_mean(si, 1) = mean(es_Slawski);
    es_Slawski_std(si, 1) = std(es_Slawski);       
    
    disp(sprintf("m=%d,n=%d, shuffle_ratio=%.1f", m, n, shuffle_ratio));
    disp(sprintf("\t mean: BnB/AIEM/LSEM/GR/Slawski=%.5f/%.5f/%.5f/%.5f/%.5f", ...
        es_BnB_mean(si, 1), es_AIEM_mean(si,1), es_hardEM_mean(si,1), es_GR_mean(si,1), es_Slawski_mean(si, 1)));

    disp(sprintf("\t std: BnB/AIEM/LSEM/GR/Slawski=%.5f/%.5f/%.5f/%.5f/%.5f", ...
        es_BnB_std(si, 1), es_AIEM_std(si,1), es_hardEM_std(si,1), es_GR_std(si,1), es_Slawski_std(si, 1)));    
end
toc;
clear As
clear ys
clear xs
fn = sprintf('./results/SLR_shuffles_n=%d_#trials=%d.mat', n, num_trials);
save(fn);