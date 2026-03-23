# 📊 PSA & GRS Analysis Pipeline

A preprint of the manuscript is available at: [medrxiv](to update)

This repository contains R scripts used for the analysis in our manuscript submitted to the British Journal of Cancer. The primary aim of this codebase is to perform PSA phenotyping, building Genetic Risk Scores (GRS), and integrating PSA and GRS for prostate cancer risk prediction in UK Biobank.

# 🔹 Getting Started
Prerequisites
R version ≥ 4.0

Required R packages: dplyr, ggplot2, pROC, purrr, tidyverse, devtools

You can install all required packages using:
install.packages(c("dplyr", "ggplot2", "pROC", "purrr", "tidyverse", "devtools"))

# 🔹 Required Pipelines

Before running the analysis, we recommend installing the following two essential pipelines:

1. ukbextractR — Reproducible Extraction of Linked Healthcare Records from UK Biobank
GitHub: https://github.com/ExeterGenetics/ukbextractR

2. GRS-Nexus — Genetic Risk Score calculation pipeline
GitHub: https://github.com/hdg204/GRS-Nexus

These pipelines are required for extracting and harmonizing healthcare records from UK Biobank and calculating GRS scores.

# 🔹 Usage
1. Load and Clean PSA Data
2. Filter Post-Surgery PSA
3. Compute Median / First / Last / Random PSA per Individual
4. Calculate GRS for Prostate Cancer
5. Final Dataset & Logistic Regression
6. Additional Data Visualization (Heatmap)
7. Forest Plot of Model Combinations

📄 Citation
If you use this code, please cite our article (upon acceptance):
Lu et al. (2026). Improved prostate cancer prediction by combining Prostate-Specific Antigen (PSA) test results with Genetic Risk Scores. British Journal of Cancer, 2026.

📬 Contact
For questions or collaboration requests, please contact:
Jingzhan Lu – 106316153@gms.tcu.edu.tw
