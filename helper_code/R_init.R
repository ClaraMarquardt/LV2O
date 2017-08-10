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

    tryCatch({update.packages(ask = FALSE, repos = "http://cran.cnr.berkeley.edu/", 
      checkBuilt = TRUE, type="source")}, error=function(e) {print("Package update failed")})
  
  }

  # install (if required, i.e. not yet installed)  
  # -----------------------------
  lapply(package_names, function(x) if(!x %in% c(
      installed.packages()[,"Package"])) {
    
       print(sprintf("Fresh Install: %s", x))
    
       suppressMessages(install.packages(x,
        repos="http://cran.cnr.berkeley.edu/", 
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
load_or_install(package_names=package_list, upgrade=FALSE)

# ---------------------------------------
# embedded dependencies
# ---------------------------------------

# set_zero_na
#----------------------------------------------------------------------------#
set_zero_na <- function(dt, replace=NA) {

  for (j in seq_len(ncol(dt)))
    set(dt, which(dt[[j]] %in% c(0)), j, replace)
}

# set_na_zero
#----------------------------------------------------------------------------#

set_na_zero <- function(dt, replace=0, subset_col=names(dt)) {

  for (j in which(names(dt) %in% subset_col))
    set(dt, which(is.na(dt[[j]]) | dt[[j]] %in% c(-Inf, +Inf) ), j, replace)

}

# set_missing_na
#----------------------------------------------------------------------------#

set_missing_na <- function(dt, replace=NA, subset_col=names(dt)) {

  for (j in which(names(dt) %in% subset_col))
    set(dt, which(gsub("[ ]*", "", dt[[j]])==""), j, replace)
}

# ps
#----------------------------------------------------------------------------#

ps <- function(char_string, ...) {

     print(sprintf(char_string, ...))
}

# out
#----------------------------------------------------------------------------#

out <- function(obj, path) {

  if (path %like% "csv") {

    write.csv(obj, path, row.names=F)

  } else if(path %like% "pdf|jpeg|png") {

    ggsave(obj, path)

  }  else if(path %like% "Rds") {

    saveRDS(obj, path)

  } else if (path %like% "txt") {

  	write.table(obj, path)

  }

}

# inv_lapply
#----------------------------------------------------------------------------#

inv_lapply <- function(X, FUN,...) {

  invisible(lapply(X, FUN,...))

}

#----------------------------------------------------------------------------#
