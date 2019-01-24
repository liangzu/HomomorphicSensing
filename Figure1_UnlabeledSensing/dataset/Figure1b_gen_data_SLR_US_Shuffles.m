clear
close all

m = 100;
k = 80;
noise_ratio = 0.01; % fixed noise


shuffle_ratios = 0:0.1:1;
n = 3; num_trials = 1000;

ys = cell(length(shuffle_ratios), num_trials);
As = cell(length(shuffle_ratios), num_trials);
xs = cell(length(shuffle_ratios), num_trials);

for triali = 1:num_trials
    x = randn(n,1);
    A = randn(m,n);
    w = randn(k, 1);
    
    projection_idx = sort(datasample(1:m, k, 'Replace', false));
    for si = 1:length(shuffle_ratios)
        % shuffle
        shuffle_ratio = shuffle_ratios(si);
        num_shuffled = int64(shuffle_ratio * m);
        shuffle_idx = datasample(1:m, num_shuffled, 'Replace', false);

        y0 = A*x;
        y1 = y0(shuffle_idx, 1);
        y0(shuffle_idx, 1) = y1(randperm(num_shuffled));

        % remove m-k entries (projection).
        y0 = y0(projection_idx, 1);        
        y = y0 + noise_ratio*w;        
        
        ys{si, triali} = y;
        As{si, triali} = A;
        xs{si, triali} = x;
    end
end           
fn = sprintf('./dataset/dataset_SLR_US_shuffles_n=%d_#trials=%d.mat', n, num_trials);
save(fn);
