### SET-UP Instructions

#### [1] Install key programs (NOTE: Order in which programs are installed does NOT matter)
---------------------------

* Note: Internet access is required for the entire set-up_

* Set-up environment (IF not on Mac)
````
	## * Confirm that can access command line
	[1] Press Start -> In Search/Run line enter "cmd" -> command line window should open

	## * Install cygwin
	[1] Install cygwin - see: https://www.cygwin.com/
	[2] Integrate cygwin with the windows command line - see: https://www.howtogeek.com/howto/41382/how-to-use-linux-commands-in-windows-with-cygwin/
````

* Install R  
````	
	## * Install R
	[1] Install R - see: https://cran.r-project.org/bin/windows/base/

	## * Confirm that R can be accessed from the command line
	[1] Open the command line window -> Enter "R" -> R should start
````
####Install Python 

	## * Install Python
	[1] Install Python - see: https://ipython.org/install.html

	## * Confirm that Python can be accessed from the command line
	[1] Open the command line window -> Enter "ipython" -> Python should start

####Install PHP 

	## * Install PHP
	[1] Install PHP - see: http://windows.php.net/download#php-7.1

	## * Confirm that PHP can be accessed from the command line
	[1] Configure and confirm - see: 
	http://php.net/manual/en/install.windows.legacy.index.php#install.windows.legacy.commandline


####Install the PDF parsing tools (pdftk, pdftotext/pdffonts, perl)

	## * Install PDFTK
	[1] Install PDFTK - see: https://www.pdflabs.com/tools/pdftk-server/

	## * Install XPdf
	[1] Install XPdf - see: http://www.foolabs.com/xpdf/download.html

	## * Install Perl
	[1] Install Perl - see: https://www.perl.org/get.html


##### [2] Obtain the code repository (code & dependencies & folder structure) 
# ---------------------------

	## * Specify directory & Navigate to chosen directory

	## * OPTION A (Requires Git)
	git clone https://github.com/ClaraMarquardt/order_automation.git

	## * OPTION B (Requires local copy of repo)
	[1] Unzip local copy of repo into the chosen directory

##### [3] Customise the settings
# ---------------------------

	## * setting.sh (tool/code_base/machine_code/)
	[1] Modify "wd_path" (All other settings are default settings and do NOT need to be modified)

	## * email_password.txt and email_username.txt (tool/helper/email_id/)
	[1] Modify the contents of both txt files - email address and password of the gmail account 
	which is to be used to receive and send emails

	## * Excel macro integration
	[1] Modify the excel macro to (a) read in data from (.csv) from tool/vb_interface/input 
	and (b) output data (.xlsx and .pdf) to tool/vb_interface/output

##### [4] Obtain the required R/Python packages
# ---------------------------

	## * Obtain the required Python packages
	[1] Start the command line window
	[2] Execute the following code 
	pip install -r [...]/tool/code_base/helper_code/python_dependency.txt

	## * Obtain the required R packages
	[1] Start the command line window
	[2] Execute the following code 
	R CMD BATCH --nosave [...]/tool/code_base/helper_code/R_dependency.R

#----------------------------------------------------------------------------#
### EXECUTION Instructions
#----------------------------------------------------------------------------#

####[1] start the windows command window 

####[2] navigate to wd
cd [....]/tool

####[3]execute - stage 1 (email -> vb input)
./code_base/machine_code/execution_master_stage_1.sh

####[*] EXECUTE VB MACRO]

####[4] execute - stage 2 (vb output -> email)
./code_base/machine_code/execution_master_stage_2.sh


#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#
