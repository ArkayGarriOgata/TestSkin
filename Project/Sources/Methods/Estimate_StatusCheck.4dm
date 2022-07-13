//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/22/06, 15:35:42
// ----------------------------------------------------
// Method: Estimate_StatusCheck
// Description
// See if estimate can be modified
// ----------------------------------------------------
// Modified by: Mel Bohince (3/27/20) add budget status

C_BOOLEAN:C305($restricted; $0)

Case of   //all user concerns 051096MLB
	: (Current user:C182="Designer")
		$restricted:=False:C215  //designer gets a pass
		
	: (Position:C15("Extracted"; [Estimates:17]Status:30)#0)  //being worked in sinlge user 4D
		uConfirm("Estimate has been Extracted, you must use Review to see this estimate."; "OK"; "Help")
		$restricted:=True:C214
		
	: (Position:C15("Superceded"; [Estimates:17]Status:30)#0)
		uConfirm("Estimate has been Superceded, you must use Review to see this estimate."; "OK"; "Help")
		$restricted:=True:C214
		
	: (User in group:C338(Current user:C182; "PriceManager"))
		$restricted:=False:C215  //PriceManager is not restricted.
		
	: (Position:C15("Quote"; [Estimates:17]Status:30)#0)
		uConfirm("Estimate has been Quoted, you must use Review to see this estimate."; "OK"; "Help")
		$restricted:=True:C214
		
	: (Position:C15("Esti"; [Estimates:17]Status:30)#0)
		uConfirm("Estimate has been Estimated, you must use Review to see this estimate."; "OK"; "Help")
		$restricted:=True:C214
		
	: (Position:C15("Price"; [Estimates:17]Status:30)#0)
		uConfirm("Estimate has been Priced, you must use Review to see this estimate."+Char:C90(13)+"Do you want to print a quote?"; "Print"; "No")
		If (OK=1)
			rRptCOQuote
		End if 
		$restricted:=True:C214
		
	: (Position:C15("Order"; [Estimates:17]Status:30)#0)
		uConfirm("Estimate has been Ordered, you must use Review to see this estimate."; "OK"; "Help")
		$restricted:=True:C214
		
	: (Position:C15("Budg"; [Estimates:17]Status:30)#0)  // Modified by: Mel Bohince (3/27/20) 
		uConfirm("Estimate is a Budget, you must use Review to see this estimate."; "OK"; "Help")
		$restricted:=True:C214
		
	: (Position:C15("Delete"; [Estimates:17]Status:30)#0)
		uConfirm("Estimate has been Deleted, you must use Review to see this estimate."; "OK"; "Help")
		$restricted:=True:C214
		
	: (Position:C15("Kill"; [Estimates:17]Status:30)#0)
		uConfirm("Estimate has been killed, you must use Review to see this estimate."; "OK"; "Help")
		$restricted:=True:C214
		
	Else   //specific user concerns
		$restricted:=False:C215
End case 

$0:=$restricted