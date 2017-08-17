#!/bin/bash

# (User) Settings
# ----------------

printf "###\n\n"

# Email settings
unset email_address
read -p 'Enter email address (e.g. test@gmail.com):' email_address
export email_address=${email_address}

unset email_pwd
read -s -p 'Enter email password:' email_pwd
export email_pwd=${email_pwd}
printf "\n"

unset email_cc_address
read -p 'Enter the cc email address:' email_cc_address
export email_cc_address=${email_cc_address}
printf "\n"

unset email_reply_address
read -p 'Enter the sender address / reply-to address:' email_reply_address
export email_reply_address=${email_reply_address}
printf "\n"


# Excel path
unset excel_path
read -p 'Enter the path to the Excel executive to be used (e.g. /Applications/Microsoft\ Office\ 2011/Microsoft\ Excel.app/):' excel_path
export excel_path=${excel_path}
printf "\n"

# Installation configuration
unset desktop_alias
read -p 'Create desktop aliases (Yes/No)? ' desktop_alias
export desktop_alias=${desktop_alias}


unset install
read -p 'Complete dependency install (Yes/No)? ' install
export install=${install}

if [ "$install" = "Yes" ]; then
	unset brew_reset
	read -p 'Complete Homebrew reset (Yes/No)? ' brew_reset
	export brew_reset=${brew_reset}
fi

printf "\n###\n"


