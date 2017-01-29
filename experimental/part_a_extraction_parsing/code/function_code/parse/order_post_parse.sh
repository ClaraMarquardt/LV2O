#----------------------------------------------------------------------------#

# Project:     Herkules_NLP - Master Control Settings
# Author:      Clara Marquardt
# Date:        Nov 2016

#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#                                   Code                                     #
#----------------------------------------------------------------------------#

cd ${parsed_order_path}

for file in *.docx; do

	# convert word to PDF
	${libre_office_path} \
   	    --headless \
    	--convert-to pdf \
    	  ${file}

done

/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py --output raw_order_${email_date}.pdf *.pdf

#----------------------------------------------------------------------------#
#                                   End                                      #
#----------------------------------------------------------------------------#


