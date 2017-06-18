# ehR package 
library(devtools)
install_github("claramarquardt/ehR", dependencies = TRUE)   
library(ehR)

# packages to install
package_list <-list( "dplyr", "data.table","stringr","lubridate", "icd", "taxize", 
  "tidyr", "reshape", "reshape2", "xlsxjars", "xlsx", "ggplot2", "RODBC", "knitr",
  "rmarkdown", "ReporteRs","zoo")

# load or install
load_or_install(package_list)