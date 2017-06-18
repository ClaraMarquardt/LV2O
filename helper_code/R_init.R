# R init

# ---------------------------------------
# external dependencies
# ---------------------------------------

## ehR
library(ehR)

## other dependencies
package_list <-list( "dplyr", "data.table","stringr","lubridate",
  "icd", "taxize", "tidyr", "reshape", "reshape2", "xlsxjars", 
  "xlsx", "ggplot2", "RODBC", "knitr",
  "rmarkdown", "ReporteRs","zoo")
load_or_install(package_list)
