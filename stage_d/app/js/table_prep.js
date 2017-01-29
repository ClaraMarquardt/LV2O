'use strict';
// var ipc= require('electron').ipcMain
console.log("xxxx");
var remote = require('electron').remote;
console.log(remote.getGlobal('sharedObj').pdf_csv_count);     
var glob = require("glob")


window.$ = window.jQuery = require("jquery");
require('/Users/claramarquardt/Google_Drive/Jobs/indep_project/herkules_nlp/tool/code_base/stage_d/other_dependencies/jquery-csv-master/src/jquery.csv.js');
var fs = require('fs');

// var input_path='/Users/claramarquardt/Google_Drive/Jobs/indep_project/herkules_nlp/tool/data/mod_data/annotated_pdf_csv_stage_c_ii/*csv'

var input_path=(remote.getGlobal('sharedObj1').csv_input_path);
console.log(input_path);
var csv_file_list=glob.sync(input_path);
	var sample = csv_file_list[remote.getGlobal('sharedObj').pdf_csv_count];
console.log(sample);
window.onload = function(sample_file=sample) {
console.log("resample");

var labels = document.querySelectorAll('#var_name');
var text_fields = document.querySelectorAll('#var_value');
console.log(sample);
fs.readFile(sample, 'UTF-8', function(err, csv) {
  $.csv.toArrays(csv, {}, function(err, data) {
    for(var i=1, len=data.length; i<len; i++) {
      console.log(data[i]);
      var var_name=data[i][0];
      var var_value=data[i][1];
      console.log(var_name);
      console.log(var_value);
      labels[i-1].innerHTML=var_name;
      text_fields[i-1].value=var_value;
    };
  });
});
};





