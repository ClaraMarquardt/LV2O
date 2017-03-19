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
parse_code_path   <-  commandArgs(trailingOnly = TRUE)[3]

print(mod_order_path)
print(parsed_order_path)
print(parse_code_path)

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

	# extract and format text
	text <- readLines(paste0(mod_order_path, "/",file_name))

	text_coll <- gsub("/|#|x|\\f", "", paste0(text, collapse=""))

	nchar_text <- nchar(text_coll)
	nchar_text_chunk <- round(nchar_text/3, digit=0)

	cutoff_1 <- sample(1:nchar_text_chunk ,1)
	length_extract_1  <- sample(20:90,1)
	cutoff_2  <- sample((nchar_text_chunk+1):(nchar_text_chunk*2),1)
	length_extract_2  <- sample(20:90,1)
	cutoff_3  <- sample(((nchar_text_chunk*2)+1):((nchar_text_chunk*3)-100),1)
	length_extract_3  <- sample(20:90,1)

	text_coll_1 <- substr(text_coll, 1,cutoff_1)
	text_coll_extract_1 <- substr(text_coll, (cutoff_1+1), (cutoff_1+length_extract_1))
	text_coll_2 <- substr(text_coll, (cutoff_1+length_extract_1+1),cutoff_2)
	text_coll_extract_2 <- substr(text_coll, (cutoff_2+1), (cutoff_2+length_extract_2))
	text_coll_3 <- substr(text_coll, (cutoff_2+length_extract_2+1),cutoff_3)
	text_coll_extract_3 <- substr(text_coll, (cutoff_3+1), (cutoff_3+length_extract_3))
	text_coll_4 <- substr(text_coll, (cutoff_3+length_extract_3+1),nchar(text_coll))


	doc <- docx()
	highlight_style_1 <- textProperties(color='#00ff00', font.weight = 'bold')
	highlight_style_2 <- textProperties(color='#ff0000', font.weight = 'bold')
	highlight_style_3 <- textProperties(color='#0000ff', font.weight = 'bold')

	text_coll_final <- text_coll_1 + pot(text_coll_extract_1,highlight_style_1) + text_coll_2 +
		pot(text_coll_extract_2,highlight_style_2) + text_coll_3 +
		pot(text_coll_extract_3,highlight_style_3) + text_coll_4

	doc <- addParagraph(doc, text_coll_final)

	writeDoc(doc, file = paste0(parsed_order_path, "/", gsub(".txt", "", file_name), ".docx"))

	# extract reg_xPatterns
	file_info_list <- list()

	file_info_list$pressure <- text_coll_extract_1 
	file_info_list$max_temperature <- text_coll_extract_2
	file_info_list$conductivity <- text_coll_extract_3

	# # save extracted info  (csv)
	file_info <- data.table(names(file_info_list), t(rbindlist(list(file_info_list))))
	setnames(file_info,c("var", "var_value"))
	write.csv(file_info,paste0(parsed_order_path, "/",file_name, "_order_extracted.csv"), 
		row.names=F)


})

# convert to pdf and bind
#----------------------------------------------------------------------------#
system(sprintf("source %s", paste0(parse_code_path, "/order_post_parse.sh")))

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

