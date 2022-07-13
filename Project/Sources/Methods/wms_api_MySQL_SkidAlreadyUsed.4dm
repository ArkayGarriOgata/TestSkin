//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_api_MySQL_SkidAlreadyUsed - Created v0.1.0-JJG (05/11/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

//moved here from wms_SkidAlreadyUsed

// Method: wms_SkidAlreadyUsed ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 02/06/15, 19:16:06
// ----------------------------------------------------
// Description
// 
//
// ----------------------------------------------------
C_BOOLEAN:C305($0)
$0:=False:C215

//$conn_id:=DB_ConnectionManager ("Open")
If ($conn_id>0)
	$sqlPrefix:="select bin_id from cases where skid_number = '"
	$sql:=$sqlPrefix+rft_skid_label_id+"'"
	//$rowSet:=MySQL Select ($conn_id;$sql)
	//$rowCount:=MySQL Get Row Count ($rowSet)
	If ($rowCount>0)
		//$bin_id:=MySQL Get String Column ($rowset;"bin_id")
		$usedSSCC:=rft_skid_label_id
		wmss_init("Scan an unused pallet label!")
		wmss_throwError($usedSSCC+" is already put away in bin "+$bin_id)
		
		
	Else 
		$0:=True:C214
	End if 
	
Else 
	wmss_throwError("Connection to WMS failed.\rTry closing window.")
End if 
//$conn_id:=DB_ConnectionManager ("Close")