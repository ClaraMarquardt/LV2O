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
echo "experimental - email extraction and parsing (stage #1) [stage #a and #b]"

# source settings
#----------------------------------------------------------------------------#
cd /Users/claramarquardt/Google_Drive/Jobs/indep_project/herkules_nlp/tool/code_base/experimental/part_a_extraction_parsing/code/machine_code
source control.sh

# reset folders
#----------------------------------------------------------------------------#
cd ${raw_order_path}
rm *.txt
rm *.pdf
rm *.docx

cd "${mod_order_path}"
rm *.txt
rm *.pdf
rm *.docx

cd "${parsed_order_path}" 
rm *.txt
rm *.pdf
rm *.docx
rm *.csv

cd "${annotated_order_path}" 
rm *.txt
rm *.pdf
rm *.docx
rm *.csv

echo "reset all folders";

# # execute email/parsing script ((a) php and (b) shell)
# #----------------------------------------------------------------------------#
${php_path}/php "${extract_code_path}/email_extract.php"

#----------------------------------------------------------------------------#
#                                     End                                    #
#----------------------------------------------------------------------------#
