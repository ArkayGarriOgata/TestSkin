//%attributes = {"publishedWeb":true}
//uExecute       
//this procedure executes a one line command entered from the keyboard
//•3/3/97 cs modified window type so that it is no longer modal
//  changed local flag for 'execute multiple' to interP so it holds
//• mlb - 5/8/02  10:51 fix type 3 crash and simplify interface

C_LONGINT:C283(cbOnce)
C_BOOLEAN:C305(fMultiple)

ON ERR CALL:C155("eExecuteErr")

Repeat 
	uDialog("ExecuteDialog"; 453; 150; 2)  // Open the Execute Dialog  
	If (OK=1)  //if OK...
		EXECUTE FORMULA:C63(vCommand)  //Execute the command    
		If (Find in array:C230(<>aCommand; vCommand; 1)=-1)  //Command does not exist in the "Q"
			INSERT IN ARRAY:C227(<>aCommand; 1; 1)  //Insert the command first in list
			<>aCommand{1}:=vCommand  //insert the Command
		End if 
		
		If (bOK=1)  //one pass
			OK:=0
		End if 
	End if 
	
Until (OK=0)  //Cancel is hit Quit

ON ERR CALL:C155("")