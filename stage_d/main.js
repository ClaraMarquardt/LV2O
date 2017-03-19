//----------------------------------------------------------------------------//

// Purpose:     Main.js - main.js file controlling electron app
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

// objects
const electron = require('electron')
const {app, BrowserWindow} = electron
var ipc = require('electron').ipcMain
var glob = require('glob')

// extensions
const PDFWindow = require('electron-pdf-window')
const {dialog} = require('electron')

require('/usr/local/lib/node_modules/shelljs/global');
var shell = require('/usr/local/lib/node_modules/shelljs');
var exec = require('child_process').exec;


// variables 
//-------------------------------------------------//
var main_window = null;
var baumer_window = null;
var chicken_window = null;
var csv_window = null;
var pdf_window = null;

var file_limit = null;
var file_limit_update = null;
var pdf_csv_count = -1;
var pdf_csv_count_update = -1;
var pdf_csv_stage = null;

// paths & file lists
//-------------------------------------------------//

// core
var wd_path = '/Users/claramarquardt/Google_Drive/Jobs/indep_project/herkules_nlp/tool/'

// original input paths
var input_path = wd_path + 'data/mod_data/annotated_pdf_csv_stage_c_ii/'

var input_path_pdf = input_path + '*.pdf'
var input_path_csv = input_path + '*.csv'
var input_path_pdf_reviewed = input_path + '*reviewed.pdf'
var input_path_csv_reviewed  = input_path + '*reviewed.csv'

// updated input paths
var input_path_update = wd_path + 'data/mod_data/annotated_pdf_csv_stage_d_ii/'

var input_path_update_pdf  = input_path + '*.pdf'
var input_path_update_csv = input_path + '*.csv'

var file_list_update_pdf = glob.sync(input_path_pdf);
var file_list_update_csv= glob.sync(input_path_csv);

// file lists
var file_list_pdf = glob.sync(input_path_pdf);
var file_list_reviewed_pdf = glob.sync(input_path_pdf_reviewed);
var file_list_non_reviewed_pdf = file_list_pdf.filter(function(x){return file_list_pdf_reviewed.indexOf(x) < 0 });

var file_list_csv = glob.sync(input_path_csv);
var file_list_reviewed_csv = glob.sync(input_path_csv_reviewed);
var file_list_non_reviewed_csv = file_list_csv.filter(function(x){return file_list_csv_reviewed.indexOf(x) < 0 });


// scripts
var output_verification_reset_script = wd_path + 'code_base/experimental/part_c_output_verification/code/output_verification_reset.sh';

var email_parsing_script   = wd_path + 'code_base/experimental/part_a_extraction_parsing/code/machine_code/extract_machine.sh';
var info_extraction_script = wd_path + 'code_base/experimental/part_a_extraction_parsing/code/machine_code/extract_info_machine.sh'
var pdf_annotation_script  = wd_path + 'code_base/experimental/part_b_pdf_output/code/output_machine.sh'
var output_verification_script  = wd_path + 'code_base/experimental/part_c_output_verification/code/output_verification.sh'

var helper_function_js_script = wd_path + 'code_base/stage_d/app/js/helper_function.js'

// global variables
//-------------------------------------------------//

// dynamic global 
global.shared_count  = {pdf_csv_count: pdf_csv_count, pdf_csv_count_update: pdf_csv_count_update,
                          pdf_csv_stage: pdf_csv_stage, file_limit : file_limit};

global.shared_file   = {file_list_csv: file_list_csv, file_list_pdf: file_list_pdf};


// stable global 
global.shared_path   = {wd_path: wd_path, input_path_csv: input_path_csv, input_path_pdf: input_path_pdf};

global.shared_code_path   = {
  output_verification_reset_script: output_verification_reset_script, 
  email_parsing_script: email_parsing_script, 
  info_extraction_script: info_extraction_script, 
  pdf_annotation_script: pdf_annotation_script,
  output_verification_script: output_verification_script,
  helper_function_js_script: helper_function_js_script
};

// helper functions
//-------------------------------------------------//
require(helper_function_js_script);

// update file paths and associated global objects
function update_file_list() {

  file_list_pdf = glob.sync(input_path_pdf);
  file_list_reviewed_pdf = glob.sync(input_path_pdf_reviewed);
  file_list_non_reviewed_pdf = file_list_pdf.filter(function(x){return file_list_pdf_reviewed.indexOf(x) < 0 });

  file_list_csv = glob.sync(input_path_csv);
  file_list_reviewed_csv = glob.sync(input_path_csv_reviewed);
  file_list_non_reviewed_csv = file_list_csv.filter(function(x){return file_list_csv_reviewed.indexOf(x) < 0 });

  file_limit        = file_list_non_reviewed_pdf.length();
  file_limit_update = file_list_reviewed_pdf.length();

  global.shared_count.pdf_csv_count = pdf_csv_count;
  global.shared_count.pdf_csv_count_update = pdf_csv_count_update;
  global.shared_count.pdf_csv_stage = pdf_csv_stage;

  global.shared_count.file_limit           = file_limit;
  global.shared_count.file_limit_update    = file_limit_update;

  global.shared_file.file_list_csv  = file_list_csv;
  global.shared_file.file_list_pdf  = file_list_pdf;
  global.shared_file.file_list_update_csv  = file_list_update_csv;
  global.shared_file.file_list_update_pdf  = file_list_update_pdf;

};


//----------------------------------------------------------------------------//
//                                    Code                                    //
//----------------------------------------------------------------------------//

// Intialise app & start main_window
//----------------------------------------------------------------------------//

app.on('ready', function() {
    const screen = require('electron').screen
    const display = screen.getPrimaryDisplay()

    // set display size
    // console.log(display.workArea)
    main_window = new BrowserWindow({
        frame: false,
        height: 700,
        width: 368,
        resizable: false
    });

    main_window.loadURL('file://' + __dirname + '/app/index.html');

});


// baumer_window
//----------------------------------------------------------------------------//

ipc.on('open-baumer-window', function () {
    baumer_window = new BrowserWindow({
        frame: false,
        height:250,
        width: 700,
        resizable: false
    });

    baumer_window.loadURL('file://' + __dirname + '/app/baumer.html');

});


// chicken_window
//----------------------------------------------------------------------------//

ipc.on('open-chicken-window', function () {
    chicken_window = new BrowserWindow({
        frame: false,
        height:380,
        width: 470,
        resizable: false
    });

    chicken_window.loadURL('file://' + __dirname + '/app/chicken.html');

});


// pdf_csv_window
//----------------------------------------------------------------------------//

ipc.on('open-pdf-csv-window', function () {
 
  // update file lists and global objects
  pdf_csv_count = -1;
  pdf_csv_stage = 'original';

  update_file_list();
  console.log('file_limit:' + file_limit)
  console.log('pdf_csv_count:' + pdf_csv_count);

  if (file_limit>0) {

    // open pdf window
    pdf_window = new PDFWindow({
      width: 800,
      height: 770,
      resizable: false,
      x:0,
      y:0
    })
  
    // load 1st pdf
    pdf_csv_count=pdf_csv_count+1;
    global.shared_count.pdf_csv_count = pdf_csv_count;

    pdf_window.loadURL('file://' + file_list_reviewed_pdf[pdf_csv_count]);


    // open csv window
    csv_window = new BrowserWindow({
        frame: false,
        height:770,
        resizable: false,
        width: (1270-800),
        x:805,
        y:0
    });

    // load csv
    csv_window.loadURL('file://' + __dirname + '/app/table.html');

  } else if (file_limit==0) {
   
    // dialogue box
    var response=dialog.showMessageBox({ message: 'No more orders to review',
         buttons: ['OK', 'Reset'] });

    // reset output verification
    if (response==1) {
      
      var command ='bash ' + output_verification_reset_script;
      execute_silent(command);
   
    };
  };
})


// pdf_csv_window_new
//----------------------------------------------------------------------------//

ipc.on('open-pdf-csv-window-new', function () {
 
  // update file lists and global objects
  pdf_csv_count_update = -1;
  pdf_csv_stage = 'update';

  update_file_list();
  console.log('file_limit:' + file_limit_update);
  console.log('pdf_csv_count:' + pdf_csv_count_update);

  // open pdf window
  pdf_window = new PDFWindow({
    width: 800,
    height: 770,
    resizable: false,
    x:0,
    y:0

  })
  
  // load 1st pff
  pdf_csv_count_update=pdf_csv_count_update+1;
  global.shared_count.pdf_csv_count_update = pdf_csv_count_update;

  pdf_window.loadURL('file://' + file_list_update_pdf[pdf_csv_count_update]);

  // open csv window
  csv_window = new BrowserWindow({
        frame: false,
        height:770,
        resizable: false,
        width: (1270-800),
        x:805,
        y:0
    });

  // load csv
  csv_window.loadURL('file://' + __dirname + '/app/table.html');

})

// pdf_csv_window - reload
//----------------------------------------------------------------------------//

ipc.on('reload-pdf-csv-window', function () {

  // update file lists and global objects
  if (pdf_csv_stage=='original') {

    pdf_csv_count = pdf_csv_count+1;
    global.shared_count.pdf_csv_count = pdf_csv_count;
    console.log('pdf_csv_count:' + pdf_csv_count);

  } else if (pdf_csv_stage=='update') {

    pdf_csv_count_update = pdf_csv_count_update+1;
    global.shared_count.pdf_csv_count_update = pdf_csv_count_update;
    console.log('pdf_csv_count:' + pdf_csv_count_update);

  }

  if (pdf_csv_count>(file_limit-1)) {

    pdf_window.close();
    csv_window.close();

    // dialogue box
    var response=dialog.showMessageBox({ message: 'No more orders to review',
         buttons: ['OK'] });


  } else {
    
    // reload pdf window
    pdf_window.destroy();
    pdf_window = null;

    pdf_window = new PDFWindow({
      width: 800,
      height: 770,
      resizable: false,
      x:0,
      y:0
    })

    if (pdf_csv_stage=='original') {
      pdf_window.loadURL('file://' + file_list_pdf[pdf_csv_count_update]);
    } else if (pdf_csv_stage=='update') {
      pdf_window.loadURL('file://' + file_list_update_pdf[pdf_csv_count_update]);
    };

    // reload csv window
    csv_window.loadURL('file://' + __dirname + '/app/table.html');


};

});

// close window
//----------------------------------------------------------------------------//

ipc.on('close-baumer-window', function () {
    baumer_window.close();
});

ipc.on('close-chicken-window', function () {
    chicken_window.close();
});

ipc.on('close-pdf-csv-window', function () {
    pdf_window.close();
    csv_window.close();
});
ipc.on('close-main-window', function () {
    app.quit();
});




//----------------------------------------------------------------------------//
//                                    End                                     //
//----------------------------------------------------------------------------//













