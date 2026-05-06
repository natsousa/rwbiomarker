# rwbiomarker — Biomarker-Stratified Real-World Survival Analysis

> A teaching-grade, fully reproducible RWE project. Loads the public
> `survival::colon` adjuvant-chemotherapy cohort as a stand-in for an
> EHR-derived oncology dataset, augments it with a simulated tumor
> biomarker, and estimates **biomarker-specific treatment effects** on
> overall survival.

[![render-report](https://github.com/natsousa/rwbiomarker/actions/workflows/render.yml/badge.svg)](https://github.com/natsousa/rwbiomarker/actions/workflows/render.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE.md)

---

## Why this project exists

Modern oncology drug development is **biomarker-driven**. RWE studies
that stratify by biomarker provide some of the most actionable insights
for early-phase decision making — they tell us *who benefits*. This
project demonstrates the canonical analytical pattern:

1. Load and clean a real-world cohort (here: `survival::colon`, public).
2. Attach (or merge) a biomarker.
3. Build descriptive Table 1 by treatment arm.
4. Estimate Kaplan–Meier curves overall and by biomarker stratum.
5. Estimate Cox PH HRs for each subgroup.
6. Test the **treatment × biomarker interaction**.
7. Visualize as a **forest plot**.
8. Discuss limitations a regulator would expect addressed.

The analytical helpers ship as an installable R package (`rwbiomarker`)
so the report stays clean and the helpers are unit-tested and reusable.

---

## Repository layout

```
rwbiomarker/
├── .devcontainer/devcontainer.json   # one-click reproducible env
├── .github/workflows/render.yml      # CI: tests + renders the report
├── DESCRIPTION                       # R package metadata
├── NAMESPACE                         # exported functions
├── R/
│   ├── rwbiomarker-package.R
│   ├── load.R                        # load_colon()
│   ├── biomarker.R                   # add_biomarker()
│   └── analyze.R                     # fit_subgroup_hr(), fit_interaction_cox()
├── man/                              # roxygen-generated help
├── tests/testthat/                   # unit tests
├── analysis/
│   ├── report.qmd                    # the Quarto walkthrough
│   ├── references.bib
│   └── _quarto.yml
├── Makefile                          # `make install | test | render`
├── LICENSE / LICENSE.md              # MIT
└── README.md
```

---

## Quick start

### Option A — VS Code Dev Container (recommended)

1. Install [Docker](https://www.docker.com/) and the
   [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
   extension.
2. Open this folder in VS Code.
3. `F1` → **Dev Containers: Reopen in Container**.
4. Wait for the build (R 4.4 + Quarto + R packages).
5. From the integrated terminal:

   ```bash
   make test
   make render   # produces analysis/report.html
   ```

### Option B — local R install

```r
install.packages(c(
  "devtools", "survival", "survminer", "broom", "gtsummary",
  "tibble", "dplyr", "ggplot2", "knitr", "gridExtra"
))
devtools::install(".")
```

```bash
quarto render analysis/report.qmd
open analysis/report.html
```

---

## What you will learn

- The mechanics of a **biomarker-stratified survival analysis**.
- Why a significant **interaction** matters more than significant
  subgroup-specific HRs.
- How to draw and interpret a **forest plot** of subgroup HRs.
- The difference between **predictive** and **prognostic** biomarkers
  (the interaction term distinguishes them).
- How to package an analysis for transparent regulatory review.

---

## Reproducibility

- **Pinned R version** via the rocker-org dev-container image
  (`tidyverse:4.4`).
- **Pinned package set** in `DESCRIPTION` (use `renv::init()` if you
  want a lockfile).
- The biomarker simulation uses a **fixed seed**.
- **CI** runs the tests and re-renders the report on every push.
- The rendered report can be published as a GitHub Pages site from the
  `docs/` folder if Pages is enabled for this repository.

---

## Extending this project

- Replace the simulated biomarker with a real one (e.g., from
  `cgdsr` / cBioPortal).
- Add competing-risk analyses (`cmprsk` / `tidycmprsk`).
- Add multiplicity-adjusted subgroup p-values (e.g., Hochberg).
- Run a sensitivity analysis under different biomarker prevalences and
  random seeds.

---

## License

MIT — see [LICENSE.md](LICENSE.md).

## Disclaimer

For education only. The simulated biomarker is **not** clinically
meaningful and the analyses are **not** regulatory advice.
