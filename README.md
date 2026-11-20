
# LBP Opioid Dispensing Prediction

**Explainable Machine Learning and Clinical Phenotype Sensitivity Using MIMIC-IV-ED**

## Project Overview

This is an individual AI in Healthcare research project investigating whether emergency department triage information can predict documented opioid dispensing among patients with an ICD-defined low back pain (LBP) phenotype. The project also examines how the choice of ICD-based clinical phenotype definition may influence cohort composition and downstream machine learning findings.

## Research Question

Can routinely available ED triage information reliably predict documented opioid dispensing among patients with an ICD-defined low back pain phenotype, and how sensitive are the findings to the choice of phenotype definition?

## Dataset

- MIMIC-IV-ED v2.2
- Unit of analysis: ED encounter (`stay_id`)
- Primary cohort: C1 — Strict LBP
- Sensitivity cohort: C2 — Expanded LBP

## Planned Methods

- ICD-based clinical phenotyping
- Encounter-level cohort construction
- Structured ED triage feature engineering
- Chief complaint text feature extraction
- Logistic Regression and LightGBM
- SHAP explainability
- Cohort sensitivity analysis


## Data Availability

This repository contains research code and documentation only.

MIMIC-IV-ED data are subject to PhysioNet access requirements and are not redistributed through this repository.

Dataset: https://physionet.org/content/mimic-iv-ed/2.2/
