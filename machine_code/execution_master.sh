#----------------------------------------------------------------------------#

# Purpose:     Master Execution Script
# Project:     Sales_Tool
# Author:      Clara Marquardt
# Date:        Jan 2017
# Language:    Shell (.sh)

#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#                              Control Section                               #
#----------------------------------------------------------------------------#

# specify main code directory
wd_path="/Users/claramarquardt/Google Drive/Jobs/indep_project/herkules_nlp/tool"

wd_code_path=${wd_path}"/code_base"
wd_helper_path=${wd_path}"/helper"
wd_data_path=${wd_path}"/data"

# specify email settings (username/passowrd file - stored separatedly & protected)
email_username_file=${wd_helper_path}"/email_id/email_username.txt"
email_password_file=${wd_helper_path}"/email_id/email_password.txt"

#----------------------------------------------------------------------------#
#                         Step-by-Step Tool Execution                        #
#----------------------------------------------------------------------------#

# Stage-a: Extract relevant PDFs from emails
#----------------------------------------------------------------------------#

# settings
#---------------------------------------------------#
export email_username="$(cat ${email_username_file})"
export email_password="$(cat ${email_password_file})"

# execute
#---------------------------------------------------#
cd ${wd_code_path}/stage_a
php email_extract.php

# Stage-b: Parse PDFs 
#----------------------------------------------------------------------------#

# settings
#---------------------------------------------------#

# execute
#---------------------------------------------------#
cd ${wd_code_path}/stage_b
./pdf_parse.sh


# Stage-c: Identify and characterise products
#----------------------------------------------------------------------------#

# settings
#---------------------------------------------------#

# execute
#---------------------------------------------------#
cd ${wd_code_path}/stage_c
python product_identification.py 


# Stage-d: Verify and ammend product identification
#----------------------------------------------------------------------------#

# settings
#---------------------------------------------------#

# execute
#---------------------------------------------------#
cd ${wd_code_path}/stage_d
npm start

# Stage-e: Generate and mail out identified PDFs
# ----------------------------------------------------------------------------#

# [] TBD

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

