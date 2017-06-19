### SET-UP Instructions - extension (_Windows - specific_)

##### [1] Using 'pdftotext' from the Windows command line
---------------------------

[1] Install xpdf / ensure that the correct version of xpdf is installed
````
[0] * Deinstall any existing version(s) of xpdf
[1] Download the binary located at: ftp://ftp.foolabs.com/pub/xpdf/xpdfbin-win-3.04.zip
[2] Unzip and move to desired path (_no_ need to change settings (as suggested in the INSTALL guide))
[3] Add the (selected) xpdf path to the Environment Variables
[4] See if can execute xpdf / the xpdf texttopdf utility from the command line
xpdf 	  # should return description of the xpdf package
pdftotext # should return description of tool
````

##### [2] Enabling 'imap_open' as part of a Windows PHP instance
---------------------------
[1] Install php (manually)
````
[0] * Deinstall any existing version(s) of PHP
[1] Download the binary located at: http://windows.php.net/downloads/releases/php-7.1.6-nts-Win32-VC14-x86.zip
[2] Unzip and move to desired path (e.g. C:\php\)
[3] Add the (selected) php path to the Environment Variables
[4] Confirm that php can be launched from the command line
````

[2] Enable the imap extension
````
[1] Copy the contents of the 'php.ini-production' file (stored in the unzipped directory) into a new file named 'php.ini' (in the same directory)

[2] Check that php has been succesfully configured to use the above created php.ini' file: Execute the below code (command line) and confirm that the line ~ "Loaded Configuration File =>" points to the 'php.ini' file created above
php -r 'phpinfo();'

[3] Open the newly created 'php.ini' file and find the line ";extension=php\_imap.dll" - uncomment this line by removing the semicolon (the line should read: "extension=php_imap.dll")

[4] Confirm that the imap extension has been enabled by executing the below code (command line). Confirm that 'imap' is returned as one of the loaded extensions
php -r 'print_r(get_loaded_extensions());
````