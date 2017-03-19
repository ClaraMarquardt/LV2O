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
echo "experimental - information extraction reset"

# source settings
#----------------------------------------------------------------------------#
cd /Users/claramarquardt/Google_Drive/Jobs/indep_project/herkules_nlp/tool/code_base/experimental/part_a_extraction_parsing/code/machine_code
source control.sh

# # rename files
# #----------------------------------------------------------------------------#
cd  ${annotated_order_path}

for file in ${annotated_order_path}/*; do
	echo ${file}
	echo "${file/_reviewed/}"
	while [[ !("${file/_reviewed/}" -ef "${file}") ]]; do
		file_new="${file/_reviewed/}"
		echo ${file_new}
		mv ${file} ${file_new}
		if [ "${file/_reviewed/}" -ef "${file}" ]; then
      		break
      	fi
      	file=${file_new}
	done
done

sleep 10

#----------------------------------------------------------------------------#
#                                     End                                    #
#----------------------------------------------------------------------------#

