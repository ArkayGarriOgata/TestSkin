//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_api_MySQL_lookup - Created v0.1.0-JJG (05/09/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

//moved here from [WMS_SerializedShippingLabels].BinCheck_dio

//$conn_id:=DB_ConnectionManager ("Open")
If ($conn_id>0)
	
	$sql:="SELECT case_id, skid_number, case_status_code, bin_id "
	$sql:=$sql+" FROM cases WHERE "
	
	Case of 
		: (rft_state="BIN")
			$sql:=$sql+"bin_id = '"+rft_response
			
		: (rft_state="SKID")
			$sql:=$sql+"skid_number = '"+rft_response
			
		: (rft_state="CASE")
			$sql:=$sql+"case_id = '"+rft_response
			
	End case 
	
	$sql:=$sql+"' order by skid_number, case_id"
	
	//$row_set:=MySQL Select ($conn_id;$sql)
	//$row_count:=MySQL Get Row Count ($row_set)
	
	ARRAY BOOLEAN:C223(ListBox1; 0)
	ARRAY TEXT:C222(rft_Case; 0)
	ARRAY TEXT:C222(rft_Skid; 0)
	ARRAY TEXT:C222(rft_Bin; 0)
	ARRAY LONGINT:C221($acase_state; 0)
	ARRAY TEXT:C222(rft_Status; 0)
	
	//MySQL Column To Array ($row_set;"";1;rft_Case)
	//MySQL Column To Array ($row_set;"";2;rft_Skid)
	//MySQL Column To Array ($row_set;"";3;$acase_state)
	//MySQL Column To Array ($row_set;"";4;rft_Bin)
	
	ARRAY BOOLEAN:C223(ListBox1; $row_count)
	ARRAY TEXT:C222(rft_Status; $row_count)
	$qty:=0
	For ($i; 1; $row_count)
		If (rft_Case{$i}#rft_Skid{$i})  //not a supercase
			$qty:=$qty+Num:C11(WMS_CaseId(rft_Case{$i}; "qty"))
		End if 
		
		rft_Status{$i}:=wmss_CaseState($acase_state{$i})
		
	End for 
	//qtyListed:=String($qty;"###,##0")
	qtyListed:=$qty
	
	//MySQL Delete Row Set ($row_set)
	//$conn_id:=DB_ConnectionManager ("Close")
	
	If (Size of array:C274(rft_Case)>0)
		SetObjectProperties(""; ->rft_error_log; False:C215)
	Else 
		rft_error_log:=rft_response+" not found"
		SetObjectProperties(""; ->rft_error_log; True:C214; ""; False:C215)
		rft_response:=""
	End if 
	
End if   //connid