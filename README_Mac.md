### SET-UP Instructions

##### [1] Install key programs
---------------------------

_Note: Internet access is required for the entire set-up_
_Note: The Oorder in which programs are installed does NOT matter_

[-] Set-up environment
````
## * Confirm that can open terminal
[1] Search for 'terminal' (application folder) - confirm that can open

## * Install Homebrew 
[1] Open the terminal - execute the below command
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

````

[-] Install R  
````	
## * Install R
[1] Install R - install: dependencies/R/R-3.4.0.pkg

## * Enable the xcode command line integration
[1] Download & install Xcode (may take some time / may require a one time set-up of an apple id): 
https://itunes.apple.com/us/app/xcode/id497799835?mt=12 ("click - view in mac app store") 
[2] Open the Xcode application to verify its installation
[3] Execute the following command in the terminal:
xcode-select --install

## * Confirm that R can be accessed from the command line
[1] Open the terminal -> Test these commands: "which R" / "R --version" / "R"
````

[-] Install Python 
````
## * Install Python & ipython
[1] Install Python  - install: dependencies/python/Anaconda2-4.4.0-MacOSX-x86_64

## * Confirm that Python can be accessed from the command line
[1] Open the terminal -> Test these commands: 
"which python" / "python --version" (confirm - 2.7 NOT 3.x) / "which pip" / "python"

## * Install iPython
[1] Open the terminal -> Execute this command: "pip install ipython"

## * Confirm that iPython can be accessed from the command line
[1] Open the terminal -> Test these commands: "which ipython" / "ipython --version" / "ipython"

````

[-] Install the PDF parsing tools (xpdf / pdfsandwich /pdftk )
````
## * Install pdftk (pdftotext command - convert pdfs to txt files)
[1] Install pdftk - install: dependencies/pdftk/pdftk_server-2.02-mac_osx-10.11-setup.pkg
[2] Open the terminal -> Test these commands: "which pdftk" / "pdftk"

## * Install PDFsandwich (pdfsandwich command - ocr recognition)
[1] Install all depdencies - execute the following commands:
brew install tesseract --all-languages                           
brew install imagemagick ghostscript exact-image unpaper ocaml poppler
[2] Navigate into the pdfsandwich directory (dependency/pdfsandwich) and execute the below command:
sudo ./configure && make && make install 
[4] Open the terminal -> Test these commands: 
"which pdfsandwich" / "pdfsandwich --version" / "pdfsandwich -list_langs" / "pdfsandwich"

## * Install XPdf (pdftotext command - convert pdfs to txt files)
[1] Install XPdf - execute the below command:
brew install xpdf
[2] Open the terminal -> Test these commands: "which pdftotext" / "pdftotext"
````

[-] Verify that PHP & Perl are installed (_Should be pre-installed by default_)
````
## * Confirm that PHP/Perl can be accessed from the command line
[1] Open the terminal -> Test these commands: "which php" / "php --version" / "which perl" / "perl version"

````

##### [2] Obtain the tool codebase/folder structure 
---------------------------

````
[1] Specify the directory in which the tool is to be stored

[2] Unzip the tool into the selected directory

[3] Open the terminal -> execute the following commands
cd [...]/tool
sudo chmod -R a+x code_base/
````

##### [3] Customise the settings
---------------------------

[1] setting.sh (tool/code_base/machine_code/)
````
[-] Modify "wd_path" (All other settings are default settings and do NOT need to be modified)
````

[2] email_password.txt and email_username.txt (tool/helper/email_id/)
````
[-] Modify the contents of both txt files - email address and password of the gmail account which is to be used to receive and send emails
````

[3] Excel macro integration
````
[-] Modify the excel macro to (a) read in data from (.csv) from tool/vb_interface/input and (b) output data (.xlsx and .pdf) to tool/vb_interface/output
````

##### [4] Obtain the required R/Python packages
---------------------------

[1] Obtain the required Python packages
````
[1] Start the terminal
[2] Execute the following code 
cd [...]/tool
pip install -r code_base/helper_code/python_dependency.txt
````

[2] Obtain the required R packages
````
[1] Start the terminal
[2] Execute the following code 
sudo R CMD javareconf
[3] Start R from the command line ("R") and execute the following code
install.packages('rJava')
library(rJava)
[4] Execute the following code from the command line
cd [...]/tool
R CMD BATCH --no-save code_base/helper_code/R_dependency.R 
````

### EXECUTION Instructions
----------------------------------------------------------------------------

[1] start the terminal

[2] navigate to tool directory
````
cd [....]/tool
````

[3] execute - stage 1 (email -> vb input)
````
./code_base/machine_code/execution_master_stage_1.sh
````

[*] EXECUTE VB MACRO


[4] execute - stage 2 (vb output -> email)
````
./code_base/machine_code/execution_master_stage_2.sh
````
