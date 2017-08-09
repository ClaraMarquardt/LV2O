### **LV20 - Leistungs-Verzeichnis-to-Order** 

#### # OVERVIEW

##### **## Stages**  
- ExtractToExcel: 
- WriteToPDF: 
- SendToCustomer: 

* Timing - 1st step take time

##### **## Output & Interface**  


##### **## Notes**  
- Execution: Bash Script + Platypus App 

##### **## Licenses**  
- Execution: Bash Script + Platypus App 
- Documentation: All documents & log files stored///Helper files & arhived data &code - within app (e.g. change settings .....)


#### # SET-UP & EXECUTION

##### **## Requirements & Dependencies**  

````
The tool is designed to run on MacOSx (Testing has been performed on MaxOSx Sierra and El Capitan)

# Key
* R & Set of R Packages (Installed as part of the set-up process)
* IPython & Set of Python Packages (Installed as part of the set-up process)
* php with imap support (Installed as part of the set-up process)
* Supporting Dependencies: PDFSandwich (XXXXXXX), XPDF, PDFTK, Perl
* Base Dependencies: Homebrew, Xcode (command line tools), gcc, awk (Installed as part of the set-up process)

* Pre-installed: Perl

# Other
* Gmail account - configured (see below if need to change)
* Excel integration

````

##### **## Set-up (BASIC)**  

````
# [1] Download the tool & Unzip to a selected path ('local path')
Download the most up-to date version of the tool: XXXXXXXXXXXXXXX

- No spaces in path
- cd [...]/tool
sudo chmod -R a+x code_base/


# [2] Execute the set-up script 
Navigate to XXXX
source code/machine_code/set_up_wrapper.sh && source code/machine_code/set_up.sh > log/set_up.txt 2>&1 

# [3] Additional manual install


# [4] Excel intergation
- See configuration log 

## Notes:
* You will need to be connected to the Internet during the set-up process
* When asked whether to complete a Homebrew reset - enter 'No' unless you encounter problems during 
set-up in which case it may help to re-run the set-up script with a Homebrew reset (enter 'Yes')
* When asked for a password - enter the root password (required to install php)
* Depending on whether or not e.g. Xcode (command line tools), are already installed installation may 
take up to 30 minutes

# [5] Aliases

````

##### **## Set-up (EXTENDED)**  

````

# [X] Adjust the email account
# [X] Reset the app

````

##### **## Execution**  

````
# [1] Execute the tool

## Notes:
* You will be asked a number of questions:
** 'Enter the earliest email date (e.g. 03-July-2017):' - Enter the earliest date from which emails are to be 
analyzed (date must be entered in the suggested format)
** 'Enter email username (e.g. test@gmail.com):' / 'Enter email password' - Enter your gmail username and password 
** 'Keep log files (Yes/No):' - Enter 'No' unless you wish to keep the log files generated 
during execution (e.g. for the purposes of debugging)
````

