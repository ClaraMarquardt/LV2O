'use strict';

const electron = require('electron')
const {app, BrowserWindow} = electron
var ipc = require('electron').ipcMain
// // var app = require('app');
// var app = require('electron').app;
// // var BrowserWindow = require('browser-window');
// var BrowserWindow = require('electron').browser-window;

var mainWindow = null;
var baumerWindow = null;
var chickenWindow = null;

const PDFWindow = require('electron-pdf-window')
 
app.on('ready', () => {
  const win = new PDFWindow({
    width: 800,
    height: 600,
    x:10,
    y:1000
  })
 
  win.loadURL('http://mozilla.github.io/pdf.js/web/compressed.tracemonkey-pldi-09.pdf')
})



// app.on('ready', function() {
   
//     mainWindow = new BrowserWindow({
//         frame: false,
//         height: 700,
//         resizable: false,
//         width: 368
//     });

//     mainWindow.loadURL('file://' + __dirname + '/app/index.html');


// });


ipc.on('open-baumer-window', function () {
    baumerWindow = new BrowserWindow({
        frame: false,
        height:250,
        resizable: false,
        width: 700
    });

    baumerWindow.loadURL('file://' + __dirname + '/app/baumer.html');

   

});


ipc.on('open-chicken-window', function () {
    chickenWindow = new BrowserWindow({
        frame: false,
        height:380,
        resizable: false,
        width: 470
    });

    chickenWindow.loadURL('file://' + __dirname + '/app/chicken.html');

   

});

ipc.on('close-baumer-window', function () {
    baumerWindow.close();
});

ipc.on('close-chicken-window', function () {
    chickenWindow.close();

});


ipc.on('close-main-window', function () {
    app.quit();
});


