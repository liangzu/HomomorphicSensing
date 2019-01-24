close all; clear all;
% algorithm parameters 
EM_iter = 20;
scale = 6;
max_iter = inf;
tolerance = 0.0001;   
trans_type = 'affine';
verbose = false;


num_trials = 100;

types = {'fish', 'fu'};

missing_ratio = 0;
angles = 0:18:180;

% CPD setting
affine_opt.method='affine';
affine_opt.viz = 0;
affine_opt.corresp = 1;

rigid_opt.method='rigid';
rigid_opt.viz = 0;
rigid_opt.corresp = 1;

for typei = 1:2
    type = types{1,typei};

    fn = sprintf('./dataset/dataset_Rotation_%s.mat', type);
    load(fn)
    
    es_BnB_mean = zeros(length(angles), 1);
    es_BnB_std = zeros(length(angles), 1);
    
    es_APM_mean = zeros(length(angles), 1);
    es_APM_std = zeros(length(angles), 1);
    
    es_CPD_mean = zeros(length(angles), 1);
    es_CPD_std = zeros(length(angles), 1);
    
    es_GMMREG_mean = zeros(length(angles), 1);
    es_GMMREG_std = zeros(length(angles), 1);
    
    for ai = 1:length(angles)
        angle= angles(ai);
        theta = angle*pi/180;
        R = [cos(theta) -sin(theta);sin(theta) cos(theta)];                
        
        es_match_BnB = zeros(num_trials, 1);
        es_match_APM = zeros(num_trials, 1);
        es_match_CPD = zeros(num_trials, 1);
        es_match_GMMREG = zeros(num_trials, 1);        
        
        parfor triali=1:num_trials
            P = Ps{ai, triali};
            Q = Qs{ai, triali};
            %% APM
            [match_err, F_hat, time_APM] = APM(P, Q);
            es_match_APM(triali, 1) = match_err;                  
            
            %% Algorithm-C         
            [~, Q_hat] = S_BnB_affine_Matrices(P, Q, scale, EM_iter, tolerance, trans_type, max_iter, time_APM, verbose);
            diff = Q_hat - Q(1:k,:);
            es_match_BnB(triali, 1) = mean(sqrt(sum(diff.^2,2)));               
            
            %% CPD            
            [Transform, C] = cpd_register(Q, P, rigid_opt);
            diff = Transform.Y - Q(1:k,:);            
            es_match_CPD(triali, 1) = mean(sqrt(sum(diff.^2,2)));
            
            %% GMMREG                        
            [param, transformed_model] = gmmreg_L2(initialize_config(P, Q, 'rigid2d')); 
            diff= transformed_model- Q(1:k,:);
            es_match_GMMREG(triali, 1) = mean(sqrt(sum(diff.^2,2)));  
        end
        es_BnB_mean(ai, 1) = mean(es_match_BnB);
        es_BnB_std(ai, 1) = std(es_match_BnB);
        
        es_APM_mean(ai, 1) = mean(es_match_APM);
        es_APM_std(ai, 1) = std(es_match_APM);
        
        es_CPD_mean(ai, 1) = mean(es_match_CPD);
        es_CPD_std(ai, 1) = std(es_match_CPD);
        
        es_GMMREG_mean(ai, 1) = mean(es_match_GMMREG);
        es_GMMREG_std(ai, 1) = std(es_match_GMMREG);
        
        disp(sprintf("k=%d, %s", k, type));
        disp(sprintf("\t mean: BnB/APM/CPD/GMMREG=%.3f/%.3f/%.3f/%.3f", ...
            es_BnB_mean(ai, 1), es_APM_mean(ai,1), es_CPD_mean(ai,1), es_GMMREG_mean(ai,1)));
        
        disp(sprintf("\t std: BnB/APM/CPD/GMMREG=%.3f/%.3f/%.3f/%.3f", ...
            es_BnB_std(ai, 1), es_APM_std(ai,1), es_CPD_mean(ai,1), es_GMMREG_mean(ai,1)));
    end    
    fn = sprintf('./results/FishFu_Rotation_%s.mat', type);
    clear Ps
    clear Qs
    save(fn);
end