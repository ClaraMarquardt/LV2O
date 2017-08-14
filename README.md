### **LV2O - LeistungsVerzeichnis-to-Order** 

Application Repository: https://drive.google.com/drive/folders/0B8_7JE9uq-iDa3AwWlhMY25KRkU?usp=sharing

#### # OVERVIEW

##### **## Application Structure**  

The LV2O application consists of four distinct applications each of which corresponds to a processing stage. The application is designed 
to (i) allow for user input and modifications at all stages and (ii) generalize across products/product groups.

* (1) **ExtractToExcel**: Screen the email inbox for any new PDF orders -> Download and parse all new orders 
-> Generate a csv file with potentially relevant order items based on keywords [User input: 
Verify all extracted PDFs]

* (2) **WriteToPDF**: Import the product description to product code mapping generated by a separate 
mapping box -> Annotate the original orders with the product information [User input: 
Verify all annotated PDFs & correct where necessary]

* (3) **TextToCode**: Map the product descriptions to product IDs -> Obtain product prices and customer information from linked databases

* (4) **SendToCustomer**: Mail the annotated and *reviewed* orders to the original customers, i.e. 
the customers from which the order was received


##### **## Interface and Output**  

- Each application execution generates a folder in the output directory (*'name of application _ 
execution identifier'*) containing all the key output along with the log files


##### **## Notes** 

- *Recommended Workflow*: It is recommended that the *ExtractToExcel* application is run e.g. 
overnight given that it can take a significant amount of time to parse all orders (using OCR). 
All subsequent steps should complete, assuming daily tool execution and 10-15 orders per day, in 
under 15 minutes and can thus be executed in-time

- *Backend structure*: The LV2O application backend consists of bash scripts which are wrapped into
a MacOSX application (.app) using Platypus and cocoaDialogue. Each bash script calls upon subroutines written in R, 
Python, php and bash. The codebase along with a number of helper files (e.g. product keywords) 
can be accessed by right clicking the application icon and selecting "Show Package Contents". 

- *Traceability*: All orders processed by the LV2O application are archived (at each processing stage) 
along with the log files generated during execution. The archived data can be accessed by right 
clicking the application icon and selecting "Show Package Contents" 
( -> Navigating to contents/resources/data/archived_data and contents/resources/log/). 
Should the application at any point become too large or should problems occur the application may be reset, i.e. the 
archive and data cleared, using the _'reset.app'_ (_'documentation_setup/reset.app'_). The _'reset.app'_ preserves a unique order - order id mapping. 

##### **## Licenses**  

The LV2O app is distributed under an Open-Source MIT License (https://choosealicense.com/licenses/mit/). All dependencies are open-source and 
may be used without restrictions. 

#### # SET-UP & EXECUTION

##### **## Requirements & Dependencies**  

````
The LV2O application is designed to run on MacOSX (testing has been performed on MaxOSx Sierra 
and El Capitan)

# Key Dependencies - Installed as part of the set-up process
* R & Set of R Packages 
* IPython & Set of Python Packages 
* php with imap support 
* Supporting Dependencies: PDFSandwich (requires tesseract and a number of other dependencies), xpdf, pdftk 
* Base Dependencies: Homebrew, Xcode (command line tools), gcc, Java SDK

# Other Dependencies
* Dependencies which are pre-installed on all MacOSX platforms: perl, gawk
* Excel  
* Gmail account with external imap support: The LV2O application is designed to interface with a gmail 
account which has been configured to allow external applications to connect through imap (see to configure: 
https://myaccount.google.com/lesssecureapps)

````

##### **## Set-up (BASIC)**  

````
# [1] Download the tool & Unzip to a selected path ('local path')
Download the most up-to date version of the tool from the application repository

## Notes:
* To minimize the risk of problems it is recommended that the path to the tool directory 
does not contain any spaces

# [2] Execute the set-up script 
cd [local path]/LV2O
source documentation_setup/installer/installer_wrapper.sh && source documentation_setup/installer/installer.sh > \
documentation_setup/installer/installer_log.txt 2>&1 

## Notes:
* You will need to be connected to the Internet during the set-up process
* When asked for an email username and password - enter the gmail address and password of the email 
account which is to be used to receive and send orders
* When asked whether to complete a Homebrew reset - enter 'No' unless you encounter problems during 
set-up in which case it may help to re-run the set-up script with a Homebrew reset (enter 'Yes')
* When asked for a password - enter the root password (required to install php and a number of other 
dependencies)
* You may be asked to install xcode/xcode command line tools & Java SDk externally - in these cases follow the given instructions to complete the installation
* Depending on whether or not e.g. Xcode (command line tools), are already installed installation may 
take up to 30 minutes

## Notes:
* Should problems occur during installation - review the more detailed installation log documentation_setup/install_log.txt
````

##### **## Execution**  

````
Navigate to the directory ([local path]/LV2O)
Launch any of the 3 applications 
Upon completion - close the application window

## Notes:
* Should problems occur - execute the reset application (documentation/set_up/reset.app) selecting "no" when asked whether you want to complete a full reset

````




