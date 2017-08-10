#----------------------------------------------------------------------------#

# Purpose:     Master Execution Script - Stage 2
# Author:      CM
# Date:        Jan 2017
# Language:    Shell (.sh)

#----------------------------------------------------------------------------#

# Settings
#----------------------------------------------------------------------------#
source code_base/machine_code/setting.sh

# Output folder
#----------------------------------------------------------------------------#
output_folder=${wd_path_output}/WriteToPDF_$execution_id
mkdir $output_folder

cd $output_folder

mkdir log
mkdir raw_order
mkdir annotated_order
mkdir non_processed_PDF

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

# Stage-c (ii): Annotate PDFs
# ----------------------------------------------------------------------------#
cd ${wd_path_code}/stage_c

ipython order_output.py "${init_path}" "${vb_path_output}" "${data_path_archived_raw}" \
	"${data_path_archived_structured}" "${execution_id}" \
	"${data_path_annotated}" "${wd_path_log}" "${data_path_archived_vb_input}" \
	"${data_path_archived_vb_output}" "$vb_path_input"


# Stage-c (ii): Merge PDFs
# ----------------------------------------------------------------------------#
cd ${data_path_annotated}

for file in *_offer*; do
    
    # identify files
	file_letter=$file
	file_order="${file_letter//_offer/}"
	file_order_mod="${file_letter//_offer/_order}"

	# rename originals
	mv $file_order $file_order_mod

	# merge
	pdftk $file_letter $file_order_mod cat output $file_order

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

# raw orders
cd ${data_path_archived_raw}

for file in *$execution_id*; do

	cp $file $output_folder/raw_order

done


# annotated orders & vb output
cd ${data_path_annotated}

for file in *$execution_id*; do

	cp $file $output_folder/annotated_order

done

cp ${vb_path_output}/*xlsx* $output_folder/annotated_order
cp ${data_path_annotated}/*csv* $output_folder/annotated_order

# non parsed 
cd ${error_path_parsed}

for file in *$execution_id*; do

	cp $file $output_folder/non_processed_PDF

done

cd ${error_path_ocr}

for file in *$execution_id*; do

	cp $file $output_folder/non_processed_PDF

done

# log files
cd ${wd_path_log}

for file in *$execution_id*; do

	mv $file $output_folder/log

done



#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

