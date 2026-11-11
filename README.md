# Constellation Design for SWIPT

**Simultaneous Wireless Information and Power Transfer: analysis and design of modulation constellations**

This repo holds a research project for the course *Telecommunication Systems II* (6th semester), School of Electrical and Computer Engineering, Aristotle University of Thessaloniki (AUTh), 2024.

**Team 22:** Georgios Lavdakis · Alexandros Pagkaltzis

---

## Overview

In **SWIPT**, one RF signal carries both information and energy to a receiver. Energy-harvesting rectifier circuits are non-linear, so the amount of energy harvested depends on the shape of the signal. Signals with a high **peak-to-average power ratio (PAPR)** are better for power transfer.

At a fixed average symbol energy $E_s$, raising PAPR pushes the remaining symbols closer together. That shrinks the **minimum Euclidean distance $d_{min}$** and increases the **symbol error rate (SER)**. This project studies the **PAPR vs. $d_{min}$ trade-off** and the matching **SER vs. harvested energy** trade-off:

1. We derive the PAPR and SER behaviour of standard and SWIPT-specific 16-ary constellations analytically.
2. We reproduce the results of two recent IEEE papers through simulation in MATLAB.
3. We propose a new constellation that combines the ideas of both papers.

All constellations have $M = 16$ symbols and average energy $E_s = 1$, so the comparisons are fair.

The full report (in Greek) has every derivation, proof and figure: [`docs/Εργασία_έρευνας.pdf`](docs/Εργασία_έρευνας.pdf). The original assignment is in [`docs/Ergasia Ereynas_2024.pdf`](docs/Ergasia%20Ereynas_2024.pdf).

---

## Constellations studied

| Constellation | Description | Source |
|---|---|---|
| **16-PSK** | All symbols on one circle, so PAPR = 1 | classic |
| **16-PAM** | One-dimensional, equally spaced amplitudes | classic |
| **16-QAM** | Square (rectangular) QAM grid | classic |
| **16-CQAM** (N = 4, 8) | Circular QAM: symbols on *N* concentric circles (energy levels), with radii set by $d_{min}$ and the outer radius set by the energy constraint | [R1] |
| **16-sQAM** (i = 1, 4) | "Spike" QAM: square QAM with *i* corner symbols pushed outward to raise PAPR | [R2] |
| **Proposed 16-QAM** (N = 5) | **Our design:** 5 circles of 3 symbols each, plus one far-out "spike" symbol on the in-phase axis | this work |

---

## Task 1: PAPR vs. $d_{min}$

We derive closed-form expressions for PAPR and $d_{min}$ for each constellation at $E_s = 1$:

| Constellation | $d_{min}$ | PAPR |
|---|---|---|
| 16-PSK | 0.3902 | 1 |
| 16-PAM | 0.2169 | 2.647 |
| 16-QAM | 0.64 | 1.8432 |
| 16-CQAM, N = 4 | $d_{min} \in [0,\ 0.6277]$ | $4 - 5.2802\, d_{min}^2$ |
| 16-CQAM, N = 8 | $d_{min} \in [0,\ 0.4139]$ | $8 - 33.4461\, d_{min}^2$ |

For CQAM we derive each radius $R_i$ from the geometry of neighbouring symbols, using equilateral triangles between adjacent rings. We then get the outer radius $R_N$ from the average-energy constraint, and the valid range of $d_{min}$ from the requirement that the outer ring keeps a distance of at least $d_{min}$ from its neighbours.

Figures: [PSK_16](plots/task1_papr_vs_dmin/PSK_16.pdf) · [PAM_16](plots/task1_papr_vs_dmin/PAM_16.pdf) · [QAM_16](plots/task1_papr_vs_dmin/QAM_16.pdf) · [CQAM_16_N4](plots/task1_papr_vs_dmin/CQAM_16_N4.pdf) · [CQAM_16_N8](plots/task1_papr_vs_dmin/CQAM_16_N8.pdf) · [PAPR_dmin](plots/task1_papr_vs_dmin/PAPR_dmin.pdf)

**Result:** 16-CQAM reaches PAPR values higher than PAM, the best of the classic schemes for PAPR, while keeping a $d_{min}$ close to that of square QAM. Changing the number of energy levels *N* trades one quantity for the other, a flexibility that classic constellations lack.

---

## Task 2(i): SER vs. harvested energy $\varepsilon(x)$, high SNR

At very high SNR, the only cause of errors is the energy harvester. Once the harvested energy $\varepsilon(x)$ reaches a symbol's energy level, that symbol collapses to the origin. SER is therefore a staircase function of $\varepsilon(x)$, with one step per energy level. We compare PAM, QAM, CQAM at maximum $d_{min}$, CQAM at maximum PAPR, and 16-sQAM with 4 spiked symbols (PAPR = 3.214, $d_{min}$ = 0.378).

Figures: [CQAM_16_N4_dmin](plots/task2_ser_analysis/CQAM_16_N4_dmin.pdf) · [CQAM_16_N4_PAPR](plots/task2_ser_analysis/CQAM_16_N4_PAPR.pdf) · [sQAM_16](plots/task2_ser_analysis/sQAM_16.pdf) · [SER_energy](plots/task2_ser_analysis/SER_energy.pdf)

**Result:** CQAM designed for maximum PAPR keeps SER below 1 up to the largest harvested energy of all schemes. CQAM designed for maximum $d_{min}$ has the lowest SER at small $\varepsilon(x)$. The sQAM comes close to max-PAPR CQAM.

---

## Task 2(ii): SER vs. SNR at fixed $\varepsilon(x)$

We derive analytical SER expressions under AWGN for $\varepsilon(x) = 0$ and $\varepsilon(x) = 0.2$:

- **PAM and QAM with $\varepsilon(x) = 0.2$:** we subtract the harvested energy from every symbol, which moves some symbols to the origin. We then rebuild the maximum-likelihood decision regions (perpendicular bisectors) and compute the probability of error for each symbol with the Q-function.
- **CQAM:** we use the nearest-neighbour SER bound from [R1] at $d_{min} = 0.627$.
- **sQAM:** we use the SER expressions from [R2], which combine square-QAM SER with the error probability of the spiked symbols.

Figures: [SER_SNR](plots/task2_ser_analysis/SER_SNR.pdf)

**Result:** with no energy harvested, the schemes with the largest $d_{min}$ perform best. With $\varepsilon(x) = 0.2$, the SER of PAM and QAM hits an error floor, because the inner symbols collapse. CQAM still drives SER down as SNR increases. High-PAPR constellations let the receiver harvest energy at little cost to reliability.

---

## Task 3: Proposed constellation

We propose a **16-QAM with N = 5 concentric circles and 3 symbols per circle**, with the phase alternating between consecutive circles. The 16th symbol is a high-energy **spike** placed on the in-phase axis. The design combines the multi-level structure of CQAM [R1] with the spike idea of sQAM [R2].

For this design we derive:

$$R_1 = \tfrac{d_{min}}{\sqrt3},\quad R_2 = \tfrac{2\sqrt3}{3}d_{min},\quad R_{i+2} = R_i + d_{min}$$

$$\text{PAPR} = 16 - 3c\, d_{min}^2,\quad c = 15.4402,\qquad d_{min} \in [0,\ 0.5332]$$

Figures: [QAM_16_NEW](plots/task3_proposed_constellation/QAM_16_NEW.pdf) · [PAPR_dmin_NEW](plots/task3_proposed_constellation/PAPR_dmin_NEW.pdf)

**Result:** the proposed constellation reaches a maximum PAPR of 16, four times that of CQAM with N = 4, and it trades off PAPR against $d_{min}$ much better than CQAM. It performs close to sQAM with one spiked symbol, while offering **5 separate energy levels**, which give finer control over the harvested energy $\varepsilon(x)$. The report also suggests a further improvement: placing the spare symbol near the origin instead of far out would allow a larger $d_{min}$.

---

## Repository structure

```
.
├── docs/
│   ├── Εργασία_έρευνας.pdf            # Full report (Greek): derivations, figures, discussion
│   └── Ergasia Ereynas_2024.pdf       # Original assignment
├── src/                               # MATLAB scripts (one figure per script)
│   ├── task1_papr_vs_dmin/            # PSK/PAM/QAM/CQAM constellations + PAPR vs d_min
│   ├── task2_ser_analysis/            # SER vs ε(x), SER vs SNR, sQAM & CQAM variants
│   └── task3_proposed_constellation/  # Proposed N=5 QAM + PAPR vs d_min comparison
└── plots/                             # Generated figures (PDF), same layout as src/
```

## Running the code

Every script in `src/` stands on its own and draws one figure. Open it in MATLAB and run it. To export the figure, uncomment the `saveas(...)` line at the end.

**Requirements:** MATLAB (written with R2023b), plus
- **Communications Toolbox**, for `qfunc` (SER scripts)
- **Image Processing Toolbox**, for `viscircles` (CQAM and proposed-QAM constellation plots)

## References

- **[R1]** G. M. Kraidy, C. Psomas and I. Krikidis, "Fundamentals of Circular QAM for Wireless Information and Power Transfer," *2021 IEEE 22nd International Workshop on Signal Processing Advances in Wireless Communications (SPAWC)*, Lucca, Italy, 2021.
- **[R2]** M. J. L. Morales, K. Chen-Hu and A. G. Armada, "Optimum Constellation for Symbol-Error-Rate to PAPR Ratio Minimization in SWIPT," *2022 IEEE 95th Vehicular Technology Conference (VTC2022-Spring)*, Helsinki, Finland, 2022.
- J. Van Wonterghem, J. J. Boutros and M. Moeneclaey, "Construction of Circular Quadrature Amplitude Modulations (CQAM)," *2018 International Conference on the Science of Electrical Engineering (ICSEE)*, 2018. (Background reading.)
