//----------------------------------------------------------------------------//

// Purpose:     Control csv - prep
// Project:     NLP sales/order automation
// Author:      Clara Marquardt
// Date:        2017
// Notes:       /

//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
//                               Control Section                              //
//----------------------------------------------------------------------------//

// set-up & dependencies
//---------------------------------------//
'use strict';

require('/usr/local/lib/node_modules/shelljs/global');
var shell = require("/usr/local/lib/node_modules/shelljs");
var exec = require('child_process').exec;

var remote = require('electron').remote;
var glob   = require("glob")
var fs     = require('fs');

window.$ = window.jQuery = require("jquery");
require(remote.getGlobal('shared_path').wd_path + 
  'code_base/stage_d/other_dependencies/jquery-csv-master/src/jquery.csv.js');

//---------------------------------------//
var label         = document.querySelectorAll('#var_name');
var text_field    = document.querySelectorAll('#var_value');
var submit_button = document.querySelectorAll('.Submit');

if (remote.getGlobal('shared_count').pdf_csv_stage=='original') {

  var csv_file_name = remote.getGlobal('shared_file_list').file_list_non_reviewed_csv[pdf_csv_count];
  var button_text   = "Submit";

} else if (remote.getGlobal('shared_count').pdf_csv_stage=='update'){

  var csv_file_name = remote.getGlobal('shared_file_list').file_list_non_reviewed_csv[pdf_csv_count];
  var button_text   = "Next";

};

// helper functions
//-------------------------------------------------//
require(remote.getGlobal('shared_code_path').helper_function_js_script);


//----------------------------------------------------------------------------//
//                                    Code                                    //
//----------------------------------------------------------------------------//

// load data from csv & update buttons 
//----------------------------------------------------------------------------//

window.onload = function(file=csv_file_name) {

  fs.readFile(file_nane, 'UTF-8', function(err, csv) {
    $.csv.toArrays(csv, {}, function(err, data) {
      for(var i=0, len=data.length; i<len; i++) {
        var var_name=data[i][0];
        var var_value=data[i][1];
        labels[i].innerHTML=var_name;
        text_fields[i].value=var_value;
      };
    });
  });
};

// load data from csv
//----------------------------------------------------------------------------//
for(var i=0, len=submit_button.length; i<len; i++) {

  submit_button[i].innerText=button_text;

};

//----------------------------------------------------------------------------//
//                                    End                                     //
//----------------------------------------------------------------------------//







