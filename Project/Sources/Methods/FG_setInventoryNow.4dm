//%attributes = {"publishedWeb":true,"executedOnServer":true}
//PM: FG_setInventoryNow() -> 
//@author mlb - 7/2/02  12:02
// Modified by: Mel Bohince (1/25/19) Loop only f/g's with an inventory record
// Modified by: Mel Bohince (5/5/21) set execute on server property

C_LONGINT:C283($i; $numFG)
READ ONLY:C145([Finished_Goods_Locations:35])
READ WRITE:C146([Finished_Goods:26])

ALL RECORDS:C47([Finished_Goods_Locations:35])
RELATE ONE SELECTION:C349([Finished_Goods_Locations:35]; [Finished_Goods:26])

$numFG:=Records in selection:C76([Finished_Goods:26])
//uThermoInit ($numFG;"Setting current inventory quantity")
For ($i; 1; $numFG)
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]FG_Key:34=[Finished_Goods:26]FG_KEY:47)
	If (Records in selection:C76([Finished_Goods_Locations:35])>0)
		[Finished_Goods:26]InventoryNow:73:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
	Else 
		[Finished_Goods:26]InventoryNow:73:=0
	End if 
	SAVE RECORD:C53([Finished_Goods:26])
	
	NEXT RECORD:C51([Finished_Goods:26])
	//uThermoUpdate ($i)
End for 
//uThermoClose 
REDUCE SELECTION:C351([Finished_Goods:26]; 0)
REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
//