clear all; close all;

%% Data Generation:
% [P0,1]*T = S*Q.
% P = P0 + W.

%% data generation setting
missing_ratio = 0.2; % outlier ratio fixed
types = {'fish', 'fu'}; % dataset
noise_ratios = 0:0.01:0.1;

num_trials = 100;

%% generate data for Fish and Fu
for typei = 1:2
    type = types{1,typei};
    P0 = load(sprintf('./libs/APM/model_%s.mat', type)); P0 = P0.X;
    k = length(P0);
    
    Ps = cell(length(noise_ratios), num_trials);
    Qs = cell(length(noise_ratios), num_trials);
    for triali=1:num_trials               
        W = randn(k, 2);
        W = W/norm(W,'fro')*norm(P0,'fro');
        
        % uniformly sample affine transformation matrices (T).
        linear = randn(2,2); translation = randn(1,2); 
        
        % fixed outliers        
        m = int64(k/(1-missing_ratio));        
        outliers = randn(m-k, 2);
        
        for ni = 1:length(noise_ratios)                                    
            noise_ratio = noise_ratios(ni);
            
            Qs{ni, triali} = [P0*linear + translation; outliers]; 
            Ps{ni, triali} = P0 + noise_ratio*W; % adding noise to the model data.
        end    
    end
    
    fn = sprintf('./dataset/dataset_NoisewithMissingPoints_missingratio=%.1f_%s.mat', missing_ratio, type);
    save(fn);
end