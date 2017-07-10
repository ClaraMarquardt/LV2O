#----------------------------------------------------------------------------#

# Purpose:     Master Execution Script - Stage 2
# Author:      CM
# Date:        Jan 2017
# Language:    Shell (.sh)

#----------------------------------------------------------------------------#

# Settings
#----------------------------------------------------------------------------#
source code_base/machine_code/setting.sh

#----------------------------------------------------------------------------#
#----------------------------------------------------------------------------#
# Visual Basic Macro (Input: Csv Output: Xlsx)
#----------------------------------------------------------------------------#
#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#----------------------------------------------------------------------------#
# Execution Commmand #2
#----------------------------------------------------------------------------#
#----------------------------------------------------------------------------#

# Stage-c: Annotate PDFs
# ----------------------------------------------------------------------------#
cd ${wd_path_code}/stage_c

ipython order_output.py "${init_path}" "${vb_path_output}" "${data_path_archived_raw}" \
	"${data_path_archived_structured}" "${execution_id}" \
	"${data_path_annotated}" "${wd_path_log}" "${data_path_archived_vb_input}" \
	"${data_path_archived_vb_output}" "$vb_path_input"


# Stage-d: Generate and mail out identified PDFs
# ----------------------------------------------------------------------------#


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

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

