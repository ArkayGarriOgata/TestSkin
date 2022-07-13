//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 07/29/15, 10:50:48
// ----------------------------------------------------
// Method: Job_ModifyActuals
// Description
// put query in a loop instead of using viewsetter
//
// ---------------------------------------------------- 


C_LONGINT:C283($winRef; fileNum; JFActivity; iMode)
C_POINTER:C301(filePtr)
C_TEXT:C284($1; sFile)

<>pid_DieBoards:=0

If (Count parameters:C259=0)
	If (<>pid_DieBoards=0)
		<>pid_DieBoards:=uSpawnProcess("Job_ModifyActuals"; <>lMidMemPart; "Modify Actuals"; False:C215; False:C215; "init")
		If (False:C215)
			Job_ModifyActuals
		End if 
		
	Else 
		SHOW PROCESS:C325(<>pid_DieBoards)
		BRING TO FRONT:C326(<>pid_DieBoards)
		POST OUTSIDE CALL:C329(<>pid_DieBoards)
	End if 
	
Else 
	zSetUsageLog(->[Job_Forms:42]; "ModifyActuals"; "")
	JFActivity:=<>JFActivity
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
	
	windowTitle:=" Job Modify Actuals"
	OK:=1
	CostCtrCurrent("init"; "00/00/00")
	ARRAY TEXT:C222(aCommCode; 0)  //choice list verifications
	LIST TO ARRAY:C288("CommCodes"; aCommCode)
	ARRAY TEXT:C222($aCompId; 0)
	LIST TO ARRAY:C288("Company"; $aCompId)
	ARRAY TEXT:C222(aCompany; Size of array:C274($aCompId))
	ARRAY TEXT:C222($Dept; 0)
	LIST TO ARRAY:C288("Departments"; $dept)
	ARRAY TEXT:C222(aDeptCode; Size of array:C274($Dept))
	C_LONGINT:C283($i)
	For ($i; 1; Size of array:C274($aCompId))
		aCompany{$i}:=String:C10(Num:C11(Substring:C12($aCompId{$i}; 1; 2)))
	End for 
	ARRAY TEXT:C222($aCompId; 0)
	
	For ($i; 1; Size of array:C274($Dept))
		aDeptCode{$i}:=Substring:C12($Dept{$i}; 1; 4)
	End for 
	ARRAY TEXT:C222($dept; 0)
	
	iMode:=2  // Modified by: Mel Bohince (7/30/15) 
	fAdHoc:=False:C215
	$winRef:=OpenFormWindow(filePtr; "InputActual2"; ->windowTitle)
	
	READ WRITE:C146([Jobs:15])
	READ WRITE:C146([Job_Forms:42])
	READ WRITE:C146([Job_Forms_Items:44])
	READ WRITE:C146([Job_Forms_Machines:43])
	READ WRITE:C146([Job_Forms_Materials:55])
	READ WRITE:C146([Finished_Goods_Locations:35])
	READ WRITE:C146([Raw_Materials_Transactions:23])
	READ WRITE:C146([Finished_Goods_Transactions:33])
	READ WRITE:C146([Job_Forms_Machine_Tickets:61])
	
	
	Repeat 
		DIALOG:C40([Job_Forms:42]; "JobBag_Find")
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
	
	//CostCtrCurrent ("kill")
	JFActivity:=0
	uClearSelection(->[Jobs:15])  //•031397  mBohince  and the lines below as well
	uClearSelection(->[Job_Forms_Items:44])
	uClearSelection(->[Job_Forms_Machine_Tickets:61])
	uClearSelection(->[Job_Forms_Materials:55])
	uClearSelection(->[Job_Forms_Machines:43])
	REDUCE SELECTION:C351([Job_DieBoards:152]; 0)
	uClearSelection(->[Job_Forms_CloseoutSummaries:87])
	uClearSelection(->[Finished_Goods_Transactions:33])
	uClearSelection(->[Finished_Goods_Locations:35])
	uClearSelection(->[Raw_Materials_Transactions:23])
	ARRAY TEXT:C222(aCompany; 0)  //clear arrays
	ARRAY TEXT:C222(aCommCode; 0)
	ARRAY TEXT:C222(aDeptCode; 0)
End if 

