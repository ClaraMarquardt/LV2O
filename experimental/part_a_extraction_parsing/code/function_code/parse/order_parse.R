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
	text <- readLines(paste0(mod_order_path, "/",file_name))
	text <- data.table(text_line=text)
	# text[, item:=NA]

	print(text[which(text_line %like% "^#")])

   	if (nrow(text[which(text_line %like% "^#")]) >0) {

	text[which(text_line %like% "^#"), item:=1:length(which(text_line %like% "^#"))]
	
		if (is.na(text[1]$item)) text[1, item:=0]

		text[, item:=na.locf(item)]
		text[,item_id:=1:.N,by=c("item")]
	print(text[which(text_line %like% "^#")])

		# collapse text
		# text[,text_coll:=gsub("/|#|x|\\f", "", paste0(text_line, collapse="")),
		# 	by=c("item")]
		text[, item_line_count:=.N,by=c("item")]

		# nchar_text       <- nchar(text_coll)
		# nchar_text_chunk <- round(nchar_text/3, digit=0)

		# cutoff_1 <- sample(1:nchar_text_chunk ,1)
		# length_extract_1  <- sample(20:90,1)
		# cutoff_2  <- sample((nchar_text_chunk+1):(nchar_text_chunk*2),1)
		# length_extract_2  <- sample(20:90,1)
		# cutoff_3  <- sample(((nchar_text_chunk*2)+1):((nchar_text_chunk*3)-100),1)
		# length_extract_3  <- sample(20:90,1)

		# text_coll_1 <- substr(text_coll, 1,cutoff_1)
		# text_coll_extract_1 <- substr(text_coll, (cutoff_1+1), (cutoff_1+length_extract_1))
		# text_coll_2 <- substr(text_coll, (cutoff_1+length_extract_1+1),cutoff_2)
		# text_coll_extract_2 <- substr(text_coll, (cutoff_2+1), (cutoff_2+length_extract_2))
		# text_coll_3 <- substr(text_coll, (cutoff_2+length_extract_2+1),cutoff_3)
		# text_coll_extract_3 <- substr(text_coll, (cutoff_3+1), (cutoff_3+length_extract_3))
		# text_coll_4 <- substr(text_coll, (cutoff_3+length_extract_3+1),nchar(text_coll))

		# randomly pick lines
		for (i in unique(text$item)) {
			line_excl_1 <- which(nchar(text[item==i]$text_line)==0)
			line_excl_2 <- which(text[item==i]$text_line=="\f")

			line_pick <- sample(setdiff(2:max(text[item==i]$item_line_count),
				c(line_excl_1,line_excl_2)),3,replace=FALSE)
			text[item==i & item_id %in% line_pick,item_select:=1:3] 
		}

		text_extract_list  <- lapply(unique(text$item),function(x) {

			extract_temp_1 <- gsub("^[ ]*|[ ]*$", "", text[item==x & item_select==1]$text_line)
			extract_temp_2 <- gsub("^[ ]*|[ ]*$", "", text[item==x & item_select==2]$text_line)
			extract_temp_3 <- gsub("^[ ]*|[ ]*$", "", text[item==x & item_select==3]$text_line)

			return(list(extract_temp_1,extract_temp_2,extract_temp_3))

		})

		# doc <- docx()
		# highlight_style_1 <- textProperties(color='#00ff00', font.weight = 'bold')
		# highlight_style_2 <- textProperties(color='#ff0000', font.weight = 'bold')
		# highlight_style_3 <- textProperties(color='#0000ff', font.weight = 'bold')

		# text_coll_final <- text_coll_1 + pot(text_coll_extract_1,highlight_style_1) + text_coll_2 +
		# 	pot(text_coll_extract_2,highlight_style_2) + text_coll_3 +
		# 	pot(text_coll_extract_3,highlight_style_3) + text_coll_4

		# doc <- addParagraph(doc, text_coll_final)

		# writeDoc(doc, file = paste0(parsed_order_path, "/", gsub(".txt", "", file_name), ".docx"))

		# extract reg_xPatterns
		file_info_list <- lapply(unique(text$item),function(x) {

			file_info_list_temp <- list()

			file_info_list_temp$pressure 		<- text_extract_list[x+1][[1]][[1]] 
			file_info_list_temp$max_temperature <- text_extract_list[x+1][[1]][[2]] 
			file_info_list_temp$conductivity 	<- text_extract_list[x+1][[1]][[3]] 

			file_info_temp <- data.table(var=names(file_info_list_temp), 
				var_value=t(rbindlist(list(file_info_list_temp))))
			setnames(file_info_temp, c("var", "var_value"))
			
			write.csv(file_info_temp,paste0(parsed_order_path, "/",gsub("\\.txt","",file_name), 
				"_order_id_",x, "_order_extracted.csv"), row.names=F)

		})


	}

})


#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

