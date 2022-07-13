//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 15/05/08, 14:51:14
// ----------------------------------------------------
// Method: Job_Die_Boards
// ----------------------------------------------------

C_LONGINT:C283($winRef; fileNum)
C_POINTER:C301(filePtr)
C_TEXT:C284($1; sFile)

<>pid_DieBoards:=0
If (Count parameters:C259=0)
	If (<>pid_DieBoards=0)
		<>pid_DieBoards:=uSpawnProcess("Job_Die_Boards"; <>lMidMemPart; "Job Die Boards"; False:C215; False:C215; "init")
		If (False:C215)
			Job_Die_Boards
		End if 
		
	Else 
		SHOW PROCESS:C325(<>pid_DieBoards)
		BRING TO FRONT:C326(<>pid_DieBoards)
		POST OUTSIDE CALL:C329(<>pid_DieBoards)
	End if 
	
Else 
	fileNum:=Table:C252(->[Job_Forms:42])
	filePtr:=Table:C252(fileNum)
	sFile:=Table name:C256(filePtr)
	printMenuSupported:=True:C214
	SET MENU BAR:C67(<>DefaultMenu)
	
	ARRAY INTEGER:C220($aFieldNums; 0)  //•090195  MLB      
	COPY ARRAY:C226(<>aSlctFF{Table:C252(filePtr)}; $aFieldNums)  //aSlctField  
	
	ARRAY POINTER:C280(aSlctField; 0)
	ARRAY POINTER:C280(aSlctField; 6)  // for backward compatiblity
	ARRAY TEXT:C222(aSelectBy; 0)
	ARRAY TEXT:C222(aSelectBy; 13)
	
	windowTitle:=" Die Board"
	OK:=1
	$winRef:=OpenFormWindow(filePtr; "DieBoard"; ->windowTitle)
	Repeat 
		DIALOG:C40([Job_Forms:42]; "DieBoard_Find")
		ERASE WINDOW:C160
		If (OK=1)
			CREATE SET:C116(filePtr->; "◊LastSelection"+String:C10(fileNum))
			SET WINDOW TITLE:C213(fNameWindow(filePtr)+windowTitle)
			
			Case of 
				: (NumRecs1=0)
					BEEP:C151
				: (NumRecs1=1)
					MODIFY RECORD:C57(filePtr->; *)
					
				: (NumRecs1>1)
					bModMany:=True:C214
					MODIFY SELECTION:C204(filePtr->; Multiple selection:K50:3; True:C214; *)
					bModMany:=False:C215  //may also be set by Done button
			End case 
			OK:=1
		End if 
	Until (OK=0)
End if 