#!/bin/bash

#----------------------------------------------------------------------------#

# Purpose:     Master Execution Script - Reset
# Author:      CM
# Date:        Jan 2017
# Language:    Shell (.sh)

#----------------------------------------------------------------------------#

# Settings
#----------------------------------------------------------------------------#
source code_base/machine_code/setting.sh


# User input
# ----------------------------------------------------------------------------#

printf "###\n\n"

# Email settings
unset complete_reset
read -p 'Complete (archival) reset (Yes/No)? ' complete_reset
export complete_reset=${complete_reset}

printf "\n###\n"

# Clear data
# ----------------------------------------------------------------------------#

# delete all files - non-archived
find $data_path_raw $data_path_temp  $data_path_parsed \
$data_path_structured $data_path_annotated $vb_path_input \
$vb_path_output $send_path $error_path_ocr $error_path_parsed \
\( -name "*.pdf" -or -name "*.txt" -or -name "*.xlsx" -or -name "*.csv" \) -exec rm {} \;

# delete all files - interface
find $vb_path_input $vb_path_output  $send_path \
\( -name "*.pdf" -or -name "*.txt" -or -name "*.xlsx" -or -name "*.csv" \) -exec rm {} \;

echo "# Application Reset Sucessfull"

if [ "$complete_reset" = "Yes" ]; then
	
	# delete all files - archived
	find $data_path_archived_parsed $data_path_archived_structured  $data_path_archived_vb_input \
	$data_path_archived_vb_output $data_path_archived_annotated $data_path_archived_sent \
	$data_path_archived_error \
	\( -name "*.pdf" -or -name "*.txt" -or -name "*.xlsx" -or -name "*.csv" \) -exec rm {} \;

	# delete all but most recent raw order (archived)
	cd ${data_path_archived_raw}
	rm `ls -t *.pdf  | awk 'NR>1'`

	# obtain new product id
	cd "${data_path_archived_raw}"

	export file_id=0
	for file in *; do
    
    	file_mod="${file//[a-z_]/ }"
		file_mod=(${file_mod// .*/ })
		file_mod=$(echo ${file_mod} | sed 's/^\([0-9]*\) .*/\1/')

    	if [ "$file_id" -lt "$file_mod" ]; then
    		file_id=$file_mod
    	fi

	done

	((file_id++))

	echo "# Complete Application Reset Sucessfull - Next Product ID: $file_id"

fi


#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

