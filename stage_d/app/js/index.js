//----------------------------------------------------------------------------//

// Purpose:     Index.js - main window
// Project:     NLP sales/order automation
// Author:      Clara Marquardt
// Date:        2017
// Notes:       /

//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
//                               Control Section                              //
//----------------------------------------------------------------------------//

// set-up & dependencies
//-------------------------------------------------//
// 'use strict';

require('/usr/local/lib/node_modules/shelljs/global');
var shell = require("/usr/local/lib/node_modules/shelljs");
var exec = require('child_process').exec;

var remote = require('electron').remote;
var glob   = require("glob")
var fs     = require('fs');

// variables 
//-------------------------------------------------//
var close_button   = document.querySelectorAll('.close');
var sound_button   = document.querySelectorAll('.button-sound');
var chicken_button = document.querySelectorAll('.chicken');
var baumer_button  = document.querySelectorAll('.baumer');

var email_parsing_button       = document.querySelectorAll('.email_parsing');
var info_extraction_button     = document.querySelectorAll('.info_extraction');
var pdf_annotation_button      = document.querySelectorAll('.pdf_annotation');
var output_verification_button = document.querySelectorAll('.output_verification');
var final_output_button        = document.querySelectorAll('.final_output');


// helper functions
//-------------------------------------------------//
var helper = require(remote.getGlobal('shared_code_path').helper_function_js_script);

//----------------------------------------------------------------------------//
//                                    Code                                    //
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// side functionalities
//----------------------------------------------------------------------------//

// sound buttons
//----------------------------------------------------------------------------//

for (var i = 0; i < sound_button.length; i++) {
    var button = sound_button[i];
    var soundName = button.attributes['data-sound'].value;

    prepare_sound_button(button, soundName);
};

function prepare_sound_button(button, soundName) {
    button.querySelector('span').style.backgroundImage = 'url("img/icons/' + soundName + '.png")';

    var audio = new Audio(__dirname + '/wav/' + soundName + '.wav');
    button.addEventListener('click', function () {
        audio.currentTime = 0;
        audio.play();
    });
};

// chicken button
//----------------------------------------------------------------------------//
helper.prepare_button_ipc(chicken_button, 'open-chicken-window');

// baumer button
//----------------------------------------------------------------------------//
helper.prepare_button_ipc(baumer_button, 'open-baumer-window');

// close buttons
//----------------------------------------------------------------------------//
helper.prepare_button_ipc(close_button, 'close-main-window');

//----------------------------------------------------------------------------//
// main functionalities
//----------------------------------------------------------------------------//

// Button 1: Download and parse (.email_parsing)
// Button 2: Extract and save csv and annotated PDF (.info_extraction)
// Button 3: Annotate PDF with resulting information - product code (.pdf_annotation)
// Button 4: Launch PDF/CSV - read in csv file / open PDF & save  modified versions  (.output_verification)
// Button 5: Open modified annotated pdf/csv (.final_output)


//1 - .email_parsing
//----------------------------------------------------------------------------//
helper.prepare_button_shell_script(email_parsing_button, 
  remote.getGlobal('shared_code_path').email_parsing_script, 
  '.email_parsing -- stage #1');

//2 - .info_extraction
//----------------------------------------------------------------------------//
helper.prepare_button_shell_script(info_extraction_button, 
  remote.getGlobal('shared_code_path').info_extraction_script, 
  '.info_extraction -- stage #2');

//3 - .pdf_annotation
//----------------------------------------------------------------------------//
helper.prepare_button_shell_script(pdf_annotation_button, 
  remote.getGlobal('shared_code_path').pdf_annotation_script, 
  '.pdf_annotation -- stage #3');

//4 - .output_verification
//----------------------------------------------------------------------------//
helper.prepare_button_ipc(pdf_annotation_button, 
  'open-pdf-csv-window');

//5 - .final_output
//----------------------------------------------------------------------------//
helper.prepare_button_ipc(final_output_button, 
  'open-pdf-csv-window-new');


//----------------------------------------------------------------------------//
//                                    End                                     //
//----------------------------------------------------------------------------//

























