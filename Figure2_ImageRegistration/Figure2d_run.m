close all; clear all;

% algorithm parameters 
EM_iter = 20;
scales = [4;4;400];
max_iter = inf;
tolerance = 0.001;
trans_type = 'affine';
verbose = false;


%% load the data
% P: Mx2
% Q: Lx2
% P = S*[Q, 1]*F
categories = {'car', 'eiffel', 'motobike', 'revolver'};

num_category = length(categories);

es_BnB_mean = zeros(length(categories), 1);
es_APM_mean = zeros(length(categories), 1);
es_CPD_mean = zeros(length(categories), 1);
es_GMMREG_mean = zeros(length(categories), 1);

% CPD setting
affine_opt.method='affine';
affine_opt.viz = 0;
affine_opt.corresp = 1;

rigid_opt.method='rigid';
rigid_opt.viz = 0;
rigid_opt.corresp = 1;

tic;
for catei = 1:4 
    %% Loading the data
    cate = categories{1,catei};    
    data_path = sprintf('./libs/APM/image_marked_match_dataset/%s/data_%s_match.mat', cate, cate);
    Xs = load(data_path);
    if strcmp(cate, 'car')
        P = Xs.X2; Q1 = Xs.X9; Q2=Xs.X11; Q3=Xs.X5; Q4=Xs.X7;Q5=Xs.X19;
    elseif strcmp(cate, 'eiffel')
        P = Xs.X0; Q1 = Xs.X3; Q2=Xs.X7; Q3=Xs.X1; Q4=Xs.X4;Q5=Xs.X20;
    elseif strcmp(cate, 'motobike')
        P = Xs.X3; Q1 = Xs.X15; Q2=Xs.X14; Q3=Xs.X13; Q4=Xs.X6;Q5=Xs.X8;
    elseif strcmp(cate, 'revolver')
        P = Xs.X0; Q1 = Xs.X6; Q2=Xs.X7; Q3=Xs.X4; Q4=Xs.X21;Q5=Xs.X9;
    end
    
    C = {P, Q1, Q2, Q3, Q4, Q5};
    err_BnB = 0; 
    err_APM = 0;    
    err_CPD = 0;    
    err_GMMREG = 0;    
    
    %% the same experimental setup as in Lian, PAMI 17.
    for i=1
        for j = i+1:6            
            P = C{1,i}; Q = C{1,j}; m = length(P);    
           
            %% APM
            [e, T_hat, APM_time] = APM(P,Q);
            err_APM = err_APM + e;      
            
            %% Algorithm-C
            [F_hat, Q_hat, BnB_time] = S_BnB_affine_Matrices(P, Q, scales, EM_iter, tolerance, trans_type, max_iter, APM_time, verbose);
            diff = Q_hat - Q(1:m,:);
            e = mean(sqrt(sum(diff.^2,2)));
            err_BnB = err_BnB + e;
              
            %% CPD            
            [Transform, Corr] = cpd_register(Q, P, rigid_opt);
            diff = Transform.Y - Q(1:m,:);            
            err_CPD = err_CPD + mean(sqrt(sum(diff.^2,2)));
            
            %% GMMREG                        
            [param, transformed_model] = gmmreg_L2(initialize_config(P, Q, 'affine2d'));  % affine2d or rigid2d
            diff= transformed_model- Q(1:m,:);
            err_GMMREG = err_GMMREG + mean(sqrt(sum(diff.^2,2)));
        end
    end

    es_BnB_mean(catei, 1)= err_BnB / 5;
    es_APM_mean(catei, 1)= err_APM / 5;
    es_CPD_mean(catei, 1)= err_CPD/ 5;
    es_GMMREG_mean(catei, 1)= err_GMMREG/ 5;
            
    disp(sprintf("error (%s):", cate));
    disp(sprintf("\t Ours/APM/CPD/GMMREG=%.3f/%.3f/%.3f/%.3f", ...
        es_BnB_mean(catei,1),es_APM_mean(catei,1),es_CPD_mean(catei,1),es_GMMREG_mean(catei,1)));

end
toc;
fn = './results/CalTechVoC.mat';
save(fn);

%% Averaged registration error on each category
%                     car         eiffel       motibike    revolver
% Ours:              15.418       4.1856        7.297       11.348
% APM:               15.361       4.1856        7.297       11.348
% CPD (affine):      82.506      42.776        64.731       63.995
% CPD (rigid):       67.4586     30.5718       45.3670      53.2754
% GMMREG (affine):   53.5456     47.5301       53.2377      48.2794
% GMMREG (rigid):    60.679      43.355        55.983       98.541


