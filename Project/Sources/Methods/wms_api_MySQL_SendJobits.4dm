//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_api_MySQL_SendJobits - Created v0.1.0-JJG (05/05/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

//v0.1.0-JJG (05/05/16) - moved original wms_api_SendJobits into here - original code follows

// ----------------------------------------------------
// User name (OS): mel
// Date and time: 05/09/08, 15:10:05
// ----------------------------------------------------
// Method: wms_api_SendJobits
// ----------------------------------------------------
// insert jobits from ams to wms so that referential integrity is available as well as joins to cpn, 
// but only if cases table has not yet populated
//**********
//**********
//  ASSUMING A JOBIT RECORD(S) IS IN THE CURRENT SELECTION
//**********
//**********

C_LONGINT:C283($i; $numRecs; $conn_id)
C_BOOLEAN:C305($break)
C_TEXT:C284($sql; $delete; $refer_test)

$break:=False:C215
$numRecs:=Records in selection:C76([Job_Forms_Items:44])
<>WMS_ERROR:=0
//$conn_id:=DB_ConnectionManager ("Open")
If ($conn_id>0)  //only continue if connection to wms works
	
	$sql:="INSERT INTO `"+"jobits"+"` ( "
	$sql:=$sql+"`"+"jobit"+"`, "
	$sql:=$sql+"`"+"fg_key"+"`, "
	$sql:=$sql+"`"+"default_qty_in_case"+"`, "
	$sql:=$sql+"`"+"case_per_skid"+"`, "
	$sql:=$sql+"`"+"cust_id"+"`, "
	$sql:=$sql+"`"+"description"+"`,  "
	$sql:=$sql+"`"+"glue_date"+"`, "
	$sql:=$sql+"`"+"alternate_barcode"+"` "
	$sql:=$sql+") VALUES ( ?, ?, ?, ?, ?, ?, ?, ? )"
	//$insert_stmt:=MySQL New SQL Statement ($conn_id;$sql)
	
	$delete:="DELETE FROM `jobits` WHERE `jobit` = ?"
	
	//$delStmt:=MySQL New SQL Statement ($conn_id;$delete)
	
	//$sql:="SELECT jobit FROM jobits WHERE jobit = '"
	$refer_test:="SELECT jobit FROM cases WHERE jobit = '"
	
	
	//$result:=MySQL Execute ($conn_id;"BEGIN")
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
		
		FIRST RECORD:C50([Job_Forms_Items:44])
		uThermoInit($numRecs; "Sending Jobits")
		For ($i; 1; $numRecs)
			If ($break)
				$i:=$i+$numRecs
			End if 
			
			$jobit:=Replace string:C233([Job_Forms_Items:44]Jobit:4; "."; "")  //wms doesn't use decimals in jobit
			If ([Job_Forms_Items:44]Glued:33#!00-00-00!)
				$glue_date:=[Job_Forms_Items:44]Glued:33
			Else 
				$glue_date:=4D_Current_date
			End if 
			
			$cases_row_count:=wms_api_mySQL_findCasesByJobit($conn_id; [Job_Forms_Items:44]Jobit:4)  //see if any cases have been inserted yet
			If ($cases_row_count<1)  //then it hasn't been used yet, delete and overlay, else ignore, it should already be there
				//MySQL Set String In SQL ($delStmt;1;$jobit)
				//$result:=MySQL Execute ($conn_id;"";$delStmt)
				
				//$row_set:=MySQL Select ($conn_id;($sql+[Job_Forms_Items]Jobit+"'"))
				//$row_count:=MySQL Get Row Count ($row_set)
				//MySQL Delete Row Set ($row_set)
				//If ($row_count=0)
				$numFG:=qryFinishedGood("#KEY"; ([Job_Forms_Items:44]CustId:15+":"+[Job_Forms_Items:44]ProductCode:3))
				
				//MySQL Set String In SQL ($insert_stmt;1;$jobit)
				//MySQL Set String In SQL ($insert_stmt;2;([Job_Forms_Items]CustId+":"+[Job_Forms_Items]ProductCode))
				//MySQL Set Longint In SQL ($insert_stmt;3;PK_getCaseCount ([Finished_Goods]OutLine_Num))
				$casePerSkid:=PK_getCasesPerSkid([Finished_Goods:26]OutLine_Num:4)
				If ($casePerSkid=0)
					$casePerSkid:=99
				End if 
				//MySQL Set Longint In SQL ($insert_stmt;4;$casePerSkid)
				//MySQL Set String In SQL ($insert_stmt;5;[Job_Forms_Items]CustId)
				//MySQL Set String In SQL ($insert_stmt;6;Substring([Finished_Goods]CartonDesc;1;249))
				//MySQL Set Date In SQL ($insert_stmt;7;$glue_date)
				If (Position:C15([Job_Forms_Items:44]CustId:15; <>WMS_ALT_LABELS)=0)
					//MySQL Set Longint In SQL ($insert_stmt;8;0)
				Else 
					//MySQL Set Longint In SQL ($insert_stmt;8;1)
				End if 
				
				//$result:=MySQL Execute ($conn_id;"";$insert_stmt)
				If ($result=1)
					[Job_Forms_Items:44]ModDate:29:=Current date:C33  //*** temp ****••••••••••••••••••••••••••
					SAVE RECORD:C53([Job_Forms_Items:44])
				End if 
				
			End if 
			//End if 
			NEXT RECORD:C51([Job_Forms_Items:44])
			
			If (($i%1000)=0)
				//$result:=MySQL Execute ($conn_id;"COMMIT")
				//$result:=MySQL Execute ($conn_id;"BEGIN")
			End if 
			
			uThermoUpdate($i)
		End for 
		
	Else 
		
		
		ARRAY TEXT:C222($_Jobit; 0)
		ARRAY DATE:C224($_Glued; 0)
		ARRAY TEXT:C222($_CustId; 0)
		ARRAY TEXT:C222($_ProductCode; 0)
		ARRAY LONGINT:C221($_record_number; 0)
		
		SELECTION TO ARRAY:C260([Job_Forms_Items:44]Jobit:4; $_Jobit; \
			[Job_Forms_Items:44]Glued:33; $_Glued; \
			[Job_Forms_Items:44]CustId:15; $_CustId; \
			[Job_Forms_Items:44]ProductCode:3; $_ProductCode; \
			[Job_Forms_Items:44]; $_record_number)
		
		ARRAY LONGINT:C221($_record_finale; 0)
		
		uThermoInit($numRecs; "Sending Jobits")
		For ($i; 1; $numRecs)
			
			$jobit:=Replace string:C233($_Jobit{$i}; "."; "")  //wms doesn't use decimals in jobit
			If ($_Glued{$i}#!00-00-00!)
				$glue_date:=$_Glued{$i}
			Else 
				$glue_date:=4D_Current_date
			End if 
			
			$cases_row_count:=wms_api_mySQL_findCasesByJobit($conn_id; $_Jobit{$i})  //see if any cases have been inserted yet
			If ($cases_row_count<1)  //then it hasn't been used yet, delete and overlay, else ignore, it should already be there
				$numFG:=qryFinishedGood("#KEY"; ($_CustId{$i}+":"+$_ProductCode{$i}))
				$casePerSkid:=PK_getCasesPerSkid([Finished_Goods:26]OutLine_Num:4)
				If ($casePerSkid=0)
					$casePerSkid:=99
				End if 
				
				If ($result=1)
					APPEND TO ARRAY:C911($_record_finale; $_record_number{$i})
					
				End if 
				
			End if 
			
			uThermoUpdate($i)
		End for 
		C_DATE:C307($date)
		$date:=Current date:C33
		
		CREATE SELECTION FROM ARRAY:C640([Job_Forms_Items:44]; $_record_finale)
		APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]ModDate:29:=$date)
		CREATE SELECTION FROM ARRAY:C640([Job_Forms_Items:44]; $_record_number)
		
	End if   // END 4D Professional Services : January 2019 
	//$result:=MySQL Execute ($conn_id;"COMMIT")
	//MySQL Delete SQL Statement ($insert_stmt)
	//MySQL Delete SQL Statement ($delStmt)
	//$conn_id:=DB_ConnectionManager ("Close")
	
	uThermoClose
	FIRST RECORD:C50([Job_Forms_Items:44])
	
End if 