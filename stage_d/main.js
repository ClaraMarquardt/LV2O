'use strict';

const electron = require('electron')
const {app, BrowserWindow} = electron
// // var app = require('app');
// var app = require('electron').app;
// // var BrowserWindow = require('browser-window');
// var BrowserWindow = require('electron').browser-window;

var mainWindow = null;

app.on('ready', function() {
    mainWindow = new BrowserWindow({
        frame: true,
        height: 700,
        resizable: false,
        width: 368
    });

    mainWindow.loadURL('file://' + __dirname + '/app/index.html');
});
