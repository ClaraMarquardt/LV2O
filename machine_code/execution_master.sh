#----------------------------------------------------------------------------#

# Purpose:     Master Execution Script 
# Author:      CM
# Date:        Jan 2017
# Language:    Shell (.sh)

#----------------------------------------------------------------------------#

# Settings
#----------------------------------------------------------------------------#
source code_base/machine_code/setting.sh

# Clear up output folder
#----------------------------------------------------------------------------#
find ${wd_path_output} -type d -maxdepth 1 \( -name "ExtractToExcel*" -or -name "WriteToPDF*" -or -name "SendToCustomer*" \) \
-exec mv {} ./archived/ \;


# User input
#----------------------------------------------------------------------------#
export stage=`$CD dropdown --title "LV2O - Leistungsverzeichnis To Order" \
--text "Which analysis step should be executed?" \
--items "ExtractToExcel (Stage 1)" "TextToCode (Stage 2)" "WriteToPDF (Stage 3)" "SendToCustomer (Stage 4)" "* Launch TextToCode Application" "* Update TextToCode Application" --button1 "Start" \
--button2 "Exit" --button3 "Reset Application"`

if [ "${stage:0:1}" = "2" ]; then

	printf "Exit"

	exit;

elif [ "${stage:0:1}" = "3" ]; then

	printf "Reset App"

	source code_base/machine_code/reset.sh

else

	export stage=${stage:2}
	echo $stage

fi

# Execute
#----------------------------------------------------------------------------#

if [ "$stage" = "0" ]; then

	printf "Starting: ExtractToExcel"

	source code_base/machine_code/execution_master_stage_1.sh

elif [ "$stage" = "1" ]; then

	printf "Starting: TextToCode"

	source code_base/machine_code/execution_master_stage_2.sh

elif [ "$stage" = "2" ]; then

	printf "Starting: WriteToPDF"

	source code_base/machine_code/execution_master_stage_3.sh

elif [ "$stage" = "3" ]; then

	printf "Starting: SendToCustomer"

	source code_base/machine_code/execution_master_stage_4.sh

elif [ "$stage" = "4" ]; then

	printf "Launching TextToCode application"

	open_command="open $TextToCode_app -a '$EXCEL'"
	eval $open_command

elif [ "$stage" = "5" ]; then

	printf "Updating TextToCode application"

	source code_base/machine_code/update.sh

fi

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

