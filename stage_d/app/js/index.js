'use strict';
// var ipc= require('electron').ipcMain
require('/usr/local/lib/node_modules/shelljs/global');
var shell = require("/usr/local/lib/node_modules/shelljs");

// var config = require('/usr/local/lib/node_modules/config');
// console.log(config);
// console.log(config.execPath);


var exec = require('child_process').exec;

function execute(command, callback){
    exec(command, function(error, stdout, stderr){ callback(stdout); });
};

var soundButtons = document.querySelectorAll('.button-sound');

for (var i = 0; i < soundButtons.length; i++) {
    var soundButton = soundButtons[i];
    var soundName = soundButton.attributes['data-sound'].value;

    prepareSoundButton(soundButton, soundName);
}

function prepareSoundButton(buttonEl, soundName) {
    buttonEl.querySelector('span').style.backgroundImage = 'url("img/icons/' + soundName + '.png")';

    var audio = new Audio(__dirname + '/wav/' + soundName + '.wav');
    buttonEl.addEventListener('click', function () {
        audio.currentTime = 0;
        audio.play();
    });
}


var baumerButtons = document.querySelectorAll('.baumer');

for (var i = 0; i < baumerButtons.length; i++) {
    var soundButton = baumerButtons[i];
    prepareBaumerButton(soundButton);
}

function prepareBaumerButton(buttonEl) {

     buttonEl.addEventListener('click', function () {
      ipc.send('open-baumer-window');
});
}


var chickenButtons = document.querySelectorAll('.chicken');

for (var i = 0; i < chickenButtons.length; i++) {
    var chickenButton = chickenButtons[i];
    preparechickenButton(chickenButton);
}

function preparechickenButton(buttonEl) {

     buttonEl.addEventListener('click', function () {
      ipc.send('open-chicken-window');
});
}



var closeButtons = document.querySelectorAll('.close');

for (var i = 0; i < closeButtons.length; i++) {
    var closeButton = closeButtons[i];
    preparecloseButton(closeButton);
}

function preparecloseButton(buttonEl) {

     buttonEl.addEventListener('click', function () {
      ipc.send('close-main-window');
});
}

///// main components scripts

// Button 1: Download and parse (.email_parsing)
// Button 2: Extract and save csv and annotated PDF (.info_extraction)
// Button 3: Annotate PDF with resulting information - product code (.pdf_annotation)
// Button 4: Launch PDF/CSV - read in csv file / open PDF & save  modified versions  (.output_verification)
// Button 5: Open modified annotated pdf/csv (.final_output)


//1 - .email_parsing

var email_parsingButtons = document.querySelectorAll('.email_parsing');

for (var i = 0; i < email_parsingButtons.length; i++) {
    var email_parsingButton = email_parsingButtons[i];
    prepareemail_parsingButton(email_parsingButton);
}

function prepareemail_parsingButton(buttonEl) {

     buttonEl.addEventListener('click', function () {
console.log('.email_parsing -- stage #1');


// call the function
execute('bash /Users/claramarquardt/Google_Drive/Jobs/indep_project/herkules_nlp/experiments/part_a_extraction_parsing/code/machine_code/extract_machine.sh', function(output) {
    console.log(output);
});

});
}


//2 - .info_extraction

var info_extractionButtons = document.querySelectorAll('.info_extraction');

for (var i = 0; i < info_extractionButtons.length; i++) {
    var info_extractionButton = info_extractionButtons[i];
    prepareinfo_extractionButton(info_extractionButton);
}

function prepareinfo_extractionButton(buttonEl) {

     buttonEl.addEventListener('click', function () {
console.log('.info_extraction -- stage #2');


// call the function
execute('bash /Users/claramarquardt/Google_Drive/Jobs/indep_project/herkules_nlp/experiments/part_a_extraction_parsing/code/machine_code/extract_info_machine.sh', function(output) {
    console.log(output);
});

});
}

//3 - .pdf_annotation

var pdf_annotationButtons = document.querySelectorAll('.pdf_annotation');

for (var i = 0; i < pdf_annotationButtons.length; i++) {
    var pdf_annotationButton = pdf_annotationButtons[i];
    preparepdf_annotationButton(pdf_annotationButton);
}

function preparepdf_annotationButton(buttonEl) {

     buttonEl.addEventListener('click', function () {
console.log('.pdf_annotation -- stage #2');


// call the function
execute('bash /Users/claramarquardt/Google_Drive/Jobs/indep_project/herkules_nlp/experiments/part_b_pdf_output/code/output_machine.sh', function(output) {
    console.log(output);
});

});
}

//4 - .output_verification

var output_verificationButtons = document.querySelectorAll('.output_verification');

for (var i = 0; i < output_verificationButtons.length; i++) {
    var output_verificationButton = output_verificationButtons[i];
    prepareoutput_verificationButton(output_verificationButton);
}

function prepareoutput_verificationButton(buttonEl) {

     buttonEl.addEventListener('click', function () {
console.log('.output_verification -- stage #2');

      ipc.send('open-pdf-csv-window');


});
}


//4 - .final_output

var final_outputButtons = document.querySelectorAll('.final_output');

for (var i = 0; i < final_outputButtons.length; i++) {
    var final_outputButton = final_outputButtons[i];
    preparefinal_outputButton(final_outputButton);
}

function preparefinal_outputButton(buttonEl) {

     buttonEl.addEventListener('click', function () {
console.log('.final_output -- stage #2');

      ipc.send('open-pdf-csv-window-new');


});
}






