// #-------------------------------------------------------------------------#

// # Project:     Herkules_NLP - Extract Attachments from email
// # Author:      Clara Marquardt
// # Date:        Nov 2016
// # Notes:       see http://stackoverflow.com/questions/5335273/how-to-send-an-email-using-php
// #----------------------------------------------------------------------------#

// #----------------------------------------------------------------------------#
// #                                    Code                                    #
// #----------------------------------------------------------------------------# */

<?php
require 'PHPMailerAutoload.php';

date_default_timezone_set('EST');
$file_path = getenv("final_output_sample_hist_path");
$username = getenv("email_address");
$password = getenv("email_pwd");

/* obtain email list & product list - read in txt file */
$file_list = array("xx");
$email_list = array("xx");
$file_list_mod = array("xx");

$csvFile = $file_path . "/" . 'email_list.csv';

$file = fopen($csvFile,"r");

while(! feof($file))
  {
  $temp_array = fgetcsv($file);
  // print_r($temp_array);

  
  $temp_email = $temp_array[1];
  $temp_file = $temp_array[2] . '.pdf';
  $temp_file_mod = $temp_array[3] . '.pdf';

  array_push($email_list, $temp_email);
  array_push($file_list, $temp_file);
  array_push($file_list_mod, $temp_file_mod);

  }

fclose($file);

// print_r($file_list);
// print_r($email_list);
// print_r($file_list_mod);


$length = count($file_list);
echo $length;
for ($i = 1; $i < $length-1; $i++) {

    /* obtain data */
    $file = $file_list[$i+1];
    $email_to = $email_list[$i+1];
    $file_mod = $file_list_mod[$i+1];

    /* print status */ 
    echo "process: " . $file;
    echo "\n\n";

    /* Create email */
    $email = new PHPMailer();

    $email->IsSMTP();                           
    $email->Host       = "smtp.gmail.com"; 
    $email->SMTPDebug  = 2;                     
    $email->SMTPAuth   = true;                  
    $email->SMTPSecure = "tls";                       
    $email->Port       = 587;                       
    $email->Username   = $username;  
    $email->Password   = $password;           

    $email->SetFrom('marquardt.clara@gmail.com', 'Supperhuhn Company');
    
    /* body */ 
    $msg = "Please see the attached product information. We look forward to hearing back from you.\n\n Should you have any further questions please feel free to reach out to us.\n\nSupperhuhn Company";
    $msg=wordwrap($msg,70);

    /* create email */ 
    $email->Subject   = "Re. " . $file_mod . " - Product Information";
    $email->Body      = $msg;
    $email->AddAddress($email_to);

    $email->AddAttachment( $file_path . "/" . $file , $file_mod);
    $email->AddAttachment( $file_path . "/" . 'chicken.jpg');


    /* print status */ 
    echo "sent " . $file . "to " . $email_to;
    echo "\n\n";
    $email->send();
    if(!$email->send()) {
        echo 'Message could not be sent.';
        echo 'Mailer Error: ' . $email->ErrorInfo;
    } else {
        echo 'Message has been sent';
    }


};

?>

// #----------------------------------------------------------------------------#
// #                                    End                                     #
// #----------------------------------------------------------------------------# */
