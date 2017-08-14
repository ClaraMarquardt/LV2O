#----------------------------------------------------------------------------#

# Purpose:     Clear up and format generated master order file
# Author:      CM
# Date:        Nov 2016
# Language:    R (.R)

#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#                               Control Section                              #
#----------------------------------------------------------------------------#

# set-up
#-------------------------------------------------#
print(Sys.time())
current_date <- as.character(format(Sys.time(), "%d/%m/%Y")) 
start_time <- Sys.time()

# command line arguments
#-------------------------------------------------#
init_path                <- commandArgs(trailingOnly = TRUE)[1]
output_path              <- commandArgs(trailingOnly = TRUE)[2]
structured_path          <- commandArgs(trailingOnly = TRUE)[3]
execution_id             <- commandArgs(trailingOnly = TRUE)[4]
error_path               <- commandArgs(trailingOnly = TRUE)[5]
print(execution_id)


# dependencies
#-------------------------------------------------#
source(paste0(init_path, "/R_init.R"))

#----------------------------------------------------------------------------#
#                                    Code                                    #
#----------------------------------------------------------------------------#

# import the xlsx file 
#----------------------------------------------------------------------------#
master_file <- grep("xlsx", list.files(output_path), value=T)
master      <- as.data.table(read.xlsx(paste0(output_path, "/",master_file), 
				1, stringsAsFactors=F, header=T,startRow=1))
master[, filename_comb:=paste0(source.order.file.name, project, "_KEYWORD", ".pdf")]

# subset
#----------------------------------------------------------------------------#

# files
file_list <- grep("\\.pdf$", list.files(output_path), value=T)

# subset
master_omit <- master[!(filename_comb %in% file_list)]
master_keep <- master[filename_comb %in% file_list]

master_omit_filename <- unique(master_omit$filename_comb)
master_keep_filename <- unique(master_keep$filename_comb)

# save file
write.xlsx(x = master_keep, file = paste0(output_path, "/",master_file), 
        sheetName = "Master Record", 
        row.names = FALSE, append=FALSE)

# move files 

## move raw files to error path
inv_lapply(master_omit_filename, function(x) 
	file.rename(paste0(structured_path, "/", x), paste0(error_path, "/",  x)))

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#
