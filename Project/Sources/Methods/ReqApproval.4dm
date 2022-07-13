//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: ReqApproval
// ----------------------------------------------------
// Modified by: Mel Bohince (5/31/13) let hold items appear in the need appv list for brian


C_TEXT:C284($Dept)
C_BOOLEAN:C305(fApproving)
C_TEXT:C284($1)  //ToApprove, OnHold, or WaitingPO
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
	
	If ($1="Requisition") | ($1="PlantMgr")  // Modified by: Mel Bohince (5/31/13) let hold items appear in the need appv list for brian
		QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Status:15=$1; *)
		QUERY:C277([Purchase_Orders:11];  | ; [Purchase_Orders:11]Status:15="Req On Hold")
		
	Else 
		QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Status:15=$1)  //orig code
	End if 
	
	Case of 
		: (Records in selection:C76([Purchase_Orders:11])>0)  //User accepted & entered a dept code & something was found
			fApproving:=True:C214
			CREATE SET:C116([Purchase_Orders:11]; "◊PassThroughSet")
			<>PassThrough:=True:C214
			<>FilePtr:=->[Purchase_Orders:11]
			ReqModRec($1)
			fApproving:=False:C215
			
		Else   //User accepted & entered a dept code & nothing was found
			uConfirm("There are no Requisitions currently in status = "+$1; "OK"; "Help")
	End case 
	
	uClearSelection(->[Purchase_Orders:11])
	
Else 
	
	SET QUERY DESTINATION:C396(Into set:K19:2; "◊PassThroughSet")
	
	If ($1="Requisition") | ($1="PlantMgr")  // Modified by: Mel Bohince (5/31/13) let hold items appear in the need appv list for brian
		QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Status:15=$1; *)
		QUERY:C277([Purchase_Orders:11];  | ; [Purchase_Orders:11]Status:15="Req On Hold")
		
	Else 
		QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Status:15=$1)  //orig code
	End if 
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	
	Case of 
		: (Records in set:C195("◊PassThroughSet")>0)  //User accepted & entered a dept code & something was found
			fApproving:=True:C214
			<>PassThrough:=True:C214
			<>FilePtr:=->[Purchase_Orders:11]
			ReqModRec($1)
			fApproving:=False:C215
			
		Else   //User accepted & entered a dept code & nothing was found
			
			uConfirm("There are no Requisitions currently in status = "+$1; "OK"; "Help")
	End case 
	
	If (Records in selection:C76([Purchase_Orders:11])>0)
		REDUCE SELECTION:C351([Purchase_Orders:11]; 0)
	End if 
	
	
End if   // END 4D Professional Services : January 2019 query selection
