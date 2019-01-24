clear
close all

noise_ratios = 0:0.01:0.1;

m = 100;
k = 80; % fixed number of observations.

n = 3; num_trials = 1000;

ys = cell(length(noise_ratios), num_trials);
As = cell(length(noise_ratios), num_trials);
xs = cell(length(noise_ratios), num_trials);

for triali = 1:num_trials
    x = randn(n,1);
    A = randn(m,n);
    w = randn(k, 1);

    y0 = A*x;
    y0 = y0(randperm(m));
    
    projection_idx = sort(datasample(1:m, k, 'Replace', false));
    y0 = y0(projection_idx);
    
    for ni = 1:length(noise_ratios)
        noise_ratio = noise_ratios(ni);
        y = y0 + noise_ratio*w;

        ys{ni, triali} = y;
        As{ni, triali} = A;
        xs{ni, triali} = x;
    end
end           
fn = sprintf('./dataset/dataset_SLR_US_Noise_n=%d_#trials=%d.mat',n,num_trials);
save(fn);