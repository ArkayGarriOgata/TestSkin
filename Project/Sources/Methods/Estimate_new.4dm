//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/22/06, 15:15:30
//              mlb 10/4/06 add cust_getteam
// ----------------------------------------------------
// Method: Estimate_new
// ----------------------------------------------------

$pjt:=Pjt_getReferId

If (Length:C16($pjt)=5)
	zwStatusMsg("ESTIMATE"; " Creating New RFQ...")
	
	[Estimates:17]EstimateNo:1:=EstOffsetAdjust  //• 1/9/98 cs check that offset & prefix are correctly set     
	[Estimates:17]DateOriginated:19:=4D_Current_date
	[Estimates:17]CreatedBy:59:=<>zResp
	[Estimates:17]Status:30:="New"
	[Estimates:17]Last_Differential_Number:31:=0  //this is a number used to calculate AA, AB...ZZ using INT() & MOD functions
	[Estimates:17]NumberOfForms:32:=1
	[Estimates:17]zCount:36:=1
	[Estimates:17]z_Num_ShipTos:4:=1
	[Estimates:17]z_Num_Releases:12:=1
	[Estimates:17]BreakOutSpls:10:=False:C215
	[Estimates:17]OnePageEstimate:62:=$1
	
	Estimate_AssignToProject($pjt)
	Cust_GetTerms([Estimates:17]Cust_ID:2; ->[Estimates:17]Terms:7; ->[Estimates:17]FOB:8; ->[Estimates:17]ShippingVia:6)
	Cust_getTeam([Estimates:17]Cust_ID:2; ->[Estimates:17]Sales_Rep:13; ->[Estimates:17]SaleCoord:46; ->[Estimates:17]PlannedBy:16)
	Cust_getBrandLines([Estimates:17]Cust_ID:2; ->aBrand)
	
Else 
	uConfirm("Use the Projects screen to create a new Estimate."; "OK"; "Help")
End if 