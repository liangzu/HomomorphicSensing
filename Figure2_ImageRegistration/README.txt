                  ___________________________________

                   EXPERIMENTS ON IMAGE REGISTRATION

                       M. C. Tsakiris and L. Peng
                  ___________________________________


Table of Contents
_________________

1 Directory Structure
2 Usage
.. 2.1 Basics
.. 2.2 Reproducing Figure 2
3 Acknowledgements





1 Directory Structure
=====================

  algorithms/
        contains the branch-and-bound algorithm
        (*S_BnB_affine_Matrices.m*) for image registration.
  dataset/
        includes data used in Figure 2 as well as MATLAB (R2018a+)
        scripts to generate data.
  libs/
        3rd-party libraries.
  results/
        stores the experimental results.


2 Usage
=======

  Other algorithms, i.e., CPD, GMMREG, and APM, are supposed to be
  directly runnable on Linux machine (e.g., Ubuntu 18.04) since
  pre-compiled MEX binaries for Linux are provided. However, in order to
  make them runnable on Windows or Mac OS, one needs to compile c++
  source files using the MEX compiler. Please consult the instructions
  provided by CPD, GMMREG, APM (see "Acknowledgements") for a successful
  compilation.


2.1 Basics
~~~~~~~~~~

  setup.m
        adds neccesary paths into MATLAB environment. needs to be run
        after launching MATLAB and before running other scripts.

  ImageRegistration_example.m
        demostrates how to run our algorithm. It is recommended to
        (modify some parameters and) run this script to get familiar
        with the interface of the algorithm.


2.2 Reproducing Figure 2
~~~~~~~~~~~~~~~~~~~~~~~~

  There are two steps to reproduce Figure 2 reported in the paper:
  1) Run the experiments
        given the dataset (in the folder dataset/), run the algorithms
        and compute the errors based on the output of the algorithms,
        and save the resulting errors into a .mat file (in the folder
        results/). This step is implemented by *Figure2a_run.m*,
        *Figure2b_run.m*, *Figure2c_rum.m*, *Figure2d_run.m*, and
        *Figure2e2f_run.m*. Since running the experiments may take a
        long time, we provide the numeric results reported in the paper
        as .mat files in the folder results/.
  2) Plot the figures
        after the resulting errors are computed and saved in results/,
        figures can be plotted through the provided R scripts
        *Figure2a_plot.R*, *Figure2b_plot.R*, *Figure2c_plot.R*,
        *Figure2d_plot.R*, *Figure2e_plot.R*, and *Figure2f_plot.R*. In
        order to run these R scripts, some R packages need to be
        installed: *R.matlab*, *tidyverse/ggplot2*, *latex2exp*.


3 Acknowledgements
==================

  We thank the following authors for their publically available
  code/software.
  Myronenko10 (CPD)
             [https://sites.google.com/site/myronenko/research/cpd]
  Jian11 (GMMREG)
        [https://github.com/bing-jian/gmmreg]
  Lian17 (APM)
        [https://www4.comp.polyu.edu.hk/~cslzhang/APM.htm]
