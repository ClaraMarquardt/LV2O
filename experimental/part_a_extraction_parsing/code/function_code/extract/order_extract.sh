#----------------------------------------------------------------------------#

# Project:     Herkules_NLP - Master Control Settings
# Author:      Clara Marquardt
# Date:        Nov 2016

#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#                                   Code                                     #
#----------------------------------------------------------------------------#

cd "${raw_order_path}"

for file in *; do

	# file_fonts=$(pdffonts -l 5 "$file" | tail -n +3 | cut -d' ' -f1 | sort | uniq)
	
	# if [ "$file_fonts" = '' ] || [ "$file_fonts" = '[none]' ]; then
    	
    # parse -- ocr recognition
	pdfsandwich -lang deu $file -o "${mod_order_path}/${file}" 

	# else 
	#  	cp $file ${mod_order_path}/$file
	#  	sleep 10
	
	#  fi 

	# extract 
	pdftotext -layout "${mod_order_path}/${file}" 

done

#----------------------------------------------------------------------------#
#                                   End                                      #
#----------------------------------------------------------------------------#
