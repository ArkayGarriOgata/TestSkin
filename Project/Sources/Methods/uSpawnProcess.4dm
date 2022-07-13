//%attributes = {"publishedWeb":true}
//uSpawnProcess(string;integer;string;boolean;boolean) -> longint
//string - procedure to run
//integer - stack size (memory for process variables
//string - name of process created
//boolean - (true) inform the user that there wasn't enough memory to create
//      the process. (false) don't inform the user
//boolean - if true, allow multiple views
//-> longint - process id, zero if process wasn't created

//MOD 10/21/94 Chip (see comment)
//4/28/95, changed compiler definition of window title from alpha 30 -> text
//• 7/9/97 cs extraneous outside call to list process
//•3/27/00  mlb allow a text parameter to be passed in

C_LONGINT:C283($ID; $0; $2; $Memory)
C_TEXT:C284($1)
C_TEXT:C284($3; $Next; $6)  //4/28/95
C_BOOLEAN:C305($4; $5; $fAllowMulti)

If ($2<<>lMinMemPart)  //added to circumvent too little memory allowcated to a process
	$Memory:=<>lMinMemPart  //64k  see uInitInterPrsVar
Else 
	$Memory:=$2
End if 

If (Count parameters:C259>=4)
	fDoErrMsg:=$4  //as specified
Else 
	fDoErrMsg:=True:C214  //default
End if 

If (Count parameters:C259>=5)
	$fAllowMulti:=$5  //as specified
Else 
	$fAllowMulti:=True:C214  //default
End if 

$id:=uProcessID($3)

If ($id=-1)
	If (Not:C34(Semaphore:C143("$QUIT ALL")))
		CLEAR SEMAPHORE:C144("$QUIT ALL")
		//ON ERR CALL("eProcess")
		If (Count parameters:C259<6)
			If ($1="BatchTHCCalc")  // Added by: Mark Zinke (11/13/12)
				REGISTER CLIENT:C648("BatchTHCCalc")  // Added by: Mark Zinke (11/14/12). Used by the process on the server to send back info.
				$id:=Execute on server:C373($1; $Memory; $3)  // Added by: Mark Zinke (11/13/12)
			Else 
				$id:=New process:C317($1; $Memory; $3)
			End if 
			//app_Log_Usage ("log";$1;$3)
		Else 
			$id:=New process:C317($1; $Memory; $3; $6)
			//app_Log_Usage ("log";$1;$3+" "+$6)
		End if 
		zwStatusMsg(String:C10(Current time:C178; HH MM SS:K7:1); $3)
		//ON ERR CALL("")
		If ($id=0)
			BEEP:C151
			ALERT:C41("Not enough memory to perform the action. "+"Try closing windows to make more memory available.")
			zwStatusMsg("ERROR"; "Process could not be created")
			$0:=-1
		End if 
	End if 
	
Else 
	If (<>fMultiviews) & ($fAllowMulti)
		// ON ERR CALL("eProcess")
		$Next:=$3+String:C10(uNextView($3))
		If (Count parameters:C259<6)
			$id:=New process:C317($1; $Memory; $Next)
			//app_Log_Usage ("log";$1;$Next)
		Else 
			$id:=New process:C317($1; $Memory; $Next; $6)
			//app_Log_Usage ("log";$1;$Next+" "+$6)
		End if 
		
		zwStatusMsg(String:C10(Current time:C178; HH MM SS:K7:1); $Next)
		
		If ($id=0)
			BEEP:C151
			ALERT:C41("Not enough memory to perform the action. "+"Try closing windows to make more memory available.")
			zwStatusMsg("ERROR"; "Process could not be created")
			$0:=-1
		End if 
		
	Else 
		BRING TO FRONT:C326($id)
	End if 
End if 

If (<>PrcsListPr>0)  //• 7/9/97 cs stop unneeded calls this screws up other proces
	<>aPrcsName:=0
	POST OUTSIDE CALL:C329(<>PrcsListPr)  //update process list
Else 
	uProcessLookup
End if 

$0:=$id