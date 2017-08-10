#----------------------------------------------------------------------------#

# Purpose:     Master Execution Script - Stage 3
# Author:      CM
# Date:        Jan 2017
# Language:    Shell (.sh)

#----------------------------------------------------------------------------#

# Settings
#----------------------------------------------------------------------------#
source code_base/machine_code/setting.sh

# User settings
#----------------------------------------------------------------------------#
export test_mode=`$CD dropdown --title "LV20 - SendToCustomer" --text "Mode" --items "Send to Customer" "Send to (Internal) Test Address" --button1 "  OK  " ‑‑no‑cancel`
export test_mode=${test_mode:2}

if [ "$test_mode" = "1" ]; then
	export email_target=`$CD inputbox --title "LV20 - SendToCustomer" --informative-text "(Internal) email address to which to send orders (Non-Gmail)" --button1 "  OK  " ‑‑no‑cancel`
	export email_target=${email_target:2}
fi

# Output folder
#----------------------------------------------------------------------------#
output_folder=${wd_path_output}/SendToCustomer_$execution_id
mkdir $output_folder

cd $output_folder

mkdir log
mkdir sent_order

#----------------------------------------------------------------------------#
#----------------------------------------------------------------------------#
# Execution Commmand #3
#----------------------------------------------------------------------------#
#----------------------------------------------------------------------------#

# replace source emails with test email (TEEST MODE only)
# ----------------------------------------------------------------------------#
if [ "${test_mode}" = "1" ]; then

	echo "TEST MODE - using test email target"

	cd ${send_path}

	file=$(ls *email_list*.csv*)
	awk -v var="$email_target" '$1=var' FS=, OFS=, ${file} > "temp_${file}"
	mv temp_${file} ${file}

fi

# execute
#---------------------------------------------------#
cd ${wd_path_code}/stage_d

php "send_email.php"

## move processed files to archive
cd "${data_path_annotated}"

for file in *; do

	mv $file $data_path_archived_annotated

done


## move error files to archive
cd $error_path_ocr

for file in *; do

	mv $file $data_path_archived_error

done

cd ${error_path_parsed}

for file in *; do

	mv $file $data_path_archived_error

done


# Stage-x: Copy to output folder
#----------------------------------------------------------------------------#

# sent mail
cd ${send_path}

for file in *$execution_id*; do

	mv $file $data_path_archived_sent

done

# log files
cd ${wd_path_log}

for file in *$execution_id*; do

	mv $file $output_folder/log

done


# Stage-x: Clear interface folder
#----------------------------------------------------------------------------#

# interface
cd ${wd_path_interface}

find  . -type f -name "*" -exec rm {} \;


#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

