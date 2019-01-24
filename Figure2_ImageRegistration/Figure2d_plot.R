library(R.matlab);
library(ggplot2);
library(latex2exp);
library(tidyverse);
library(scales);

text_size = element_text(size=20);
title_text_size = element_text(size=20+10);
point_size = 7;

    saving_path = sprintf("./Figure2d.eps");

    fn = './results/CalTechVoC.mat';
    res = readMat(fn);

    start = 1;
    end = 4;
    l = end-start+1;

    categories = c("car", "eiffel", "motobike", "revolver");

    BnB_mean = res$es.BnB.mean[start:end, 1];

    APM_mean = res$es.APM.mean[start:end, 1];
    CPD_mean = res$es.CPD.mean[start:end, 1];
    GMMREG_mean = res$es.GMMREG.mean[start:end, 1];

    means = c(BnB_mean, APM_mean, CPD_mean, GMMREG_mean);

    categories = factor(rep(c(categories), 4));
    groups = factor(c(rep("Algorithm-C", l),
                      rep("APM", l),
                      rep("CPD", l),
                      rep("GMMREG", l)), levels=c("GMMREG", "CPD", "APM", "Algorithm-C"));

    dat = data.frame(categories, means, groups);

    shape_values = c("Algorithm-C"=21, "APM"=22, "CPD"=22, "GMMREG"=22);
    fill_values = c("Algorithm-C"="red", "APM"="black", "CPD"="white", "GMMREG"="floralwhite");
    alpha_values = c("Algorithm-C"=0.2, "APM"=0.2, "CPD"=1, "GMMREG"=1);

    p = ggplot(data=dat, mapping=aes(x=categories, y=means,
                                     #colour=groups,
                                     fill=groups,
                                     shape=groups
                                     )) +
      geom_col(position="dodge", colour="black")+
      #geom_text(aes(label=format(means, digits=3)), angle=90, position = position_dodge(.9), size=10) +
      scale_shape_manual(values=shape_values)+
      scale_fill_manual(values=fill_values)+

      labs(x="Category", y="Registration Error"#, title=TeX(titlename)
      ) +
      ylim(0,75) +

      theme(axis.text=element_text(face="plain", size=30, color='gray10'),
            legend.text=element_text(face="plain",size=26, family="mono"),
            title=element_text(face="plain",size=32, color='gray10'),

            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),

            legend.background=element_rect(colour='gray90', fill='gray90'),
            legend.key=element_rect(color='gray90'), # legend.direction="horizontal",

            legend.title=element_blank(), legend.position=c(0.7,0.85),
            legend.spacing.x=unit(0.2,"lines"), legend.key.size = unit(2, 'lines')
            )



       ggsave(saving_path, device="pdf",
           width=8,height=7)
