#----------------------------------------------------------------------------#

# Purpose:     Master Execution Script - Stage 1
# Author:      CM
# Date:        Jan 2017
# Language:    Shell (.sh)

#----------------------------------------------------------------------------#

# Settings
#----------------------------------------------------------------------------#
source code_base/machine_code/setting.sh

#----------------------------------------------------------------------------#
#                         Step-by-Step Tool Execution                        #
#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#----------------------------------------------------------------------------#
# Execution Commmand #1
#----------------------------------------------------------------------------#
#----------------------------------------------------------------------------#

# Stage-a: Extract relevant PDFs from all incoming emails
#----------------------------------------------------------------------------#

# execute
#---------------------------------------------------#
cd ${wd_path_code}/stage_a
php email_extract.php

cd ${wd_path_code}/stage_a
source order_parse.sh

# Stage-b: Split PDFs
#----------------------------------------------------------------------------#

# execute
#---------------------------------------------------#
cd ${wd_path_code}/stage_b

ipython order_parse.py "${init_path}" "${data_path_parsed}" \
	"${data_path_structured}" "${error_path_parsed}" "${data_path_archived_parsed}" \
	"${wd_path_log}" "${execution_id}" 

cd "${data_path_structured}"

for file in *; do

	# extract 
	pdftotext -layout "${file}" 

done

# execute
#---------------------------------------------------#
cd ${wd_path_code}/stage_b

R CMD BATCH --no-save "--args ${init_path} ${data_path_structured} ${vb_path_input} ${helper_path_keyword} \
	${execution_id}  ${wd_path_log} ${data_path_temp} \
	${data_path_archived_structured}" order_clean.R

## delete output file
[ -e .RData ] && rm .RData
[ -e order_clean.Rout ] && rm order_clean.Rout


#----------------------------------------------------------------------------#
#----------------------------------------------------------------------------#
# Visual Basic Macro (Input: Csv Output: Xlsx)
#----------------------------------------------------------------------------#
#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

