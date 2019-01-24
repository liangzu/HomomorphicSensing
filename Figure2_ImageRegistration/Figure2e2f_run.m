close all; clear all;

% algorithm parameters 
EM_iter = 20;
scale = 6;
max_iter = inf;
time_budget = inf;
tolerance = 1e-10;
trans_type = 'affine';
verbose = false;


types = {'fish', 'fu'}; % dataset
missing_ratios = 0:0.05:0.5; % outlier to data ratio

for typei = 1
    type = types{1,typei};

    fn = sprintf('./dataset/dataset_Runningtime_WRT_MissingPoints_%s.mat', type);
    load(fn)

    rt_BnB_mean = zeros(length(missing_ratios), 1);
    rt_BnB_std = zeros(length(missing_ratios), 1);

    rt_APM_mean = zeros(length(missing_ratios), 1);
    rt_APM_std = zeros(length(missing_ratios), 1);
    
    es_BnB_mean = zeros(length(missing_ratios), 1);
    es_BnB_std = zeros(length(missing_ratios), 1);

    es_APM_mean = zeros(length(missing_ratios), 1);
    es_APM_std = zeros(length(missing_ratios), 1);

    for mi = 1:length(missing_ratios)
        missing_ratio = missing_ratios(mi);

        rt_BnB = zeros(num_trials, 1);        
        rt_APM = zeros(num_trials, 1);  
        
        es_match_BnB = zeros(num_trials, 1);        
        es_match_APM = zeros(num_trials, 1);  
        
        parfor triali=1:num_trials
            P = Ps{mi, triali};
            Q = Qs{mi, triali};
            %% BnB
            tic;
            [F_hat, Q_hat] = S_BnB_affine_Matrices(P, Q, scale, EM_iter, tolerance, trans_type, max_iter, time_budget, verbose);
            rt_BnB(triali, 1) = toc;            
            diff = Q_hat - Q(1:k,:);
            es_match_BnB(triali, 1) = mean(sqrt(sum(diff.^2,2)));   

            %% APM
            [match_err, T_hat, time_] = APM(P, Q);
            rt_APM(triali, 1) = time_;  
            es_match_APM(triali, 1) = match_err;        
            
        end
        rt_BnB_mean(mi, 1) = mean(rt_BnB);
        rt_BnB_std(mi, 1) = std(rt_BnB);

        rt_APM_mean(mi, 1) = mean(rt_APM);
        rt_APM_std(mi, 1) = std(rt_APM);
        
        es_APM_mean(mi, 1) = mean(es_match_APM);
        es_APM_std(mi, 1) = std(es_match_APM);
        
        es_BnB_mean(mi, 1) = mean(es_match_BnB);
        es_BnB_std(mi, 1) = std(es_match_BnB);

        disp(sprintf("#trials=%d, missing_ratio=%.2f, %s", num_trials, missing_ratio, type));
        disp(sprintf("\t mean: rt_BnB/rt_APM/es_BnB/es_APM=%.3f/%.3f/%.3f/%.3f", ...
            rt_BnB_mean(mi, 1), rt_APM_mean(mi,1), es_BnB_mean(mi,1), es_APM_mean(mi,1)));

        disp(sprintf("\t std: rt_BnB/rt_APM/es_BnB/es_APM=%.3f/%.3f/%.3f/%.3f", ...
            rt_BnB_std(mi, 1), rt_APM_std(mi,1), es_BnB_std(mi,1), es_APM_std(mi,1)));
    end
    clear Ps
    clear Qs
    fn = sprintf('./results/BnB_APM_runningtime_%s.mat',type);
    save(fn);
end
