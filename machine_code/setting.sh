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

export wd_path=$(pwd)
echo $wd_path

echo $PATH

# directory settings
#-------------------------------------------------#

# directories [* DEFAULT SETTINGS]
export wd_path_helper=$wd_path"/helper"
export wd_path_data=$wd_path"/data"
export wd_path_helper=$wd_path"/helper"
export wd_path_log=$wd_path"/log"
export wd_path_code=$wd_path"/code_base"
export wd_path_TextToCode=$wd_path"/TextToCode"

export wd_path_output=$(cd $wd_path/../../../output; pwd)
export wd_path_interface=$(cd $wd_path/../../../interface; pwd)

## data paths
export data_path_raw=$wd_path_data"/raw_data"
export data_path_temp=$wd_path_data"/temp_data"
export data_path_parsed=$wd_path_data"/parsed_data"
export data_path_structured=$wd_path_data"/structured_data"
export data_path_annotated=$wd_path_data"/annotated_data"

## vb interface paths
export vb_path_input=$wd_path_interface"/product_code_input"
export vb_path_output=$wd_path_interface"/product_code_output"
export send_path=$wd_path_interface"/send_order"

## error_paths
export error_path_ocr=$wd_path_data"/error/ocr"
export error_path_parsed=$wd_path_data"/error/parse"

## archived paths
export data_path_archived_raw=$wd_path_data"/archived_data/raw_data"
export data_path_archived_parsed=$wd_path_data"/archived_data/parsed_data"
export data_path_archived_structured=$wd_path_data"/archived_data/structured_data"
export data_path_archived_annotated=$wd_path_data"/archived_data/annotated_data"
export data_path_archived_sent=$wd_path_data"/archived_data/sent_data"
export data_path_archived_error=$wd_path_data"/archived_data/error"

## code paths
export init_path=$wd_path_code"/helper_code"

## helper paths
export helper_path_keyword=${wd_path_helper}"/product/master_keyword.xlsm"

## texttocode app
export app_name=`cat helper/TextToCode/app_version.txt`
export database_name=`cat helper/TextToCode/database_version.txt`

export TextToCode_app=$wd_path_TextToCode"/"$app_name
export TextToCode_database=$wd_path_TextToCode"/"$database_name

export TextToCode_input=$wd_path_TextToCode"/input"
export TextToCode_output=$wd_path_TextToCode"/output"

# parsing settings [DEFAULT]
#-------------------------------------------------#
# export thorough_mode="FALSE"
export thorough_mode="TRUE"

# email settings [DEFAULT]
#-------------------------------------------------#
export email_sender=`cat helper/user_setting/email/email_sender.txt`
export email_text=`cat helper/user_setting/email/email_text.txt`
export email_pwd=`cat helper/user_setting/email/email_password.txt`
export email_address=`cat helper/user_setting/email/email_username.txt`
export email_cc_address=`cat helper/user_setting/email/email_cc_address.txt`

# Cocoa Dialogue [DEFAULT]
#-------------------------------------------------#
export CD="$wd_path/code_base/helper_code/CocoaDialog.app/Contents/MacOS/CocoaDialog"

# Excel [DEFAULT]
#-------------------------------------------------#
export EXCEL=`cat helper/user_setting/excel/excel_path.txt`

# PHP [DEFAULT]
#-------------------------------------------------#
export PHP="/usr/local/php5/bin/php"
export PHP_ini="/usr/local/php5/lib/php.ini"


#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#
