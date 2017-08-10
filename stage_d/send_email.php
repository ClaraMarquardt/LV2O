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
$file_path = getenv("send_path");
$username = getenv("email_address");
$password = getenv("email_pwd");
$execution_id = getenv("execution_id");
$log_path = getenv("wd_path_log");
$email_text = getenv("email_text");
$email_sender = getenv("email_sender");

/* initialise output buffer */
function ob_file_callback($buffer)
{
  global $ob_file;
  fwrite($ob_file,$buffer);
}

$log_file = $log_path . '/stage_d_' . $execution_id . ".txt";
$ob_file = fopen($log_file,'w');
ob_start('ob_file_callback');

/* obtain email list & product list - read in txt file */
$file_list = array("xx");
$file_list_no_ext = array("xx");
$email_list = array("xx");
$project_list = array("xx");
$file_list_mod = array("xx");
$file_list_mod_no_ext = array("xx");

$csvFile = $file_path . "/" . 'email_list_' . $execution_id . '.csv';

$file = fopen($csvFile,"r");

while(! feof($file))
  {
  $temp_array = fgetcsv($file);  
  $temp_email = $temp_array[0];
  $temp_file = $temp_array[1] . '.pdf';
  $temp_file_no_ext = $temp_array[1];
  $temp_project = $temp_array[2];
  $temp_file_mod = $temp_array[3];
  $temp_file_mod_no_ext = preg_replace("/(\\.pdf)/", "", $temp_array[3]);
  ;

  array_push($email_list, $temp_email);
  array_push($file_list, $temp_file);
  array_push($file_list_no_ext, $temp_file_no_ext);
  array_push($project_list, $temp_project);
  array_push($file_list_mod, $temp_file_mod);
  array_push($file_list_mod_no_ext, $temp_file_mod_no_ext);

  }

fclose($file);

$length = count($file_list);

for ($i = 1; $i < $length-1; $i++) {

    /* obtain data */
    $file = $file_list[$i+1];
    $file_no_ext = $file_list_no_ext[$i+1];

    if(!($file === ".pdf")) {
    // echo $file;
    $email_to = $email_list[$i+1];
    $project_name=$project_list[$i+1];
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
    $email->ClearReplyTos();
    $email->addReplyTo($email_sender, $email_sender);

    $email->SetFrom($username, $email_sender);
    
    /* body */ 
    $msg = $email_text;
    if (strlen($project_name)>0) {
      $msg = preg_replace("/(BETREFF)/", "Betreff: " . $project_name, $msg);
    } else {
      $msg = preg_replace("/(BETREFF)/", "", $msg);
    }
    $msg = wordwrap($msg,80);

    /* create email */ 
    $email->Subject   = "Re. " . $file_mod_no_ext;
    $email->Body      = $msg;
    $email->AddAddress($email_to);

    if (strlen($project_name)>0) {
      $email->AddAttachment( $file_path . "/" . $file_no_ext . "_" . $project_name . ".pdf" , $file_mod);
    } else { 
      $email->AddAttachment( $file_path . "/" . $file_no_ext . ".pdf" , $file_mod);
    }

    /* print status */ 
    if (strlen($project_name)>0) {
      echo "sent " . $file_no_ext . "_" . $project_name . ".pdf" . " to " . $email_to . "\n";
    } else {
      echo "sent " . $file_no_ext . ".pdf" . " to " . $email_to . "\n";
    }
    echo "\n\n";
    if(!$email->send()) {
        echo 'Message could not be sent.';
        echo 'Mailer Error: ' . $email->ErrorInfo;
    } else {
        echo 'Message has been sent';
    }

    ## save to log file
    $log_path_temp = $log_path . '/' . 'stage_d.txt';   
    $fp = fopen($log_path_temp,"a");

    $execution_id = "########\n\nExecution ID: " . $execution_id . "\n";
    fwrite($fp,$execution_id);
    
    $date_text =  "Date: " . date('Y-m-d H:i:s') . "\n\n";
    fwrite($fp,$date_text);
    

    if (strlen($project_name)>0) {
       $content = "sent " . $file_no_ext . "_" . $project_name . ".pdf" . " to " . $email_to . "\n";
    } else {
      $content = "sent " . $file_no_ext . ".pdf" . " to " . $email_to . "\n";
    }

    fwrite($fp,$content);

    fclose($fp);
}

};

ob_end_flush();

?>

// #----------------------------------------------------------------------------#
// #                                    End                                     #
// #----------------------------------------------------------------------------# */
