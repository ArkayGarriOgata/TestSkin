//%attributes = {"publishedWeb":true}
//PM: ReqShowMine() -> 
//@author Mel - 5/9/03  12:26

C_TEXT:C284($reqBy)

READ ONLY:C145([Purchase_Orders:11])

$reqBy:=Request:C163("Initials of who entered the Requisistion:"; <>zResp; "Find"; "Cancel")
If (ok=1)
	QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]ReqBy:6=$reqBy)
	If (Records in selection:C76([Purchase_Orders:11])>0)
		fApproving:=False:C215
		<>FilePtr:=->[Purchase_Orders:11]
		<>iMode:=3
		pattern_PassThru(<>FilePtr)
		
		ReqRevRec($reqBy)
		fApproving:=False:C215
	Else 
		BEEP:C151
		ALERT:C41("No Reqs were made by "+$reqBy; "That ain't rite")
	End if 
End if 

uClearSelection(->[Purchase_Orders:11])