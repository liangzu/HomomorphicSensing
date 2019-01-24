clear all; close all;

%% Data Generation:
% [P0,1]*T = S*Q.
% P = P0 + W.

%% data generation setting
noise_ratio= 0.01;  % noise level fixed
types = {'fish', 'fu'}; % dataset
missing_ratios = 0:0.05:0.5; % outlier to data ratio

num_trials = 100;

%% generate data for Fish and Fu
for typei = 1:2
    type = types{1,typei};
    P0 = load(sprintf('./libs/APM/model_%s.mat', type)); P0 = P0.X;
    k = length(P0);
    
    Ps = cell(length(missing_ratios), num_trials);
    Qs = cell(length(missing_ratios), num_trials);
    for triali=1:num_trials
        % adding fixed noise for different level of missing ratios.        
        W = randn(k, 2);
        W = noise_ratio*W/norm(W,'fro')*norm(P0,'fro');
        
        % uniformly sample affine transformation matrices (T).
        linear = randn(2,2); translation = randn(1,2); 
        
        for mi = 1:length(missing_ratios)            
            missing_ratio = missing_ratios(mi);
            
            m = int64(k/(1-missing_ratio));         
            outliers = randn(m-k, 2);
            Qs{mi, triali} = [P0*linear + translation; outliers]; % adding outliers randomly to the scene data.
            Ps{mi, triali} = P0 + W; % adding noise to the model data.
        end    
    end
    
    fn = sprintf('./dataset/dataset_MissingPointswithNoise_%s.mat', type);
    save(fn);
end