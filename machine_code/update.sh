#!/bin/bash

#----------------------------------------------------------------------------#

# Purpose:     Master Execution Script - Update TextToCode App
# Author:      CM
# Date:        Jan 2017
# Language:    Shell (.sh)

#----------------------------------------------------------------------------#

# User input
# ----------------------------------------------------------------------------#

# baseline
app_name=$(ls ${wd_path_TextToCode}/P2F_petm*xlsb)
database_name=$(ls ${wd_path_TextToCode}/P2F-Database*xlsb)
app_name=$(basename "$app_name")
database_name=$(basename $database_name)

echo $app_name
echo $database_name

# replace App
export update_app=`$CD msgbox --title "LV2O - Update TextToCode" \
--text "Update TextToCode App?" --button1 "  Yes  " --button2 "  No  "`

if [ "${update_app:0:1}" = "1" ]; then

	printf "Update TextToCode App"

	# user input
	app=`$CD fileselect \
	--title "This is a fileselect"\
    --text "Choose the xlsb file to serve as the TextToCode app" \
    --with-extensions .xlsb`

    echo $app

    # update name
    app_name=$(basename "${app}")
    app_name > $wd_path_helper"/TextToCode/app_version.txt"

    # replace
    rm ${wd_path_TextToCode}/*P2F_petm*xlsb
    cp "$app" ${wd_path_TextToCode}/${app_name}


fi

# replace Database
export update_database=`$CD msgbox --title "LV2O - Update TextToCode" \
--text "Update TextToCode Price Database?" --button1 "  Yes  " --button2 "  No  "`

if [ "${update_database:0:1}" = "1" ]; then

	printf "Update TextToCode Database"

	# user input
	database=`$CD fileselect \
	--title "This is a fileselect"\
    --text "Choose the xlsb file to serve as the TextToCode price database" \
    --with-extensions .xlsb`

    echo $database
    
    # update name
    database_name=$(basename "${database}")
    database_name > $wd_path_helper"/TextToCode/database_version.txt"

    # replace
    rm ${wd_path_TextToCode}/*P2F-Database*xlsb
    cp "$database" ${wd_path_TextToCode}/${database_name}

fi

# update documentation
cp ${wd_path_helper}/credit/credit_template.rtf ${wd_path_code}/Credits.rtf
sed -ie "s/APP/${app_name}/g" ${wd_path_code}/Credits.rtf && rm `ls ${wd_path_code}/*rtfe`
sed -ie "s/DATABASE/${database_name}/g" ${wd_path_code}/Credits.rtf && rm `ls ${wd_path_code}/*rtfe`

# Status
#----------------------------------------------------------------------------#
$CD bubble --title "LV2O - Update TextToCode" \
--text "Successfully Completed" ‑‑no‑timeout \
--background-top "F8F8F8" --background-bottom "F8F8F8" --border-color "F8F8F8" \
--icon-file "${wd_path_helper}/icon/Bourdon_logo_macro_icon.png"


#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

