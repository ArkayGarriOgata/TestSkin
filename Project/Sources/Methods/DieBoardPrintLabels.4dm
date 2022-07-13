//%attributes = {}

// ----------------------------------------------------
// User name (OS): Philip Keth
// Date and time: 08/27/18, 11:22:13
// ----------------------------------------------------
// Method: DieBoardPrintLabels
// Description
// 
//
// Parameters
// ----------------------------------------------------
// Modified by: Mel Bohince (4/15/19) added call to app_SelectPrinter
C_LONGINT:C283($i)
If (Records in set:C195("DieBoardSet")>0)
	app_SelectPrinter("pick")  // Added by: Mel Bohince (4/15/19) 
	
	
	PRINT SETTINGS:C106
	If (OK=1)
		CUT NAMED SELECTION:C334([Job_DieBoard_Inv:168]; "HoldDBs")
		USE SET:C118("DieBoardSet")
		OPEN PRINTING JOB:C995
		For ($i; 1; Records in selection:C76([Job_DieBoard_Inv:168]))
			GOTO SELECTED RECORD:C245([Job_DieBoard_Inv:168]; $i)
			$xlPix:=Print form:C5([Job_DieBoard_Inv:168]; "DieBoardLabel")
			
		End for 
		CLOSE PRINTING JOB:C996
		
		app_SelectPrinter("reset")  // Added by: Mel Bohince (4/15/19) 
		
		USE NAMED SELECTION:C332("HoldDBs")
		HIGHLIGHT RECORDS:C656([Job_DieBoard_Inv:168]; "DieBoardSet")
	End if 
Else 
	ALERT:C41("You must select one or more records to print.")
End if 