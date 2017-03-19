#----------------------------------------------------------------------------#

# Project:     Herkules_NLP - Master Control Settings
# Author:      Clara Marquardt
# Date:        Nov 2016

#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#                                  Settings                                  #
#----------------------------------------------------------------------------#

# initialise
#-------------------------------------------------#
current_date=$(date +"%m_%d_%Y")

# generic_settings
#-------------------------------------------------#

# directories
export wd_path_main="/Users/claramarquardt/Google_Drive/Jobs/indep_project/herkules_nlp/tool"

export wd_path_1=$wd_path_main"/code_base/experimental/part_a_extraction_parsing"
export wd_path_exec_1=$wd_path_main"/code_base/experimental/part_a_extraction_parsing"

export wd_path_2=$wd_path_main"/code_base/experimental/part_b_pdf_output"
export wd_path_3=$wd_path_main"/code_base/experimental/part_c_output_verification"
export wd_path_4=$wd_path_main"/code_base/experimental/part_hist"

export wd_path_helper=$wd_path_main"/helper"
export wd_path_data=$wd_path_main"/data"
export wd_path_exec_data=$wd_path_main"/data"

export raw_order_path="${wd_path_data}/mod_data/raw_pdf_stage_a"
export mod_order_path="${wd_path_data}/mod_data/parsed_pdf_txt_stage_b"
export parsed_order_path="${wd_path_data}/mod_data/annotated_pdf_csv_stage_c_i"
export annotated_order_path="${wd_path_data}/mod_data/annotated_pdf_csv_stage_c_ii"
export verified_order_path="${wd_path_data}/mod_data/verified_pdf_csv_stage_d_i"
export verified_order_final_path="${wd_path_data}/mod_data/verified_pdf_csv_stage_d_ii"

export annotated_sample_hist_path="${wd_path_data}/mod_data/annotated_hist/raw"
export mod_annotated_sample_hist_path="${wd_path_data}/mod_data/annotated_hist/mod"
export final_annotated_sample_hist_path="${wd_path_data}/mod_data/annotated_hist/final"

export doc_path="${wd_path_data}/mod_data/doc"
export key_word_path="${wd_path_helper}/product_identification/master_keyword.xlsm"

export code_path_1="${wd_path_1}/code"
export code_path_2="${wd_path_2}/code"
export code_path_3="${wd_path_3}/code"
export code_path_4="${wd_path_4}/code"

export code_path_exec_1="${wd_path_exec_1}/code"

export extract_code_path="${code_path_1}/function_code/extract"
export extract_code_path_exec="${code_path_exec_1}/function_code/extract"
export parse_code_path="${code_path_1}/function_code/parse"

export annotate_code_path="${code_path_2}"

export output_verification_code_path="${code_path_3}"

export annotated_hist_code_path="${code_path_4}"

# other paths
export php_path=/usr/local/opt/php56/bin
export libre_office_path=/Applications/LibreOffice.app/Contents/MacOS/soffice

# extract_settings
#-------------------------------------------------#

# email 
export email_address=marquardt.clara@gmail.com
export email_pwd=c.i.s.03H

# email filter
export email_subject=herkules_order_update
export email_date=${current_date}



#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

