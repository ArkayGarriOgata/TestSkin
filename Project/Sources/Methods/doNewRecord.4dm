//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: doNewRecord
// ----------------------------------------------------

C_LONGINT:C283($winRef)

fAdHoc:=False:C215  //Flag for entry screens, 3/24/95
uSetUp(1; 1)  //doNewRecord() doreviewRecord domodifyRecord
gClearFlags
windowTitle:=" Adding records"

READ WRITE:C146(filePtr->)

Case of   //Need to override forms "Input"&"List" or special setup
	: (sFile="")
		$mySplWindowTitle:="Hey, Something is wrong!"
		$winRef:=OpenFormWindow(filePtr; "Input"; ->windowTitle; $mySplWindowTitle)
		
	Else 
		$winRef:=OpenFormWindow(filePtr; "*"; ->windowTitle)
End case 

Repeat 
	If (<>SCROLLING)
		ADD RECORD:C56(filePtr->)
	Else 
		ADD RECORD:C56(filePtr->; *)
	End if 
	ControlCtrFill(filePtr)  // Added by: Mark Zinke (3/27/13)
	
	$userOK:=OK  // Use this if you want the user to keep adding until cancel
	OK:=0  //Only add one record
	
	Case of 
		: (filePtr=(->[Estimates:17]))
			SAVE RECORD:C53([Estimates_Carton_Specs:19])
			SAVE RECORD:C53([Estimates_Machines:20])
			SAVE RECORD:C53([Process_Specs:18])
			SAVE RECORD:C53([Estimates_FormCartons:48])
			SAVE RECORD:C53([Estimates_DifferentialsForms:47])
			SAVE RECORD:C53([Estimates_Differentials:38])
			
			uClearEstimates
			
			
		: (filePtr=(->[y_accounting_departments:4]))
			UpdateDeptList  //Recreate the department lists - resets OK
			OK:=$userOK  // Modified by: Mel Bohince (6/24/19) 
			
		: (filePtr=(->[Cost_Centers:27]))  //• 3/26/98 cs 
			uSetupCCDivisio  //Update interprocess sets 
			OK:=0
			
		: (filePtr=(->[QA_Corrective_Actions:105]))
			$i:=CAR_Locations("init")
			
	End case 
	
	windowTitle:=" Adding records"
	CREATE SET:C116(filePtr->; "◊LastSelection"+String:C10(fileNum))
	SET WINDOW TITLE:C213(fNameWindow(filePtr)+" Adding records"; $winRef)
	
Until (OK=0)

uWinListCleanup