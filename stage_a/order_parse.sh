#----------------------------------------------------------------------------#

# Project:     Herkules_NLP - Master Control Settings
# Author:      Clara Marquardt
# Date:        Nov 2016

#----------------------------------------------------------------------------#

# control
#----------------------------------------------------------------------------#
start=`date +%s`

#----------------------------------------------------------------------------#
#                                   Code                                     #
#----------------------------------------------------------------------------#

# # initialise file_ids
# #----------------------------------------------------------------------------#

cd "${data_path_archived_raw}"

# initialise
export file_id=0

# check what the highest current id is 
for file in *; do
    
    file_mod="${file//[a-z_]/ }"
	file_mod=(${file_mod// .*/ })
	file_mod=$(echo ${file_mod} | sed 's/^\([0-9]*\) .*/\1/')

    if [ "$file_id" -lt "$file_mod" ]; then
    	file_id=$file_mod
    fi

done

((file_id++))

echo "starting ID: "${file_id}


# # rename (no spaces, etc)
# #----------------------------------------------------------------------------#

cd "${data_path_raw}"

for file in *; do

	# file_name  mod
	file_mod="${file//  / }"
	file_mod="${file_mod// /_}"
	file_mod="${file_mod//PDF/pdf}"
	file_mod=${file_id}_${file_mod}
	echo $file_mod

	# move
	mv $file $file_mod 

	((file_id++))

done

# parse
#----------------------------------------------------------------------------#
cd "${data_path_raw}"

# paraneters
agg_file=$(ls -l | wc -l )
total_file=0
ocr_file=0

log_file=${wd_path_log}'/log_parsing_sh.txt'

for file in *; do

	echo "parse order: "${total_file}" out of "${agg_file}
	echo $file

    find . -type f -name $file -exec perl -pi -e 's/Annots/ffffff/g' {} +


	if [ "$file" != 'temp.pdf' ]; then

		cp $file temp.pdf

		file_fonts=''
		file_fonts=$(pdffonts -l 5 "temp.pdf" | tail -n +3 | cut -d' ' -f1 | sort | uniq)
	
		if [ "$file_fonts" = '' ] || [ "$file_fonts" = '[none]' ]; then
    	
    		echo "non ocr - parse"
    		
    		# parse -- ocr recognition
			# pdfsandwich -lang deu $file -o "${mod_annotated_sample_hist_path}/${file}" 
			# pdfsandwich -lang deu -coo "-contrast -unsharp 0" $file -o "${mod_annotated_sample_hist_path}/${file}" 

			cp $file ${error_path_ocr}/$file

		else 

			check=`python ${wd_path_code}/stage_a/encrypt.py "${data_path_raw}"/"${file}"`

			if [ "$check" = 'False' ]; then

				echo "ocr - non parse"

	 			# cp $file ${mod_annotated_sample_hist_path}/$file
	 			pdftk $file output ${data_path_parsed}/$file
	  			sleep 5

	  			((ocr_file++))

	  		else
	  			echo "non ocr - parse (python)"
    		
    			# parse -- ocr recognition
				# pdfsandwich -lang deu $file -o "${mod_annotated_sample_hist_path}/${file}" 
				# pdfsandwich -lang deu -coo "-contrast -unsharp 0" $file -o "${mod_annotated_sample_hist_path}/${file}" 

				cp $file ${error_path_raw}/$file

			fi
		fi 

		rm temp.pdf

		mv $file $data_path_archived_raw/$file

	((total_file++))
	fi


done

end=`date +%s`

# print summary stats
echo "Total number of orders: ${total_file}"
echo "Parsed number of orders: ${ocr_file}"
echo "Run time (minutes): $(((end-start)/60))"

echo "\n\n###########" >> $log_file
echo "\nExecution ID: ${execution_id}" >> $log_file
echo "Date: ${current_date}" >> $log_file
echo "\nTotal number of orders: ${total_file}" >> $log_file
echo "Parsed number of orders: ${ocr_file}" >> $log_file
echo "Run time (minutes): $(((end-start)/60))" >> $log_file


#----------------------------------------------------------------------------#
#                                   End                                      #
#----------------------------------------------------------------------------#
