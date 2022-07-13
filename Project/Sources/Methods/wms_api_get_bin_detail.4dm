//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_api_get_bin_detail - Created v0.1.0-JJG (05/13/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($0; $xlNumRows)

WMS_API_LoginLookup  //make sure <>WMS variables are up to date.

If (<>fWMS_Use4D)
	$xlNumRows:=WMS_API_4D_getBinDetail
	
Else 
	$xlNumRows:=wms_api_MySQL_get_bin_detail
	
End if 

$0:=$xlNumRows




If (False:C215)  //v0.1.0-JJG (05/13/16) - moved to MySQL method
	//  // ----------------------------------------------------
	//  // User name (OS): mel
	//  // Date and time: 06/20/08, 11:52:27
	//  // ----------------------------------------------------
	//  // Method: wms_api_get_bin_detail
	//  // Description:
	//  // From askme screen, show cases and their location in the wms
	//  // ----------------------------------------------------
	
	//  //app_OpenSelectedIncludeRecords (->[Finished_Goods_Locations]Location;2;"Finished_Goods_Locations")
	//$selectionSetName:="clickedIncludeRecordFinished_Goods_Locations"
	//If (Records in set($selectionSetName)>0)
	//UNLOAD RECORD([Finished_Goods_Locations])
	//CUT NAMED SELECTION([Finished_Goods_Locations];"holdNamedSelectionBefore")
	//  //READ WRITE([Finished_Goods_Locations])
	//USE SET($selectionSetName)
	//<>WMS_ERROR:=0
	//$conn_id:=DB_ConnectionManager ("Open")
	//If ($conn_id>0)
	//utl_LogIt ("init")
	
	//$jobit:=[Finished_Goods_Locations]Jobit
	//  //$location:=[Finished_Goods_Locations]Location
	//  //If (Length($location)=2)  `go for the ams_location
	//  //  `the summary:
	//  //$sql:="select skid_number, bin_id, count(case_id), sum(qty_in_case) from cases "
	//  //$sql:=$sql+"where ams_location = '"+$location+"' and jobit = '"+Replace string($jobit;".";"")+"' "
	//  //$sql:=$sql+" and case_status_code < 300 "
	//  //$sql:=$sql+"group by skid_number order by bin_id"
	//  //Else 
	//$location:=wms_convert_bin_id ("wms";[Finished_Goods_Locations]Location)
	//  //the summary:
	//$sql:="select skid_number, bin_id, count(case_id), sum(qty_in_case) from cases "
	//$sql:=$sql+"where bin_id = '"+$location+"' and jobit = '"+Replace string($jobit;".";"")+"' "
	//  //$sql:=$sql+" and case_status_code < 300 "
	//$sql:=$sql+"group by skid_number, bin_id order by bin_id"
	//  //End if 
	//$askme_onhand_qty:=[Finished_Goods_Locations]QtyOH
	
	//$row_set:=MySQL Select ($conn_id;$sql)
	//$row_count:=MySQL Get Row Count ($row_set)
	//$0:=$row_count
	//If ($row_count>0)
	//  //Case Id                 Skid Id               Bin Id  Case Qty
	//utl_LogIt ("SUMMARY:")
	//utl_LogIt ("Skid Id               Bin Id              Cases   Quantity")
	//ARRAY TEXT($aSkid_id;0)
	//ARRAY TEXT($abin_id;0)
	//ARRAY LONGINT($aNum_Cases;0)
	//ARRAY LONGINT($aQuantity;0)
	
	//ARRAY LONGINT($acase_state;0)
	
	//MySQL Column To Array ($row_set;"";1;$aSkid_id)
	//MySQL Column To Array ($row_set;"";2;$aBin_id)
	//MySQL Column To Array ($row_set;"";3;$aNum_Cases)
	//MySQL Column To Array ($row_set;"";4;$aQuantity)
	//$qty:=0
	//$skid_cases:=0
	//For ($i;1;$row_count)
	//utl_LogIt ($aSkid_id{$i}+"  "+txt_Pad ($aBin_id{$i};" ";1;20)+"  "+String($aNum_Cases{$i};"^^^")+"  "+String($aQuantity{$i};"^,^^^,^^0"))
	//$qty:=$qty+$aNum_Cases{$i}
	//$skid_cases:=$skid_cases+$aQuantity{$i}
	//End for 
	//utl_LogIt (" === ")
	//utl_LogIt ("   "+String($qty)+" cases on "+String($row_count)+" skids totaling "+String($skid_cases)+" cartons")
	//utl_LogIt (" ### ")
	//utl_LogIt (" ### ")
	//utl_LogIt ("DETAIL ")
	//End if 
	
	//$qty:=0
	//$skid_cases:=0
	//$skid_qty:=0
	
	//$sql:="SELECT case_id, qty_in_case, skid_number, bin_id, case_status_code "
	//$sql:=$sql+" FROM cases WHERE "
	//$sql:=$sql+"jobit = '"+Replace string($jobit;".";"")+"' AND "
	//$sql:=$sql+"bin_id = '"+$location+"' "
	//  //$sql:=$sql+" and case_status_code < 300 "
	
	//$row_set:=MySQL Select ($conn_id;$sql)
	//$row_count:=MySQL Get Row Count ($row_set)
	//$0:=$row_count
	
	//If ($row_count>0)
	//  //Case Id                 Skid Id               Bin Id  Case Qty
	
	//ARRAY TEXT($acase_id;0)
	//ARRAY LONGINT($aqty_in_case;0)
	//ARRAY TEXT($askid_number;0)
	//ARRAY TEXT($abin_id;0)
	//ARRAY LONGINT($acase_state;0)
	
	//MySQL Column To Array ($row_set;"";1;$acase_id)
	//MySQL Column To Array ($row_set;"";2;$aqty_in_case)
	//MySQL Column To Array ($row_set;"";3;$askid_number)
	//MySQL Column To Array ($row_set;"";4;$abin_id)
	//MySQL Column To Array ($row_set;"";5;$acase_state)
	
	//MULTI SORT ARRAY($askid_number;>;$acase_id;>;$abin_id;>;$aqty_in_case;$acase_state)
	
	
	//utl_LogIt ("Case Id                 Bin Id     Case Qty    State")
	//$currentskid:=""
	
	//For ($i;1;$row_count)
	//If ($askid_number{$i}#$currentskid)
	//If ($i#1)
	//utl_LogIt (String($skid_cases)+" cases on skid "+$currentskid+"  "+String($skid_qty)+" qty on skid")
	//utl_LogIt (" --- ")
	//End if 
	//$currentskid:=$askid_number{$i}
	//$skid_cases:=0
	//$skid_qty:=0
	//End if 
	//Case of 
	//: ($acase_state{$i}=1)
	//$state:=" CERTIFICATION "
	
	//: ($acase_state{$i}=10)
	//$state:=" EXAMINING "
	
	//: ($acase_state{$i}=110)
	//$state:=" BOL PENDING "
	
	//: ($acase_state{$i}=130)
	//$state:=" RE-CERT "
	
	//: ($acase_state{$i}=200)
	//$state:=" B&H "
	
	//: ($acase_state{$i}=250)
	//$state:=" EXCESS "
	
	//: ($acase_state{$i}=300)
	//$state:=" SHIPPED "
	
	//: ($acase_state{$i}=350)
	//$state:=" RE-CERT "
	
	//: ($acase_state{$i}=400)
	//$state:=" SCRAPPED "
	
	//: ($acase_state{$i}=500)
	//$state:=" UNKNOWN "
	//Else 
	//$state:=" FG "
	//End case 
	//utl_LogIt ($acase_id{$i}+"  "+$abin_id{$i}+"  "+String($aqty_in_case{$i})+$state)
	//$qty:=$qty+$aqty_in_case{$i}
	//$skid_cases:=$skid_cases+1
	//$skid_qty:=$skid_qty+$aqty_in_case{$i}
	//End for 
	//utl_LogIt (String($skid_cases)+"  cases on skid "+$currentskid+"  "+String($skid_qty)+" qty on skid")
	//utl_LogIt (" --- ")
	
	//utl_LogIt (String($row_count)+"  total cases    "+String($qty)+" total qty in location = "+$location)
	
	//utl_LogIt ("show")
	//utl_LogIt ("init")
	
	//Else 
	//uConfirm ("No case were found for "+[Finished_Goods_Locations]Jobit+" in "+[Finished_Goods_Locations]Location;"OK";"Help")
	//End if 
	
	//If ($askme_onhand_qty#$qty) & (False)
	//uConfirm ("Set aMs to match WMS qty of "+String($qty)+"?";"Change";"Ignore")
	//If (ok=1)
	//UNLOAD RECORD([Finished_Goods_Locations])
	//READ WRITE([Finished_Goods_Locations])
	//LOAD RECORD([Finished_Goods_Locations])
	//If ($qty=0)
	//DELETE RECORD([Finished_Goods_Locations])
	//Else 
	//[Finished_Goods_Locations]QtyOH:=$qty
	//SAVE RECORD([Finished_Goods_Locations])
	//End if 
	//End if 
	//End if 
	
	//UNLOAD RECORD([Finished_Goods_Locations])
	//READ ONLY([Finished_Goods_Locations])
	//USE NAMED SELECTION("holdNamedSelectionBefore")
	//MySQL Delete Row Set ($row_set)
	//$conn_id:=DB_ConnectionManager ("Close")
	
	//Else 
	//uConfirm ("Could not connect to WMS database.";"OK";"Help")
	//End if 
	
	//Else 
	//uConfirm ("Please select a Location record to show bins.";"OK";"Help")
	//End if 
End if   //v0.1.0-JJG (05/13/16) - end of comented block