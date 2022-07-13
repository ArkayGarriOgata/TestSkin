//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_compareToAMS - Created v0.1.0-JJG (05/18/16) - 4D version of wms_MySQL_comapre_to_ams
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($i; $xlNumRecs)
C_TEXT:C284($ttMsg; $ttPkgType)
C_DATE:C307($dInventory)
<>WMS_ERROR:=0
$ttMsg:=$ttMsg+"1) In aMs, not in WMS{[Finished_Goods_Locations]LastCycleCount:=-1} also in wms.missing_inventory table"+Char:C90(Carriage return:K15:38)
$ttMsg:=$ttMsg+"2) In WMS, not in aMs{WMS.inventory_date not set to current date}"+Char:C90(Carriage return:K15:38)
$ttMsg:=$ttMsg+"3) In both, but quantity discrepancy{[Finished_Goods_Locations]LastCycleCount:=-1*$xlAMSQty}"+Char:C90(Carriage return:K15:38)
$ttMsg:=$ttMsg+"4) Both systems insync{[Finished_Goods_Locations]LastCycleCount:=$xlAMSQty when match ?}"+Char:C90(Carriage return:K15:38)

If (WMS_API_4D_DoLogin)
	$dInventory:=4D_Current_date
	$ttPkgType:="summary"
	
	WMS_CompareSetup
	
	READ WRITE:C146([Finished_Goods_Locations:35])
	ALL RECORDS:C47([Finished_Goods_Locations:35])
	//APPLY TO SELECTION([Finished_Goods_Locations];[Finished_Goods_Locations]LastCycleCount:=0)
	//FIRST RECORD([Finished_Goods_Locations])
	//APPLY TO SELECTION([Finished_Goods_Locations];[Finished_Goods_Locations]LastCycleDate:=$dInventory)
	$xlNumRecs:=Records in selection:C76([Finished_Goods_Locations:35])
	
	uThermoInit($xlNumRecs; "Updating Records")
	For ($i; 1; $xlNumRecs)
		GOTO SELECTED RECORD:C245([Finished_Goods_Locations:35]; $i)
		WMS_API_4D_compareToAMS_Do($dInventory)
		SAVE RECORD:C53([Finished_Goods_Locations:35])
		NEXT RECORD:C51([Finished_Goods_Locations:35])
		uThermoUpdate($i-1)
	End for 
	uThermoClose
	
	WMS_API_4D_DoLogout
	BEEP:C151
	util_FloatingAlert($ttMsg)
	
Else 
	uConfirm("Could not connect to WMS database."; "OK"; "Help")
End if 

