//%attributes = {}
// Method: FG_setKillStatus () -> 
// ----------------------------------------------------
// by: mel: 07/26/05, 11:17:08
// ----------------------------------------------------
// Description:
// called by rptAgeFGdetail
// Updates:

// ----------------------------------------------------

C_TEXT:C284($1; $2)
C_LONGINT:C283($3)

READ WRITE:C146([Finished_Goods_Locations:35])
QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2=$1; *)  //$aLoc{$i}
QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Jobit:33=$2)  //$aJi{$i}
If (Records in selection:C76([Finished_Goods_Locations:35])=1)
	If ([Finished_Goods_Locations:35]KillStatus:30#$3)  //may need changed
		If ([Finished_Goods_Locations:35]KillStatus:30#1)  //confirmed
			[Finished_Goods_Locations:35]KillStatus:30:=$3
			SAVE RECORD:C53([Finished_Goods_Locations:35])
		End if 
	End if 
End if 
UNLOAD RECORD:C212([Finished_Goods_Locations:35])