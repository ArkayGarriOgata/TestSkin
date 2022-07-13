//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_api_MySQL_getCasesByRelease - Created v0.1.0-JJG (05/16/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

//moved here from wms_api_get_cases_by_release

// ----------------------------------------------------
// User name (OS): mel
// Date and time: 06/19/08, 17:14:35
// ----------------------------------------------------
// Method: wms_api_get_cases_by_release
// Description
// grab some info about shipped cases
//
// Parameters
//release number
// ----------------------------------------------------
C_LONGINT:C283($release_number; $1; $0; $wgt_per_case_quess)
$0:=-1
$release_number:=$1
$wgt_per_case_quess:=25  //wag
READ ONLY:C145([Finished_Goods_Locations:35])  //need to grab record numbers
READ ONLY:C145([Job_Forms_Items:44])  //need to grab some fields
<>WMS_ERROR:=0
//$conn_id:=DB_ConnectionManager ("Open")
If ($conn_id>0)
	$sql:="select qty_in_case, jobit, "
	$sql:=$sql+"substring(skid_number,11), from_bin_id, count(case_id), sum(qty_in_case)  "
	$sql:=$sql+"from cases where release_number = '"+String:C10($release_number)+"' "
	$sql:=$sql+"group by qty_in_case, jobit, skid_number, from_bin_id"
	
	//$row_set:=MySQL Select ($conn_id;$sql)
	//$row_count:=MySQL Get Row Count ($row_set)
	$0:=$row_count
	//from BOL_PickRelease
	//ARRAY BOOLEAN(ListBox2;0)
	ARRAY LONGINT:C221(aNumCases; 0)
	ARRAY LONGINT:C221(aPackQty; 0)
	ARRAY LONGINT:C221(aTotalPicked; 0)
	ARRAY LONGINT:C221(aWgt; 0)
	ARRAY TEXT:C222(aPallet; 0)
	//from FGL_InventoryPick
	ARRAY TEXT:C222(aCustid; 0)
	ARRAY TEXT:C222(aJobit; 0)
	ARRAY TEXT:C222(aLocation; 0)
	ARRAY LONGINT:C221(aQty; 0)  //this is the onhand qty, ref only
	ARRAY DATE:C224(aGlued; 0)
	ARRAY LONGINT:C221(aRecNo; 0)
	ARRAY TEXT:C222(aCPN; 0)
	
	If ($row_count>0)
		//MySQL Column To Array ($row_set;"";1;aPackQty)
		//MySQL Column To Array ($row_set;"";2;aJobit)
		//MySQL Column To Array ($row_set;"";3;aPallet)
		//MySQL Column To Array ($row_set;"";4;aLocation)
		//MySQL Column To Array ($row_set;"";5;aNumCases)
		//MySQL Column To Array ($row_set;"";6;aTotalPicked)
		//wms_convert_bin_id ("ams";[WMS_aMs_Exports]BinId)
		
		ARRAY LONGINT:C221(aRecNo; $row_count)
		ARRAY TEXT:C222(aCustid; $row_count)
		ARRAY LONGINT:C221(aQty; $row_count)
		ARRAY TEXT:C222(aCPN; $row_count)
		ARRAY DATE:C224(aGlued; $row_count)
		ARRAY LONGINT:C221(aWgt; $row_count)
		
		For ($row; 1; $row_count)  //get some ams refer data
			aJobit{$row}:=JMI_makeJobIt(aJobit{$row})
			aLocation{$row}:=wms_convert_bin_id("ams"; aLocation{$row})
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2=aLocation{$row}; *)
			QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Jobit:33=aJobit{$row})
			aRecNo{$row}:=Record number:C243([Finished_Goods_Locations:35])
			REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
			
			$jmi:=qryJMI(aJobit{$row})
			aCustid{$row}:=[Job_Forms_Items:44]CustId:15
			aQty{$row}:=0  //this is the onhand qty, ref only
			aCPN{$row}:=[Job_Forms_Items:44]ProductCode:3
			aGlued{$row}:=[Job_Forms_Items:44]Glued:33
			REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
			
			aWgt{$row}:=$wgt_per_case_quess  //wag
		End for 
		
	Else 
		utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"No case were found for release "+String:C10($release_number))
	End if 
	
	//MySQL Delete Row Set ($row_set)
	//$conn_id:=DB_ConnectionManager ("Close")
	
Else 
	utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"Could not connect to WMS database. ")
End if 
