# COVID-19 Gatherings

Using random-intercept cross-lagged panel models to study the determinants of in-person interactions during the COVID-19 pandemic.

## Getting Started

### Installing

To run this code, you will need to [install R](https://www.r-project.org/) and the following R packages:

```
install.packages(c("lavaan", "targets", "tarchetypes", "tidyverse"))
```

### Executing code

1. Set the working directory to this code repository
2. Load the `targets` package with `library(targets)`
3. To run all analyses, run `tar_make()`
4. To load individual targets into your environment, run `tar_load(riclpm1)` etc.
5. To view model parameters, load the `lavaan` package with `library(lavaan)` and run `summary(riclpm1)` etc.

## Help

Any issues, please email scott.claessens@gmail.com.

## Authors

Scott Claessens, scott.claessens@gmail.com
