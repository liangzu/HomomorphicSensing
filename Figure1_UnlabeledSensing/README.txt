                   __________________________________

                    EXPERIMENTS ON UNLABELED SENSING

                       M. C. Tsakiris and L. Peng
                   __________________________________


Table of Contents
_________________

1 Directory Structure
2 Usage
.. 2.1 Basics
.. 2.2 Reproducing Figure 1
3 Acknowledgements





1 Directory Structure
=====================

  algorithms/
        contains the branch-and-bound algorithm (*S_BnB_v2.m*) for
        unlabeled sensing as well as Algorithm-B
        (*GeometricReconstruction.m*).
  dataset/
        includes synthetic data used in Figure 1 as well as MATLAB
        (R2018a+) scripts to generate data.
  libs/
        3rd-party libraries.
  results/
        stores numeric results for the figures.


2 Usage
=======

2.1 Basics
~~~~~~~~~~

  setup.m
        adds neccesary paths into the MATLAB environment. needs to be
        run after launching MATLAB and before running other scripts.

  UnlabeledSensing_example.m
        demostrates how to run our algorithms. It is recommended to
        (modify some parameters and) run this script to get familiar
        with the interface of the algorithm.


2.2 Reproducing Figure 1
~~~~~~~~~~~~~~~~~~~~~~~~

  There are three steps to reproduce Figure 1 reported in the paper:
  1) Download the dataset
        The synthetic dataset for unlabeled sensing is shared
        anonymously through Gofile: [https://gofile.io/?c=QG89eX].
        Please download it and place all .mat files in the folder
        dataset/, where MATLAB scripts are provided to (randomly)
        generate synthetic data.
  2) Run the experiments
        given the dataset (in the folder dataset/), run the algorithms
        and compute the errors based on the output of the algorithms,
        and save the resulting errors into a .mat file (in the folder
        results/). This step is implemented by *Figure1a_run.m*,
        *Figure1b_run.m*, *Figure1c_rum.m*, and *Figure1d_run.m*. Since
        running the experiments may take a long time, we provide the
        numeric results reported in the paper as .mat files in the
        folder results/.
  3) Plot the figures
        after the resulting errors are computed and saved in results/,
        figures can be plotted through the provided R scripts
        *Figure1a_plot.R*, *Figure1b_plot.R*, *Figure1c_plot.R*, and
        *Figure1d_plot.R*. In order to run these R scripts, some R
        packages need to be installed: *R.matlab*, *tidyverse/ggplot2*,
        *latex2exp*.


3 Acknowledgements
==================

  We thank the following authors for their providing the code/software.
  Tsakiris18

  Abid18
        [https://github.com/abidlabs/stochastic-em-shuffled-regression]
  CVX
        [http://cvxr.com/cvx/]
  Rene Vidal
        for his scripts *libs/veronese.m* and *libs/exponent.m*.
