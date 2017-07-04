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

/************ HELPER FUNCTIONS

/* Define flatten function */
function flattenParts($messageParts, $flattenedParts = array(), $prefix = '', $index = 1, $fullPrefix = true) {

    foreach($messageParts as $part) {
        $flattenedParts[$prefix.$index] = $part;
        if(isset($part->parts)) {
            if($part->type == 2) {
                $flattenedParts = flattenParts($part->parts, $flattenedParts, $prefix.$index.'.', 0, false);
            }
            elseif($fullPrefix) {
                $flattenedParts = flattenParts($part->parts, $flattenedParts, $prefix.$index.'.');
            }
            else {
                $flattenedParts = flattenParts($part->parts, $flattenedParts, $prefix);
            }
            unset($flattenedParts[$prefix.$index]->parts);
        }
        $index++;
    }

    return $flattenedParts;
            
}

/* Define getPart function */
function getPart($connection, $messageNumber, $partNumber, $encoding) {
    
    $data = imap_fetchbody($connection, $messageNumber, $partNumber);
    switch($encoding) {
        case 0: return $data; // 7BIT
        case 1: return $data; // 8BIT
        case 2: return $data; // BINARY
        case 3: return base64_decode($data); // BASE64
        case 4: return quoted_printable_decode($data); // QUOTED_PRINTABLE
        case 5: return $data; // OTHER
    }
    
    
}

/* Define getFilenameFromPart function */
function getFilenameFromPart($part) {

    $filename = '';
    
    if($part->ifdparameters) {
        foreach($part->dparameters as $object) {
            if(strtolower($object->attribute) == 'filename') {
                $filename = $object->value;
            }
        }
    }

    if(!$filename && $part->ifparameters) {
        foreach($part->parameters as $object) {
            if(strtolower($object->attribute) == 'name') {
                $filename = $object->value;
            }
        }
    }
    
    return $filename;
    
}

/************ END HELPER FUNCTIONS

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
        $status = imap_setflag_full($inbox, $email_number, "\\Seen \\Flagged"); 

        /* get mail structure */
        $structure_raw = imap_fetchstructure($inbox, $email_number);
        // echo print_r($structure_raw);

        $structure_flat = flattenParts($structure_raw->parts);
        // echo print_r($structure_flat);
     
		/* get information specific to this email */
        $message=imap_fetchbody($inbox,$email_number,1);
        
        /* get information specific to this email */
        $overview = imap_fetch_overview($inbox,$email_number,0);

        /* extract email address of sender */ 
        $address = array();
        // $address_simple = array();

        $address[1] =  $overview[0]->from;
        echo "address";
        print_r($address[1]);

        // if (preg_match('/(.*@.*)(<mailto.*)/', $message, $address_simple)) {
        // };

        // echo "address";
        // print_r($address_simple[1]);

        // if($address_simple[1]!="") 
        // {
        // $address[1]=$address_simple[1];
        // }

        echo "address";
        print_r($address[1]);
     
        /* initialise attachment array */ 
        $attachments = array();

        /* if any attachments found... */
        $i = 0;

        foreach($structure_flat as $partNumber => $part) {


            $attachments[$i] = array(
                    'is_attachment' => false,
                    'filename' => '',
                    'attachment' => ''
            );

            switch($part->type) {
        
            case 0:
            // the HTML or plain text part of the email
            $message = getPart($inbox, $email_number, $partNumber, $part->encoding);
            // print_r($message);

            $address_simple = array();

            if (preg_match('/(Von:.*)(mailto)(.*@.*)/', $message, $address_simple)) {
                print_r($address_simple);
                $address[1] = $address_simple[3];

                echo "address";
                print_r($address[1]);

            };

            break;
    
            case 1:
            // multi-part headers, can ignore
            break;
        
            case 2:
            // attached message headers, can ignore
            break;
    
            case 3: // application
            case 4: // audio
            case 5: // image
            case 6: // video
            case 7: // other
            $filename = getFilenameFromPart($part);
            
            if($filename) {
                // attachment
                $attachment = getPart($inbox, $email_number, $partNumber, $part->encoding);

                $attachments[$i]['is_attachment'] = 1;
                $attachments[$i]['attachment'] = $attachment;
                $attachments[$i]['filename']  = $filename;
                
            }

        break;
    
    }

    $i++;
}
        echo "number of attachments: ".count($attachments) . "\n\n";

        /* iterate through each attachment and save it */
        for($j = 0; $j < count($attachments); $j++) {
            echo $j;
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


}


?>

// #----------------------------------------------------------------------------#
// #                                    End                                     #
// #----------------------------------------------------------------------------# */

