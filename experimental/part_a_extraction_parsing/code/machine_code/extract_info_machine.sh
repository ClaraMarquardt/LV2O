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
echo "experimental - information extraction (stage #2a) [stage #c]"

# source settings
#----------------------------------------------------------------------------#
cd /Users/claramarquardt/Google_Drive/Jobs/indep_project/herkules_nlp/tool/code_base/experimental/part_a_extraction_parsing/code/machine_code
source control.sh

# # execute extraction script 
# #----------------------------------------------------------------------------#
cd ${parse_code_path}
./order_parse.sh


#----------------------------------------------------------------------------#
#                                     End                                    #
#----------------------------------------------------------------------------#
