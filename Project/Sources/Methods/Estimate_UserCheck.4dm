//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/22/06, 15:43:25
// ----------------------------------------------------
// Method: Estimate_UserCheck
// ----------------------------------------------------

C_BOOLEAN:C305($restricted; $0)

$restricted:=False:C215

Case of 
	: (Current user:C182="Designer") | (User in group:C338(Current user:C182; "AccountManager"))
		SetObjectProperties(""; ->[Estimates:17]OrderNo:51; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		
	: (User in group:C338(Current user:C182; "PriceManager"))
		
	: (<>fisSalesRep)
		If (Position:C15([Estimates:17]Status:30; " RFQ Budget Estimated ")>1)
			uConfirm("You may not modify an Estimate in the status of "+[Estimates:17]Status:30+", use Review to see this estimate or make a copy.")
			$restricted:=True:C214
		End if 
		
	: (<>fisCoord)
		If (Position:C15([Estimates:17]Status:30; " RFQ Budget Estimated ")>1)
			uConfirm("You may not modify an Estimate in the status of "+[Estimates:17]Status:30+", use Review to see this estimate or make a copy.")
			$restricted:=True:C214
		End if 
End case 

If (Not:C34($restricted))
	If (Length:C16([Estimates:17]EstimatedBy:14)>0)
		If ([Estimates:17]EstimatedBy:14#<>zResp)
			If (User in group:C338(Current user:C182; "RoleEstimator"))
				uConfirm("WARNING: Estimate belongs to "+[Estimates:17]EstimatedBy:14; "OK"; "Help")
			Else 
				uConfirm("Estimate belongs to "+[Estimates:17]EstimatedBy:14+", you must use Rev(iew) to see this estimate or make a copy."; "OK"; "Help")
				$restricted:=True:C214
			End if 
		End if 
	End if 
End if 

$0:=$restricted