#----------------------------------------------------------------------------#

# Purpose:     Master Execution Script - Stage 2
# Author:      CM
# Date:        Jan 2017
# Language:    Shell (.sh)

#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#                         Step-by-Step Tool Execution                        #
#----------------------------------------------------------------------------#

# User control check (!)
#----------------------------------------------------------------------------#
export user_check=`$CD msgbox --title "LV2O - TextToCode" \
--text "Processed orders checked?" \
--informative-text "All approved orders (and the accompanying 'order_master....xlsx') \
need to be copied from 'output/.../' to 'interface/product_code_input/'" \
--button1 "Yes" --button2 "No" \
--icon-file "${wd_path_helper}/icon/notice.png"`

if [ "${user_check:0:1}" = "2" ]; then

	printf "Exit - User Check Fail"

	exit;

fi

#----------------------------------------------------------------------------#
#----------------------------------------------------------------------------#
# Execution Command #2
#----------------------------------------------------------------------------#
#----------------------------------------------------------------------------#

# Stage-x: Subset to user-approved orders
#----------------------------------------------------------------------------#

# execute
#---------------------------------------------------#
cd ${wd_path_code}/stage_2

R CMD BATCH --no-save "--args ${init_path} ${vb_path_input} \
${data_path_archived_structured} ${execution_id} ${error_path_parsed}" order_subset.R

## delete output file
[ -e .RData ] && rm .RData
[ -e order_subset.Rout ] && rm order_subset.Rout

# pass to excel tool
#---------------------------------------------------#
cp ${vb_path_input}/* ${TextToCode_input}/


# Stage-x: Start TextToCode app
#----------------------------------------------------------------------------#

# execute
open_command="open $TextToCode_app -a $EXCEL"
eval $open_command

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

