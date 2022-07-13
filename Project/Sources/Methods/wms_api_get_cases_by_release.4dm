//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_api_get_cases_by_release - Created v0.1.0-JJG (05/16/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($0; $1; $xlNumRows; $xlReleaseNumber)
$xlReleaseNumber:=$1

//re-written for MySQL vs 4D WMS
If (<>fWMS_Use4D)
	$xlNumRows:=WMS_API_4D_getCasesByRelease($xlReleaseNumber)
Else 
	$xlNumRows:=wms_api_MySQL_getCasesByRelease($xlReleaseNumber)
End if 

$0:=$xlNumRows



If (False:C215)  //v0.1.0-JJG (05/16/16) - moved to wms_api_MySQL_getCasesByRelease
	//  // ----------------------------------------------------
	//  // User name (OS): mel
	//  // Date and time: 06/19/08, 17:14:35
	//  // ----------------------------------------------------
	//  // Method: wms_api_get_cases_by_release
	//  // Description
	//  // grab some info about shipped cases
	//  //
	//  // Parameters
	//  //release number
	//  // ----------------------------------------------------
	//C_LONGINT($release_number;$1;$0;$wgt_per_case_quess)
	//$0:=-1
	//$release_number:=$1
	//$wgt_per_case_quess:=25  //wag
	//READ ONLY([Finished_Goods_Locations])  //need to grab record numbers
	//READ ONLY([Job_Forms_Items])  //need to grab some fields
	//<>WMS_ERROR:=0
	//$conn_id:=DB_ConnectionManager ("Open")
	//If ($conn_id>0)
	//$sql:="select qty_in_case, jobit, "
	//$sql:=$sql+"substring(skid_number,11), from_bin_id, count(case_id), sum(qty_in_case)  "
	//$sql:=$sql+"from cases where release_number = '"+String($release_number)+"' "
	//$sql:=$sql+"group by qty_in_case, jobit, skid_number, from_bin_id"
	
	//$row_set:=MySQL Select ($conn_id;$sql)
	//$row_count:=MySQL Get Row Count ($row_set)
	//$0:=$row_count
	//  //from BOL_PickRelease
	//  //ARRAY BOOLEAN(ListBox2;0)
	//ARRAY LONGINT(aNumCases;0)
	//ARRAY LONGINT(aPackQty;0)
	//ARRAY LONGINT(aTotalPicked;0)
	//ARRAY LONGINT(aWgt;0)
	//ARRAY TEXT(aPallet;0)
	//  //from FGL_InventoryPick
	//ARRAY TEXT(aCustid;0)
	//ARRAY TEXT(aJobit;0)
	//ARRAY TEXT(aLocation;0)
	//ARRAY LONGINT(aQty;0)  //this is the onhand qty, ref only
	//ARRAY DATE(aGlued;0)
	//ARRAY LONGINT(aRecNo;0)
	//ARRAY TEXT(aCPN;0)
	
	//If ($row_count>0)
	//MySQL Column To Array ($row_set;"";1;aPackQty)
	//MySQL Column To Array ($row_set;"";2;aJobit)
	//MySQL Column To Array ($row_set;"";3;aPallet)
	//MySQL Column To Array ($row_set;"";4;aLocation)
	//MySQL Column To Array ($row_set;"";5;aNumCases)
	//MySQL Column To Array ($row_set;"";6;aTotalPicked)
	//  //wms_convert_bin_id ("ams";[WMS_aMs_Exports]BinId)
	
	//ARRAY LONGINT(aRecNo;$row_count)
	//ARRAY TEXT(aCustid;$row_count)
	//ARRAY LONGINT(aQty;$row_count)
	//ARRAY TEXT(aCPN;$row_count)
	//ARRAY DATE(aGlued;$row_count)
	//ARRAY LONGINT(aWgt;$row_count)
	
	//For ($row;1;$row_count)  //get some ams refer data
	//aJobit{$row}:=JMI_makeJobIt (aJobit{$row})
	//aLocation{$row}:=wms_convert_bin_id ("ams";aLocation{$row})
	//QUERY([Finished_Goods_Locations];[Finished_Goods_Locations]Location=aLocation{$row};*)
	//QUERY([Finished_Goods_Locations]; & ;[Finished_Goods_Locations]Jobit=aJobit{$row})
	//aRecNo{$row}:=Record number([Finished_Goods_Locations])
	//REDUCE SELECTION([Finished_Goods_Locations];0)
	
	//$jmi:=qryJMI (aJobit{$row})
	//aCustid{$row}:=[Job_Forms_Items]CustId
	//aQty{$row}:=0  //this is the onhand qty, ref only
	//aCPN{$row}:=[Job_Forms_Items]ProductCode
	//aGlued{$row}:=[Job_Forms_Items]Glued
	//REDUCE SELECTION([Job_Forms_Items];0)
	
	//aWgt{$row}:=$wgt_per_case_quess  //wag
	//End for 
	
	//Else 
	//utl_Logfile ("wms_api.log";String([WMS_aMs_Exports]id)+": "+"No case were found for release "+String($release_number))
	//End if 
	
	//MySQL Delete Row Set ($row_set)
	//$conn_id:=DB_ConnectionManager ("Close")
	
	//Else 
	//utl_Logfile ("wms_api.log";String([WMS_aMs_Exports]id)+": "+"Could not connect to WMS database. ")
	//End if 
End if 
