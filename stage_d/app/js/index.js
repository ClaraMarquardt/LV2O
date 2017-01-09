'use strict';
// var ipc= require('electron').ipcMain

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
    var soundButton = chickenButtons[i];
    preparechickenButton(soundButton);
}

function preparechickenButton(buttonEl) {

     buttonEl.addEventListener('click', function () {
      ipc.send('open-chicken-window');
});
}
