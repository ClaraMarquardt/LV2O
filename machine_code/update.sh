#!/bin/bash

#----------------------------------------------------------------------------#

# Purpose:     Master Execution Script - Update TextToCode App
# Author:      CM
# Date:        Jan 2017
# Language:    Shell (.sh)

#----------------------------------------------------------------------------#

# User input
# ----------------------------------------------------------------------------#

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
    echo $TextToCode_app

    # replace
    cp "$app" "$TextToCode_app"

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
    echo $TextToCode_database
    
    # replace
    cp "$database" "$TextToCode_app"

fi

# Status
#----------------------------------------------------------------------------#
$CD bubble --title "LV2O - Update TextToCode" \
--text "Successfully Completed" ‑‑no‑timeout \
--background-top "F8F8F8" --background-bottom "F8F8F8" --border-color "F8F8F8" \
--icon-file "${wd_path_helper}/icon/Bourdon_logo_macro_icon.png"


#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

