# R init

# ---------------------------------------
# external dependencies
# ---------------------------------------

## ehR - load or install function
load_or_install <- function(package_names, custom_lib_path=FALSE, 
  custom_path=NA, verbose=FALSE, local_package=FALSE, 
  local_package_path=NA) {  


  # obtain & save default path
  # -----------------------------
  library(devtools)
  dev_mode(FALSE)
  default_path     <- .libPaths()[1]

  # dev tools & dev mode
  # -----------------------------
  library(devtools)
  # set to dev_mode 
  dev_mode(TRUE)

  # lib path
  # -----------------------------
  if (custom_lib_path==TRUE) {

    if (!dir.exists(custom_path)) {
      dir.create(custom_path)
    }

    if (!("dev" %in% list.files(custom_path))) {
      dir.create(paste0(custom_path, "/dev"))
    }

    lib_path     <- custom_path
    lib_dev_path <- paste0(custom_path, "/dev")

    print(sprintf("lib_path: %s", lib_path))

  } else if (custom_lib_path==FALSE) {

    lib_path     <- default_path
    lib_dev_path <- default_path

    print(sprintf("lib_path: %s", lib_path))

  }

  if (local_package==FALSE) {

     # install (if required, i.e. not yet installed)  
     # -----------------------------
     
     ## extended - handle special cases
     lapply(package_names, function(x) if(!x %in% c(installed.packages(
       lib.loc=lib_path), installed.packages(lib.loc=lib_dev_path))) {
    
       print(sprintf("Fresh Install: %s", x))
    
    
       # install
       if (x=="data.table") {
    
         suppressMessages(withr::with_libpaths(new = lib_path,
           install_version("data.table", version = "1.9.6",
           repos = "http://cran.us.r-project.org",
           dependencies=TRUE)))
    
       } else {
    
         suppressMessages(install.packages(x,repos="http://cran.cnr.berkeley.edu/", 
           dependencies=TRUE, lib=lib_path))
    
      }
   
  })
 
 } 

  # load
  # -----------------------------

  packages_loaded <- lapply(package_names, function(x) {
    if (verbose==TRUE) {
      print(sprintf("Loading: %s", x))
    }

    suppressMessages(library(x,
        character.only=TRUE, quietly=TRUE,verbose=FALSE, 
        lib.loc=lib_path))

  })

}
# ---------------------------------------
# external dependencies
# ---------------------------------------
package_list <-list("devtools", "dplyr", "data.table","stringr","lubridate",
  "tidyr", "reshape", "reshape2", "xlsxjars", "xlsx","zoo")
load_or_install(package_list)

# ---------------------------------------
# embedded dependencies
# ---------------------------------------

#----------------------------------------------------------------------------#

#' Replace (in place) zeros in in data.table with another value.
#' @export
#' @param name Name of data.table [character]
#' @param replace Value with which to replace 0s  [any]
#' @return Data.table modified in place
#' @examples
#' TBC

set_zero_na <- function(dt, replace=NA) {

  for (j in seq_len(ncol(dt)))
    set(dt, which(dt[[j]] %in% c(0)), j, replace)
}

#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#

#' Replace (in place) NAs/+inf/-inf in data.table with another value.
#' @export
#' @param name Name of data.table [character]
#' @param replace Value with which to replace Nas/+inf/-inf  [any]
#' @return Data.table modified in place
#' @examples
#' TBC

set_na_zero <- function(dt, replace=0, subset_col=names(dt)) {

  for (j in which(names(dt) %in% subset_col))
    set(dt, which(is.na(dt[[j]]) | dt[[j]] %in% c(-Inf, +Inf) ), j, replace)

}

#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#

#' Replace (in place) empty values ("[ ]*" or "") in data.table with another value.
#' @export
#' @param name Name of data.table [character]
#' @param replace Value with which to replace empty values  [any]
#' @return Data.table modified in place
#' @examples
#' TBC

set_missing_na <- function(dt, replace=NA, subset_col=names(dt)) {

  for (j in which(names(dt) %in% subset_col))
    set(dt, which(gsub("[ ]*", "", dt[[j]])==""), j, replace)
}

#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#

#' Print(sprintf(...).
#' @export
#' @param  TBC
#' @return TBC
#' @examples
#' TBC

ps <- function(char_string, ...) {

     print(sprintf(char_string, ...))
}

#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#

#' Save R objects to different formats.
#' 
#' @export
#' @param  TBC
#' @return TBC
#' @examples
#' TBC

out <- function(obj, path) {

  # purpose: 
  # save .csv,.pdf,.Rds files

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

#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#

#' Invisible lapply.
#' @export
#' @param  TBC
#' @return TBC
#' @examples
#' TBC

inv_lapply <- function(X, FUN,...) {

  invisible(lapply(X, FUN,...))

}

#----------------------------------------------------------------------------#
