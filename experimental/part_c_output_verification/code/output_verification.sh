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
cd /Users/claramarquardt/Google_Drive/Jobs/indep_project/herkules_nlp/experiments/part_a_extraction_parsing/code/machine_code
source control.sh

# # modify csv
# #----------------------------------------------------------------------------#
echo ${1}
echo ${2}
echo ${3}

cd ${output_verification_code_path}
python output_verification.py ${1} ${2} ${annotated_order_path} ${verified_order_path} ${verified_order_final_path} &

# # # copy pdf
# # #----------------------------------------------------------------------------#
cp ${3} ${verified_order_path}/
sleep 10

# # parse
# #----------------------------------------------------------------------------#
cd ${annotate_code_path}
python parsing.py ${verified_order_path} ${verified_order_final_path} False &

#----------------------------------------------------------------------------#
#                                     End                                    #
#----------------------------------------------------------------------------#
