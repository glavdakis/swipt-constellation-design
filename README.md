# Constellation Design for SWIPT

This repository contains the research project on modulation design for **Simultaneous Wireless Information and Power Transfer (SWIPT)** for the **Telecommunication Systems II** course at ECE AUTH during the 2023-2024 academic year.

**Team 22:** Georgios Lavdakis · Alexandros Pagkaltzis

## Motivation

In SWIPT, one signal carries both data and energy. Rectifier circuits are non-linear, so signals with a high **peak-to-average power ratio (PAPR)** harvest more energy. However, at a fixed average energy a higher PAPR shrinks the **minimum symbol distance $d_{min}$**, which raises the **symbol error rate (SER)**. This project analyzes the trade-off for 16-ary constellations and proposes a new design.

## What we did

| Task | Description | Figures |
|---|---|---|
| **1. PAPR vs. $d_{min}$** | Closed-form PAPR and $d_{min}$ for 16-PSK, PAM, QAM and Circular QAM (CQAM, N = 4 and 8), verified by building every constellation numerically and measuring PAPR and $d_{min}$ | [PAPR_dmin](plots/task1/PAPR_dmin.pdf) |
| **2i. SER vs. harvested energy** | SER as harvested energy grows at high SNR, including spike QAM (sQAM) from [R2], verified with Monte Carlo simulation | [SER_energy](plots/task2/SER_energy.pdf) |
| **2ii. SER vs. SNR** | Analytical SER under AWGN with and without energy harvesting (including sQAM), using ML decision regions, the union bound and the Q-function, verified with Monte Carlo simulation | [SER_SNR](plots/task2/SER_SNR.pdf) |
| **3. Proposed constellation** | A new 16-QAM: 5 circles of 3 symbols each, plus one high-energy "spike" symbol | [QAM_16_NEW](plots/task3/QAM_16_NEW.pdf), [PAPR_dmin_NEW](plots/task3/PAPR_dmin_NEW.pdf) |

## Key findings

- **CQAM** gives a better PAPR/$`d_{min}`$ trade-off than PSK, PAM and QAM. Its number of energy levels lets you choose between energy harvesting and reliability. Each circle is placed at the smallest radius that keeps every distance at least $d_{min}$, with its phase chosen to make that radius as small as possible (R1's Algorithm 1). With N = 4 this gives $\text{PAPR} = 4 - (3.5+\sqrt{3})\,d_{min}^2$ up to $d_{min} = 0.650$, above the 0.632 of 16-QAM with almost the same PAPR (1.79 vs 1.8). With N = 8 all symbols lie on a hexagonal lattice and $\text{PAPR} = 8 - 13.25\,d_{min}^2$ up to $d_{min} = 2/3$.
- When the same energy ($\varepsilon(x) = 0.2$) is harvested from every symbol, PAM, QAM and sQAM reach the same error floor, SER = 3/16: each has 4 symbols with energy of at most 0.2, which collapse to the origin and can no longer be told apart. CQAM (N = 4) has no error floor, because its inner circle keeps energy 0.211 > 0.2, and reaches SER = 10⁻⁵ at 25.7 dB.
- **Our proposed constellation** reaches PAPR up to 16, four times CQAM with N = 4, following $\text{PAPR} = 16 - 46.32\,d_{min}^2$ for $d_{min} \le 0.533$. It offers 5 energy levels for fine control of the harvested energy.

All derivations and discussion are in the full report: [`docs/report.pdf`](docs/report.pdf).

## Corrections to the reference papers

Where a result in [R1] or [R2] is not correct, the report points it out and the plots use the correct curve.

- **[R1], Fig. 2 (PAPR vs. $d_{min}$):** the CQAM curves are not the maximum PAPR that Algorithm 1 allows. With the phase of each circle chosen to minimise its radius, N = 4 reaches $d_{min} = 0.650$ (R1 stops at about 0.6), and N = 8 reaches $d_{min} = 2/3$ with PAPR 6.81 at $d_{min} = 0.3$ (R1: about 6, stopping at about 0.45). A numerical search over all radii and phases found no better placement.
- **[R1], Fig. 4 (SER vs. harvested energy):**
  - The 16-QAM curve jumps straight to 0.75 at $\varepsilon(x) \approx 0.2$. Only the 4 inner symbols are lost there; the jump to 0.75 belongs at $\varepsilon(x) = 1$.
  - The energy levels of the CQAM (max $d_{min}$) curve add up to about 5.2 instead of 4, so they do not belong to a constellation with unit average energy.
  - It counts all $k$ symbols that collapse to the origin as errors. An ML detector still decides correctly for one of them, so the SER is $(k-1)/M$.
- **[R1], eq. (4):** it only uses the distance between symbols on the same circle, while the nearest neighbours are often on another circle. The report uses the union bound over the actual distances.
- **[R2], eq. (7):** it treats the 12 inner sQAM symbols as a full 16-QAM scaled to their mean energy, giving a minimum distance of 0.324 instead of the actual 0.378. It overestimates the SER (4.1·10⁻³ instead of 6.9·10⁻⁴ at 16 dB). The report plots the union bound on the actual constellation.

The union-bound and decision-region curves were checked against Monte Carlo simulation with an ML detector.

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
