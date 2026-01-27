# GRS_PSA_UKBB Scripts

## Preprint
A preprint of the manuscript is available at: [medrxiv](to update)

This repository contains R scripts used in the analysis for our manuscript submitted to British Journal of Cancer. The primary aim of this codebase is to perform PSA phenotyping and building the GRS in UK Biobank.

Getting Started
Prerequisites
R version ≥ 4.0

Required packages:
dplyr
ggplot2

You can install required packages via:
install.packages(c("dplyr", "data.table", "ggplot2"))

# Usage
1. Matched Control Selection
source("matched_controls.R")
This will generate a matched case-control dataset using nearest neighbor or propensity score matching.
2. Random Control Selection
source("random_controls.R")
This will randomly select controls from a specified eligible population.

3. Downstream GWAS
Both scripts output .csv file that can be used in downstream GWAS analysis with tools such as plink, or REGENIEE.

Output
Matched or random control dataset (data.frame)
Summary tables (case/control counts, demographics)
eQQ plots (e.g., distribution of covariates before/after matching)

📄 Citation
If you use this code, please cite our article (upon acceptance):
Lu et al. (2025). Improved prostate cancer prediction by combining Prostate-Specific Antigen (PSA) test results with Genetic Risk Scores. British Journal of Cancer, 2026.

📬 Contact
For questions or collaboration requests, please contact:
Jingzhan Lu – 106316153@gms.tcu.edu.tw
