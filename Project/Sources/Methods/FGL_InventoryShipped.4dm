//%attributes = {"publishedWeb":true}
//PM: FGL_InventoryShipped(recordnumber;qty) -> success or failure
//@author mlb - 9/3/02  12:13
C_LONGINT:C283($recNum; $1; $qty; $2)
$recNum:=$1
$qty:=$2
C_BOOLEAN:C305($0; $success; $notCritical)
$success:=False:C215

READ WRITE:C146([Finished_Goods_Locations:35])
GOTO RECORD:C242([Finished_Goods_Locations:35]; $recNum)
If (fLockNLoad(->[Finished_Goods_Locations:35]))
	//next line now in fgx trigger
	//$notCritical:=FG_inventoryShipped ([Finished_Goods_Locations]FG_Key;4D_Current_date)
	
	[Finished_Goods_Locations:35]QtyOH:9:=[Finished_Goods_Locations:35]QtyOH:9-$qty
	If (([Finished_Goods_Locations:35]QtyOH:9=0) & (Not:C34([Finished_Goods_Locations:35]PiDoNotDelete:29)))  // & ($1<0)`•010296  MLB  UPR 1802
		DELETE RECORD:C58([Finished_Goods_Locations:35])
		
	Else 
		[Finished_Goods_Locations:35]ModDate:21:=4D_Current_date
		[Finished_Goods_Locations:35]ModWho:22:=<>zResp
		SAVE RECORD:C53([Finished_Goods_Locations:35])
		UNLOAD RECORD:C212([Finished_Goods_Locations:35])
	End if 
	$success:=True:C214
	
Else 
	$success:=False:C215
	BEEP:C151
	ALERT:C41("Bin locked."+[Finished_Goods_Locations:35]Location:2+" "+[Finished_Goods_Locations:35]Jobit:33; "Cancel")
End if 

$0:=$success