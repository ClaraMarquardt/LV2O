#----------------------------------------------------------------------------#

# Purpose:     Master Execution Script - Stage 1
# Author:      CM
# Date:        Jan 2017
# Language:    Shell (.sh)

#----------------------------------------------------------------------------#

# Output folder
#----------------------------------------------------------------------------#
output_folder=${wd_path_output}/ExtractToExcel_$execution_id
mkdir $output_folder

cd $output_folder

mkdir log
mkdir non_processed_PDF
mkdir raw_order
mkdir processed_order

#----------------------------------------------------------------------------#
#                         Step-by-Step Tool Execution                        #
#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#----------------------------------------------------------------------------#
# Execution Command #1
#----------------------------------------------------------------------------#
#----------------------------------------------------------------------------#

# Stage-a: Extract relevant PDFs from all incoming emails
#----------------------------------------------------------------------------#

# execute
#---------------------------------------------------#
cd ${wd_path_code}/stage_1a
${PHP} -c ${PHP_ini} -f email_extract.php
source order_parse.sh

# Stage-b: Split PDFs
#----------------------------------------------------------------------------#

# execute
#---------------------------------------------------#
cd ${wd_path_code}/stage_1b

ipython order_parse.py "${init_path}" "${data_path_parsed}" "${data_path_structured}" \
"${error_path_parsed}" "${data_path_archived_parsed}" "${wd_path_log}" "${execution_id}" 

cd "${data_path_structured}"

for file in *; do

	# extract 
	pdftotext -layout "${file}" 

done

# execute
#---------------------------------------------------#
cd ${wd_path_code}/stage_1b

R CMD BATCH --no-save "--args ${init_path} ${data_path_structured} \
${helper_path_keyword} ${execution_id} ${wd_path_log} \
${data_path_temp} ${data_path_archived_structured}" order_clean.R

## delete output file
[ -e .RData ] && rm .RData
[ -e order_clean.Rout ] && rm order_clean.Rout

# Stage-x: Copy to output folder
#----------------------------------------------------------------------------#

# raw orders
cd ${data_path_archived_raw}

for file in *$execution_id*; do

	if [ -e $file ]; then
		cp $file $output_folder/raw_order
	fi

done


# parsed orders & vb output
cd ${data_path_archived_structured}

for file in *$execution_id*KEYWORD.pdf; do

	if [ -e $file ]; then

		cp $file $output_folder/processed_order

	fi

done

cp ${data_path_archived_structured}/*$execution_id*xlsx $output_folder/processed_order

# non parsed 
cd ${error_path_parsed}

for file in *$execution_id*; do

	if [ -e $file ]; then

		cp $file $output_folder/non_processed_PDF

	fi

done

cd ${error_path_ocr}

for file in *$execution_id*; do

	if [ -e $file ]; then

		cp $file $output_folder/non_processed_PDF

	fi

done

# log files
cd ${wd_path_log}

for file in *$execution_id*; do

	if [ -e $file ]; then

		mv $file $output_folder/log
	fi

done

# Status
#----------------------------------------------------------------------------#
$CD bubble --title "LV2O - ExtractToExcel" \
--text "Successfully Completed" ‑‑no‑timeout \
--background-top "F8F8F8" --background-bottom "F8F8F8" --border-color "F8F8F8" \
--icon-file "${wd_path_helper}/icon/Bourdon_logo_macro_icon.png"


#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

