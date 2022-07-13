//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getBinDetailList_Fix - Created v0.1.0-JJG (05/13/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($1; $2; $xlAskMeOnHandyQty; $xlQty)
$xlAskMeOnHandyQty:=$1
$xlQty:=$2

If (($xlQty#$xlAskMeOnHandyQty) & False:C215)  //this was nullified in original for some reason, so I left it
	uConfirm("Set aMs to match WMS qty of "+String:C10($xlQty)+"?"; "Change"; "Ignore")
	If (ok=1)
		UNLOAD RECORD:C212([Finished_Goods_Locations:35])
		READ WRITE:C146([Finished_Goods_Locations:35])
		LOAD RECORD:C52([Finished_Goods_Locations:35])
		If ($xlQty=0)
			DELETE RECORD:C58([Finished_Goods_Locations:35])
		Else 
			[Finished_Goods_Locations:35]QtyOH:9:=$xlQty
			SAVE RECORD:C53([Finished_Goods_Locations:35])
		End if 
	End if 
End if 