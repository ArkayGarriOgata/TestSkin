//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_api_MySQL_Send_Super_Case - Created v0.1.0-JJG (05/05/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

//v0.1.0-JJG (05/05/16) - moved wms_api_super_case code here.

// ----------------------------------------------------
// User name (OS): mel
// Date and time: 01/15/09, 17:09:34
// ----------------------------------------------------
// Method: wms_api_Send_Super_Case
// ----------------------------------------------------

C_LONGINT:C283($i; $conn_id; insert_stmt; $rows_affected)
C_TEXT:C284($sql; $1)
C_BOOLEAN:C305($0)

$0:=False:C215

Case of 
	: ($1="init")
		<>WMS_ERROR:=0
		//$conn_id:=DB_ConnectionManager ("Open")
		If ($conn_id>0)
			$0:=True:C214
			$sql:="INSERT INTO `"+"cases"+"` ( "
			$sql:=$sql+"`"+"case_id"+"`, "
			$sql:=$sql+"`"+"glue_date"+"`, "
			$sql:=$sql+"`"+"qty_in_case"+"`, "
			$sql:=$sql+"`"+"jobit"+"`, "
			$sql:=$sql+"`"+"case_status_code"+"`, "
			$sql:=$sql+"`"+"ams_location"+"`,  "
			$sql:=$sql+"`"+"bin_id"+"`, "
			$sql:=$sql+"`"+"insert_datetime"+"`, "
			$sql:=$sql+"`"+"update_datetime"+"`, "
			$sql:=$sql+"`"+"update_initials"+"`, "
			$sql:=$sql+"`"+"warehouse"+"`, "
			$sql:=$sql+"`"+"skid_number"+"` "
			$sql:=$sql+") VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )"
			//insert_stmt:=MySQL New SQL Statement ($conn_id;$sql)
			
		Else 
			$0:=False:C215
		End if 
		
	: ($1="initCase")
		<>WMS_ERROR:=0
		//$conn_id:=DB_ConnectionManager ("Open")
		If ($conn_id>0)
			$0:=True:C214
			$sql:="INSERT INTO `"+"cases"+"` ( "
			$sql:=$sql+"`"+"case_id"+"`, "
			$sql:=$sql+"`"+"glue_date"+"`, "
			$sql:=$sql+"`"+"qty_in_case"+"`, "
			$sql:=$sql+"`"+"jobit"+"`, "
			$sql:=$sql+"`"+"case_status_code"+"`, "
			$sql:=$sql+"`"+"ams_location"+"`,  "
			$sql:=$sql+"`"+"bin_id"+"`, "
			$sql:=$sql+"`"+"insert_datetime"+"`, "
			$sql:=$sql+"`"+"update_datetime"+"`, "
			$sql:=$sql+"`"+"update_initials"+"`, "
			$sql:=$sql+"`"+"warehouse"+"` "
			$sql:=$sql+") VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )"
			//insert_stmt:=MySQL New SQL Statement ($conn_id;$sql)
			
		Else 
			$0:=False:C215
		End if 
		
	: ($1="insert")
		//MySQL Set String In SQL (insert_stmt;1;$2)  //caseid
		//MySQL Set Date In SQL (insert_stmt;2;$3)  //gluedate
		//MySQL Set Longint In SQL (insert_stmt;3;$4)  //qtyincase
		//MySQL Set String In SQL (insert_stmt;4;$5)  //jobit
		//MySQL Set Integer In SQL (insert_stmt;5;$6)  //casestatucode
		//MySQL Set String In SQL (insert_stmt;6;$7)  //amslocation
		//MySQL Set String In SQL (insert_stmt;7;$8)  //binid
		//MySQL Set DateTime In SQL (insert_stmt;8;$9;Current time)  //inserdatetime
		//MySQL Set DateTime In SQL (insert_stmt;9;$10;Current time)  //updatedatetime
		//MySQL Set String In SQL (insert_stmt;10;$11)  //updateinitials
		//MySQL Set String In SQL (insert_stmt;11;$12)  //warehouse
		//MySQL Set String In SQL (insert_stmt;12;$13)  //skidnumber
		
		//$rows_affected:=MySQL Execute (DB_ConnectionManager ("Connection");"";insert_stmt)
		
		$0:=($rows_affected>0)
		
	: ($1="insertCase")
		//MySQL Set String In SQL (insert_stmt;1;$2)  //caseid
		//MySQL Set Date In SQL (insert_stmt;2;$3)  //gluedate
		//MySQL Set Longint In SQL (insert_stmt;3;$4)  //qtyincase
		//MySQL Set String In SQL (insert_stmt;4;$5)  //jobit
		//MySQL Set Integer In SQL (insert_stmt;5;$6)  //casestatucode
		//MySQL Set String In SQL (insert_stmt;6;$7)  //amslocation
		//MySQL Set String In SQL (insert_stmt;7;$8)  //binid
		//MySQL Set DateTime In SQL (insert_stmt;8;$9;Current time)  //inserdatetime
		//MySQL Set DateTime In SQL (insert_stmt;9;$10;Current time)  //updatedatetime
		//MySQL Set String In SQL (insert_stmt;10;$11)  //updateinitials
		//MySQL Set String In SQL (insert_stmt;11;$12)  //warehouse
		
		//$rows_affected:=MySQL Execute (DB_ConnectionManager ("Connection");"";insert_stmt)
		
		$0:=($rows_affected>0)
		
	: ($1="kill")
		//MySQL Delete SQL Statement (insert_stmt)
		//$conn_id:=DB_ConnectionManager ("Close")
		$0:=True:C214
End case 