//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_compareToAMS_Do - Created v0.1.0-JJG (05/18/16)
// Modified by: JJG (3/18/17) 
//If (<>fDebug)
//DODEBUG (Current method name)
//End if 

//C_DATE($1;$dInventory)
//C_TEXT($ttJobit;$ttLocation;$ttPkgID;$ttPkgType;$ttWarehouse)
//C_LONGINT($xlAMSQty)
//ARRAY TEXT($sttBinID;0)
//ARRAY TEXT($sttJobit;0)
//ARRAY LONGINT($sxlAMSQty;0)
//$dInventory:=$1
//$ttWarehouse:="R"
//$ttJobit:=Replace string([Finished_Goods_Locations]Jobit;".";"")
//$ttLocation:=wms_convert_bin_id ("wms";[Finished_Goods_Locations]Location)
//$xlAMSQty:=[Finished_Goods_Locations]QtyOH

//If (WMS_API_4D_compareToAMS_Query ($ttLocation;$ttJobit;->$sttBinID;->$sttJobit;->$sxlAMSQty)>0)
//If ($sxlAMSQty{1}=$xlAMSQty)
//[Finished_Goods_Locations]LastCycleCount:=$xlAMSQty
//WMS_API_4D_compareToAMS_Match ($dInventory;$ttWarehouse;$ttLocation;$ttLocation;$ttJobit)

//Else 
//[Finished_Goods_Locations]LastCycleCount:=1+$sxlAMSQty{1}
//WMS_API_4D_compareToAMS_Update ($dInventory;$ttWarehouse;$ttLocation;$ttJobit)
//End if 

//Else   //not found in AMS
//[Finished_Goods_Locations]LastCycleCount:=-1
//$ttPkgType:=$ttJobit+" = "+String($xlAMSQty)
//$ttPkgID:="ams_bin_"+[Finished_Goods_Locations]Location
//WMS_API_4D_compareToAMS_Insert ($ttPkgID;$ttPkgType;<>zResp;$ttWarehouse;$dInventory;$ttLocation)

//End if 

//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_compareToAMS_Do - Created v0.1.0-JJG (05/18/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_DATE:C307($1; $dInventory)
C_TEXT:C284($ttJobit; $ttLocation; $ttPkgID; $ttPkgType; $ttWarehouse)
C_LONGINT:C283($xlAMSQty)
ARRAY TEXT:C222($sttBinID; 0)
ARRAY TEXT:C222($sttJobit; 0)
ARRAY LONGINT:C221($sxlAMSQty; 0)
$dInventory:=$1
$ttWarehouse:="R"
$ttJobit:=Replace string:C233([Finished_Goods_Locations:35]Jobit:33; "."; "")
$ttLocation:=wms_convert_bin_id("wms"; [Finished_Goods_Locations:35]Location:2)
$xlAMSQty:=[Finished_Goods_Locations:35]QtyOH:9

If (WMS_API_4D_compareToAMS_Query($ttLocation; $ttJobit; ->$sttBinID; ->$sttJobit; ->$sxlAMSQty)>0)
	If ($sxlAMSQty{1}=$xlAMSQty)
		[Finished_Goods_Locations:35]LastCycleCount:7:=$xlAMSQty
		WMS_API_4D_compareToAMS_Match($dInventory; $ttWarehouse; $ttLocation; $ttLocation; $ttJobit)
		
	Else 
		[Finished_Goods_Locations:35]LastCycleCount:7:=-1*$sxlAMSQty{1}  //v1.0.3-JJG (03/14/17) - fixed bug, was 1+$sxlAMSQty{1}
		WMS_API_4D_compareToAMS_Update($dInventory; $ttWarehouse; $ttLocation; $ttJobit)
	End if 
	
Else   //not found in AMS
	[Finished_Goods_Locations:35]LastCycleCount:7:=-1
	$ttPkgType:=$ttJobit+" = "+String:C10($xlAMSQty)
	$ttPkgID:="ams_bin_"+[Finished_Goods_Locations:35]Location:2
	WMS_API_4D_compareToAMS_Insert($ttPkgID; $ttPkgType; <>zResp; $ttWarehouse; $dInventory; $ttLocation)
	
End if 