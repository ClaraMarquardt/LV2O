'use strict';

const electron = require('electron')
const {app, BrowserWindow} = electron
var ipc = require('electron').ipcMain
// // var app = require('app');
// var app = require('electron').app;
// // var BrowserWindow = require('browser-window');
// var BrowserWindow = require('electron').browser-window;

var mainWindow = null;

app.on('ready', function() {
	  console.log('done proxy kind of things'); 
   
    mainWindow = new BrowserWindow({
        frame: false,
        height: 700,
        resizable: false,
        width: 368
    });

    mainWindow.loadURL('file://' + __dirname + '/app/index.html');


});


ipc.on('open-baumer-window', function () {
var baumerWindow = new BrowserWindow({
        frame: false,
        height:250,
        resizable: false,
        width: 700
    });

    baumerWindow.loadURL('file://' + __dirname + '/app/baumer.html');

   

});


ipc.on('open-chicken-window', function () {
var chickenWindow = new BrowserWindow({
        frame: false,
        height:380,
        resizable: false,
        width: 470
    });

    chickenWindow.loadURL('file://' + __dirname + '/app/chicken.html');

   

});
