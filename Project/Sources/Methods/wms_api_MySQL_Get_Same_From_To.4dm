//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_api_MySQL_Get_Same_From_To - Created v0.1.0-JJG (05/16/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

//moved from wms_api_Get_Same_From_To

// ----------------------------------------------------
// User name (OS): mel
// Date and time: 02/09/09, 08:54:31
// ----------------------------------------------------
// Method: wms_api_Get_Same_From_To
// Description
// don't import if same from and to location as that is not needed by aMs
//
// Parameters
// ----------------------------------------------------

//C_TEXT($1)  `optional transaction type
C_LONGINT:C283($conn_id; $numRecs; $0)
$numRecs:=0
//$conn_id:=DB_ConnectionManager ("Open")
If ($conn_id>0)
	//mark them as having been imported to aMs so wms can archive
	$sql:="UPDATE ams_exports SET transaction_state_indicator = 'X' "+"WHERE "
	$sql:=$sql+"transaction_state_indicator = 'S' AND "  //not yet imported as indicated by 'S' rather than 'X'
	$sql:=$sql+"bin_id = from_bin_id AND"  //
	$sql:=$sql+"(transaction_type_code = '350' OR transaction_type_code = 200) "  //looking for specific types of transactions *** was <= $1  ****
	
	//$stmt:=MySQL New SQL Statement ($conn_id;$sql)
	//$numRecs:=MySQL Execute ($conn_id;"";$stmt)
	
	//$conn_id:=DB_ConnectionManager ("Close")
End if 

$0:=$numRecs