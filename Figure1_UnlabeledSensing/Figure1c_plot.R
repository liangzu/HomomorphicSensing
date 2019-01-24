library(R.matlab);
library(ggplot2);
library(latex2exp);
library(tidyverse);
library(scales);

num_trials = 1000;
n = 3;

text_size = element_text(size=20);
title_text_size = element_text(size=20+10);
point_size = 7;
    titlename = sprintf("Unlabeled Sensing");
    saving_path = sprintf("./Figure1c.eps", n);

    fn = sprintf('./results/SLR_US_MissingPoints_n=%d_#trials=%d.mat', n, num_trials);
    res = readMat(fn);
    l = length(res$missing.ratios);

    BnB_mean = res$es.BnB.mean[1:l, 1];
    BnB_std = res$es.BnB.std[1:l, 1];

    AltMin_mean = res$es.AltMin.mean[1:l, 1];
    AltMin_std = res$es.AltMin.std[1:l, 1];

    GRplus_mean = res$es.GR.mean[1:l,1];
    GRplus_std = res$es.GR.std[1:l,1];

    means = c(BnB_mean, AltMin_mean, GRplus_mean);
    stds = c(BnB_std, AltMin_std, GRplus_std);

    missing_ratios = res$missing.ratios[1,1:l];
    missing_ratios = rep(c(missing_ratios), 3);

    groups = factor(c(rep("Algorithm-A", l),
                      rep("Haghighatshoar18", l),
                      rep("Algorithm-B", l)),
                      levels=c("Haghighatshoar18", "Algorithm-A", "Algorithm-B"));

    dat = data.frame(missing_ratios, means, stds, groups);
    fill_values = c("Algorithm-A"="red", "Haghighatshoar18"="black", "Algorithm-B"="red");
    shape_values = c("Algorithm-A"=21, "Haghighatshoar18"=5, "Algorithm-B"=22);

    p = ggplot(data=dat, mapping=aes(x=missing_ratios, y=means,
                         # colour=groups,
                         fill=groups,
                         shape=groups
                         )) +
      # geom_ribbon(aes(ymin=max(means-stds,0),
      #                 ymax=means+stds),
      #             position=position_dodge(0.005),
      #             alpha=0.2) +
      geom_line(position=position_dodge(0.005)) +
      geom_point(position=position_dodge(0.005), size=point_size) +

      scale_shape_manual(values=shape_values)+
      scale_fill_manual(values=fill_values)+

      # scale_y_continuous(breaks=seq(0,1.2,0.4),
      #                    labels=c("0", "0.4",  "0.8", "1.2")) +
      scale_y_log10(breaks=10^(-3:0),
                    # labels=seq(10^(-2), 10^(-1), 1)
                    labels=trans_format("log10", math_format(10^.x))) +
      scale_x_continuous(breaks=seq(0, 0.5, 0.1),
                         labels=c("0%","10%","20%","30%","40%","50%")) +
      expand_limits(y=0.001) +

      labs(x="Outlier Ratio",y="Estimation Error", title=TeX(titlename)) +

      theme(axis.text=element_text(face="plain", size=28, color='gray10'),
            legend.text=element_text(face="plain",size=30, family="mono"),
            # title=element_blank(),
            title=element_text(face="plain",size=30, color='gray10'),
            plot.title=element_blank(),
            legend.background=element_rect(colour='gray90', fill='gray90'),
            legend.key=element_rect(color='gray90'),
            legend.title=element_blank(), legend.position=c(0.6,0.75),
            legend.spacing.x=unit(0.2,"lines"), legend.key.size = unit(2, 'lines')
            )

    ggsave(saving_path, device="pdf",
           width=8,height=7)
