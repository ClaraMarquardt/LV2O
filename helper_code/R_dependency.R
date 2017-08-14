# ---------------------------------------
# external dependencies
# ---------------------------------------

## ehR - load or install function
load_or_install <- function(package_names, verbose=FALSE, upgrade=FALSE) {  

  # obtain & save default path
  # -----------------------------
  print(.libPaths())

  # upgrade packages
  # -----------------------------
  if (upgrade==TRUE) {

    print("Updating Packages")

    tryCatch({update.packages(ask = FALSE, repos = "https://cran.rstudio.com", 
      checkBuilt = TRUE, type="source")}, error=function(e) {print("Package update failed")})
  
  }


  # install (if required, i.e. not yet installed)  
  # -----------------------------
  lapply(package_names, function(x) if(!x %in% c(
      installed.packages()[,"Package"])) {
    
       print(sprintf("Fresh Install: %s", x))
    
       suppressMessages(install.packages(x,
        repos="https://cran.rstudio.com", 
        type="source"))

  })
 
  # load
  # -----------------------------
  packages_loaded <- lapply(package_names, function(x) {
    if (verbose==TRUE) {
      print(sprintf("Loading: %s", x))
    }

    suppressMessages(library(x,
        character.only=TRUE, quietly=TRUE,verbose=FALSE))

  })

} 

# ---------------------------------------
# external dependencies
# ---------------------------------------
package_list <- list( "rJava","dplyr", "data.table","stringr","lubridate",
  "tidyr","reshape", "reshape2", "xlsxjars", "xlsx","zoo")
load_or_install(package_names=package_list, upgrade=TRUE)




