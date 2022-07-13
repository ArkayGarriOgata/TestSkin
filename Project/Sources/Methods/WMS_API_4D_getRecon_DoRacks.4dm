//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getRecon_DoRacks - Created v0.1.0-JJG (05/18/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_TEXT:C284($1; $2; $4; $ttAMSJobit; $ttWMSBinID; $ttSkidNumber; $ttAMSLocation; $ttMatch1; $ttMatch2)
C_LONGINT:C283($3; $5; $xlCaseQty; $xlNumCases; $xlNumJMI)
$ttAMSJobit:=$1
$ttWMSBinID:=$2
$xlCaseQty:=$3
$ttSkidNumber:=$4
$xlNumCases:=$5
$ttAMSLocation:=wms_convert_bin_id("ams"; $ttWMSBinID)
$ttMatch1:="BNV-"
$ttMatch2:="BNR-"

If ((Position:C15($ttMatch1; $ttWMSBinID)>0) | (Position:C15($ttMatch2; $ttWMSBinID)>0))
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33=$ttAMSJobit; *)
	QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2=$ttAMSLocation)
	If (Records in selection:C76([Finished_Goods_Locations:35])=0)
		$xlNumJMI:=qryJMI($ttAMSJobit)
		CREATE RECORD:C68([Finished_Goods_Locations:35])  //uMakeFGLocation
		[Finished_Goods_Locations:35]Jobit:33:=$ttAMSJobit  //12345.78.01
		[Finished_Goods_Locations:35]ProductCode:1:=[Job_Forms_Items:44]ProductCode:3
		[Finished_Goods_Locations:35]Location:2:=$ttAMSLocation
		[Finished_Goods_Locations:35]JobForm:19:=Substring:C12($ttAMSJobit; 1; 8)
		[Finished_Goods_Locations:35]JobFormItem:32:=Num:C11(Substring:C12($ttAMSJobit; 10; 2))
		[Finished_Goods_Locations:35]CustID:16:=[Job_Forms_Items:44]CustId:15
		[Finished_Goods_Locations:35]zCount:18:=1
		[Finished_Goods_Locations:35]OrigDate:27:=[Job_Forms_Items:44]Glued:33
		[Finished_Goods_Locations:35]ModWho:22:="wms0"
		
	Else 
		[Finished_Goods_Locations:35]ModWho:22:="wms1"
		
	End if 
	
	[Finished_Goods_Locations:35]QtyOH:9:=[Finished_Goods_Locations:35]QtyOH:9+$xlCaseQty
	[Finished_Goods_Locations:35]skid_number:43:=$ttSkidNumber
	[Finished_Goods_Locations:35]wms_bin_id:44:=$ttWMSBinID
	[Finished_Goods_Locations:35]Cases:24:=[Finished_Goods_Locations:35]Cases:24+$xlNumCases
	[Finished_Goods_Locations:35]ModDate:21:=4D_Current_date
	SAVE RECORD:C53([Finished_Goods_Locations:35])
End if 