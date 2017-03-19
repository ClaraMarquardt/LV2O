#----------------------------------------------------------------------------#

# Project:     Herkules_NLP - Master Control Settings
# Author:      Clara Marquardt
# Date:        Nov 2016

#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#                                   Code                                     #
#----------------------------------------------------------------------------#

cd "${annotated_sample_hist_path}"

for file in *; do

	echo $file

	if [ "$file" != 'temp.pdf' ]; then

		cp $file temp.pdf

		find . -type f -name 'temp.pdf' -exec perl -pi -e 's/Annots/ffffff/g' {} +

		file_fonts=''
		file_fonts=$(pdffonts -l 5 "temp.pdf" | tail -n +3 | cut -d' ' -f1 | sort | uniq)
	
		if [ "$file_fonts" = '' ] || [ "$file_fonts" = '[none]' ]; then
    	
    		echo "non ocr - parse"
    		
    		# parse -- ocr recognition
			pdfsandwich -lang deu $file -o "${mod_annotated_sample_hist_path}/${file}" 
			# pdfsandwich -lang deu -coo "-contrast -unsharp 0" $file -o "${mod_annotated_sample_hist_path}/${file}" 

		else 
			echo "ocr - non parse"

	 		cp $file ${mod_annotated_sample_hist_path}/$file
	  		sleep 10

		fi 

		rm temp.pdf

	fi

done

#----------------------------------------------------------------------------#
#                                   End                                      #
#----------------------------------------------------------------------------#

