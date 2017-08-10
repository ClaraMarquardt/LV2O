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

# Installation configuration
unset brew_reset
read -p 'Complete Homebrew reset (Yes/No)? ' brew_reset
export brew_reset=${brew_reset}

printf "\n###\n"


