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
echo "experimental - information extraction (stage #3) [stage #d])"

# source settings
#----------------------------------------------------------------------------#
cd /Users/claramarquardt/Google_Drive/Jobs/indep_project/herkules_nlp/tool/code_base/experimental/part_a_extraction_parsing/code/machine_code
source control.sh

# # modify csv
# #----------------------------------------------------------------------------#
echo ${1}
echo ${2}
echo ${3}
echo ${4}

cd ${output_verification_code_path}
python output_verification.py ${1} ${2} ${annotated_order_path} ${verified_order_path} ${verified_order_final_path} &

# # # copy pdf
# # #----------------------------------------------------------------------------#
cp ${3} ${verified_order_path}/

orig_file_name=${4}
orig_file_name="${orig_file_name/.pdf/_reviewed.pdf}"
# orig_file_name="${orig_file_name/${annotated_order_path}/${verified_order_final_path}}"
echo ${orig_file_name}
mv ${4} ${orig_file_name}

orig_file_name_csv=${4}
orig_file_name_csv="${orig_file_name_csv/.pdf/.txt_order_extracted.csv}"
orig_file_name_csv_mod="${orig_file_name_csv/.csv/_reviewed.csv}"
# orig_file_name="${orig_file_name/${annotated_order_path}/${verified_order_final_path}}"
echo ${orig_file_name}
mv ${orig_file_name_csv} ${orig_file_name_csv_mod}


sleep 10

# # parse
# #----------------------------------------------------------------------------#
cd ${annotate_code_path}
python parsing.py ${verified_order_path} ${verified_order_final_path} False &
sleep 10

#----------------------------------------------------------------------------#
#                                     End                                    #
#----------------------------------------------------------------------------#

