library(R.matlab);
library(ggplot2);
library(latex2exp);
library(tidyverse);
library(scales);
# setwd("/home/liangzu/Dropbox/S/");
setwd(".");


num_trials = 1000;
n = 3;

text_size = element_text(size=20);
title_text_size = element_text(size=20+10);
point_size = 6;

    titlename = sprintf("Shuffled Linear Regression");
    saving_path = sprintf("./Figure1a.eps", n);

    fn = sprintf('./results/SLR_shuffles_n=%d_#trials=%d.mat', n, num_trials);
    res = readMat(fn);
    l = length(res$shuffle.ratios);

    BnB_mean = res$es.BnB.mean[1:l, 1];
    BnB_std = res$es.BnB.std[1:l, 1];

    AIEM_mean = res$es.AIEM.mean[1:l, 1];
    AIEM_std = res$es.AIEM.std[1:l, 1];

    hardEM_mean = res$es.hardEM.mean[1:l, 1];
    hardEM_std = res$es.hardEM.std[1:l, 1];

    GR_mean = res$es.GR.mean[1:l, 1];
    GR_std = res$es.GR.std[1:l, 1];

    Slawski_mean = res$es.Slawski.mean[1:l,1];
    Slawski_std = res$es.Slawski.std[1:l,1];

    means = c(AIEM_mean, hardEM_mean, GR_mean, Slawski_mean, BnB_mean);
    stds = c(AIEM_std, hardEM_std, GR_std, Slawski_std, BnB_std);


    shuffle_ratios = res$shuffle.ratios[1,1:l];
    shuffle_ratios = rep(c(shuffle_ratios), 5);

    groups = factor(c(rep("Tsakiris18", l),
                       rep("Abid18", l),
                       rep("Algorithm-B", l),
                       rep("Slawski19", l),
                       rep("Algorithm-A", l)), levels=c("Tsakiris18","Abid18","Slawski19","Algorithm-A","Algorithm-B"));

    linewidth = c(rep(c(0.5, 0.5, 0.5, 0.5, 0.5), l)# rep(c(0.5, 2, 0.5, 0.5, 2), l)
                  );

    dat = data.frame(shuffle_ratios, means, stds, groups, linewidth);
    fill_values = c("Algorithm-A"="red", "Tsakiris18"="black",
                                  "Abid18"="black",
                                  "Algorithm-B"="red",
                                  "Slawski19"="lightblue");

    shape_values = c("Algorithm-A"=21, "Tsakiris18"=22, "Abid18"=5, "Algorithm-B"=22, "Slawski19"=25);

    p = ggplot(data=dat, mapping=aes(x=shuffle_ratios, y=means,
                         # colour=groups,
                         fill=groups,
                         shape=groups,
                         )) +
      # geom_ribbon(aes(ymin=means-stds,
      #                 ymax=means+stds),
      #             position=position_dodge(0.005),
      #             alpha=0.2) +
      geom_line(position=position_dodge(0.005), size=linewidth) +
      geom_point(position=position_dodge(0.005), size=point_size) +
      scale_shape_manual(values=shape_values)+
      scale_fill_manual(values=fill_values)+

      # scale_y_continuous(breaks=seq(0,0.4,0.1),
      #                    labels=c("0%","10%","20%","30%","40%")) +

      scale_y_log10(breaks=10^(-3:0),
                    # labels=seq(10^(-2), 10^(-1), 1)
                    labels=trans_format("log10", math_format(10^.x))) +
      scale_x_continuous(breaks=seq(0, 1, 0.2),
                         labels=c("0%","20%","40%","60%","80%","100%")) +
      expand_limits(x=1.02,y=0.001) +

      labs(x="Percentage of Shuffled Data",y="Estimation Error", title=TeX(titlename)) +

      theme(axis.text=element_text(face="plain", size=28, color='gray10'),
            legend.text=element_text(face="plain",size=30, family="mono"),
            plot.title=element_blank(),
            title=element_text(face="plain",size=30, color='gray10'),
            legend.background=element_rect(colour='gray90', fill='gray90'),
            legend.key=element_rect(size=1,color='gray90'),
            legend.title=element_blank(), legend.position=c(0.27,0.8),
            legend.spacing.x=unit(0.2,"lines"), legend.key.size = unit(2, 'lines')
            )

    ggsave(saving_path, device="pdf",
           width=8,height=7)
