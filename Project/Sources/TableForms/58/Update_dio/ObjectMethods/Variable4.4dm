// _______
// Method: [Raw_Materials_Allocations].Update_dio.Variable4   ( ) ->
// By: MelvinBohince
// Description
// 
// ----------------------------------------------------
// Modified by: MelvinBohince (2/23/22) chg ARRAY REAL($aAlloc;0) ARRAY REAL($aIssued;0) to real

If (sCriterion2#"")
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=sCriterion3)
	If (Records in selection:C76([Job_Forms:42])#0)
		QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=[Job_Forms:42]JobNo:2)
		
		If (Records in selection:C76([Jobs:15])#0)
			t3:=[Jobs:15]CustomerName:5+Char:C90(13)
			t3b:=[Jobs:15]CustID:2
		Else 
			BEEP:C151
			t3:="WARNING: Job not found."+Char:C90(13)
		End if 
		
		If (iMode=4)  //delete
			QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]JobForm:3=sCriterion3; *)
			QUERY:C277([Raw_Materials_Allocations:58];  & ; [Raw_Materials_Allocations:58]Raw_Matl_Code:1=sCriterion2)
			t3:=t3+String:C10(Records in selection:C76([Raw_Materials_Allocations:58]))+" found"
			If (Records in selection:C76([Raw_Materials_Allocations:58])=0)
				BEEP:C151
			End if 
			
		Else 
			QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]JobForm:3=sCriterion3)
			If (Records in selection:C76([Raw_Materials_Allocations:58])>0)
				//FIRST RECORD([RM_Allocations])
				$currentRMs:=""
				C_LONGINT:C283($i; $issued)
				C_DATE:C307($dDate)
				ARRAY TEXT:C222($aRM; 0)
				ARRAY REAL:C219($aAlloc; 0)  // Modified by: MelvinBohince (2/23/22) 
				ARRAY REAL:C219($aIssued; 0)  // Modified by: MelvinBohince (2/23/22) 
				ARRAY DATE:C224($aDate; 0)
				SELECTION TO ARRAY:C260([Raw_Materials_Allocations:58]Raw_Matl_Code:1; $aRM; [Raw_Materials_Allocations:58]Qty_Allocated:4; $aAlloc; [Raw_Materials_Allocations:58]Qty_Issued:6; $aIssued; [Raw_Materials_Allocations:58]Date_Issued:7; $aDate)
				
				For ($i; 1; Size of array:C274($aRM))
					$currentRMs:=$currentRMs+$aRM{$i}+" or "
					$issued:=$issued+$aIssued{$i}
					If ($dDate<[Raw_Materials_Allocations:58]Date_Issued:7)
						$dDate:=[Raw_Materials_Allocations:58]Date_Issued:7
					End if 
				End for 
				// While (Not(End selection([RM_Allocations])))
				// $currentRMs:=$currentRMs+[RM_Allocations]RM_Code+" or "
				// NEXT RECORD([RM_Allocations])
				// End while 
				$currentRMs:=Substring:C12($currentRMs; 1; (Length:C16($currentRMs)-4))
				
				t3:=t3+String:C10($issued; "###,###,##0")+" issued as of "+String:C10($dDate; 1)
				If (Size of array:C274($aRM)=1)
					//CONFIRM("Job form "+sCriterion3+" already has one allocation, OK to update, Canc
					$text:="Job form "+sCriterion3+" already has one allocation. What do you want to do?"
				Else 
					$text:="Job form "+sCriterion3+" already has "+String:C10(Size of array:C274($aRM))+" allocations. What do you want to do?"
					//CONFIRM("Job form "+sCriterion3+" already has "+String(Records in selection([RM_
				End if 
				uYesNoCancel($text; "Update"; "New"; "Cancel")
				Case of 
					: (bAccept=1)
						
						// ******* Verified  - 4D PS - January  2019 ********
						
						QUERY SELECTION:C341([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]Raw_Matl_Code:1=sCriterion2)
						
						
						// ******* Verified  - 4D PS - January 2019 (end) *********
						
						If (Records in selection:C76([Raw_Materials_Allocations:58])=1)
							iMode:=2
							dDate:=[Raw_Materials_Allocations:58]Date_Allocated:5
							rReal1:=[Raw_Materials_Allocations:58]Qty_Allocated:4
							If (Not:C34(fLockNLoad(->[Raw_Materials_Allocations:58])))
								t3:="Allocation record locked."+Char:C90(13)
								sCriterion3:=""
							End if 
							
						Else 
							BEEP:C151
							If (Records in selection:C76([Raw_Materials_Allocations:58])=0)
								ALERT:C41("The allocation is not for "+sCriterion2)
							Else 
								ALERT:C41("The allocation has been duplicated, see your administrator.")
							End if 
							sCriterion1:="Try "+$currentRMs
							sCriterion2:=""
							t3:=sCriterion3
							sCriterion3:=""
							rReal1:=0
							dDate:=!00-00-00!
							UNLOAD RECORD:C212([Job_Forms:42])
						End if 
						
					: (bNo=1)
						If (Position:C15(sCriterion2; $currentRMs)=0)
							iMode:=1
						Else 
							sCriterion3:=""
							rReal1:=0
							t3:="You must update the existing allocation."
							GOTO OBJECT:C206(sCriterion3)
							UNLOAD RECORD:C212([Job_Forms:42])
						End if 
						
					: (bCancel=1)
						sCriterion3:=""
						t3:="Enter a job form."
						GOTO OBJECT:C206(sCriterion3)
						UNLOAD RECORD:C212([Job_Forms:42])
				End case 
				
			Else   //just make a new one
				iMode:=1
			End if 
			
			
			If (sCriterion3#"")  //still got a form
				If ([Job_Forms:42]ClosedDate:11#!00-00-00!)
					BEEP:C151
					ALERT:C41("This job is closed!")
					dDate:=[Job_Forms:42]ClosedDate:11
				Else 
					dDate:=[Job_Forms:42]NeedDate:1
				End if 
				If (rReal1=0)
					rReal1:=Round:C94(([Job_Forms:42]EstGrossSheets:27*([Job_Forms:42]Lenth:24/12)); 0)
					Case of 
						: (rReal1>iOpen)
							BEEP:C151
							ALERT:C41(String:C10(rReal1; "###,###,##0")+" exceeds the available quantity. Make a requisition.")
							//rReal1:=0
							GOTO OBJECT:C206(rReal1)
							
						: ((iOpen-rReal1)<[Raw_Materials:21]ReorderPoint:12)
							BEEP:C151
							ALERT:C41("Reorder point reached. Please make a requisition for "+sCriterion2)
							
					End case 
				End if 
			End if   //still got a form
			
		End if   //delete mode
		
	Else   //invalid job fjorm
		BEEP:C151
		ALERT:C41("WARNING: Job Form "+sCriterion3+" was not found.")
		sCriterion3:=""
		t3:="Enter a VALID job form number."
		GOTO OBJECT:C206(sCriterion3)
	End if 
	
	
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
		
		UNLOAD RECORD:C212([Job_Forms:42])
		UNLOAD RECORD:C212([Jobs:15])
		REDUCE SELECTION:C351([Job_Forms:42]; 0)
		REDUCE SELECTION:C351([Jobs:15]; 0)
		
	Else 
		
		REDUCE SELECTION:C351([Job_Forms:42]; 0)
		REDUCE SELECTION:C351([Jobs:15]; 0)
		
	End if   // END 4D Professional Services : January 2019 
	
	//REDUCE SELECTION([RM_Allocations];0)
	
Else 
	BEEP:C151
	ALERT:C41("Please enter a R/M code first.")
	sCriterion3:=""
	sCriterion1:="You MUST enter a R/M code first."
	GOTO OBJECT:C206(sCriterion2)
End if 
//