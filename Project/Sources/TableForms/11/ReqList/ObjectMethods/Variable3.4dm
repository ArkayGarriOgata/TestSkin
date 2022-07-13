//(S) ReqList'bapprove
// Modified by: Mel Bohince (5/31/13) don't hide approved immediately

C_BOOLEAN:C305($Continue; $OverRun)
C_TEXT:C284(xText)

fSavePO:=True:C214

If (iMode=2)
	$Continue:=True:C214
	zwStatusMsg("APPROVING Reqs"; "Only those in status = Requisition, PlantMgr, or Req On Hold")
	CUT NAMED SELECTION:C334([Purchase_Orders:11]; "hold")
	USE SET:C118("UserSet")  //use POs user selected to process
	
	Case of 
		: (Records in set:C195("UserSet")=0)
			uConfirm("You Need to Select (highlight) the Requisitions you wish to Approve."; "OK"; "Help")
			USE NAMED SELECTION:C332("Hold")
			
		: (Not:C34(User in group:C338(Current user:C182; "Req_Approval")))
			uConfirm("You are not authorized to approve Requisitions."; "OK"; "Help")
			USE NAMED SELECTION:C332("Hold")
			
		Else   //lets do it...
			SET QUERY DESTINATION:C396(Into set:K19:2; "approvable")
			
			// ******* Verified  - 4D PS - January  2019 ********
			
			QUERY SELECTION:C341([Purchase_Orders:11]; [Purchase_Orders:11]Status:15="Requisition"; *)
			QUERY SELECTION:C341([Purchase_Orders:11];  | ; [Purchase_Orders:11]Status:15="PlantMgr"; *)
			QUERY SELECTION:C341([Purchase_Orders:11];  | ; [Purchase_Orders:11]Status:15="Req On Hold")
			
			// ******* Verified  - 4D PS - January 2019 (end) *********
			
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			USE SET:C118("approvable")
			
			CREATE EMPTY SET:C140([Purchase_Orders:11]; "problemApproving")
			$Count:=Records in selection:C76([Purchase_Orders:11])
			
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
				
				FIRST RECORD:C50([Purchase_Orders:11])
				
			Else 
				// you use set was created and not modified
				
			End if   // END 4D Professional Services : January 2019 First record
			// 4D Professional Services : after Order by , query or any query type you don't need First record  
			
			uThermoInit($Count; "Approving Requisitions...")
			For ($i; 1; $Count)
				$OverRun:=PoOneApprove([Purchase_Orders:11]PONo:1; "*")
				NEXT RECORD:C51([Purchase_Orders:11])
				uThermoUpdate($i; 1)
			End for 
			uThermoClose
			
			DIFFERENCE:C122("approvable"; "problemApproving"; "approvable")
			COPY SET:C600("approvable"; "UserSet")
			CLEAR SET:C117("problemApproving")
			CLEAR SET:C117("approvable")
			USE NAMED SELECTION:C332("Hold")
			HIGHLIGHT RECORDS:C656  //([PURCHASE_ORDER])
			zwStatusMsg("APPROVED"; "Highlighted Requisitions have been approved.")
			BEEP:C151
			$Title:=fNameWindow(filePtr)
			SET WINDOW TITLE:C213(Replace string:C233($Title; "Purchase_Order"; "Requisitions"))
	End case 
	
Else 
	BEEP:C151
End if 