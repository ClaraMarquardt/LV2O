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
current_date <- as.character(format(Sys.time(), "%d/%m/%Y")) 

# command line arguments
#-------------------------------------------------#
mod_order_path         <- commandArgs(trailingOnly = TRUE)[1]
doc_path               <- commandArgs(trailingOnly = TRUE)[2]
key_word_path          <- commandArgs(trailingOnly = TRUE)[3]


print(mod_order_path)
print(doc_path)
print(key_word_path)

# parameters / helpers
#-------------------------------------------------#
key_word     <- as.data.table(read.xlsx(key_word_path, 1 , stringsAsFactors=F, 
    header=T,startRow=3))
key_word[get(names(key_word[,c(1), with=F]))=="END", TYPE:="END"]
key_word[, TYPE:=na.locf(TYPE)]

product_id <- c(unlist(as.data.table(read.xlsx(key_word_path, 3 , stringsAsFactors=F, 
    header=T))[, c(1),with=F]))


# regx patterns - product type
temp_key     <- unique(key_word[TYPE=="Temperature" & !(is.na(Keyword)) & Keyword %like% "[^ ]" ]$Keyword)
pressure_key <- unique(key_word[TYPE=="Pressure" & !(is.na(Keyword)) & Keyword %like% "[^ ]" ]$Keyword)
zubehoer_key <- unique(key_word[TYPE=="Zubehoer" & !(is.na(Keyword)) & Keyword %like% "[^ ]" ]$Keyword)

product_type_list <- c("temp_key", "pressure_key", "zubehoer_key")

for (i in product_type_list) {

    temp <- get(i)
    temp <- gsub("^[ ]*|[ ]*$", "", temp)
    temp <- paste0(temp, collapse="|")

    assign(i, temp)

}

# regx patterns - product id
product_id_orig <- copy(product_id)
product_id      <- gsub("-|/|\\.|\\(|\\)| |,|\\&", "", product_id)

product_id_xwalk <-data.table(id=product_id, id_orig=product_id_orig)

product_id_key <- unique(gsub("(....)(.*)", "\\1", product_id))
product_id_key <- product_id_key[!is.na(product_id_key)]
product_id_key <- paste0(product_id_key, collapse="|")

product_id_ext_key <- unique(product_id)
product_id_ext_key <- product_id_ext_key[!is.na(product_id_ext_key)]
# product_id_ext_key <- paste0(product_id_ext_key, collapse="|")


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
    text[,item:=""]
    text[which(text_line %like% "^#"), item:=1:length(which(text_line %like% "^#"))]
    text[, item:=as.integer(item)]

    if (is.na(text[1]$item)) text[1, item:=0]
    text[, item:=na.locf(item)]
    text <- text[!(item==0)]

    if (nrow(text)>0){

    # clean 
    #-----------------------------------------#
    text[,text_line_mod:=""]
    text[!(text_line %like% "^#"), text_line_mod:=gsub("(.*)([ ]{15,})([a-zA-Z*]{1,}.*)", "\\3", text_line), 
        by=1:nrow(text[!(text_line %like% "^#")])]
    text[(text_line %like% "^#"), text_line_mod:=gsub("(#order-item: [0-9]*)(.*)", "\\1", text_line), 
        by=1:nrow(text[(text_line %like% "^#")])]

    print(head(text))

    text[, text_line_mod:=gsub("^[ ]*", "", text_line_mod), 
        by=1:nrow(text)]
    text[, text_line_mod:=gsub("[ ]*$", "", text_line_mod), 
        by=1:nrow(text)]
    text[, text_line_mod:=gsub("((Stck|Stk|St)( )[0-9]*)(.*)", "\\1", text_line_mod), 
        by=1:nrow(text)]

    # identify product id
    text[, detail_id:=""]
    text[, detail_price:=""]
    text[, text_line_mod_temp:=gsub("[ ]*", "", text_line_mod)]
    text[, text_line_mod_temp:=gsub("-|/|\\.|\\(|\\)|,|\\&", "", text_line_mod_temp)]


    # text[text_line_mod %like% "\\+" & text_line_mod %like% "[0-9]", ':='(detail=text_line_mod, 
    #     text_line_mod="")]
    # text[text_line_mod %like% "\\+" & text_line_mod %like% "[0-9]", ':='(detail=text_line_mod)]
    text[text_line_mod_temp %like% product_id_key, ':='(detail_id=text_line_mod_temp)]
    text[text_line_mod %like% "[0-9]{1,},[0-9]{1,}", ':='(detail_price=text_line_mod)]

    text[detail_id=="", detail_id:=NA]
    text[detail_price=="", detail_price:=NA]

    # text[, c("hist_id"):=gsub("([a-zA-Z0-9/\\.\\+ ]*)([ ]{5,})([0-9,\\+ ]*$)", "\\1", detail)]
    # text[!(text_line_mod %like% "\\+"), c("hist_id"):=gsub(paste0("(.*)(, ", 
    #     product_id_key, ")([^ ]*)(.*)"), "\\2\\3", detail_id)]
    # text[(text_line_mod %like% "\\+"), c("hist_id"):=gsub(paste0("(.*)(, ", 
    #     product_id_key, ")([^ ]*)(.*)(\\+)(.*)(, ",product_id_key, ")([^ ]*)(.*)"), 
    #     "\\2\\3+\\7\\8", detail_id)]
    # text[, c("hist_id"):=gsub(paste0("(.*)(, ", 
    #     product_id_ext_key, ")(.*)(\\+)(.*)(, ",product_id_ext_key, ")(.*)"), 
    #     "\\2+\\6", detail_id)]

    text[!(is.na(detail_id)), c("hist_id"):=gsub(paste0("(",  
        paste0(product_id_ext_key[which(sapply(gsub("(....)(.*)", "\\1", 
        product_id_ext_key), function(x) as.logical(grep(x,detail_id)))==TRUE)],collapse="|"), ")"), "----\\1_---", 
        detail_id), by=1:nrow(text[!(is.na(detail_id))])]
    text[!(hist_id %like% "---_|_---"), ':='(hist_id=NA, detail_id=NA)]

    text[, hist_id:=gsub("_---.*----", "----", hist_id)]
    text[, hist_id:=gsub("^.*----", "", hist_id)]
    text[, hist_id:=gsub("_---.*$", "", hist_id)]
    text[, text_line_mod_temp:=NULL]

    # text[, c("hist_price"):=gsub("([a-zA-Z0-9/\\.\\+ ]*)([ ]{5,})([0-9,\\+ ]*$)", "\\3", detail)]
    text[, c("hist_price"):="/"]

    text[, hist_id:=gsub("^[ ]*|[ ]*$", "", hist_id)]
    text[, hist_price:=gsub("^[ ]*|[ ]*$", "", hist_price)]

    # text[, hist_id:=gsub("\\+", "----", hist_id), by=1:nrow(text)]
    # text[, hist_price:=gsub("\\+", "----", hist_price), by=1:nrow(text)]
    text[, hist_id:=hist_id[!is.na(hist_id)], by=c("item")]
    text[, hist_price:=hist_price[!is.na(hist_price)], by=c("item")]

    # split product ids and prices  (simple for now - 2 max)
    text[hist_id %like% "----",c("hist_id_1","hist_id_2"):=tstrsplit(hist_id,"----"), by=1:nrow(text)]
    text[!(hist_id %like% "----"),':='(hist_id_1=hist_id, hist_id_2=NA), by=1:nrow(text)]

    # text[,c("hist_price_1","hist_price_2"):=tstrsplit(hist_price,"----"), by=1:nrow(text)]]
    text[,c("hist_price_1","hist_price_2"):="/", by=1:nrow(text)]
    text[, c("hist_id", "hist_price"):=NULL]
    text[,c(grep("hist",names(text),value=T)):=lapply(.SD,function(x) gsub("^[ ]*|[ ]*$", "",x)),
        .SDcols=grep("hist",names(text),value=T)]

    # merge in orignal product ids
    text <- product_id_xwalk[!is.na(id)][text, on=c(id="hist_id_1"), nomatch=NA]
    text[, id:=NULL]
    setnames(text, "id_orig","hist_id_1")
    text <- product_id_xwalk[!is.na(id)][text, on=c(id="hist_id_2"), nomatch=NA]
    text[, id:=NULL]
    setnames(text, "id_orig","hist_id_2")

    # record origin file
    text[, origin_file_name:=gsub("\\.txt", "", file_name)]

    # record date
    text[, date_processed:=current_date]

    # clean
    text[!(text_line_mod %like% "[a-zA-Z]{3,}") & !(text_line_mod %like% "(Stck|Stk|St)( |$)"), 
        text_line_mod:=""]
    text <- text[!(text_line_mod=="" & is.na(detail_id))]
    text[, detail_id:=NULL]
    text[, detail_price:=NULL]

    text <- text[!(text_line_mod %like% "Seite|Datum|Ubertrag|Projekt|@|Mail|Fax|Tel|GmbH|Str\\.")]
    text[,text_line_mod:=gsub("[\\* ]*Eventualposition", "", text_line_mod),by=1:nrow(text)]
    text[,text_line_mod:=gsub("(,|\\.|\\\")$", "", text_line_mod), by=1:nrow(text)]
    text[,text_line_mod:=gsub("^[ ]*|[ ]*$", "", text_line_mod), by=1:nrow(text)]

    # location clean
    location_header <- c("Karlsruhe|Datum|Seite")

    location_header_pattern <- gsub("\\|$", "", paste0(location_header, sep="|"))
    text <- text[!(text_line_mod %like% location_header_pattern)]


    # identify non products 
    #-----------------------------------------#
    text[, st_sum:=sum(text_line_mod %like% "(Stck|Stk|St)( |$)"), by=c("item")]

    # clean extended
    text <- text[!(text_line_mod %like% "(Stck|Stk|St)( |$)")]
    text[, text_line_mod:=gsub("Übertrag:", "",text_line_mod )]

    text[st_sum==0, item:=NA]
    text <- text[!is.na(item)]


    # merge
    #-----------------------------------------#
    text[, prod_desc:=paste0(text_line_mod[!(text_line_mod %like% "^#")], collapse="\n"), by=c("item")]
    dt_final <- text[, .(date_processed, prod_desc, hist_id_1, hist_price_1, hist_id_2, hist_price_2, origin_file_name, item)]
    dt_final <- unique(dt_final, by=c("item"))
    # dt_final[!(prod_desc %like% "^#"), prod_desc:=paste0(c("#order-item: ", item, "\n", 
    #     prod_desc), collapse=""), by=1:nrow(dt_final[!(prod_desc %like% "^#")])]
    setnames(dt_final, c("date_processed", "prod_desc", "historical product ID #1", "historical price #1", 
        "historical product ID #2", "historical price #2","source order file name",
        "source order-item number"))

    # clean
    dt_final[, prod_desc:=gsub("\n$", "",prod_desc )]
    dt_final[, prod_desc:=gsub("[\n]{2,}", "\n",prod_desc )]
    

    # identify product type 
    #-----------------------------------------#
    dt_final[, product_type:=""]

    dt_final[!is.na(get("historical product ID #1")) & prod_desc %like% temp_key, 
        product_type:="temperature "]
    dt_final[!is.na(get("historical product ID #1")) & prod_desc %like% pressure_key, 
        product_type:=paste0(product_type, "pressure ")]
    dt_final[!is.na(get("historical product ID #1")) & prod_desc %like% zubehoer_key, 
        product_type:=paste0(product_type, "zubehoer ")]

    # output
    #-----------------------------------------#
    print(dt_final)
    # write.csv(dt_final,paste0(doc_path, "/",gsub("\\.txt","",file_name), 
    #             "_order_cleaned.csv") , row.names=F,fileEncoding = "UTF-8")
    
    dt_final_identified <- dt_final[!is.na(get("historical product ID #1"))]
    dt_final_identified[, master_product_id:=0]
    dt_final[, master_product_id:=0]

    output_file <- paste0(doc_path, "/", "order_master_database.xlsx")

    if (file.exists (output_file)) {

        dt_final_orig            <- read.xlsx(output_file, 
            sheetName = "Master Record - Raw", stringsAsFactors=F, 
            check.names=F)
        print(names(dt_final_orig))
        dt_final_identified_orig <- read.xlsx(output_file, 
            sheetName = "Master Record - Identified", stringsAsFactors=F, 
            check.names=F)
        print(names(dt_final_identified_orig))

        dt_final <- rbindlist(list(dt_final_orig, dt_final), use.names=T, fill=T)
        dt_final_identified <- rbindlist(list(dt_final_identified_orig, 
            dt_final_identified), use.names=T,fill=T)

    }
    
    # generate master product id
    dt_final_identified[,master_product_id:=1:nrow(dt_final_identified)]
    setcolorder(dt_final_identified, c("master_product_id", setdiff(names(dt_final_identified), 
        "master_product_id")))

    dt_final[,master_product_id:=1:nrow(dt_final)]
    setcolorder(dt_final, c("master_product_id", setdiff(names(dt_final), 
        "master_product_id")))

    write.xlsx(x = dt_final_identified, file = output_file, 
                sheetName = "Master Record - Identified", row.names = FALSE)
    write.xlsx(x = dt_final, file = output_file, 
                sheetName = "Master Record - Raw", row.names = FALSE, append=TRUE)

    }
})
#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

