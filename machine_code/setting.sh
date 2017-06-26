#----------------------------------------------------------------------------#

# Purpose:     Master Settings
# Author:      CM
# Date:        Jan 2017
# Language:    Shell (.sh)

#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#                                  Settings                                  #
#----------------------------------------------------------------------------#


# initialise  [* DEFAULT]
#-------------------------------------------------#
export execution_id=`date +%s`
echo $execution_id

export current_date=$(date +"%m_%d_%Y")
echo $current_date

# directory settings
#-------------------------------------------------#

# directories [CUSTOMISE]
export wd_path="/Users/claramarquardt/Google_Drive/Jobs/indep_project/herkules_nlp/tool" ## DEV mode
# export wd_path="/Users/[username]/..../tool"                                           ## PRODUCTION mode

# directories [* DEFAULT SETTINGS]
export wd_path_helper=$wd_path"/helper"
export wd_path_data=$wd_path"/data"
export wd_path_helper=$wd_path"/helper"
export wd_path_log=$wd_path"/log"
export wd_path_vb=$wd_path"/vb_interface"
export wd_path_code=$wd_path"/code_base"

# subdirectories [* DEFAULT SETTINGS]

## data paths
export data_path_raw=$wd_path_data"/raw_data"
export data_path_temp=$wd_path_data"/temp_data"
export data_path_parsed=$wd_path_data"/parsed_data"
export data_path_structured=$wd_path_data"/structured_data"
export data_path_annotated=$wd_path_data"/annotated_data"

## vb interface paths
export vb_path_input=$wd_path_vb"/input"
export vb_path_output=$wd_path_vb"/output"

## error_paths
export error_path_ocr=$wd_path_data"/error/ocr"
export error_path_parsed=$wd_path_data"/error/parse"

## archived paths
export data_path_archived_raw=$wd_path_data"/archived_data/raw_data"
export data_path_archived_parsed=$wd_path_data"/archived_data/parsed_data"
export data_path_archived_structured=$wd_path_data"/archived_data/structured_data"
export data_path_archived_vb_input=$wd_path_data"/archived_data/vb_input"
export data_path_archived_vb_output=$wd_path_data"/archived_data/vb_output"
export data_path_archived_annotated=$wd_path_data"/archived_data/annotated_data"

## code paths
export init_path=$wd_path_code"/helper_code"

## helper paths
export helper_path_keyword=${wd_path_helper}"/product_identification/master_keyword.xlsm"

# parsing settings [DEFAULT]
#-------------------------------------------------#
# export thorough_mode="FALSE"
export thorough_mode="TRUE"

# email settings [DEFAULT]
#-------------------------------------------------#

export email_address=`cat helper/email_id/email_username.txt`
export email_pwd=`cat helper/email_id/email_password.txt`


#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#
