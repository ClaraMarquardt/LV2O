
#----------------------------------------------------------------------------#

# Project:     Herkules_NLP - Master Control Settings
# Author:      Clara Marquardt
# Date:        Nov 2016

#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#                                   Code                                     #
#----------------------------------------------------------------------------#


# execute R script - parse orders
# -------------- #
command="--args ${mod_order_path} ${parsed_order_path} ${parse_code_path}"
echo $command
R CMD BATCH "--args ${mod_order_path} ${parsed_order_path} ${parse_code_path}" ${parse_code_path}/order_parse.R


#----------------------------------------------------------------------------#
#                                   End                                      #
#----------------------------------------------------------------------------#
