library(targets)
library(tarchetypes)
source("R/functions.R")
options(tidyverse.quiet = TRUE)
tar_option_set(packages = c("lavaan", "tidyverse"))
# workflow
list(
  # data file
  tar_target(dataFile, "data/Cohorts 1&2 -- T1-T14 - new covid.csv", format = "file"),
  tar_target(d, loadData(dataFile)),
  # fit riclpms
  tar_target(riclpm1, fitRICLPM(d, var1 = "Contacts24hrsLog", var2 = "Stress")),
  tar_target(riclpm2, fitRICLPM(d, var1 = "Contacts7daysLog", var2 = "Stress")),
  tar_target(riclpm3, fitRICLPM(d, var1 = "Contacts24hrsLog", var2 = "PerceptionsRisk")),
  tar_target(riclpm4, fitRICLPM(d, var1 = "Contacts7daysLog", var2 = "PerceptionsRisk"))
)