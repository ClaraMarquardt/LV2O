#!/bin/bash

#----------------------------------------------------------------------------#

# Purpose:     Master Execution Script - Reset
# Author:      CM
# Date:        Jan 2017
# Language:    Shell (.sh)

#----------------------------------------------------------------------------#

# User input
# ----------------------------------------------------------------------------#
export complete_reset=`$CD msgbox --title "LV2O - Reset Application" \
--text "Complete (archival) reset?" --button1 "  Yes  " --button2 "  No  "`

# Clear data
# ----------------------------------------------------------------------------#

# delete all files - non-archived 
find $data_path_raw $data_path_temp  $data_path_parsed ${TextToCode_input} ${TextToCode_output} \
$data_path_structured $data_path_annotated $error_path_ocr $error_path_parsed \
\( -name "*.pdf" -or -name "*.txt" -or -name "*.xlsx" -or -name "*.csv" \) -exec rm {} \;

# delete all files - interface
find $vb_path_input $vb_path_output $send_path \
\( -name "*.pdf" -or -name "*.txt" -or -name "*.xlsx" -or -name "*.csv" \) -exec rm {} \;

# delete all nuisance files
find $wd_path \( -name "*.DS*" \)  -exec rm {} \;

echo "# Application Reset Successful"

if [ "$complete_reset" = "1" ]; then
	
	# delete all files - archived
	find $data_path_archived_parsed $data_path_archived_structured  $data_path_archived_vb_input \
	$data_path_archived_vb_output $data_path_archived_annotated $data_path_archived_sent \
	$data_path_archived_error \
	\( -name "*.pdf" -or -name "*.txt" -or -name "*.xlsx" -or -name "*.csv" \) -exec rm {} \;

	# delete all but most recent raw order (archived)
	cd ${data_path_archived_raw}
	rm `ls -t *.pdf  | awk 'NR>1'`
	rm `ls -t *.txt  | awk 'NR>1'`

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

	file_id_old=${file_id}
	((file_id_old++))

	export reset_id=`$CD msgbox --title "LV2O - Reset Application" \
	--text "Default next order ID: $file_id_old" \
	--button1 "  Use ID  " --button2 "  Reset ID  "`

	if [ "${reset_id:0:1}" = "2" ]; then

		printf "Reset ID"

		export file_id=`$CD inputbox --title "LV2O - Reset Application" \
		--informative-text "Default next order ID: $file_id_old" \
		--button1 "  OK  " ‑‑no‑cancel`


	fi

	# create new file with id
	rm `ls *.txt`
	rm `ls *.pdf`
	touch ${data_path_archived_raw}/${file_id}_id_file.txt


fi

# Status
#----------------------------------------------------------------------------#
$CD bubble --title "LV2O - Reset Application" \
--text "Successfully Completed" ‑‑no‑timeout \
--background-top "F8F8F8" --background-bottom "F8F8F8" --border-color "F8F8F8" \
--icon-file "${wd_path_helper}/icon/Bourdon_logo_macro_icon.png"


#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

