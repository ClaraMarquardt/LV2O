
#----------------------------------------------------------------------------#

# Project:     Herkules_NLP - Master Control Settings
# Author:      Clara Marquardt
# Date:        Nov 2016

#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#                                   Code                                     #
#----------------------------------------------------------------------------#

# execute python script - parse orders
# -------------- #
cd ${parse_code_path}
python order_parse.py ${mod_order_path} ${parsed_order_path} &

# convert parsed orders - txt
# -------------- #
cd "${parsed_order_path}"

for file in *; do

	# extract 
	pdftotext -layout "${parsed_order_path}/${file}" 

done

# execute R script - parse orders
# -------------- #
cd ${parse_code_path}
R CMD BATCH "--args ${parsed_order_path} ${parsed_order_path}" order_parse.R

# execute R script - clean orders
# -------------- #
cd ${parse_code_path}
R CMD BATCH "--args ${parsed_order_path} ${parsed_order_path}" order_clean.R

# execute py script - annotate pdf
# -------------- #
cd ${parse_code_path}
python order_post_parse.py ${parsed_order_path} ${parsed_order_path} &


#----------------------------------------------------------------------------#
#                                   End                                      #
#----------------------------------------------------------------------------#
