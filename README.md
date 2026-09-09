# Guardian Battery ECM & SOC Estimation

A MATLAB/Simulink project implementing an equivalent circuit model (ECM) and State of Charge (SOC) estimation for the EVE LF50K (3.2V / 50Ah LiFePO4) battery cell.

## Overview

This project models battery terminal voltage behavior from a current input and estimates SOC using two approaches: Coulomb Counting and an Extended Kalman Filter (EKF). It was built around a real, commercially available LFP cell, using datasheet-derived and literature-scaled parameters.

**Signal flow:**

```
Current Input → OCV(SOC) Lookup + Hysteresis Noise → Thevenin ECM → Terminal Voltage
                                                              ↓
                                              Coulomb Counting / EKF SOC Estimation
```

## Features

### Core
- Current input read from provided drive-cycle CSV data (Ts = 1 s)
- OCV(SOC) via 1-D Lookup Table
- Bounded hysteresis noise (Band-Limited White Noise → Discrete Filter → Saturation)
- R0-R1C1 (1RC) Thevenin equivalent circuit model
- Coulomb Counting SOC estimation with SOC(0) = 80%, clamped to a 10-90% operating window

### Bonus 1 — 2RC Extension
- Extended the Thevenin branch to a full 2RC model (added R2-C2 branch)
- Terminal voltage updated to account for both polarization voltages (V1, V2)

### Bonus 2 — Extended Kalman Filter
- Extended the provided 1RC EKF (states: [SOC, V1]) to a 2RC formulation (states: [SOC, V1, V2])
- Reworked the filter's process/measurement matrices (F, H, P, Qcov) for the added state
- Estimates SOC, V1, and V2 from current and terminal voltage

## Model Parameters

| Parameter | Value | Basis |
|---|---|---|
| Q_nominal | 50 Ah | Datasheet |
| R0 | 0.70 mΩ | Datasheet (AC impedance) |
| R1 | 1.60 mΩ | Scaled from literature (HPPC-fitted 2RC set) |
| C1 | 17,000 F | Scaled from literature |
| R2 | 0.35 mΩ | Scaled from literature |
| C2 | 5,200 F | Scaled from literature |
| Sample time (Ts) | 1 s | Matches current dataset |

## Repository Structure

```
├── models/                  # Simulink model files (.slx)
├── data/                    # Provided CSV datasets (current profile, OCV table)
├── scripts/                 # Parameter setup, bus objects, plotting scripts
├── EKF_SOC_Estimator.m      # Extended Kalman Filter implementation
└── README.md
```

## Requirements

- MATLAB
- Simulink

- No thermal model is implemented; simulation assumes a fixed 25°C ambient temperature.
- R1/C1/R2/C2 are fitted dynamic-response parameters, not literal physical components — they are not published in the cell's datasheet and were scaled from literature-reported HPPC test data.
