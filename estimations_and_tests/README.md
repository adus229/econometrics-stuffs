# Theoretical and Empirical Economics Analysis

## Table of Contents
- [Theoretical and Empirical Economics Analysis](#theoretical-and-empirical-economics-analysis)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Project Structure](#project-structure)
  - [Methodology](#methodology)
  - [Analysis Process](#analysis-process)
    - [1. Logistic Estimation](#1-logistic-estimation)
    - [2. Maximum Likelihood Estimation](#2-maximum-likelihood-estimation)
    - [3. Testing](#3-testing)
  - [Results](#results)
  - [Conclusion](#conclusion)
  - [How to Run the Project](#how-to-run-the-project)
  - [Dependencies](#dependencies)

## Introduction
This project aims to estimate a relationship between a binary dependent variable and several independent variables using logistic regression and maximum likelihood estimation. The analysis is conducted using R, and tests are performed to assess the significance of the parameters.

## Project Structure
The project consists of the following main files:
<!-- - `ulrich_aiounou_assignment_doc.pdf`: A detailed report presenting the analysis process and results. -->
- `assignement.R`: An R script that contains the data loading, estimation, and testing procedures.

## Methodology
The study is focused on estimating the relationship between a binary dependent variable `y` and two independent variables (`x1` and `x2`). The following methods were employed:
1. **Logistic Estimation**: Estimates the probability of `y = 1` using a logistic function.
2. **Maximum Likelihood Estimation (MLE)**: Maximizes the log-likelihood function to estimate the parameters.

## Analysis Process
The analysis involves several steps:

### 1. Logistic Estimation
The logistic regression model estimates the probability that `y` equals 1 using the function:
\[ Pr(y_t = 1) = \frac{1}{1 + e^{-(\beta_0 + \beta_1 x_{t1} + \beta_2 x_{t2})}} \]
The `glm()` function in R was used for this estimation, and the results showed significant coefficients for both `x1` and `x2`.

### 2. Maximum Likelihood Estimation
The MLE approach was implemented by defining custom functions to calculate `F_t` and the log-likelihood. The `optim()` function in R was used to optimize the parameters.

### 3. Testing
Two statistical tests were conducted:
- **Student's t-test**: Tested whether the coefficients matched hypothesized values.
- **Likelihood Ratio (LR) Test**: Compared the log-likelihoods under different hypotheses.

## Results
The analysis provided the following insights:
- The logistic regression and MLE produced the same estimates for coefficients: \((β_0, β_1, β_2) = (-0.85, 3.04, 3.31)\).
- The Student's t-test and LR test indicated that we could not reject the hypotheses that \(\beta_1 = 3\) and \(\beta_2 = 4\) at common significance levels.

## Conclusion
The project demonstrated that logistic estimation and MLE can yield consistent parameter estimates. Both the t-test and LR test indicated that the hypothesized values for \(\beta_1\) and \(\beta_2\) could not be rejected.

## How to Run the Project
1. Ensure you have R installed on your system.
2. Open the `assignement.R` script in RStudio or any other R environment.
3. Run the script to reproduce the analysis and results.

## Dependencies
The project requires the following R packages:
- `stats`: For logistic regression using `glm()` and optimization using `optim()`.
- `base`: For basic R functions.

You can install these packages using:
```R
install.packages(c("stats"))
