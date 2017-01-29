'use strict';
// var ipc= require('electron').ipcMain
require('/usr/local/lib/node_modules/shelljs/global');
var shell = require("/usr/local/lib/node_modules/shelljs");

var remote = require('electron').remote;
console.log(remote.getGlobal('sharedObj').pdf_csv_count);     
var glob = require("glob")
var fs = require('fs');

window.$ = window.jQuery = require("jquery");

// require("jsdom").env("", function(err, window) {
// 	if (err) {
// 		console.error(err);
// 		return;
// 	}
var exec = require('child_process').exec;





var input_path='/Users/claramarquardt/Google_Drive/Jobs/indep_project/herkules_nlp/tool/data/mod_data/annotated_pdf_csv_stage_c_ii/*csv'
var csv_file_list=glob.sync(input_path);
var sample = csv_file_list[remote.getGlobal('sharedObj').pdf_csv_count];

var input_path_pdf='/Users/claramarquardt/Google_Drive/Jobs/indep_project/herkules_nlp/tool/data/mod_data/annotated_pdf_csv_stage_c_i/*pdf'
var pdf_file_list=glob.sync(input_path_pdf);
var pdf_sample = pdf_file_list[remote.getGlobal('sharedObj').pdf_csv_count];


function execute(command, callback){
    exec(command, function(error, stdout, stderr){ callback(stdout); });
};
// 	var $ = require("jquery")(window);

// $(".edit").click(function (e) {
//     if($(this).find("input").length !== 0) return false;
//     var ipt = $("<input>");
//     ipt.val($(this).text());
//     $(this).html(ipt);
//     console.log(ipt);
//     console.log($(ipt)["0"].value);
//     // ipt_g=ipt;

//     // e.stopPropagation();
// });

// });

	var textbox_field = document.querySelectorAll('.textbox');


    $(".Submit").click(function () {

    var return_value="";
	for (var i = 0; i < textbox_field.length; i++) {
    var textbox = textbox_field[i];
    // console.log($(textbox).val());
    return_value=return_value+"//////"+$(textbox).val();
	};
	console.log(return_value);

return_value=return_value.replace(/ /g,"*****");
console.log(return_value);

var command='bash /Users/claramarquardt/Google_Drive/Jobs/indep_project/herkules_nlp/experiments/part_c_output_verification/code/output_verification.sh "'+return_value+ '" '+ sample +' '+ pdf_sample;
console.log(command);
// call the function
execute(command, function(output) {
    // console.log(output);
});

ipc.send('reload-pdf-csv-window');


    });



var closeButtons = document.querySelectorAll('.close');

for (var i = 0; i < closeButtons.length; i++) {
    var closeButton = closeButtons[i];
    preparecloseButton(closeButton);
}

function preparecloseButton(buttonEl) {

     buttonEl.addEventListener('click', function () {
      ipc.send('close-pdf-csv-window');
});
}


// http://jsfiddle.net/DerekL/McJ4s/5/