# Econometric Simulation and Bootstrap Analysis

## Table of Contents
- [Econometric Simulation and Bootstrap Analysis](#econometric-simulation-and-bootstrap-analysis)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Project Structure](#project-structure)
  - [Methodology](#methodology)
    - [Methods](#methods)
  - [Analysis Process](#analysis-process)
    - [1. Asymptotic P-Value Calculation](#1-asymptotic-p-value-calculation)
    - [2. Bootstrap P-Value Calculation](#2-bootstrap-p-value-calculation)
    - [3. Resampling Bootstrap P-Value Calculation](#3-resampling-bootstrap-p-value-calculation)
    - [4. Multiple Sample Sizes](#4-multiple-sample-sizes)
  - [Results](#results)
  - [Conclusion](#conclusion)
  - [How to Run the Project](#how-to-run-the-project)
  - [Dependencies](#dependencies)

## Introduction
This project involves conducting a simulation to calculate p-values from a Fisher statistic using three different methods: asymptotic calculation, bootstrap, and resampling bootstrap. The purpose is to evaluate the effectiveness of these methods in hypothesis testing using econometric techniques.

## Project Structure
The project consists of the following main files:
<!-- - `rappor_aiounou_ulrich.pdf`: A detailed report presenting the simulation process, methods used, and results. -->
- `code_aiounou_ulrich.R`: An R script containing the simulation code, data processing, and the calculation of p-values using different methods.

## Methodology
The main objective is to estimate a model based on the linear regression equation:
\[ y_t = \beta_0 + 0.6 y_{t-1} + \beta_1 x_{1t} + \beta_2 x_{2t} + \beta_3 x_{3t} + u_t \]
where the goal is to test the null hypothesis \( H_0: \beta_1 = \beta_2 = \beta_3 = 0 \).

### Methods
Three different methods were used to calculate the p-values:
1. **Asymptotic Calculation**: Using the Fisher statistic's theoretical distribution.
2. **Bootstrap Method**: Generating multiple samples and recalculating the Fisher statistic.
3. **Resampling Bootstrap**: Using resampling techniques with residuals from the original model.

## Analysis Process
The analysis involves the following steps:

### 1. Asymptotic P-Value Calculation
- Generate data based on the null hypothesis.
- Calculate the F-statistic from a regression model.
- Determine the p-value from the asymptotic distribution.

### 2. Bootstrap P-Value Calculation
- Generate bootstrap samples from the data under the null hypothesis.
- Calculate the F-statistic for each sample and determine the proportion that exceeds the original F-statistic.

### 3. Resampling Bootstrap P-Value Calculation
- Generate bootstrap samples by resampling residuals from the initial model.
- Recompute the F-statistic for each resampled dataset.

### 4. Multiple Sample Sizes
The above steps are repeated for different sample sizes, ranging from 20 to 100, to assess the robustness of each method across varying sample sizes.

## Results
The project demonstrated that both the bootstrap and resampling bootstrap methods provided better results than the asymptotic approach, especially for smaller sample sizes. A graphical comparison was made to visualize the rejection frequencies across different sample sizes.

## Conclusion
The bootstrap and resampling bootstrap methods were found to be more effective in providing accurate p-values compared to the asymptotic approach, indicating their robustness in econometric simulations.

## How to Run the Project
1. Ensure you have R installed on your system.
2. Open the `code_aiounou_ulrich.R` script in RStudio or any other R environment.
3. Run the script to reproduce the simulation and calculate the p-values.

## Dependencies
The project requires the following R packages:
- `dplyr`: For data manipulation and generating variable lags.

You can install the necessary package using:
```R
install.packages("dplyr")
