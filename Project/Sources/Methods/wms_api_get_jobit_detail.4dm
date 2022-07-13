//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_api_get_jobit_detail - Created v0.1.0-JJG (05/13/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($0; $xlNumRows)

WMS_API_LoginLookup  //make sure <>WMS variables are up to date.

If (<>fWMS_Use4D)
	$xlNumRows:=WMS_API_4D_getJobitDetail
	
Else 
	$xlNumRows:=wms_api_MySQL_get_jobit_detail
	
End if 

$0:=$xlNumRows



If (False:C215)  //v0.1.0-JJG (05/13/16) - moved to MySQL method
	//  // ----------------------------------------------------
	//  // User name (OS): mel
	//  // Date and time: 09/30/08, 07:46:54
	//  // ----------------------------------------------------
	//  // Method: wms_api_get_jobit_detail
	//  // ----------------------------------------------------
	
	//$selectionSetName:="Job_Forms_Items"
	//If (Records in set($selectionSetName)>0)
	//UNLOAD RECORD([Job_Forms_Items])
	//CUT NAMED SELECTION([Job_Forms_Items];"holdNamedSelectionBefore")
	//  //READ WRITE([Finished_Goods_Locations])
	//USE SET($selectionSetName)
	//<>WMS_ERROR:=0
	//$conn_id:=DB_ConnectionManager ("Open")
	//If ($conn_id>0)
	//utl_LogIt ("init")
	//$jobit:=[Job_Forms_Items]Jobit
	//$jobit_actual_qty:=[Job_Forms_Items]Qty_Actual
	
	//  //the summary:
	//$sql:="select skid_number, bin_id, count(case_id), sum(qty_in_case) from cases "
	//$sql:=$sql+"where  jobit = '"+Replace string($jobit;".";"")+"' "
	//$sql:=$sql+"group by skid_number, bin_id order by bin_id"
	
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
	
	//$sql:="SELECT case_id, qty_in_case, skid_number, bin_id, case_status_code "
	//$sql:=$sql+" FROM cases WHERE "
	//$sql:=$sql+"jobit = '"+Replace string($jobit;".";"")+"'"
	
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
	//$qty:=0
	//$skid_cases:=0
	//$skid_qty:=0
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
	
	//: ($acase_state{$i}=400)
	//$state:=" SCRAPPED "
	
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
	
	//utl_LogIt (String($row_count)+"  total cases    "+String($qty)+" total qty")
	
	//utl_LogIt ("show")
	//utl_LogIt ("init")
	
	//If ($jobit_actual_qty#$qty) & ($qty>0) & (False)
	//uConfirm ("Set aMs Qty_Actual to match WMS qty of "+String($qty)+"?";"Change";"Ignore")
	//If (ok=1)
	//UNLOAD RECORD([Job_Forms_Items])
	//READ WRITE([Job_Forms_Items])
	//LOAD RECORD([Job_Forms_Items])
	//[Job_Forms_Items]Qty_Actual:=$qty
	//SAVE RECORD([Job_Forms_Items])
	//End if 
	//End if 
	
	//Else 
	//uConfirm ("No case were found for "+[Job_Forms_Items]Jobit+". ";"OK";"Help")
	//End if 
	
	//UNLOAD RECORD([Job_Forms_Items])
	//USE NAMED SELECTION("holdNamedSelectionBefore")
	//MySQL Delete Row Set ($row_set)
	//$conn_id:=DB_ConnectionManager ("Close")
	
	//Else 
	//uConfirm ("Could not connect to WMS database.";"OK";"Help")
	//End if 
	
	//Else 
	//uConfirm ("Please select a Job_Forms_Item record to show bins.";"OK";"Help")
	//End if 
End if   //v0.1.0-JJG (05/13/16) - end of commented  block