'use strict';

const electron = require('electron')
const {app, BrowserWindow} = electron
const PDFWindow = require('electron-pdf-window')
var ipc = require('electron').ipcMain
var glob = require("glob")
// // var app = require('app');
// var app = require('electron').app;
// // var BrowserWindow = require('browser-window');
// var BrowserWindow = require('electron').browser-window;



var mainWindow = null;
var baumerWindow = null;
var chickenWindow = null;
var PDFReader = null;
var csvWindow = null;

 var pdf_csv_count=-1;
 var input_path='/Users/claramarquardt/Google_Drive/Jobs/indep_project/herkules_nlp/tool/data/mod_data/annotated_pdf_csv_stage_c_ii/*pdf'
 var pdf_file_list=glob.sync(input_path);
 var input_path_new='/Users/claramarquardt/Google_Drive/Jobs/indep_project/herkules_nlp/tool/data/mod_data/verified_pdf_csv_stage_d_ii/*pdf'
 var pdf_file_list_new=glob.sync(input_path_new);

var csv_input_path='/Users/claramarquardt/Google_Drive/Jobs/indep_project/herkules_nlp/tool/data/mod_data/annotated_pdf_csv_stage_c_ii/*csv'
var csv_input_path_new='/Users/claramarquardt/Google_Drive/Jobs/indep_project/herkules_nlp/tool/data/mod_data/verified_pdf_csv_stage_d_ii/*csv'

global.sharedObj = {pdf_csv_count: pdf_csv_count};
global.sharedObj1 = { csv_input_path: csv_input_path};

ipc.on('show-pdf_csv_count', function(event) {
  console.log(global.sharedObj.pdf_csv_count);
});

app.on('ready', function() {
    const screen = require('electron').screen
const display = screen.getPrimaryDisplay()
console.log(display.workArea)

   
    mainWindow = new BrowserWindow({
        frame: false,
        height: 700,
        resizable: false,
        width: 368
    });

    mainWindow.loadURL('file://' + __dirname + '/app/index.html');

});

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


ipc.on('open-pdf-csv-window', function () {
 

if (pdf_csv_count>=2) {
    pdf_csv_count=-1
    global.sharedObj = {pdf_csv_count: pdf_csv_count};
};

  PDFReader = new PDFWindow({
    width: 800,
    height: 770,
    resizable: false,
    x:0,
    y:0

  })
  
 pdf_csv_count=pdf_csv_count+1;
 global.sharedObj = {pdf_csv_count: pdf_csv_count};

 // // console.log(pdf_csv_count);

 PDFReader.loadURL('file://' + pdf_file_list[pdf_csv_count]);


  csvWindow = new BrowserWindow({
        frame: false,
        height:770,
        resizable: false,
        width: (1270-800),
        x:805,
        y:0
    });

    csvWindow.loadURL('file://' + __dirname + '/app/table.html');


})


ipc.on('open-pdf-csv-window-new', function () {
 
global.sharedObj1 = { csv_input_path: csv_input_path_new};

if (pdf_csv_count>=2) {
    pdf_csv_count=-1
    global.sharedObj = {pdf_csv_count: pdf_csv_count};
};

  PDFReader = new PDFWindow({
    width: 800,
    height: 770,
    resizable: false,
    x:0,
    y:0

  })
  
 pdf_csv_count=pdf_csv_count+1;
 global.sharedObj = {pdf_csv_count: pdf_csv_count};

 // // console.log(pdf_csv_count);

 PDFReader.loadURL('file://' + pdf_file_list_new[pdf_csv_count]);


  csvWindow = new BrowserWindow({
        frame: false,
        height:770,
        resizable: false,
        width: (1270-800),
        x:805,
        y:0
    });

    csvWindow.loadURL('file://' + __dirname + '/app/table.html');

})


ipc.on('close-baumer-window', function () {
    baumerWindow.close();
});

ipc.on('close-chicken-window', function () {
    chickenWindow.close();

});

ipc.on('reload-pdf-csv-window', function () {
  
  pdf_csv_count=pdf_csv_count+1;
  global.sharedObj = {pdf_csv_count: pdf_csv_count};

  // console.log(pdf_csv_count);

  PDFReader.loadURL('file://' + pdf_file_list[pdf_csv_count]);

  csvWindow.loadURL('file://' + __dirname + '/app/table.html');

// if (pdf_csv_count==2) {
//     pdf_csv_count=-1
//     global.sharedObj = {pdf_csv_count: pdf_csv_count};

// };

});

ipc.on('close-pdf-csv-window', function () {
    PDFReader.close();
    csvWindow.close();

});


ipc.on('close-main-window', function () {
    app.quit();
});


