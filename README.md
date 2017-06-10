# sales_automation


# SET-UP Instructions
# --------------

# [1] Install key programs
# ---------------------------

## Terminal/Shell (IF not on Mac)

## Install R & Packages 

## Install Python & Packages

## Install PHP 

## Install the PDF parsing tools (pdftk, pdfsandwich, perl)

## Libre Office(?)

# [2] Pull repo from Github (contains dependencies & folder structure)
# ---------------------------


# [3] Update the helper files
# ---------------------------

## setting.sh
* All non default settings

## product_identification



# [4] Update the xlsx file - link to vb input and output folders
# ---------------------------


# EXECUTION Instructions
# --------------

## navigate to wd
cd /Users/claramarquardt/Google_Drive/Jobs/indep_project/herkules_nlp/tool

## execute - stage 1 (email -> vb input)
./code_base/machine_code/execution_master_stage_1.sh

## execute - stage 2 (vb output -> email)
./code_base/machine_code/execution_master_stage_2.sh