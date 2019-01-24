clear
close all

m = 100;

noise_ratio = 0.01; % fixed noise
missing_ratios = 0:0.05:0.5;

n = 3; num_trials = 1000;

ys = cell(length(missing_ratios), num_trials);
As = cell(length(missing_ratios), num_trials);
xs = cell(length(missing_ratios), num_trials);

for triali = 1:num_trials
    x = randn(n,1);
    A = randn(m,n);
    w = randn(m, 1);
    
    y0 = A*x;
    y0 = y0(randperm(m))+noise_ratio*w;

    for mi = 1:length(missing_ratios)
        missing_ratio = missing_ratios(mi);
        
        k = int64(m*(1-missing_ratio));

        % since y0 is already shuffled.
        y = y0(1:k);

        ys{mi, triali} = y;
        As{mi, triali} = A;
        xs{mi, triali} = x;
    end
end           
fn = sprintf('./dataset/dataset_SLR_US_MissingPoints_n=%d_#trials=%d.mat', n, num_trials);
save(fn);
