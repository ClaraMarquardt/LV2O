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
echo "experimental - information extraction (stage #2b) [stage #c])"

# source settings
#----------------------------------------------------------------------------#
cd /Users/claramarquardt/Google_Drive/Jobs/indep_project/herkules_nlp/tool/code_base/experimental/part_a_extraction_parsing/code/machine_code
source control.sh

# # execute extraction script 
# #----------------------------------------------------------------------------#
cd ${annotate_code_path}
python parsing.py ${parsed_order_path} ${annotated_order_path} True &


#----------------------------------------------------------------------------#
#                                     End                                    #
#----------------------------------------------------------------------------#
