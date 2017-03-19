#----------------------------------------------------------------------------#

# Purpose:     Project
# Author:      Clara Marquardt
# Date:        Nov 2016

#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#                               Control Section                              #
#----------------------------------------------------------------------------#

# set-up
#-------------------------------------------------#
print(sessionInfo())
print(Sys.time())
current_date <- as.character(format(Sys.time(), "%d_%m_%Y")) 

# command line arguments
#-------------------------------------------------#
mod_order_path    <- commandArgs(trailingOnly = TRUE)[1]
parsed_order_path <-  commandArgs(trailingOnly = TRUE)[2]

print(mod_order_path)
print(parsed_order_path)

# parameters
#-------------------------------------------------#

# regx patterns
# xxx <- "fhdsjkfhdsjk: ()" ## 1
# xxx <- "fhdsjkfhdsjk: ()" ## 1
# xxx <- "fhdsjkfhdsjk: ()" ## 1


#----------------------------------------------------------------------------#
#                                    Code                                    #
#----------------------------------------------------------------------------#

# obtain file list 
#----------------------------------------------------------------------------#
file_list <- list.files(mod_order_path)
file_list <- file_list[file_list %like% "txt"]

# iterate over files
#----------------------------------------------------------------------------#

lapply(file_list, function(file_name) {

	print(file_name)

	# import text & identify products
	#-----------------------------------------#
	text <- readLines(paste0(mod_order_path, "/",file_name))
	text <- data.table(text_line=text)
	
	# identify product breaks
	#-----------------------------------------#
	text[which(text_line %like% "^#"), item:=1:length(which(text_line %like% "^#"))]
	if (is.na(text[1]$item)) text[1, item:=0]
	text[, item:=na.locf(item)]

	# clean 
	#-----------------------------------------#
	text[!(text_line %like% "^#"), text_line_mod:=gsub("(.*)([ ]{15,})([a-zA-Z*]{1,}.*)", "\\3", text_line), 
		by=1:nrow(text[!(text_line %like% "^#")])]
	text[(text_line %like% "^#"), text_line_mod:=gsub("(#order-item: [0-9]*)(.*)", "\\1", text_line), 
		by=1:nrow(text[(text_line %like% "^#")])]

	text[, text_line_mod:=gsub("^[ ]*", "", text_line_mod), 
		by=1:nrow(text)]
	text[, text_line_mod:=gsub("[ ]*$", "", text_line_mod), 
		by=1:nrow(text)]
	text[, text_line_mod:=gsub("((Stck|Stk|St)( )[0-9]*)(.*)", "\\1", text_line_mod), 
		by=1:nrow(text)]

	text[!(text_line_mod %like% "[a-zA-Z]{3,}") & !(text_line_mod %like% "(Stck|Stk|St)( |$)"), 
		text_line_mod:=""]
	text <- text[text_line_mod!=""]
	text <- text[!(text_line_mod %like% "Seite|Datum|Ubertrag|Projekt|@|Mail|Fax|Tel|GmbH|Str\\.")]
	text[,text_line_mod:=gsub("[\\* ]*Eventualposition", "", text_line_mod),by=1:nrow(text)]
	text[,text_line_mod:=gsub("(,|\\.|\\\")$", "", text_line_mod), by=1:nrow(text)]
	text[,text_line_mod:=gsub("^[ ]*|[ ]*$", "", text_line_mod), by=1:nrow(text)]

	# identify non products 
	#-----------------------------------------#
	text[, st_sum:=sum(text_line_mod %like% "(Stck|Stk|St)( |$)"), by=c("item")]
	text[st_sum==0, item:=NA]
	text <- text[!is.na(item)]

	# merge
	#-----------------------------------------#
	text[, prod_desc:=paste0(text_line_mod, collapse="\n"), by=c("item")]
	dt_final <- text[, .(prod_desc, item)]
	dt_final <- unique(dt_final, by=c("item"))
	dt_final[!(prod_desc %like% "^#"), prod_desc:=paste0(c("#order-item: ", item, "\n", 
		prod_desc), collapse=""), by=1:nrow(dt_final[!(prod_desc %like% "^#")])]
	setnames(dt_final, c("prod_desc", "order_item"))


	# output
	#-----------------------------------------#
	write.csv(dt_final,paste0(parsed_order_path, "/",gsub("\\.txt","",file_name), 
				"_order_cleaned.csv") , row.names=F)

})


#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

