//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 01/22/08, 14:13:11
// ----------------------------------------------------
// Method: CAR_setToCompleted
// ----------------------------------------------------

If (Not:C34(Read only state:C362([QA_Corrective_Actions:105])))
	$hilited:=Records in set:C195("UserSet")
	If ($hilited>0)
		uConfirm("Set the "+String:C10($hilited)+" highlighted records to Complete status?"; "OK"; "Cancel")
		If (OK=1)
			If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
				
				COPY NAMED SELECTION:C331([QA_Corrective_Actions:105]; "beforeChange")
				
				
			Else 
				ARRAY LONGINT:C221($_beforeChange; 0)
				LONGINT ARRAY FROM SELECTION:C647([QA_Corrective_Actions:105]; $_beforeChange)
				
			End if   // END 4D Professional Services : January 2019 
			USE SET:C118("UserSet")
			For ($i; 1; $hilited)
				If (Length:C16([QA_Corrective_Actions:105]RGA:4)=0)
					[QA_Corrective_Actions:105]RGA:4:="n/a"
				End if 
				
				If (Length:C16([QA_Corrective_Actions:105]RootCause:17)=0)
					[QA_Corrective_Actions:105]RootCause:17:="n/a"
				End if 
				
				If (Length:C16([QA_Corrective_Actions:105]ActionTaken:18)=0)
					[QA_Corrective_Actions:105]ActionTaken:18:="n/a"
				End if 
				
				If (Length:C16([QA_Corrective_Actions:105]ApprovalQAMgr:21)=0)
					[QA_Corrective_Actions:105]ApprovalQAMgr:21:=<>zResp
				End if 
				
				If ([QA_Corrective_Actions:105]DateEffective:19=!00-00-00!)
					[QA_Corrective_Actions:105]DateEffective:19:=4D_Current_date
				End if 
				
				If ([QA_Corrective_Actions:105]DateReported:22=!00-00-00!)
					[QA_Corrective_Actions:105]DateReported:22:=4D_Current_date
				End if 
				
				SAVE RECORD:C53([QA_Corrective_Actions:105])
				NEXT RECORD:C51([QA_Corrective_Actions:105])
			End for 
			
			BEEP:C151
			If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
				
				USE NAMED SELECTION:C332("beforeChange")
				CLEAR NAMED SELECTION:C333("beforeChange")
				
			Else 
				
				CREATE SELECTION FROM ARRAY:C640([QA_Corrective_Actions:105]; $_beforeChange)
				
				
			End if   // END 4D Professional Services : January 2019 
			
			HIGHLIGHT RECORDS:C656([QA_Corrective_Actions:105]; "UserSet")
			CLEAR SET:C117("UserSet")
		End if 
		
	Else 
		uConfirm("You must select some of the displayed "+String:C10(Records in selection:C76([QA_Corrective_Actions:105]))+" records to continue. You may use Edit>Select All."; "Try Again"; "Help")
	End if 
	
Else 
	uConfirm("You are in Review Mode and can't make a change, start over using Modify..."; "Try Again"; "Help")
	If (OK=1)
		CANCEL:C270
	End if 
End if 