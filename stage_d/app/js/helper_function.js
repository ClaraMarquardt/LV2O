//----------------------------------------------------------------------------//

// Purpose:     Define helper functions
// Project:     NLP sales/order automation
// Author:      Clara Marquardt
// Date:        2017
// Notes:       /

//----------------------------------------------------------------------------#

//----------------------------------------------------------------------------//
//                                    Code                                    //
//----------------------------------------------------------------------------//

// execute shell command
//----------------------------------------------------------------------------//
function execute(command, verbose=false, dialogue=false, dialogue_desc='') {
      
      exec(command, function(error, stdout, stderr){
      	
      	if (verbose==false) {
      		console.log(stdout);
      	};


      	if (dialogue==true) {
    		var response=dialog.showMessageBox({ message: 'Completed: ' + dialogue_desc,
         		buttons: ['OK'] });
      	};

      });
};

// prepare button - ipc
//----------------------------------------------------------------------------//

function prepare_button_ipc(button_list, ipc_command) {

    for (var i = 0; i < button_list.length; i++) {
      var button = button_list[i];
      prepare_button_ipc_sub(button);
    };

    function prepare_button_ipc_sub(button) {
      button.addEventListener('click', function () {
        ipc.send(ipc_command);
      });
    };
};

// prepare button - shell script
//----------------------------------------------------------------------------//

function prepare_button_shell_script(button_list, script, desc='', 
	verbose_arg=false, dialogue_arg=true) {
    
    for (var i = 0; i < button_list.length; i++) {
      var button = button_list[i];
      prepare_button_shell_script_sub(button);
    };

    function prepare_button_shell_script_sub(button) {
      button.addEventListener('click', function () {
        
        console.log(desc);
        command = 'bash ' + script;

        if (verbose_arg==false) {

          execute(command, verbose=false, dialogue=dialogue_arg, 
          	dialogue_desc=desc);

        } else if (verbose_arg==true) {

          execute(command, verbose=true);

        };
      });
    };
};

// export
//----------------------------------------------------------------------------//

module.exports = {
	test: test,
	execute: execute,
	prepare_button_ipc: prepare_button_ipc, 
	prepare_button_shell_script: prepare_button_shell_script
};

//----------------------------------------------------------------------------//
//                                    End                                     //
//----------------------------------------------------------------------------//




