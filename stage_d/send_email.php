// #-------------------------------------------------------------------------#

// # Purpose:     Send formatted attachments via email
// # Author:      CM
// # Date:        Nov 2016
// # Language:    PHP (.php)


// #----------------------------------------------------------------------------#

// #----------------------------------------------------------------------------#
// #                                    Code                                    #
// #----------------------------------------------------------------------------# */

<?php
require 'PHPMailerAutoload.php';

date_default_timezone_set('EST');
$file_path = getenv("data_path_annotated");
$username = getenv("email_address");
$password = getenv("email_pwd");
$execution_id = getenv("execution_id");
$log_path = getenv("wd_path_log");
$email_text = getenv("email_text");
$email_sender = getenv("email_sender");

/* obtain email list & product list - read in txt file */
$file_list = array("xx");
$email_list = array("xx");
$file_list_mod = array("xx");
$file_list_mod_no_ext = array("xx");

$csvFile = $file_path . "/" . 'email_list_' . $execution_id . '.csv';

$file = fopen($csvFile,"r");

while(! feof($file))
  {
  $temp_array = fgetcsv($file);
  // print_r($temp_array);

  
  $temp_email = $temp_array[1];
  $temp_file = $temp_array[2] . '.pdf';
  $temp_file_mod = $temp_array[3] . '.pdf';
  $temp_file_mod_no_ext = $temp_array[3];

  array_push($email_list, $temp_email);
  array_push($file_list, $temp_file);
  array_push($file_list_mod, $temp_file_mod);
  array_push($file_list_mod_no_ext, $temp_file_mod_no_ext);

  }

fclose($file);

// print_r($file_list);
// print_r($email_list);
// print_r($file_list_mod);


$length = count($file_list);
// echo $length;
for ($i = 1; $i < $length-1; $i++) {



    /* obtain data */
    $file = $file_list[$i+1];

    if(!($file === ".pdf")) {
    // echo $file;
    $email_to = $email_list[$i+1];
    $file_mod = $file_list_mod[$i+1];
    $file_mod_no_ext = $file_list_mod_no_ext[$i+1];

    /* print status */ 
    echo "process: " . $file;
    echo "\n\n";

    /* Create email */
    $email = new PHPMailer();

    $email->IsSMTP();                           
    $email->Host       = "smtp.gmail.com"; 
    $email->SMTPDebug  = 0;                     
    $email->SMTPAuth   = true;                  
    $email->SMTPSecure = "tls";                       
    $email->Port       = 587;                       
    $email->Username   = $username;  
    $email->Password   = $password;           

    $email->SetFrom($username, $email_sender);
    
    /* body */ 
    $msg = $email_text;
    $msg = wordwrap($msg,80);

    /* create email */ 
    $email->Subject   = "Re. " . $file_mod_no_ext;
    $email->Body      = $msg;
    $email->AddAddress($email_to);

    $email->AddAttachment( $file_path . "/" . $file , $file_mod_no_ext);


    /* print status */ 
    echo "sent " . $file . " to " . $email_to;
    echo "\n\n";
    $email->send();
    if(!$email->send()) {
        echo 'Message could not be sent.';
        echo 'Mailer Error: ' . $email->ErrorInfo;
    } else {
        echo 'Message has been sent';
    }


    ## save to log file
    $log_path = $log_path . '/' . 'send_email.txt';   
    $fp = fopen($log_path,"a");

    
    $execution_id = "########\n\nExecution ID: " . $execution_id . "\n";
    fwrite($fp,$execution_id);
    
    $date_text =  "Date: " . date('Y-m-d H:i:s') . "\n\n";
    fwrite($fp,$date_text);
    
    $content = "sent " . $file . " to " . $email_to . "\n";
    fwrite($fp,$content);

    fclose($fp);
}

};

?>

// #----------------------------------------------------------------------------#
// #                                    End                                     #
// #----------------------------------------------------------------------------# */
