# custom functions

loadData <- function(dataFile) {
  read.csv(dataFile) %>%
    transmute(Contacts24hrsLog.12 = log(Contacts24hrs.12 + 1),
              Contacts24hrsLog.13 = log(Contacts24hrs.13 + 1),
              Contacts24hrsLog.14 = log(Contacts24hrs.14 + 1),
              Contacts7daysLog.12 = log(Contacts7days.12 + 1),
              Contacts7daysLog.13 = log(Contacts7days.13 + 1),
              Contacts7daysLog.14 = log(Contacts7days.14 + 1),
              Stress.12 = Stress.12,
              Stress.13 = Stress.13,
              Stress.14 = Stress.14,
              PerceptionsRisk.12 = PerceptionsRisk.12,
              PerceptionsRisk.13 = PerceptionsRisk.13,
              PerceptionsRisk.14 = PerceptionsRisk.14
              )
}

fitRICLPM <- function(d, var1, var2, constrained = TRUE) {
  # model code for 3-wave riclpm
  # https://jeroendmulder.github.io/RI-CLPM/lavaan.html
  model <- '# Create between components (random intercepts)
            ri1 =~ 1*var1.12 + 1*var1.13 + 1*var1.14
            ri2 =~ 1*var2.12 + 1*var2.13 + 1*var2.14
            
            # Create within-person centered variables
            w1_12 =~ 1*var1.12
            w1_13 =~ 1*var1.13
            w1_14 =~ 1*var1.14
            w2_12 =~ 1*var2.12
            w2_13 =~ 1*var2.13
            w2_14 =~ 1*var2.14
            
            # Estimate the lagged effects between the within-person centered variables (constrained)
            w1_13 ~ v1_v1*w1_12 + v1_v2*w2_12
            w1_14 ~ v1_v1*w1_13 + v1_v2*w2_13
            w2_13 ~ v2_v2*w2_12 + v2_v1*w1_12
            w2_14 ~ v2_v2*w2_13 + v2_v1*w1_13
            
            # Estimate the covariance between the within-person centered variables at the first wave
            w1_12 ~~ w2_12
            
            # Estimate the covariances between the residuals of the within-person centered variables
            w1_13 ~~ cov*w2_13
            w1_14 ~~ cov*w2_14
            
            # Estimate the variance and covariance of the random intercepts
            ri1 ~~ ri1
            ri2 ~~ ri2
            ri1 ~~ ri2
            
            # Estimate the (residual) variance of the within-person centered variables
            w1_12 ~~ w1_12
            w1_13 ~~ e1*w1_13
            w1_14 ~~ e1*w1_14
            w2_12 ~~ w2_12
            w2_13 ~~ e2*w2_13
            w2_14 ~~ e2*w2_14
  
            # Constrain the means over time
            var1.12 + var1.13 + var1.14 ~ m1*1
            var2.12 + var2.13 + var2.14 ~ m2*1
  
            # Difference in cross-lagged effects
            diff := v1_v2 - v2_v1'
  # dynamically introduce variable names
  model <- str_replace_all(model, fixed("var1"), var1)
  model <- str_replace_all(model, fixed("var2"), var2)
  # remove constraints?
  if (!constrained) {
    model <- str_replace_all(model, fixed("cov*"  ), "")
    model <- str_replace_all(model, fixed("v1_v1*"), "")
    model <- str_replace_all(model, fixed("v1_v2*"), "")
    model <- str_replace_all(model, fixed("v2_v1*"), "")
    model <- str_replace_all(model, fixed("v2_v2*"), "")
    model <- str_replace_all(model, fixed("e1*"   ), "")
    model <- str_replace_all(model, fixed("e2*"   ), "")
    model <- str_replace_all(model, fixed("m1*"   ), "")
    model <- str_replace_all(model, fixed("m2*"   ), "")
  }
  # fit model
  out <- lavaan(model, data = d, missing = "fiml",
                meanstructure = T, int.ov.free = T)
  return(out)
}