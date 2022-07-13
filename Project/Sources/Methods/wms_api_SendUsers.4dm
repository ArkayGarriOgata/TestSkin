//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 05/10/08, 14:07:32
// ----------------------------------------------------
// Method: wms_api_SendUsers
// Description
// 
//
// Parameters
// ----------------------------------------------------


C_LONGINT:C283($i; $numRecs)
C_BOOLEAN:C305($break)
$break:=False:C215
$numRecs:=Records in selection:C76([Users:5])


<>WMS_ERROR:=0
//$conn_id:=DB_ConnectionManager ("Open")
If ($conn_id>0)
	
	$sql:="INSERT INTO `"+"users"+"` ( "
	$sql:=$sql+"`"+"initials"+"`, "
	$sql:=$sql+"`"+"user_name"+"`, "
	$sql:=$sql+"`"+"login_id"+"`, "
	$sql:=$sql+"`"+"warehouse"+"` "
	$sql:=$sql+") VALUES ( ?, ?, ?, ? )"
	//$insert_stmt:=MySQL New SQL Statement ($conn_id;$sql)
	
	$delete:="DELETE FROM `users` WHERE `initials` = ?"
	
	//$delStmt:=MySQL New SQL Statement ($conn_id;$delete)
	
	//$sql:="SELECT jobit FROM jobits WHERE jobit = '"
	
	//$result:=MySQL Execute ($conn_id;"BEGIN")
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		QUERY:C277([Users:5]; [Users:5]aMsUser:39=True:C214)
		FIRST RECORD:C50([Users:5])
		
	Else 
		
		QUERY:C277([Users:5]; [Users:5]aMsUser:39=True:C214)
		
	End if   // END 4D Professional Services : January 2019 First record
	
	
	uThermoInit($numRecs; "Sending Users")
	
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
		
		
		For ($i; 1; $numRecs)
			If ($break)
				$i:=$i+$numRecs
			End if 
			
			If (User in group:C338([Users:5]UserName:11; "RoleMaterialHandler"))
				//MySQL Set String In SQL ($delStmt;1;[Users]Initials)
				//$result:=MySQL Execute ($conn_id;"";$delStmt)
				
				//$row_set:=MySQL Select ($conn_id;($sql+[Job_Forms_Items]Jobit+"'"))
				//$row_count:=MySQL Get Row Count ($row_set)
				//MySQL Delete Row Set ($row_set)
				//If ($row_count=0)
				
				//MySQL Set String In SQL ($insert_stmt;1;[Users]Initials)
				//MySQL Set String In SQL ($insert_stmt;2;[Users]UserName)
				//MySQL Set String In SQL ($insert_stmt;3;([Users]FirstName+" "+[Users]LastName))
				Case of 
					: (User in group:C338([Users:5]UserName:11; "RoanokeWarehouse"))
						//MySQL Set String In SQL ($insert_stmt;4;"Vista")
					: (User in group:C338([Users:5]UserName:11; "Roanoke"))
						//MySQL Set String In SQL ($insert_stmt;4;"Roanoke")
					Else 
						//MySQL Set String In SQL ($insert_stmt;4;"Hauppauge")
				End case 
				
				//$result:=MySQL Execute ($conn_id;"";$insert_stmt)
				If ($result=1)
					[Users:5]wms_user:61:=True:C214
					SAVE RECORD:C53([Users:5])
				End if 
				//End if 
			End if 
			NEXT RECORD:C51([Users:5])
			
			If (($i%1000)=0)
				//$result:=MySQL Execute ($conn_id;"COMMIT")
				//$result:=MySQL Execute ($conn_id;"BEGIN")
			End if 
			
			uThermoUpdate($i)
		End for 
		
	Else 
		
		// Laghzaoui Ps 4d we need to question Mel if he prefere we don't use uThermoUpdate on this case
		// we change the ordre of if
		
		ARRAY TEXT:C222($_UserName; 0)
		ARRAY LONGINT:C221($_record_number; 0)
		ARRAY LONGINT:C221($_record_number_Finale; 0)
		
		SELECTION TO ARRAY:C260([Users:5]UserName:11; $_UserName; \
			[Users:5]; $_record_number)
		
		If ($result=1)
			For ($i; 1; $numRecs)
				
				If (User in group:C338($_UserName{$i}; "RoleMaterialHandler"))
					
					APPEND TO ARRAY:C911($_record_number_Finale; $_record_number{$i})
					
				End if 
				
				uThermoUpdate($i)
			End for 
			
			CREATE SELECTION FROM ARRAY:C640([Users:5]; $_record_number_Finale)
			APPLY TO SELECTION:C70([Users:5]; [Users:5]wms_user:61:=True:C214)
			CREATE SELECTION FROM ARRAY:C640([Users:5]; $_record_number)
			
		End if 
		
	End if   // END 4D Professional Services : January 2019 
	
	//$result:=MySQL Execute ($conn_id;"COMMIT")
	//MySQL Delete SQL Statement ($insert_stmt)
	//MySQL Delete SQL Statement ($delStmt)
	//$conn_id:=DB_ConnectionManager ("Close")
	
	uThermoClose
	FIRST RECORD:C50([Users:5])
	
End if 

