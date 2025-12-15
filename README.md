# Code for Review – Manuscript

## Biophysical modeling of anatomically realistic prenatal cortical folding development

**Authors:** Jixin Hou, Zhengwang Wu, Kun Jiang, Taotao Wu, Lu Zhang, Dajiang Zhu, Wei Gao,  
Mir Jalil Razavi, Tianming Liu, Ellen Kuhl, Gang Li, Xianqiao Wang  
**Corresponding author:** Xianqiao Wang

---

## Overview

This repository contains the **analysis and simulation code** supporting above manuscript  

The study presents a **whole-brain computational framework** for modeling prenatal cortical
folding that integrates:

- Anatomically realistic prenatal brain geometries  
- Region-specific heterogeneous growth laws derived from prenatal MRI  
- Finite-element simulations implemented in **Abaqus**  
- **Symbolic regression** for characterization of regional growth trajectories  
- Quantitative evaluation of folding at global, regional, and vertex levels  

This repository is provided **exclusively for peer review purposes** and is **not intended
for public release** at this stage.

A public version of the code (with DOI) will be prepared upon manuscript acceptance.

The repository is arranged as:

Whole-brain modeling/
├── README.md
│
├── abaqus_script/
│   ├── ExtractDataFromABAQUS.py        # Abaqus output extraction
│   ├── surfReconstruction.m            # Surface reconstruction from simulation outputs
│   ├── vuexpan_orth_wholebrain.f       # Abaqus VUEXPAN subroutine for orthotropic growth
│   └── mfile/                          # MATLAB utilities for folding metrics (not expanded)
│
├── figure scripts/
│   ├── fig2c.py
│   ├── fig4a.py
│   ├── fig4b.py
│   ├── fig4c.py
│   ├── fig4f.py
│   ├── fig5c.py
│   ├── fig5d.opju
│   ├── fig6c_heatmap.py
│   ├── fig6c_radar.py
│   ├── fig6d.opju
│   ├── fig7a.py
│   ├── fig7d.py
│   ├── fig7e.py
│   ├── fig7g.py
│   ├── fig7i.py
│   └── metadata/
│       ├── dataFigures.xlsx            # Processed data for figure plotting
│       └── dataSR.xlsx                 # Data used for symbolic regression plots
│
└── symbolic regression/
    ├── Pysr_growth_area.py             # Symbolic regression for tangential growth
    └── Pysr_growth_thickness.py        # Symbolic regression for radial growth

---

## Software Requirements

- **Abaqus**: 2022 or later (Dynamic-Explicit solver)  
- **Python**: ≥ 3.9  
- **Symbolic regression**: PySR (Julia backend)

---

## Data Availability

Due to **data-use agreements** and **computational scale**, the following materials are
**not included** in this repository:

- Full prenatal MRI datasets (dHCP)  
- High-resolution cortical surface meshes  
- Full Abaqus simulation output files (`.odb`)  

The prenatal MRI data used in this study are publicly available from the  
**Developing Human Connectome Project (dHCP)** under standard access agreements.