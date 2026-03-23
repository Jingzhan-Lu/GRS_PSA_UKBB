##############################################
# Title: PSA, GRS Analysis Pipeline
# Description: Cleaned workflow for PSA processing,
#              GRS calculation, and modelling
# Author: [Your Name]
##############################################

# Load required libraries
library(dplyr)
library(ggplot2)
library(pROC)
library(purrr)
library(tidyverse)
library(devtools)
source_url("https://raw.githubusercontent.com/hdg204/UKBB/main/UKBB_Health_Records_New_Project.R") 


##############################################
# 1. Load Data
##############################################
grs_data <- read.csv("all_male_grs.csv")
baseline_data <- read.csv("Baseline.csv")

##############################################
# 2. Clean PSA Data
##############################################
psa_data_raw <- read_GP('43Z2.') #read PSA from GP records
# Function to extract numeric PSA values
extract_numeric <- function(x) {
  as.numeric(gsub("[^0-9.]", "", x))
}

psa_data <- psa_data_raw %>%
  mutate(
    value1 = extract_numeric(value1),
    value2 = extract_numeric(value2),
    value3 = extract_numeric(value3)
  ) %>%
  mutate(
    psa_mean = rowMeans(select(., value1, value2, value3), na.rm = TRUE)
  ) %>%
  filter(!is.na(psa_mean))

#####drop any post-sugery PSA data, sugery definition by OPCS4_code
Cystoprostatectomy <- read_OPCS('M34.1')
prostate <- read_OPCS('M65.')
prostate_only <- prostate %>%
  filter(!grepl("M65.8|M65.9", oper4))
merged_surgery <- bind_rows(prostate_only, Cystoprostatectomy) #all surgery records related with prostate

surgery_min_age <- merged_surgery %>%
  group_by(eid) %>%
  summarise(op_age = min(op_age, na.rm = TRUE)) %>%
  ungroup()
write.csv(surgery_min_age, "op_min_age.csv", row.names = FALSE)

# 3. Select PSA Before Operation Age
##############################################
op_age <-read.csv('op_min_age.csv')
cancer <- read_cancer('C61') #extract the prostate cancer cases from cancer registration data
cancer_age <- data.frame(eid = cancer$eid, diag_age = cancer$diag_age) 

merged_data <- psa_data %>%
  inner_join(op_age, by = "eid")

psa_filtered <- merged_data %>%
  inner_join(op_age, by = "eid") %>%
  filter(event_age < op_age)

# 4. Calculate Median/First/Last/Random PSA per Individual
##############################################
psa_median <- psa_filtered %>%
  group_by(eid) %>%
  summarise(
    median_psa = median(value, na.rm = TRUE),
    median_age = median(event_age, na.rm = TRUE),
    n_measurements = n()
  ) %>%
  ungroup()
write.csv(psa_median, "PSA_data", row.names = FALSE)

# First PSA
PSA_first <- psa_filtered %>%
  group_by(eid) %>%
  slice_min(event_age, n = 1) %>%
  ungroup()

# Last PSA (the most recent PSA)
PSA_last <- psa_filtered %>%
  group_by(eid) %>%
  slice_max(event_age, n = 1) %>%
  ungroup()

set.seed(42) #ensure the random can be reproducible
Random PSA
PSA_random <- psa_filtered %>%
  group_by(eid) %>%
  slice_sample(n = 1) %>%
  ungroup()


# 5. Calculate the GRS269 for prostate cancer
##############################################
system('curl https://raw.githubusercontent.com/hdg204/UKBB/main/Generate_GRS.sh > Generate_GRS.sh')
system('chmod +777 Generate_GRS.sh')
system('curl https://raw.githubusercontent.com/hdg204/Rdna-nexus/main/Example_GRS > Example_GRS')
prostate_cancer_GRS <- system('./Generate_GRS.sh Example_GRS')
prostate_cancer_GRS

##############################################
# 6. Final Dataset for Downstream Analysis
merged_data <- merge(prostate_cancer_GRS, PSA_data, by = "eid", all.x = TRUE) #Merge GRS data with PSA
all_data_grs <- merged_data %>%    #Filter valid PSA values
  filter(!is.na(value1)) %>%
  filter(value1 > 0.2 & value1 < 500)

#Logistic regression: pheno ~ GRS + PSA
logit <- glm(pheno ~ grs + value1, data = all_data_grs, family = "binomial")
all_data_grs$prob <- predict(logit, newdata = all_data_grs, type = "response")# Predicted probability
roc_obj <- roc(all_data_grs$pheno ~ all_data_grs$prob, plot = TRUE, print.auc = TRUE, ci = TRUE)# ROC curve

#Heatmap visualization
pred_grid <- all_data_grs %>%
  mutate(GRS_quantile = ntile(grs, 10))  # 分为10个分位
pred_grid$prob <- predict(logit, newdata = pred_grid, type = "response")
pred_grid$GRS_quantile <- factor(pred_grid$GRS_quantile, 
                                 levels = 1:10,
                                 labels = c("10%", "20%", "30%", "40%", "50%", "60%", "70%", "80%", "90%", "100%"))
p <- pred_grid |>
  tidyplot(x = GRS_quantile, y = value1, color = prob) |>
  add_heatmap()+
  labs(
    x = "GRS Category",
    y = "Median PSA value (ng/ML)", 
    color = "Predicted\nProbability"
  )