#----------------------------------------------------------------------------#

# Project:     Herkules_NLP - Master Control Settings
# Author:      Clara Marquardt
# Date:        Nov 2016

#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#                                  Settings                                  #
#----------------------------------------------------------------------------#
#!/bin/bash

# control
#----------------------------------------------------------------------------#
echo "experimental - processing of historical orders"

# source settings
#----------------------------------------------------------------------------#
cd /Users/claramarquardt/Google_Drive/Jobs/indep_project/herkules_nlp/tool/code_base/experimental/part_a_extraction_parsing/code/machine_code
source control.sh


# # rename (no spaces, etc)
# #----------------------------------------------------------------------------#
cd "${annotated_sample_hist_path}"

for file in *; do

	# file_name  mod
	file_mod="${file//  / }"
	file_mod="${file_mod// /_}"
	echo $file_mod

	# move
	mv $file $file_mod 

done

# # execute parsing script
# #----------------------------------------------------------------------------#
cd ${annotated_hist_code_path}
./parsing.sh 

# # execute parsing/splitting script 
# #----------------------------------------------------------------------------#
python ${parse_code_path}/order_parse.py "${mod_annotated_sample_hist_path}" "${final_annotated_sample_hist_path}" &

cd "${final_annotated_sample_hist_path}"

for file in *; do

	# extract 
	pdftotext -layout "${file}" 

done


# # execute processing 
# #----------------------------------------------------------------------------#
cd ${annotated_hist_code_path}
R CMD BATCH "--args ${final_annotated_sample_hist_path} ${doc_path} ${key_word_path}" order_clean.R

#----------------------------------------------------------------------------#
#                                     End                                    #
#----------------------------------------------------------------------------#
