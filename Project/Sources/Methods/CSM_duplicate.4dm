//%attributes = {}
// Method: CSM_duplicate ($oldCSM) -> 
// ----------------------------------------------------
// by: mel: 10/28/03, 16:43:26
// ----------------------------------------------------

C_LONGINT:C283($i)
C_TEXT:C284($oldCSM; $newCSM; $0)

$oldCSM:=$1
$newCSM:=""

READ WRITE:C146([Finished_Goods_Color_SpecMaster:128])

QUERY:C277([Finished_Goods_Color_SpecMaster:128]; [Finished_Goods_Color_SpecMaster:128]id:1=$oldCSM)
If (Records in selection:C76([Finished_Goods_Color_SpecMaster:128])=1)
	DUPLICATE RECORD:C225([Finished_Goods_Color_SpecMaster:128])
	[Finished_Goods_Color_SpecMaster:128]pk_id:26:=Generate UUID:C1066
	[Finished_Goods_Color_SpecMaster:128]name:2:="dup of "+[Finished_Goods_Color_SpecMaster:128]id:1
	$newCSM:=String:C10(app_AutoIncrement(->[Finished_Goods_Color_SpecMaster:128]); "00000")
	[Finished_Goods_Color_SpecMaster:128]id:1:=$newCSM
	// deleted 5/15/20: gns_ams_clear_sync_fields(->[Finished_Goods_Color_SpecMaster]z_SYNC_ID;->[Finished_Goods_Color_SpecMaster]z_SYNC_DATA)
	SAVE RECORD:C53([Finished_Goods_Color_SpecMaster:128])
	
	READ WRITE:C146([Finished_Goods_Color_SpecSolids:129])
	QUERY:C277([Finished_Goods_Color_SpecSolids:129]; [Finished_Goods_Color_SpecSolids:129]masterSet:3=$oldCSM)
	SELECTION TO ARRAY:C260([Finished_Goods_Color_SpecSolids:129]; $aRecNum)
	REDUCE SELECTION:C351([Finished_Goods_Color_SpecSolids:129]; 0)
	For ($i; 1; Size of array:C274($aRecNum))
		GOTO RECORD:C242([Finished_Goods_Color_SpecSolids:129]; $aRecNum{$i})
		DUPLICATE RECORD:C225([Finished_Goods_Color_SpecSolids:129])
		[Finished_Goods_Color_SpecSolids:129]pk_id:18:=Generate UUID:C1066
		[Finished_Goods_Color_SpecSolids:129]id:1:=String:C10(app_AutoIncrement(->[Finished_Goods_Color_SpecSolids:129]); "0000000")
		[Finished_Goods_Color_SpecSolids:129]masterSet:3:=$newCSM
		// deleted 5/15/20: gns_ams_clear_sync_fields(->[Finished_Goods_Color_SpecSolids]z_SYNC_ID;->[Finished_Goods_Color_SpecSolids]z_SYNC_DATA)
		SAVE RECORD:C53([Finished_Goods_Color_SpecSolids:129])
	End for 
	REDUCE SELECTION:C351([Finished_Goods_Color_SpecSolids:129]; 0)
	
Else 
	BEEP:C151
End if 

$0:=$newCSM