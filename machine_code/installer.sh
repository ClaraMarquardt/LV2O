#----------------------------------------------------------------------------#

# Purpose:     Installer
# Author:      CM
# Date:        Jan 2017
# Language:    Shell (.sh)

#----------------------------------------------------------------------------#

# Initialisation
#----------------------------------------------------------------------------#

# WD
wd_path=$(pwd)
echo ${wd_path}

# DateTime
current_date=$(date +"%m_%d_%Y / %H:%M")

# define log function
status_file=${wd_path}/documentation_setup/installer/config_status.txt
log_file=${wd_path}/documentation_setup/installer/install_log.txt

[ -e $status_file ] && rm $status_file
[ -e $log_file ] && rm $log_file

printf ${status_file}
printf ${log_file}

echolog()
(
echo $1
echo $1 >> ${status_file}
)

echolog_ext()
(
echo $1
echo $1 >> ${status_file}
echo $1 >> ${log_file}
)

# Configure function
#----------------------------------------------------------------------------#
configure() {

	# output
	if [ "$1" = "status_log" ]; then
		log_temp="echolog_ext";
	else 
		log_temp="echolog";
	fi

	# log
	$log_temp "### CONFIGURATION ###"

	# paths
	$log_temp "## Paths "

	$log_temp "# WD: $wd_path"
	$log_temp "# PATH: $PATH"

	# interface paths - VB
	$log_temp "## VB Interface Paths "

	$log_temp "# VB Input (Read into VB): $(cd $wd_path"/interface/vb_input"; pwd)"
	$log_temp "# VB Output (Save from VB): $(cd $wd_path"/interface/vb_output"; pwd)"

	# helper dependencues
	$log_temp "## Devtools "

	$log_temp "# Xcode: $(xcode-select --print-path)"

	$log_temp "# Homebrew: $(which brew)"
	$log_temp "Homebrew Version: $(brew --version)"

	# key dependencies
	$log_temp "## Key Dependencies "

	$log_temp "# PHP: $(which php)"
	$log_temp "# PHP Version: $(php --version)"

	$log_temp "# R: $(which R)"
	$log_temp "# R Version: $(R --version)"

	$log_temp "# Ipython: $(which Ipython)"
	$log_temp "# Ipython Version: $(ipython --version)"

	# supporting dependencies
	$log_temp "## Supporting Dependencies "

	$log_temp "# Tesseract: $(which tesseract)"
	$log_temp "# Tesseract Version: $(tesseract --version)"

	$log_temp "# Perl: $(which perl)"
	$log_temp "# Perl Version: $(perl --version)"

	$log_temp "# pdftk: $(which pdftk)"
	$log_temp "# pdftk Version: $(pdftk --version)"
	$log_temp "$(pdftk)"

	$log_temp "# PDFSandwich: $(which pdfsandwich)"
	$log_temp "# PDFSandwich Version: $(pdfsandwich --version)"
	$log_temp "# PDFSandwich Languages: $(pdfsandwich -list_langs)"
	$log_temp "$(pdfsandwich)"

	$log_temp "# XPDF (pdftotext): $(which pdftotext)"
	$log_temp "$(pdftotext)"

	$log_temp "### END CONFIGURATION ###"

}

# Initial Configuration
#----------------------------------------------------------------------------#
configure "status"

# install
#----------------------------------------------------------------------------#

# ----------------
#####  PHP
# ----------------

# Install PHP
printf "\n# Installing PHP with imap support"
printf "\n# ----------------------\n"

cd ${wd_path}
sudo curl -s https://php-osx.liip.ch/install.sh | bash -s 7.1

# Check if PHP is correctly configured
export php_custom_path="/usr/local/php5/bin/php"
export php_custom_path_ini=$(${php_custom_path} -r "echo php_ini_loaded_file();")

echolog "# PHP: $php_custom_path"
echolog "# PHP .ini: $php_custom_path_ini"
${php_custom_path} -c ${php_custom_path_ini} -r "echo phpinfo();" 

printf "\n# SUCCESS - PHP successfully installed & configured"
printf "\n# ----------------------\n"

# ----------------
#####  R
# ----------------

## Homebrew
printf "\n# Installing & Updating Homebrew (+ Command Line Tools)"
printf "\n# ----------------------\n"

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"</dev/null

## Confirm that the Command Line Tools are correctly confgured
echolog "# Homebrew Version: $(brew --version)"
echolog "# Xcode: $(xcode-select --print-path)"


## Homebrew reset
printf "brew_reset: $brew_reset\n"

if [ "$brew_reset" == "Yes" ]; then

	printf "Homebrew Reset\n"

	# initial status
	brew list
	brew doctor 

	# remove all packages installed through homebrew
	brew remove --force --ignore-dependencies $(brew list)

	# fix potential gcc problem
	brew install gcc
	brew link --overwrite gcc

fi

## Homebrew - update/clear up
brew cleanup
brew update
brew doctor

## R
printf "Installing R"
printf "\n# ----------------------\n"

## - Uninstall
brew uninstall --force r
[ -e  /usr/local/lib/R/3.4/site-library ] && rm -rf /usr/local/lib/R/3.4/site-library/*
[ -e  /usr/local/Cellar/r/3.4.1_1/lib/R/library ] && rm -rf  /usr/local/Cellar/r/3.4.1_1/lib/R/library*

## - Reinstall
brew prune 
brew tap homebrew/science && brew install r
brew link --overwrite r

# Check if R is correctly configured
echolog "R: $(which R)"
echolog "R Version: $(R --version)"

## R Packages
printf "Installing R Packages"
printf "\n# ----------------------\n"

### java configuration
sudo R CMD javareconf

### other packages
cd ${wd_path}
R CMD BATCH --no-save ${wd_path}/documentation_setup/installer/R_dependency.R \
${wd_path}/documentation_setup/installer/R_dependency.Rout

printf "\n# SUCCESS - R successfully installed & configured"
printf "\n# ----------------------\n"

# ----------------
#####  Python & Ipython
# ----------------

printf "Installing Python & Ipython"
printf "\n# ----------------------\n"

## - Uninstall
brew uninstall --force python
[ -e  /usr/local/lib/python2.7] && rm -rf /usr/local/lib/python2.7/*

## - Reinstall
brew prune 
brew install python
brew link --overwrite python

# Check if Python is correctly configured
echolog "Python: $(which python)"
echolog "Python Version: $(python --version)"
echolog "Pip: $(which pip)"

## Ipython
pip install ipython

# Check if Ipython is correctly configured
echolog "Ipython: $(which ipython)"
echolog "Ipython Version: $(ipython --version)"

## Python Packages
printf "Installing Python Packages"
printf "\n# ----------------------\n"

pip install -r ${wd_path}/documentation_setup/installer/python_dependency.txt

printf "\n# SUCCESS - Python & Ipython successfully installed & configured"
printf "\n# ----------------------\n"

# ----------------
#####  Other dependencies
# ----------------

### Tesseract
brew uninstall --force tesseract
brew install tesseract --all-languages
brew link --overwrite tesseract

### PDFSandwich dependencies
brew uninstall --force imagemagick ghostscript exact-image unpaper ocaml poppler
brew install imagemagick ghostscript exact-image unpaper ocaml poppler
brew link --overwrite imagemagick ghostscript exact-image unpaper ocaml poppler

### PDFSandwich
wget https://sourceforge.net/projects/pdfsandwich/files/pdfsandwich%200.1.6/pdfsandwich-0.1.6.tar.bz2 | unzip
tar xjvf pdfsandwich-0.1.6.tar.bz2
cd pdfsandwich-0.1.6
sudo ./configure && make && make install 

rm pdfsandwich-0.1.6.tar.bz2
rm -rf pdfsandwich-0.1.6

# Check if PDFSandwich is correctly configured
echolog "PDFSandwich: $(which pdfsandwich)"
echolog "PDFSandwich Version: $(pdfsandwich --version)"
echolog "PDFSandwich Languages: $(pdfsandwich -list_langs)"
echolog "$(pdfsandwich)"

### Xpdf
brew uninstall --force xpdf
brew install xpdf
brew link --overwrite xpdf

# Check if Xpdf is correctly configured
echolog "XPDF (pdftotext): $(which pdftotext)"
echolog "$(pdftotext)"

#### pdftk

# install
brew install https://raw.githubusercontent.com/turforlag/homebrew-cervezas/master/pdftk.rb

# Check if pdftk is correctly configured
echo_log "pdftk: $(which pdftk)"
echo_log "pdftk Version: $(pdftk --version)"
echo_log "$(pdftk)"


# Final configuration
#----------------------------------------------------------------------------#
configure "status_log"

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

