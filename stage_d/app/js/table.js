
//----------------------------------------------------------------------------//

// Purpose:     Control csv
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
'use strict';

require('/usr/local/lib/node_modules/shelljs/global');
var shell = require('/usr/local/lib/node_modules/shelljs');
var exec = require('child_process').exec;

var remote = require('electron').remote;
var glob   = require('glob')
var fs     = require('fs');

window.$ = window.jQuery = require('jquery');

// variables
//-------------------------------------------------//
var close_button = document.querySelectorAll('.close');
var textbox_field = document.querySelectorAll('.textbox');

if (remote.getGlobal('shared_count').pdf_csv_stage=='original') {

    var csv_file_name     = remote.getGlobal('shared_file_list').file_list_non_reviewed_csv[pdf_csv_count];
    var pdf_file_name     = remote.getGlobal('shared_file_list').file_list_non_reviewed_pdf[pdf_csv_count];
    var pdf_file_name_new = 

};

// helper functions
//-------------------------------------------------//
require(remote.getGlobal('shared_code_path').helper_function_js_script);


//----------------------------------------------------------------------------//
//                                    Code                                    //
//----------------------------------------------------------------------------//

// submit buttons
//----------------------------------------------------------------------------//
$('.Submit').click(function () {

    var temp=remote.getGlobal('sharedObj3').csv_input_path;
    
    // if in update verification mode
    if (remote.getGlobal('shared_count').pdf_csv_stage=='original') {

        var return_value=';
        for (var i = 0; i < textbox_field.length; i++) {
            var textbox = textbox_field[i];
            return_value=return_value+'//////'+$(textbox).val();
        };
    
        console.log(return_value);

        return_value = return_value.replace(/ /g,'*****');
        console.log(return_value);

        // execute update script
        var command='bash ' + remote.getGlobal('shared_code_path').output_verification_script + return_value + 
            '' '+ csv_file_name +' '+ pdf_file_name +' '+ pdf_file_name_new;
        execute(command)
    
    };
    
    // reload/refresh window
    ipc.send('reload-pdf-csv-window');

});

// close buttons
//----------------------------------------------------------------------------//
prepare_button_ipc(close_button, 'close-pdf-csv-window')

//----------------------------------------------------------------------------//
//                                    End                                     //
//----------------------------------------------------------------------------//











