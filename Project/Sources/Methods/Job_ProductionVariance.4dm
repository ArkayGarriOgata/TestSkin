//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 07/29/15, 11:35:48
// ----------------------------------------------------
// Method: Job_ProductionVariance
// Description
// 
//
// ----------------------------------------------------


C_LONGINT:C283($winRef; fileNum; JFActivity; iMode)
C_POINTER:C301(filePtr)
C_TEXT:C284($1; sFile)

<>pid_DieBoards:=0

If (Count parameters:C259=0)
	If (<>pid_DieBoards=0)
		<>pid_DieBoards:=uSpawnProcess("Job_ProductionVariance"; <>lMidMemPart; "Production Variance"; False:C215; False:C215; "init")
		If (False:C215)
			Job_ProductionVariance
		End if 
		
	Else 
		SHOW PROCESS:C325(<>pid_DieBoards)
		BRING TO FRONT:C326(<>pid_DieBoards)
		POST OUTSIDE CALL:C329(<>pid_DieBoards)
	End if 
	
Else 
	zSetUsageLog(->[Job_Forms:42]; "JobVariance"; "")
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
	
	windowTitle:=" Job Variance"
	OK:=1
	CostCtrCurrent("init"; "00/00/00")
	
	iMode:=3
	fAdHoc:=False:C215
	$winRef:=OpenFormWindow(filePtr; "ProductionClose"; ->windowTitle)
	READ ONLY:C145([Jobs:15])
	READ ONLY:C145([Job_Forms:42])
	READ ONLY:C145([Job_Forms_Items:44])
	READ ONLY:C145([Job_Forms_Machines:43])
	READ ONLY:C145([Job_Forms_Materials:55])
	READ ONLY:C145([Finished_Goods_Locations:35])
	READ ONLY:C145([Raw_Materials_Transactions:23])
	READ ONLY:C145([Finished_Goods_Transactions:33])
	
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
					DISPLAY SELECTION:C59(filePtr->; *)
					
				: (NumRecs1>1)
					bModMany:=True:C214
					DISPLAY SELECTION:C59(filePtr->; Multiple selection:K50:3; True:C214; *)
					bModMany:=False:C215  //may also be set by Done button
			End case 
			OK:=1
		End if 
	Until (OK=0)
	
	If (JFActivity=4)
		//CostCtrCurrent ("kill")
	End if 
	JFActivity:=0
	uClearSelection(->[Jobs:15])  //•031397  mBohince  and the lines below as well
	uClearSelection(->[Job_Forms_Items:44])
	uClearSelection(->[Job_Forms_Machine_Tickets:61])
	uClearSelection(->[Job_Forms_Materials:55])
	uClearSelection(->[Job_Forms_Machines:43])
	uClearSelection(->[Job_Forms_CloseoutSummaries:87])
	uClearSelection(->[Finished_Goods_Transactions:33])
	uClearSelection(->[Finished_Goods_Locations:35])
	uClearSelection(->[Raw_Materials_Transactions:23])
End if 