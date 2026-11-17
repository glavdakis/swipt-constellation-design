# Constellation Design for SWIPT

This repository contains the research project on modulation design for **Simultaneous Wireless Information and Power Transfer (SWIPT)** for the **Telecommunication Systems II** course at ECE AUTH during the 2023-2024 academic year.

**Team 22:** Georgios Lavdakis · Alexandros Pagkaltzis

## Motivation

In SWIPT, one signal carries both data and energy. Rectifier circuits are non-linear, so signals with a high **peak-to-average power ratio (PAPR)** harvest more energy. However, at a fixed average energy a higher PAPR shrinks the **minimum symbol distance $d_{min}$**, which raises the **symbol error rate (SER)**. This project analyzes the trade-off for 16-ary constellations and proposes a new design.

## What we did

| Task | Description | Figures |
|---|---|---|
| **1. PAPR vs. $d_{min}$** | Closed-form PAPR and $d_{min}$ for 16-PSK, PAM, QAM and Circular QAM (CQAM, N = 4 and 8), verified with simulation | [PAPR_dmin](plots/task1/PAPR_dmin.pdf) |
| **2i. SER vs. harvested energy** | SER as harvested energy grows at high SNR, including spike QAM (sQAM) from [R2] | [SER_energy](plots/task2/SER_energy.pdf) |
| **2ii. SER vs. SNR** | Analytical SER under AWGN with and without energy harvesting, using ML decision regions and the Q-function | [SER_SNR](plots/task2/SER_SNR.pdf) |
| **3. Proposed constellation** | A new 16-QAM: 5 circles of 3 symbols each, plus one high-energy "spike" symbol | [QAM_16_NEW](plots/task3/QAM_16_NEW.pdf), [PAPR_dmin_NEW](plots/task3/PAPR_dmin_NEW.pdf) |

## Key findings

- **CQAM** gives a better PAPR/$`d_{min}`$ trade-off than PSK, PAM and QAM. Its number of energy levels lets you choose between energy harvesting and reliability.
- With energy harvesting ($\varepsilon(x) = 0.2$), the SER of PAM and QAM stops falling as SNR rises, while CQAM's SER keeps dropping.
- **Our proposed constellation** reaches PAPR up to 16, four times CQAM with N = 4, following $\text{PAPR} = 16 - 46.32\,d_{min}^2$ for $d_{min} \le 0.533$. It offers 5 energy levels for fine control of the harvested energy.

All derivations and discussion are in the full report (in Greek): [`docs/report.pdf`](docs/report.pdf).

## Repository structure

```
docs/     report and original assignment
src/      MATLAB scripts
plots/    generated figures
```

## Requirements

The scripts need the **Communications Toolbox** (`qfunc`) and the **Image Processing Toolbox** (`viscircles`).

## References

- **[R1]** G. M. Kraidy, C. Psomas, I. Krikidis, "Fundamentals of Circular QAM for Wireless Information and Power Transfer," IEEE SPAWC, 2021.
- **[R2]** M. J. L. Morales, K. Chen-Hu, A. G. Armada, "Optimum Constellation for Symbol-Error-Rate to PAPR Ratio Minimization in SWIPT," IEEE VTC2022-Spring, 2022.
- **[R3]** J. Van Wonterghem, J. J. Boutros, M. Moeneclaey, "Construction of Circular Quadrature Amplitude Modulations (CQAM)," ICSEE, 2018.
