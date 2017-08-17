### **LV2O - LeistungsVerzeichnis (LV)-to-Order**

_Current Version: V2.0 (17th August 2017)_

- Application Repository: https://drive.google.com/drive/folders/0B8_7JE9uq-iDa3AwWlhMY25KRkU?usp=sharing
- Application Code Repository: https://github.com/ClaraMarquardt/LV2O

#### # OVERVIEW

##### **## Application Structure**  

The LV2O application consists of four distinct processing steps:

* (1) **ExtractToExcel**: Screen the email inbox for new emails -> Identify and download all 
relevant PDF attachments -> Extract the text from all PDF LVs (OCR) -> Parse the LVs extracting
(a) individual order items containing product-related keywords and (b) project and customer meta data
:: Output: Xlsx workbook containing relevant orders & meta data

* (2) **TextToCode**: Iterate through the individual orders -> Map product descriptions to product
codes -> Use the product codes to source prices and customer data from SAP databases -> Generate
customer-specific offer letters including  discounts where applicable
:: Output: (a) Xlsx workbook containing product codes & product meta data (b) Customer-specific offer
letters

* (3) **WriteToPDF**: Annotate individual order items within the original PDF 
LVs with product codes and prices -> Combine the annotated LVs with the offer letters
:: Output: Completed, ready-to-send LVs including offer letters

* (4) **SendToCustomer**: Mail the completed LVs and offer letters to the customers
:: Output: Emails to customer containing completed LVs and customer-specific offer letters

##### **## User Control** 

- The application is designed to guarantee full user control at all stages (with minimal effort):

* (1) The text-extraction process (**ExtractToExcel**) is subject to user verification - PDF LVs
which are identified by the user as having been incorrectly parsed are set aside for later
manual processing, i.e. are excluded from subsequent automatic processing steps

* (2) The product description to code mapping process (**TextToCode**) is subject to user verification - 
where product descriptions are e.g. incomplete or ambiguous the tool suggests plausible default values
and flags these for user verification (e.g. a direct follow-up with the customer)

* (3) The final output (**WriteToPDF**), i.e. the completed LVs and offers, are subject to user review - 
incorrect LVs can be modified in place while non-parsed LVs are flagged for manual processing. The \
**SendToCustomer** step further prompts the user to decide whether the emails
are to be sent to the customers or to a given (internal) test email (e.g. for a final verification)

##### **## Miscellaneous Notes** 

- *Recommended Workflow*: It is recommended that the *ExtractToExcel* application is run e.g. 
overnight (with the appropriate sleep settings) given that it can take a significant amount of 
time to parse all LVs (using OCR). All subsequent steps should complete, assuming daily 
tool execution and 10-30 orders per day, in under 20 minutes and can thus be executed in-time

- *Backend structure*: The LV2O application backend is structured around a number of master bash scripts 
which are wrapped into a MacOSX application (.app) using Platypus and cocoaDialogue. Each bash script calls upon 
scripts written in e.g. R, Python and php. The codebase and supporting files can be accessed by 
right clicking the application icon and selecting "Show Package Contents". 

- *Traceability*: All LVs processed by the LV2O application are archived (at each processing stage) 
along with all log files. The archived data can be accessed by right clicking the application icon and 
selecting "Show Package Contents", and navigating to Contents/Resources/data/archived_data and 
Contents/Resources/log. Should the application at any point become too large or should problems 
occur the application may be reset (see below)

##### **## Licenses**  

The LV2O application is distributed under an Open-Source MIT License 
(https://choosealicense.com/licenses/mit/). All dependencies (other than Excel (Microsoft Office)) 
are open-source and may be used without restrictions. 

#### # SET-UP & EXECUTION

##### **## Requirements & Dependencies**  

````
The LV2O application is designed to run on MacOSX (testing has been performed on MaxOSx Sierra 
and El Capitan). 

# Key Dependencies - _Installed as part of the set-up process_
* R & Set of R Packages 
* IPython & Set of Python Packages 
* php with imap support 
* Supporting Dependencies: PDFSandwich (requires tesseract with German language support 
and a number of other dependencies), xpdf, pdftk 
* Base Dependencies: Homebrew, Xcode (command line tools), gcc, Java SDK, gawk, wget

# Other Dependencies
* Microsoft Excel 2011 (It is recommended that Excel is configured not to warn regarding 
workbooks containing macros)
* Gmail account setup to receive all incoming customer emails. The account needs to be 
configured to support to allow external applications to connect through imap (see: 
https://myaccount.google.com/lesssecureapps)
* Supporting dependencies - pre-installed on MacOSX: Perl, bash

````
##### **## Set-up (BASIC)**  

````
# [1] Download the application & unzip to a selected path ('local path')
Download the most up-to date version of the application from the application repository (_see above_)

## Notes:
* It is recommended that the path to the application directory does not contain any spaces

# [2] Execute the set-up script (terminal)
[1] Ensure that the machine is connected to the Internet

[2] Launch the installer
cd [local path]/LV2O
source documentation_setup/installer/installer_wrapper.sh && \
source documentation_setup/installer/installer.sh > documentation_setup/installer/installer_log.txt 2>&1 

# [3] Confirm that the application was successful 
Launch the LV20.app and confirm that the application starts without any error messages

## User settings:
* *Email settings*: When asked for an email username and password - enter the 
Gmail address and password of the gmail account which is to be used to receive and 
send customer emails. When asked for a cc address enter the email address which is to be cc'ed 
on all emails sent to customers (e.g. for archival purposes). When asked for a sender/reply to address 
enter the email address which is to receive all customer replies

* *Excel settings*: When asked for an excel path - enter the path to the local instance 
of Microsoft Excel 2011 (e.g. /Applications/Microsoft\ Office\ 2011/Microsoft\ Excel.app/)

* *Installation settings*: When asked whether to create Desktop aliases - enter 'Yes' or 'No'. When asked
whether to complete a dependency install - enter 'No' unless the application is installed for the 
1st time. When asked whether to complete a Homebrew reset enter 'No' unless 
problems arise during the set-up process in which case it may help to re-run the installer with a Homebrew 
reset (enter 'Yes')

## Notes:
* When prompted for a password during the installation process - enter the root password 
* If asked to install Xcode (command line tools) & Java SDK follow the provided 
instructions to complete the installation
* Depending on whether or not e.g. Xcode (command line tools), are already installed the installation 
may take up to 30 minutes
* Should problems occur during installation - review the more detailed installation 
log (documentation_setup/install_log.txt)

````

##### **## Execution**  

````
[1] Start the application
- Navigate to the directory ([local path]/LV2O)
- Launch the LV2O.app
- Select the processing step which is to be performed
- Upon completion a notification will appear and an output folder containing the output and 
log files will be available in the output folder (output/[Processing Stage]_[Execution ID])

## Notes:
* Manual user intervention is required at two points: 

(a) Prior to launching the **TextToCode** process  - all processed LVs 
(output/ExtractToExcel.../processed_order) need to be reviewed. *Correctly* processed LVs need to be 
copied, along with the order_master...xlsx file, to the interface/product_code_input folder 
prior to launching the *TextToCode* process

(b) Prior to launching the *SendToCustomer* process - (a) all processed LVs
(output/WriteToPDF.../annotated_order) need to be reviewed and where necessary modified in-place 
using e.g. AdobeAcrobat Reader (or any other PDF reader) (b) non-processed LVs 
(output/WriteToPDF.../non_processed_PDF) need to be processed manually and appended to 
the email_list...csv file . *Correctly* processed LVs need to be copied, along with the 
email_list...csv file, to the interface/send_order folder prior to launching 
the *SendToCustomer* process

````

##### **## Extensions & Other Features **  

````
## Application reset 

- The application can be reset by launching the application and selecting "Reset App". Note 
that in case of a complete archival reset the highest current LV ID is stored, i.e. a unique LV-ID 
mapping is ensured unless the "reset ID" option is selected

## TextToCode application 

- The TextToCode application can be launched independently by selecting "* Launch TextToCode Application"
from the main menu

- The version of the **TextToCode** application, i.e. the application and database, can be checked 
by starting the application and selecting "about" from the main menu bar

- The TextToCode application/database can be updated, i.e. the application and 
database replaced with newer versions, by selecting "* Update TextToCode Application" from the main menu

## Customization

- Keywords, email settings, etc. can be customized (i.e. reset) by right clicking the application 
icon, selecting "Show Package Contents" and navigating to Content/Resources/helper/user_setting)

````