//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_api_MySQL_sendReleases - Created v0.1.0-JJG (05/16/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

//moved from wms_api_sendReleases

// ----------------------------------------------------
// User name (OS): mel
// Date and time: 05/09/08, 15:10:05
// ----------------------------------------------------
// Method: wms_api_SendReleases($bol-number)
// Description
// 
//
// Parameters
// ----------------------------------------------------
C_LONGINT:C283($1)
//If the bol# is 0 it will display in wms but can't be picked
If (Count parameters:C259=1)
	$bol_number:=$1
Else 
	$bol_number:=0
End if 

C_LONGINT:C283($i; $numRecs)
C_BOOLEAN:C305($break)
$break:=False:C215
$numRecs:=Records in selection:C76([Customers_ReleaseSchedules:46])

$sql:="INSERT INTO `"+"releases"+"` ( "

$sql:=$sql+"`"+"release_number"+"`, "
$sql:=$sql+"`"+"sched_date"+"`, "
$sql:=$sql+"`"+"fg_key"+"`, "
$sql:=$sql+"`"+"sched_qty"+"`, "
$sql:=$sql+"`"+"b_o_l_number"+"`, "
$sql:=$sql+"`"+"remark_line1"+"`, "
$sql:=$sql+"`"+"remark_line2"+"`, "
$sql:=$sql+"`"+"customer_line"+"`, "
$sql:=$sql+"`"+"active_flag"+"` "

$sql:=$sql+") VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ? )"

$delete:="DELETE FROM `releases` WHERE `release_number` = ?"
<>WMS_ERROR:=0
//$conn_id:=DB_ConnectionManager ("Open")
If ($conn_id>0)
	//$stmt:=MySQL New SQL Statement ($conn_id;$sql)
	
	
	//$delStmt:=MySQL New SQL Statement ($conn_id;$delete)
	//$sql:="SELECT release_number FROM releases WHERE release_number = '"
	
	//$result:=MySQL Execute ($conn_id;"BEGIN")
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
		
		FIRST RECORD:C50([Customers_ReleaseSchedules:46])
		uThermoInit($numRecs; "Sending Releases")
		For ($i; 1; $numRecs)
			If ($break)
				$i:=$i+$numRecs
			End if 
			
			//MySQL Set Longint In SQL ($delStmt;1;[Customers_ReleaseSchedules]ReleaseNumber)
			//$result:=MySQL Execute ($conn_id;"";$delStmt)
			
			//$row_set:=MySQL Select ($conn_id;($sql+String([Customers_ReleaseSchedules]ReleaseNumber)+"'"))
			//$row_count:=MySQL Get Row Count ($row_set)
			//MySQL Delete Row Set ($row_set)
			//If ($row_count=0)
			//MySQL Set Longint In SQL ($stmt;1;[Customers_ReleaseSchedules]ReleaseNumber)
			//MySQL Set Date In SQL ($stmt;2;[Customers_ReleaseSchedules]Sched_Date)
			//MySQL Set String In SQL ($stmt;3;([Customers_ReleaseSchedules]CustID+":"+[Customers_ReleaseSchedules]ProductCode))
			//MySQL Set Longint In SQL ($stmt;4;[Customers_ReleaseSchedules]Sched_Qty)
			//MySQL Set Longint In SQL ($stmt;5;[Customers_ReleaseSchedules]B_O_L_pending)
			//MySQL Set String In SQL ($stmt;6;[Customers_ReleaseSchedules]RemarkLine1)
			//MySQL Set String In SQL ($stmt;7;[Customers_ReleaseSchedules]RemarkLine2)
			//MySQL Set String In SQL ($stmt;8;[Customers_ReleaseSchedules]CustomerLine)
			//MySQL Set String In SQL ($stmt;9;"Y")
			
			//$result:=MySQL Execute ($conn_id;"";$stmt)
			If ($result=1)
				[Customers_ReleaseSchedules:46]Expedite:35:="wms"
				SAVE RECORD:C53([Customers_ReleaseSchedules:46])
			End if 
			
			//End if 
			NEXT RECORD:C51([Customers_ReleaseSchedules:46])
			
			If (($i%1000)=0)
				//$result:=MySQL Execute ($conn_id;"COMMIT")
				//$result:=MySQL Execute ($conn_id;"BEGIN")
			End if 
			
			uThermoUpdate($i)
		End for 
		
	Else 
		
		uThermoInit($numRecs; "Sending Releases")
		
		If ($result=1)
			
			APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Expedite:35:="wms")
		End if 
	End if   // END 4D Professional Services : January 2019 
	
	//$result:=MySQL Execute ($conn_id;"COMMIT")
	//MySQL Delete SQL Statement ($stmt)
	//MySQL Delete SQL Statement ($delStmt)
	//$conn_id:=DB_ConnectionManager ("Close")
	
	uThermoClose
	FIRST RECORD:C50([Customers_ReleaseSchedules:46])
	
End if 

