//%attributes = {"publishedWeb":true}
//PM:  RM_ReviewIssues  083002  mlb
//show the issues for a job or board type

fAdHoc:=False:C215  //flag for entry screens, 3/24/95
<>iMode:=3
<>filePtr:=->[Raw_Materials_Transactions:23]

uSetUp(1; 1)
gClearFlags
NewWindow(680; 392; 1; 8; "R/M Issues"; "wCloseCancel")

READ ONLY:C145([Raw_Materials_Transactions:23])

CONFIRM:C162("Search issues by R/M Code or Jobform?"; "R/M Code"; "Jobform")

If (OK=1)
	$criter:=Request:C163("Search for what Raw_Matl_Code?"; ""; "Find"; "Cancel")
	If (OK=1)
		QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue"; *)
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Raw_Matl_Code:1=$criter)
	End if 
Else 
	$criter:=Request:C163("Search for what jobform issues?"; "00000.00"; "Find"; "Cancel")
	If (OK=1)
		QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue"; *)
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]JobForm:12=$criter)
	End if 
End if 

If (OK=1)
	If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
		//OUTPUT FORM([RM_XFER];"RMRCInclList")
		DISPLAY SELECTION:C59([Raw_Materials_Transactions:23])
		//OUTPUT FORM([RM_XFER];"List")
	Else 
		BEEP:C151
		ALERT:C41("No issues found for "+$criter)
	End if 
End if 