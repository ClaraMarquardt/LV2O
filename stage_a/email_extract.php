// #-------------------------------------------------------------------------#

// # Purpose:     Extract and download incoming mail attachments
// # Author:      CM
// # Date:        Nov 2016
// # Language:    PHP (.php)

// #----------------------------------------------------------------------------#

// #----------------------------------------------------------------------------#
// #                                    Code                                    #
// #----------------------------------------------------------------------------# */

<?php

/* initialise */
date_default_timezone_set('EST');

/* obtain environment arguments - email related */
$hostname = '{imap.gmail.com:993/imap/ssl}INBOX';
$username = getenv("email_address");
$password = getenv("email_pwd");
$subject = getenv("email_subject");

/* obtain environment arguments - misc */
$folder_output = getenv("data_path_raw");  // output folder
$folder_temp = getenv("data_path_temp");   // temp path
$shell_root_path = getenv("wd_path_code"); // code path
$execution_id = getenv("execution_id");
$date =  getenv("current_date");

/* initialise variables */ 
$filename_master = array();

/* try to connect to gmail */
$inbox = imap_open($hostname,$username,$password) or die('Cannot connect to Gmail: ' . imap_last_error());

/* extract emails */
$emails = imap_search($inbox,'UNSEEN');
echo "\n\n" . "number of emails: " . count($emails) . "\n\n";

/* if emails are returned, cycle through each email */
if($emails) {
	
	/* begin output var */
	$output = '';
	
	/* put the newest emails on top */
	rsort($emails);
	
	/* for every email... */
	foreach($emails as $email_number) {

        echo "\n\n" . "email #: " . $email_number . "\n\n";

        /* mark as read */
        $status = imap_setflag_full($inbox, "1", "\\Seen \\Flagged", ST_UID); 

        /* get mail structure */
        $structure = imap_fetchstructure($inbox, $email_number);

		/* get information specific to this email */
        $message=imap_fetchbody($inbox,$email_number,1.1);

        /* extract email address of sender */ 
        $address = array();

        if (preg_match('/(.*@.*)(<mailto.*)/', $message, $address)) {
        };

        /* get information specific to this email */
        $overview = imap_fetch_overview($inbox,$email_number,0);

        /* initialise attachment array */ 
        $attachments = array();

        /* if any attachments found... */
        if(isset($structure->parts) && count($structure->parts)) 

        {
            for($i = 0; $i < count($structure->parts); $i++) 
            {
                $attachments[$i] = array(
                    'is_attachment' => false,
                    'filename' => '',
                    'name' => '',
                    'attachment' => ''
                );

                if($structure->parts[$i]->ifdparameters) 
                {
                    foreach($structure->parts[$i]->dparameters as $object) 
                    {
                        if(strtolower($object->attribute) == 'filename') 
                        {
                            $attachments[$i]['is_attachment'] = true;
                            $attachments[$i]['filename'] = $object->value;
                        }
                    }
                }

                if($structure->parts[$i]->ifparameters) 
                {
                    foreach($structure->parts[$i]->parameters as $object) 
                    {
                        if(strtolower($object->attribute) == 'name') 
                        {
                            $attachments[$i]['is_attachment'] = true;
                            $attachments[$i]['name'] = $object->value;
                        }
                    }
                }

                if($attachments[$i]['is_attachment']) 
                {
                    $attachments[$i]['attachment'] = imap_fetchbody($inbox, $email_number, $i+1);

                    /* 3 = BASE64 encoding */
                    if($structure->parts[$i]->encoding == 3) 
                    { 
                        $attachments[$i]['attachment'] = base64_decode($attachments[$i]['attachment']);
                    }
                    /* 4 = QUOTED-PRINTABLE encoding */
                    elseif($structure->parts[$i]->encoding == 4) 
                    { 
                        $attachments[$i]['attachment'] = quoted_printable_decode($attachments[$i]['attachment']);
                    }
                }
            }



        }

        echo "number of attachments: ".count($attachments) . "\n\n";

        /* iterate through each attachment and save it */
        for($j = 0; $j < count($attachments); $j++) {

            $attachment_number=$email_number+$j;

            $filename_raw = iconv_mime_decode($attachments[$j]["filename"]);
            $ext = pathinfo($filename_raw, PATHINFO_EXTENSION);
   
            if( $ext == 'PDF' | $ext == 'pdf') {
                
                echo iconv_mime_decode($attachments[$j]["filename"]);

                $filename_raw = iconv_mime_decode($attachments[$j]["filename"]);
                $filname_mod = array();
                preg_match('/(.*)(.pdf)/', $filename_raw, $filname_mod);
                $filename = $filname_mod[1];
                $filename = $filename . "_RAW_" . $email_number . $j . "_" . $execution_id . ".pdf";

                $attachment_number_id = sizeof($filename_master);
                $attachment_number_id = $attachment_number_id + 1;
                $filename_master[$attachment_number_id] = array();
                $filename_master[$attachment_number_id]["filename"] = $filename;
                $filename_master[$attachment_number_id]["address"] = $address[1];
                $filename_master[$attachment_number_id]["date"] = $date;

                if($attachments[$j]['is_attachment'] == 1)
                {

                    $filepath = $folder_output ."/". $filename;

                    $fp = fopen($filepath,"w+");
                    fwrite($fp, $attachments[$j]['attachment']);
                    fclose($fp);
                }
            }
        }

    }



/* close the connection */
imap_close($inbox);

/* generate master file */
$filepath = $folder_temp . "/" . "order_email_master_" . "$execution_id" . ".csv";
$fp = fopen($filepath, 'w');

foreach ($filename_master as $fields) {
    fputcsv($fp, $fields);
}

fclose($fp);

/* parse all attachments - shell script */
$shell_file =  'order_parse.sh';
$shell_path = "$shell_root_path" . "/" . "stage_a" . "/" .  "$shell_file";
shell_exec("sh $shell_path");

}


?>

// #----------------------------------------------------------------------------#
// #                                    End                                     #
// #----------------------------------------------------------------------------# */

