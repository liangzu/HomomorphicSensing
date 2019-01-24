close all; clear all;
% algorithm parameters 
EM_iter = 20;
scale = 6;
max_iter = inf;
tolerance = 0.0001;   
trans_type = 'affine';
verbose = false;


% data
types = {'fish', 'fu'};
noise_ratios = 0:0.01:0.1;
missing_ratio = 0.2;

% CPD setting
affine_opt.method='affine';
affine_opt.viz = 0;
affine_opt.corresp = 1;

rigid_opt.method='rigid';
rigid_opt.viz = 0;
rigid_opt.corresp = 1;

for typei = 1:2
    type = types{1,typei};
    fn = sprintf('./dataset/dataset_NoisewithMissingPoints_missingratio=%.1f_%s.mat', missing_ratio, type);
    load(fn);
    
    es_BnB_mean = zeros(length(noise_ratios), 1);
    es_BnB_std = zeros(length(noise_ratios), 1);    
    
    es_APM_mean = zeros(length(noise_ratios), 1);
    es_APM_std = zeros(length(noise_ratios), 1);
    
    es_CPD_mean = zeros(length(noise_ratios), 1);
    es_CPD_std = zeros(length(noise_ratios), 1);
    
    es_GMMREG_mean = zeros(length(noise_ratios), 1);
    es_GMMREG_std = zeros(length(noise_ratios), 1);
    
    for ni = 1:length(noise_ratios)
        noise_ratio = noise_ratios(ni);                  
        
        es_match_BnB = zeros(num_trials, 1);
        
        es_match_APM = zeros(num_trials, 1);
        
        es_match_CPD = zeros(num_trials, 1);
        es_match_GMMREG = zeros(num_trials, 1);
                 
        parfor triali=1:num_trials   
            P = Ps{ni, triali};
            Q = Qs{ni, triali};
            
            %% APM
            [match_err, F_hat, time_APM] = APM(P, Q);
            es_match_APM(triali, 1) = match_err;                  
            
            %% Algorithm-C           
            [~, Q_hat] = S_BnB_affine_Matrices(P, Q, scale, EM_iter, tolerance, trans_type, max_iter, time_APM, verbose);
            diff = Q_hat - Q(1:k,:);
            es_match_BnB(triali, 1) = mean(sqrt(sum(diff.^2,2)));   
            
            %% CPD            
            [Transform, C] = cpd_register(Q, P, affine_opt);
            diff = Transform.Y - Q(1:k,:);            
            es_match_CPD(triali, 1) = mean(sqrt(sum(diff.^2,2)));
            
            %% GMMREG                        
            [param, transformed_model] = gmmreg_L2(initialize_config(P, Q, 'rigid2d')); 
            diff= transformed_model- Q(1:k,:);
            es_match_GMMREG(triali, 1) = mean(sqrt(sum(diff.^2,2)));       
            
        end                            
        es_APM_mean(ni, 1) = mean(es_match_APM);
        es_APM_std(ni, 1) = std(es_match_APM);
        
        es_BnB_mean(ni, 1) = mean(es_match_BnB);
        es_BnB_std(ni, 1) = std(es_match_BnB);
        
        es_CPD_mean(ni, 1) = mean(es_match_CPD);
        es_CPD_std(ni, 1) = std(es_match_CPD);
                
        es_GMMREG_mean(ni, 1) = mean(es_match_GMMREG);
        es_GMMREG_std(ni, 1) = std(es_match_GMMREG);            
        
        disp(sprintf("#trials=%d, noise_ratio=%.2f, %s", num_trials, noise_ratio, type));
        disp(sprintf("\t mean: BnB/APM=%.3f/%.3f", ...
            es_BnB_mean(ni, 1), es_APM_mean(ni,1)));
        
        disp(sprintf("\t std: BnB/APM=%.3f/%.3f", ...
             es_BnB_std(ni, 1), es_APM_std(ni,1)));
    end
    fn = sprintf('./results/FishFu_NoisewithMissingPoints_%s_iter=%d.mat', type, max_iter);
    clear Ps
    clear Qs
    save(fn);
end