# Predicting Opioid Dispensing in Low Back Pain Emergency Visits: Explainable Machine Learning and Clinical Phenotype Sensitivity

**Project Type:** Individual Graduate Course Project — AI in Healthcare  
**Study Design:** Retrospective observational study with predictive machine learning  
**Dataset:** MIMIC-IV-ED v2.2, with linked MIMIC-IV data if required for age estimation  
**Unit of Analysis:** Emergency department encounter (`stay_id`)  
**Status:** Research design finalized in principle; cohort eligibility and opioid outcome require final validation

---

## 1. Project Overview

This project investigates whether structured emergency department (ED) triage information and short chief complaint text can predict documented opioid dispensing among patients with an ICD-defined low back pain (LBP) phenotype.

A central challenge is that LBP is a clinical symptom rather than a single disease with a universally reliable diagnostic code. Different ICD codes may represent overlapping presentations, including lumbago, sciatica, and broader back pain symptoms. Consequently, decisions about which codes to include can influence the composition of the study population and potentially affect downstream machine learning findings.

The project addresses this uncertainty using two prespecified ICD-based phenotype definitions:

- **C1 — Strict LBP:** The primary study cohort, defined by explicit low back pain codes, including LBP with sciatica.
- **C2 — Expanded LBP:** A broader cohort that additionally includes sciatica-only and other back pain symptom codes.

An explainable machine learning framework will be developed primarily using C1. A limited sensitivity experiment will examine how results change when the same modeling approach is applied to C2.

The project emphasizes reproducibility, methodological transparency, and thoughtful interpretation rather than developing a clinically deployable prediction system.

## 2. Background and Clinical Motivation

Low back pain is a common and clinically important condition associated with substantial individual and healthcare burden. Most LBP presentations cannot be attributed to a single identifiable underlying cause, making clinical assessment and classification challenging (Hartvigsen et al., 2018).

Opioid treatment is an important topic in LBP management. Clinical guidelines emphasize careful consideration of opioid-related risks and the availability of nonopioid treatment options for many common pain conditions, including low back pain (Dowell et al., 2022).

Emergency department data provide an opportunity to study documented treatment patterns using routinely collected information. However, retrospective EHR research introduces two related challenges: identifying an appropriate patient population and accurately defining the treatment outcome.

This project builds on earlier coursework involving LBP cohort identification and predictive modeling. Rather than relying on a small set of ICD codes without further examination, the present study develops a more systematic and transparent clinical phenotype definition and evaluates its implications for machine learning.

## 3. Problem Definition

### 3.1 Clinical Phenotyping Problem

There is no single ICD code that identifies all clinically relevant LBP presentations with perfect accuracy.

A narrow ICD-based definition may exclude relevant encounters, while a broad definition may include patients with less specific or clinically heterogeneous back pain presentations.

The study therefore treats ICD codes as operational indicators of LBP-related presentations rather than definitive evidence of clinically confirmed nonspecific LBP.

### 3.2 Prediction Problem

Given an ED encounter retrospectively identified as belonging to an ICD-defined LBP cohort, predict whether at least one qualifying opioid dispensing event was documented during that encounter.

**Input:** Information recorded at or before the selected ED triage prediction point.

**Target:** Binary documented opioid dispensing outcome derived from ED Pyxis records.

**Output:** An estimated probability of documented opioid dispensing.

This is a retrospective conditional prediction task. Final ICD codes are used to identify the study population but are not included as triage-time predictive features.

### 3.3 Cohort Sensitivity Problem

Determine whether expanding the ICD-based LBP phenotype changes:

- Cohort size and patient characteristics.
- Observed opioid dispensing prevalence.
- Predictive discrimination and calibration.

Differences between C1 and C2 will be interpreted as sensitivity to operational cohort definitions, not as direct evidence of differences in underlying clinical diagnoses.

## 4. Research Question and Hypotheses

### 4.1 Primary Research Question

**Can routinely available ED triage information reliably predict documented opioid dispensing among patients with an ICD-defined low back pain phenotype, and how sensitive are the findings to the choice of phenotype definition?**

The question has two connected analytical components:

**Primary Prediction Analysis**

Develop and evaluate predictive models in the strict ICD-defined LBP cohort (C1).

**Supporting Sensitivity Analysis**

Examine whether broader LBP case identification (C2) changes cohort characteristics, dispensing prevalence, and predictive performance.

### 4.2 Working Hypotheses

**H1 — Predictive Feasibility**

Structured triage information will contain predictive signal for documented opioid dispensing beyond a prevalence-based baseline, although performance may be limited by incomplete clinical context.

**H2 — Incremental Value of Text**

Short chief complaint text may provide additional predictive information beyond structured triage features. The magnitude of any improvement is uncertain.

**H3 — Phenotype Sensitivity**

Expanding the ICD phenotype from C1 to C2 may change cohort composition, opioid dispensing prevalence, and model performance.

No directional improvement or deterioration is assumed in advance.

These are exploratory working hypotheses rather than claims that statistically significant effects must be demonstrated.

## 5. Literature Review

The literature review will remain focused on four areas.

### 5.1 Low Back Pain as a Clinical and Classification Challenge

**Purpose:** Establish why LBP is difficult to define consistently in clinical research.

Key concepts include nonspecific LBP, overlapping clinical presentations, and limitations of symptom-based diagnostic coding.

**Core reference:** Hartvigsen et al. (2018), *What low back pain is and why we need to pay attention.*

### 5.2 ICD-Based Phenotyping and Cohort Identification

**Purpose:** Explain how differences in ICD code selection may affect patient identification and research validity.

Relevant literature includes studies comparing case-identification algorithms and examining the sensitivity and specificity of administrative definitions for nonspecific LBP.

**Core references:**

- *Identifying neck and back pain in administrative data: defining the right cohort* (2012).
- *Sensitivity and specificity of algorithms for the identification of nonspecific low back pain in medico-administrative databases* (2023).

The project will use these studies to motivate phenotype uncertainty, not to claim that the present ICD codebook has been clinically validated.

### 5.3 Opioid Treatment in Emergency Care

**Purpose:** Explain the clinical importance of opioid use in ED back pain encounters.

The review will distinguish ED dispensing, medication administration, discharge prescribing, and longer-term opioid use.

**Core references:**

- Dowell et al. (2022), CDC opioid prescribing guideline.
- *The Association of Emergency Department Opioid Administration and Prescribing with Ongoing Opioid Use* (2020).
- *Usual Care for Low Back Pain at U.S. Emergency Departments, 2016–2022* (2025).

These sources provide clinical context, but their outcome definitions are not necessarily interchangeable with MIMIC-IV-ED Pyxis dispensing.

### 5.4 Machine Learning and Clinical Prediction

**Purpose:** Establish appropriate methodological practices for retrospective healthcare prediction.

The discussion will cover model evaluation, clinical interpretability, data leakage, calibration, and transparent reporting.

**Core methodological reference:** TRIPOD+AI (Collins et al., 2024).

A brief discussion of PROBAST+AI may be used to identify common concerns about bias and applicability, without conducting a full formal risk-of-bias assessment.

**Literature review boundary:** Approximately 6–10 well-selected sources are sufficient for this course project. A systematic review or meta-analysis is outside scope.

## 6. Data and Study Population

### 6.1 Data Source

MIMIC-IV-ED v2.2 provides deidentified ED encounter information, including diagnosis codes, triage observations, vital signs, medication-related records, and patient identifiers.

The study will use the ED encounter as its analytical unit.

Relevant data sources include:

- `edstays`: Encounter identifiers and ED visit information.
- `diagnosis`: ICD-based phenotype identification.
- `triage`: Clinical presentation and structured triage observations.
- `pyxis`: Documented medication dispensing.
- MIMIC-IV patient information, if needed for adult eligibility.

### 6.2 Primary Cohort — C1 Strict LBP

The primary study cohort (C1) will be identified using a literature-informed, rule-based ICD phenotyping approach.

The phenotype will focus on diagnosis codes explicitly representing low back pain or lumbago, including low back pain with sciatica. Candidate codes will be identified from the MIMIC-IV-ED diagnosis inventory and reviewed against ICD terminology, prespecified clinical inclusion rules, and relevant literature.

The proposed C1 definition contains five ICD-9/10 codes, subject to final verification during phenotype codebook construction.

Code inclusion decisions will be documented with clinical rationale and supporting references. The resulting versioned codebook will provide the operational definition used for encounter-level cohort identification.

C1 represents a relatively narrow, ICD-defined LBP population. It does not establish clinically confirmed nonspecific low back pain, and the absence of additional underlying conditions cannot be assumed from symptom codes alone.

Final adult eligibility, unique encounter counts, and patient counts will be confirmed during encounter-level cohort integration.

### 6.3 Sensitivity Cohort — C2 Expanded LBP

The sensitivity cohort (C2) will use a broader ICD-based phenotype to evaluate how operational case definitions influence study population characteristics, documented opioid dispensing prevalence, and predictive model performance.

C2 will include all C1 codes, together with additional symptom codes representing sciatica without explicit low back pain and broader or anatomically less specific back pain presentations.

The proposed C2 definition contains twelve ICD-9/10 codes, including the five C1 codes, subject to final code-level review.

The same literature-informed, rule-based selection process will be applied to both cohorts. Inclusion and exclusion decisions will be documented in a versioned phenotype codebook, with explicit verification that C1 is nested within C2.

Encounters identified exclusively through the expanded definition (`C2-only`) will be distinguished from C1 encounters to characterize the additional population captured by the broader phenotype.

C2 is intended as a sensitivity analysis of cohort definition, not as a more clinically accurate or independently validated LBP phenotype. Differences between C1 and C2 will be interpreted in the context of cohort composition and operational coding definitions rather than as evidence of causal effects.

### 6.4 Eligibility and Exclusions

Proposed eligibility:

- Adult patients aged 18 years or older.
- ED encounters matching the corresponding ICD phenotype definition.
- Valid unique ED encounter identifier.

All ED dispositions will initially be retained.

Exclusions will be limited to prespecified eligibility or data-integrity requirements. Encounters will not be excluded solely because no Pyxis record exists.

Age eligibility, codebook version, and handling of encounters with additional diagnoses must be finalized before the cohort is frozen.

### 6.5 Encounter-Level Integration

The analytical dataset will contain exactly one record per `stay_id`.

Multiple diagnosis records will be aggregated into encounter-level phenotype flags before joining to triage features and chief complaint information.

The dataset will retain C1, C2, and relevant subtype indicators for cohort construction and descriptive analysis.

ICD-derived variables will not enter the triage-time predictive feature matrix.

## 7. Outcome Definition

### 7.1 Primary Outcome

**Documented opioid dispensing during the ED encounter.**

A binary label will indicate whether at least one qualifying opioid medication dispensing event is present within the prespecified ED time window.

### 7.2 Outcome Construction

The outcome pipeline will:

1. Identify candidate opioid medication names in Pyxis.
2. Create and review a reproducible opioid medication mapping.
3. Apply the ED encounter time-window definition.
4. Aggregate qualifying events to `stay_id`.
5. Generate one binary outcome per encounter.
6. Validate outcome prevalence and selected medication records.

### 7.3 Outcome Interpretation

The outcome measures documented dispensing rather than verified medication administration, discharge prescriptions, patient consumption, or treatment appropriateness.

The absence of a qualifying record will be interpreted as no *observed* opioid dispensing event in the available source, not definitive evidence that no opioid treatment occurred.

## 8. Predictive Modeling Methodology

### 8.1 Prediction Time and Candidate Features

The prediction point will be set at completion of ED triage, subject to the availability of actual recorded timestamps.

Candidate structured variables include:

- Age and recorded sex/gender.
- Arrival transport.
- Triage acuity.
- Pain score.
- Heart rate, blood pressure, respiratory rate, temperature, and oxygen saturation.

Chief complaint information will be incorporated using previously developed P3 features.

Post-triage information such as final ICD diagnosis, ED disposition, encounter duration, and medication dispensing events will not be used as predictors.

### 8.2 Clinical Text Feature Engineering

P3 has already generated a normalized chief complaint field and rule-based phenotype indicators.

The project will investigate the added value of short clinical text through:

- Existing P3 rule-based phenotype features.
- TF-IDF with TruncatedSVD for a compact text representation, if feasible.

Text representation will be fit exclusively on training data.

No new clinical text annotation or transformer fine-tuning is planned.

### 8.3 Models

**Baseline:** L2-regularized Logistic Regression.

**Main model:** LightGBM gradient-boosted decision trees.

**Reference:** Prevalence-based dummy prediction.

Regularized Logistic Regression will provide an interpretable linear predictive benchmark. LightGBM will examine whether nonlinear relationships improve predictive performance.

Coefficient-based interpretations will not be treated as causal effects. Formal confidence intervals for odds ratios will not be claimed from regularized predictive regression without a separate appropriate inferential procedure.

### 8.4 Primary Experiments

| ID | Cohort | Features | Model |
|---|---|---|---|
| E1 | C1 | Structured only | Logistic Regression |
| E2 | C1 | Structured only | LightGBM |
| E3 | C1 | Structured + chief complaint features | LightGBM |
| E4 | C2 | Structured only | LightGBM |

E1–E3 constitute the primary modeling analysis.

E4 is a limited case-definition sensitivity experiment using the same modeling specification as E2.

### 8.5 Data Partitioning and Leakage Prevention

Data will be separated into training and held-out test sets using patient-level grouping by `subject_id`.

Patients appearing in both cohorts will retain consistent training/test assignment across sensitivity experiments.

Model selection and feature preprocessing will occur using training data only.

The held-out test set will be reserved for final evaluation.

Because final ICD-defined cohort membership is not known at triage, findings will be interpreted as retrospective conditional prediction rather than prospective ED deployment performance.

### 8.6 Evaluation Metrics

The primary evaluation metrics will be:

- AUROC — discrimination.
- AUPRC — precision–recall performance.
- Brier score and calibration plot — probability accuracy and calibration.

Outcome prevalence and positive-event counts will be reported alongside model performance.

A simple bootstrap confidence interval for key performance estimates may be included if time permits.

The project will not require a specific AUROC threshold to be considered successful.

## 9. Explainability

SHAP will be applied to the primary LightGBM model trained on C1.

The analysis will identify variables contributing most strongly to the model's predictions.

A SHAP summary plot will be included in the results.

Interpretations will focus on predictive associations within the observed dataset, not causal explanations of clinician behavior.

If the text-enhanced model is used for SHAP, compressed text dimensions will be interpreted cautiously. A structured-only explanation may be preferred for greater clinical readability.

## 10. Cohort Sensitivity Analysis

The sensitivity analysis will compare strict and expanded ICD-defined cohorts.

### 10.1 Cohort Composition

Compare C1, C2, and the additional C2-only encounters using:

- Encounter and patient counts.
- Demographic and triage characteristics.
- Chief complaint phenotype distribution.
- Documented opioid dispensing prevalence.

### 10.2 Predictive Performance

Apply the same structured-feature LightGBM modeling specification to C1 and C2, using identical eligibility rules, outcome mapping, preprocessing principles, and evaluation metrics.

Because C1 is a subset of C2, the analysis will not treat the two performance estimates as statistically independent.

Performance differences may reflect changes in cohort size, clinical heterogeneity, outcome prevalence, and patient composition. They cannot establish the causal effect of phenotype uncertainty.

### 10.3 Interpretation

The analysis will consider whether prediction results appear stable across the two prespecified ICD definitions.

Both similar and different results will be reported without assuming that one outcome must occur.

## 11. Expected Contributions and High-Risk Nature

The primary contribution is an exploratory assessment of opioid dispensing prediction in an ICD-defined LBP ED population.

The project's distinctive methodological component is its investigation of clinical phenotype uncertainty.

Its high-risk characteristics include:

- Difficulty identifying a clinically meaningful LBP cohort using ICD records.
- Trade-offs between strict case definitions and broader clinical coverage.
- Incomplete medication documentation and potential outcome misclassification.
- Limited predictive information at ED triage.
- Uncertain incremental value of short clinical text.
- Potential sensitivity of ML findings to cohort construction.

The project may find limited predictive performance, minimal text-related improvement, or little difference between cohort definitions.

Such findings will not automatically constitute failure. The educational objective is to implement and critically evaluate a defensible healthcare ML approach under real-world data limitations.

The project does not claim to develop or clinically validate a new diagnostic phenotype.

## 12. Limitations

### 12.1 Phenotype Validity

ICD codes are imperfect proxies for clinical conditions. Neither C1 nor C2 can guarantee clinically confirmed nonspecific LBP.

The codebook is literature-informed and researcher-reviewed but has not undergone full independent chart-based clinical validation.

### 12.2 Retrospective Selection

Final diagnosis information is used to identify the analytical population retrospectively. The resulting model is not directly applicable to an unselected real-time triage population without further evaluation.

### 12.3 Outcome Misclassification

Pyxis dispensing records may not capture all treatment pathways and do not confirm medication administration or clinical appropriateness.

### 12.4 Missing Clinical Context

The model will not reconstruct longitudinal medication history, detailed examination findings, imaging results, clinician reasoning, or patient treatment preferences.

### 12.5 Generalizability

MIMIC-IV-ED represents a particular clinical environment. Findings may not generalize to other institutions, care systems, or time periods.

### 12.6 Cohort Comparison

C1 and C2 are overlapping populations with potentially different case mix and event prevalence. Differences in model performance cannot be attributed exclusively to phenotype definition.

### 12.7 Clinical Interpretation

The prediction target reflects documented historical treatment patterns, not optimal treatment decisions. The model must not be interpreted as recommending opioid use.

## 13. Technical Scope and Deliverables

### 13.1 Core Scope

The project will include:

- Literature-informed ICD phenotype construction.
- Encounter-level cohort integration.
- One binary opioid dispensing label.
- Structured-feature modeling with Logistic Regression and LightGBM.
- Limited clinical text feature integration.
- Standard model performance evaluation.
- Focused SHAP interpretation.
- One C1-versus-C2 sensitivity experiment.

### 13.2 Out of Scope

The following will not be included in the current course submission:

- Bio_ClinicalBERT or other large clinical language models.
- Complete clinical-note NLP.
- Longitudinal medication history reconstruction.
- Causal inference about opioid treatment.
- Comprehensive demographic fairness audits.
- Temporal drift analysis.
- External clinical validation.
- Prospective clinical deployment.
- Comprehensive clinical chart review.

### 13.3 Final Deliverables

**Code and Data Processing**

- Reproducible SQL scripts and Jupyter notebooks.
- Versioned phenotype definitions and opioid mapping.
- Encounter-level analytical dataset.
- Documented data-quality and leakage checks.

**Research Outputs**

- Table 1: Cohort characteristics and outcome prevalence.
- Table 2: C1 model performance comparison.
- Figure 1: Overall study workflow and cohort construction.
- Figure 2: Primary model performance and calibration.
- Figure 3: SHAP explanation.
- Table 3 or Figure 4: C1 vs C2 sensitivity results.

**Course Submission**

- Approximately 5–10-page ACM-style report.
- Reproducible code repository.
- Presentation slides and a 5–10-minute recorded presentation.

## 14. Project Execution Plan

| Phase | Objective | Completion Criterion |
|---|---|---|
| P1 — Data EDA | Understand source tables and data quality | Completed |
| P2 — ICD Phenotyping | Establish reproducible case definitions | Provisional codebook available |
| P3 — Chief Complaint | Extract clinical text phenotypes | V2 output available |
| P4 — Cohort Integration | Build C1 and C2 encounter-level datasets | Unique stays, documented eligibility |
| P5 — Opioid Outcome | Create and validate binary dispensing outcome | Reviewed mapping and event counts |
| P6 — ML Modeling | Train and evaluate primary models | Held-out performance results |
| P7 — Interpretation & Sensitivity | SHAP and C1/C2 robustness comparison | Core figures and comparison table |
| P8 — Reporting | Present methods, results, and limitations | Final report and presentation |

A minimum complete submission will prioritize P4–P6 and basic interpretation. Additional text representations and extended uncertainty estimates are secondary to completing a valid primary analysis.

## 15. Future Research Opportunities

The course project may serve as a foundation for a more extensive independent research effort.

Potential extensions include:

- Independent clinical validation of ICD-based LBP phenotypes.
- Alternative phenotype definitions using chief complaint and diagnosis combinations.
- Richer clinical NLP using physician notes and pretrained clinical language models.
- Cross-institutional validation.
- More comprehensive medication utilization analysis.
- Formal fairness and subgroup evaluation.
- Prospective validation in a clinically identifiable population.
- Statistical investigation of how cohort definition changes predictive model estimates.

These extensions would require separate feasibility assessment, additional data validation, and potentially clinical collaboration.

## 16. Preliminary References

1. Hartvigsen, J., et al. (2018). *What low back pain is and why we need to pay attention.* The Lancet, 391, 2356–2367. https://pubmed.ncbi.nlm.nih.gov/29573870/
2. *Identifying neck and back pain in administrative data: defining the right cohort.* (2012). https://pubmed.ncbi.nlm.nih.gov/22127268/
3. *Sensitivity and specificity of algorithms for the identification of nonspecific low back pain in medico-administrative databases.* (2023). https://pubmed.ncbi.nlm.nih.gov/36728479/
4. Dowell, D., Ragan, K. R., Jones, C. M., Baldwin, G. T., & Chou, R. (2022). *CDC Clinical Practice Guideline for Prescribing Opioids for Pain — United States, 2022.* MMWR. https://www.cdc.gov/mmwr/volumes/71/rr/rr7103a1.htm
5. *The Association of Emergency Department Opioid Administration and Prescribing with Ongoing Opioid Use: A Retrospective Cohort Study of Patients With Back Pain.* (2020). https://pmc.ncbi.nlm.nih.gov/articles/PMC8079173/
6. *Usual Care for Low Back Pain at U.S. Emergency Departments, 2016–2022.* (2025). https://pmc.ncbi.nlm.nih.gov/articles/PMC12258925/
7. Johnson, A. E. W., et al. (2023). *MIMIC-IV-ED, version 2.2.* PhysioNet. https://physionet.org/content/mimic-iv-ed/2.2/
8. Collins, G. S., et al. (2024). *TRIPOD+AI statement: updated guidance for reporting clinical prediction models that use regression or machine learning methods.* BMJ, 385, e078378. https://doi.org/10.1136/bmj-2023-078378
9. *PROBAST+AI: An updated quality, risk of bias, and applicability assessment tool for prediction models using regression or artificial intelligence methods.* (2025). BMJ, 388, e082505. https://doi.org/10.1136/bmj-2024-082505

*Reference list is preliminary; full author, journal, and formatting details should be checked before final ACM submission.*