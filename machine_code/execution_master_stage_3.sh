#----------------------------------------------------------------------------#

# Purpose:     Master Execution Script - Stage 3
# Author:      CM
# Date:        Jan 2017
# Language:    Shell (.sh)

#----------------------------------------------------------------------------#

# Output folder
#----------------------------------------------------------------------------#
output_folder=${wd_path_output}/WriteToPDF_$execution_id
mkdir $output_folder

cd $output_folder

mkdir log
mkdir annotated_order
mkdir non_processed_PDF

#----------------------------------------------------------------------------#
#----------------------------------------------------------------------------#
# Execution Command #3
#----------------------------------------------------------------------------#
#----------------------------------------------------------------------------#

# Obtain from excel tool
#----------------------------------------------------------------------------#
for file in ${TextToCode_output}/*; do
	echo $file
	if [ -e $file ]; then

		cp $file $vb_path_output/

	fi
done

# clear up
rm ${TextToCode_input}/* 
rm ${TextToCode_output}/* 

# Stage-c (ii): Annotate PDFs
# ----------------------------------------------------------------------------#
cd ${wd_path_code}/stage_3

ipython order_output.py "${init_path}" "${vb_path_output}" "${data_path_archived_raw}" \
"${data_path_archived_structured}" "${execution_id}" \
"${data_path_annotated}" "${wd_path_log}" "${vb_path_input}"

# Stage-c (ii): Merge PDFs
# ----------------------------------------------------------------------------#
for file in ${vb_path_output}/*pdf; do
	echo $file
	if [ -e $file ]; then

		cp $file $data_path_annotated/

	fi
done

cd ${data_path_annotated}

for file in *_offer*; do
    
    # identify files
	file_id="${file//[a-z_]/ }"
	file_id=(${file_id// .*/ })
	file_id=$(echo ${file_id} | sed 's/^\([0-9]*\) .*/\1/')

	# rename offer
	file_letter=$file
	file_letter_mod="${file_letter//${file_id}/offer_${file_id}}"
	mv $file_letter $file_order_mod

	# identify offer and letter
	file_order=$(ls $file_id*.pdf)
	file_letter=$(ls offer_$file_id*.pdf)

	# rename originals
	file_order_mod="${file_order//.pdf/_order.pdf}"
	mv $file_order $file_order_mod

	file_letter_mod="${file_letter//offer_/}"
	mv $file_letter $file_letter_mod

	# merge
	file_orig="${file_order_mod//_order/}"
	pdftk $file_letter_mod $file_order_mod cat output $file_order

done

# move non-merged PDFs
cd "${data_path_annotated}"

for file in *_offer*; do

	mv $file $data_path_archived_annotated

done

for file in *_order*; do

	mv $file $data_path_archived_annotated

done

# Stage-x: Copy to output folder
#----------------------------------------------------------------------------#

# annotated orders & vb output
cd ${data_path_annotated}

for file in *pdf; do

	if [ -e $file ]; then

		cp $file $output_folder/annotated_order
	fi

done

cp ${data_path_archived_structured}/_order_master*${execution_id}.xlsx* $output_folder/annotated_order
cp ${data_path_annotated}/*csv* $output_folder/annotated_order

# non parsed 
cd ${error_path_parsed}

for file in *; do

	if [ -e $file ]; then

		cp $file $output_folder/non_processed_PDF
	fi

done

cd ${error_path_ocr}

for file in *; do

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
$CD bubble --title "LV2O - WriteToPDF" \
--text "Successfully Completed" ‑‑no‑timeout \
--background-top "F8F8F8" --background-bottom "F8F8F8" --border-color "F8F8F8" \
--icon-file "${wd_path_helper}/icon/Bourdon_logo_macro_icon.png"


#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

