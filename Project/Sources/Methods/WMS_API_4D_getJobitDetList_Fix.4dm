//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getJobitDetList_Fix - Created v0.1.0-JJG (05/13/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($1; $2; $xlActualJobitQty; $xlQty)
$xlActualJobitQty:=$1
$xlQty:=$2

If (($xlQty#$xlActualJobitQty) & False:C215)  //this was nullified in original for some reason, so I left it
	uConfirm("Set aMs Qty_Actual to match WMS qty of "+String:C10($xlQty)+"?"; "Change"; "Ignore")
	If (ok=1)
		UNLOAD RECORD:C212([Job_Forms_Items:44])
		READ WRITE:C146([Job_Forms_Items:44])
		LOAD RECORD:C52([Job_Forms_Items:44])
		[Job_Forms_Items:44]Qty_Actual:11:=$xlQty
		SAVE RECORD:C53([Job_Forms_Items:44])
	End if 
End if 