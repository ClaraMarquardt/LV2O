<?php

// xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx#

// Purpose:     Extract relevant PDFs from email inbox
// Project:     Sales_Tool
// Author:      Clara Marquardt
// Date:        Jan 2017
// Language:    PHP (.php)

// xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx#


// xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx#
//                               Control Section                             #
// xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx#

/* set-up */
echo "\n\n** launching 'email_extract.php' **\n\n";

/* connection settings */
$hostname = '{imap.gmail.com:993/imap/ssl}INBOX';
$username = getenv("email_username");
$password = getenv("email_password");

/* date_time settings */
date_default_timezone_set('EST');
$date = getenv("email_date");

// xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx#
//                                 Main Code                                 #
// xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx#

// connect to email
// xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx#
$inbox = imap_open($hostname,$username,$password) or die('Cannot connect to Gmail: ' . imap_last_error());

// test connection
// xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
$emails = imap_search($inbox,'UNSEEN SUBJECT " "' );
echo "number of emails: " . count($emails);


// xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx#
//                                   End                                     #
// xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx#

?>


