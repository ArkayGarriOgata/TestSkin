//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_api_SendJobits - Created v0.1.0-JJG (05/05/16) - method re-written for 4D vs MySQL split
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

WMS_API_LoginLookup  //make sure <>WMS variables are up to date.

If (<>fWMS_Use4D)
	WMS_API_4D_SendJobits
	
Else 
	wms_api_MySQL_SendJobits
	
End if 


If (False:C215)  //v0.1.0-JJG (05/05/16) - old fMySQL code moved into wms_api_MySQL_SendJobits
	
	//// ----------------------------------------------------
	//  // User name (OS): mel
	//  // Date and time: 05/09/08, 15:10:05
	//  // ----------------------------------------------------
	//  // Method: wms_api_SendJobits
	//  // ----------------------------------------------------
	//  // insert jobits from ams to wms so that referential integrity is available as well as joins to cpn, 
	//  // but only if cases table has not yet populated
	//  //**********
	//  //**********
	//  //  ASSUMING A JOBIT RECORD(S) IS IN THE CURRENT SELECTION
	//  //**********
	//  //**********
	
	//C_LONGINT($i;$numRecs;$conn_id)
	//C_BOOLEAN($break)
	//C_TEXT($sql;$delete;$refer_test)
	
	//$break:=False
	//$numRecs:=Records in selection([Job_Forms_Items])
	//<>WMS_ERROR:=0
	//$conn_id:=DB_ConnectionManager ("Open")
	//If ($conn_id>0)  //only continue if connection to wms works
	
	//$sql:="INSERT INTO `"+"jobits"+"` ( "
	//$sql:=$sql+"`"+"jobit"+"`, "
	//$sql:=$sql+"`"+"fg_key"+"`, "
	//$sql:=$sql+"`"+"default_qty_in_case"+"`, "
	//$sql:=$sql+"`"+"case_per_skid"+"`, "
	//$sql:=$sql+"`"+"cust_id"+"`, "
	//$sql:=$sql+"`"+"description"+"`,  "
	//$sql:=$sql+"`"+"glue_date"+"`, "
	//$sql:=$sql+"`"+"alternate_barcode"+"` "
	//$sql:=$sql+") VALUES ( ?, ?, ?, ?, ?, ?, ?, ? )"
	//$insert_stmt:=MySQL New SQL Statement ($conn_id;$sql)
	
	//$delete:="DELETE FROM `jobits` WHERE `jobit` = ?"
	
	//$delStmt:=MySQL New SQL Statement ($conn_id;$delete)
	
	//  //$sql:="SELECT jobit FROM jobits WHERE jobit = '"
	//$refer_test:="SELECT jobit FROM cases WHERE jobit = '"
	
	
	//$result:=MySQL Execute ($conn_id;"BEGIN")
	
	//FIRST RECORD([Job_Forms_Items])
	//uThermoInit ($numRecs;"Sending Jobits")
	//For ($i;1;$numRecs)
	//If ($break)
	//$i:=$i+$numRecs
	//End if 
	
	//$jobit:=Replace string([Job_Forms_Items]Jobit;".";"")  //wms doesn't use decimals in jobit
	//If ([Job_Forms_Items]Glued#!00/00/0000!)
	//$glue_date:=[Job_Forms_Items]Glued
	//Else 
	//$glue_date:=4D_Current_date
	//End if 
	
	//$cases_row_count:=wms_api_find_cases_by_jobit ($conn_id;[Job_Forms_Items]Jobit)  //see if any cases have been inserted yet
	//If ($cases_row_count<1)  //then it hasn't been used yet, delete and overlay, else ignore, it should already be there
	//MySQL Set String In SQL ($delStmt;1;$jobit)
	//$result:=MySQL Execute ($conn_id;"";$delStmt)
	
	//  //$row_set:=MySQL Select ($conn_id;($sql+[Job_Forms_Items]Jobit+"'"))
	//  //$row_count:=MySQL Get Row Count ($row_set)
	//  //MySQL Delete Row Set ($row_set)
	//  //If ($row_count=0)
	//$numFG:=qryFinishedGood ("#KEY";([Job_Forms_Items]CustId+":"+[Job_Forms_Items]ProductCode))
	
	//MySQL Set String In SQL ($insert_stmt;1;$jobit)
	//MySQL Set String In SQL ($insert_stmt;2;([Job_Forms_Items]CustId+":"+[Job_Forms_Items]ProductCode))
	//MySQL Set Longint In SQL ($insert_stmt;3;PK_getCaseCount ([Finished_Goods]OutLine_Num))
	//$casePerSkid:=PK_getCasesPerSkid ([Finished_Goods]OutLine_Num)
	//If ($casePerSkid=0)
	//$casePerSkid:=99
	//End if 
	//MySQL Set Longint In SQL ($insert_stmt;4;$casePerSkid)
	//MySQL Set String In SQL ($insert_stmt;5;[Job_Forms_Items]CustId)
	//MySQL Set String In SQL ($insert_stmt;6;Substring([Finished_Goods]CartonDesc;1;249))
	//MySQL Set Date In SQL ($insert_stmt;7;$glue_date)
	//If (Position([Job_Forms_Items]CustId;<>WMS_ALT_LABELS)=0)
	//MySQL Set Longint In SQL ($insert_stmt;8;0)
	//Else 
	//MySQL Set Longint In SQL ($insert_stmt;8;1)
	//End if 
	
	//$result:=MySQL Execute ($conn_id;"";$insert_stmt)
	//If ($result=1)
	//[Job_Forms_Items]ModDate:=Current date  //*** temp ****••••••••••••••••••••••••••
	//SAVE RECORD([Job_Forms_Items])
	//End if 
	
	//End if 
	//  //End if 
	//NEXT RECORD([Job_Forms_Items])
	
	//If (($i%1000)=0)
	//$result:=MySQL Execute ($conn_id;"COMMIT")
	//$result:=MySQL Execute ($conn_id;"BEGIN")
	//End if 
	
	//uThermoUpdate ($i)
	//End for 
	//$result:=MySQL Execute ($conn_id;"COMMIT")
	//MySQL Delete SQL Statement ($insert_stmt)
	//MySQL Delete SQL Statement ($delStmt)
	//$conn_id:=DB_ConnectionManager ("Close")
	
	//uThermoClose 
	//FIRST RECORD([Job_Forms_Items])
	
	//End if 
End if 