#----------------------------------------------------------------------------#

# Purpose:     Master Execution Script - Stage 3
# Author:      CM
# Date:        Jan 2017
# Language:    Shell (.sh)

#----------------------------------------------------------------------------#

# Settings
#----------------------------------------------------------------------------#
source code_base/machine_code/setting.sh

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
if [ test_mode="TRUE" ]; then

	echo "TEST MODE - using test email target"

	cd ${data_path_annotated}

	file=$(ls *email_list*.csv*)
	awk -v var="$email_target" '$2=var' FS=, OFS=, ${file} > "temp_${file}"
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
cd error_path_ocr

for file in *; do

	mv $file $data_path_archived_error

done

cd error_path_parse

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





#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

