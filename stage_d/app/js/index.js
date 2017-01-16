'use strict';
// var ipc= require('electron').ipcMain
require('/usr/local/lib/node_modules/shelljs/global');
var shell = require("/usr/local/lib/node_modules/shelljs");
var soundButtons = document.querySelectorAll('.button-sound');
// var config = require('/usr/local/lib/node_modules/config');
// console.log(config);
// console.log(config.execPath);


var exec = require('child_process').exec;

function execute(command, callback){
    exec(command, function(error, stdout, stderr){ callback(stdout); });
};

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


var email_parsingButtons = document.querySelectorAll('.email_parsing');

for (var i = 0; i < email_parsingButtons.length; i++) {
    var email_parsingButton = email_parsingButtons[i];
    action_email_parsingButton(email_parsingButton);
}

function action_email_parsingButton(buttonEl) {

     buttonEl.addEventListener('click', function () {
     var hhh=ls();
     console.log(hhh);
     // console.log(config.execPath);
     // var output= shell.exec("bash /Users/claramarquardt/test.sh",{silent:true,async:false}).output;
     // console.log(output);


// call the function
execute('bash /Users/claramarquardt/Google\ Drive/Jobs/indep_project/herkules_nlp/experiments/part_a_extraction_parsing/code/machine_code/extract_machine.sh', function(output) {
    console.log(output);
});


});
}






