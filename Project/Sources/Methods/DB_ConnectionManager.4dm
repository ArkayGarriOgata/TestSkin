//%attributes = {}
// (PM) DB_ConnectionManager
// $1 = Action string
// Modified by: mel (2/12/10) try to make connection resurrect itself without getting out of sequence

C_TEXT:C284($1; $2)
C_LONGINT:C283(conn_id; $0)
//C_BOOLEAN(<>MySQL_Registered)

//If (Not(<>MySQL_Registered))
//$error:=MySQL Register ("AJAUOAJ15D58M5DG")
//If ($error=0)
//ALERT("MyConnect Registration Failed.")
//Else 
//<>MySQL_Registered:=True
//End if 
//$wasSet:=MySQL Set Error Handler ("DB_Error")
//End if 

$0:=-1
Case of 
	: (<>WMS_ERROR#0)  // Modified by: mel (2/12/10) try to make connection resurrect itself without getting out of sequence
		//error occurred, so wait until next loop
		
	: ($1="Connection")
		If (conn_id>0)
			$0:=conn_id
		Else 
			DB_ConnectionManager("Open")
		End if 
		
	: ($1="Open")
		DB_ConnectionManager("Close")
		$uri:=DB_GetLogin
		If (Count parameters:C259=2)
			$database:=$2
		Else 
			$database:=DB_GetLogin("database")
		End if 
		//conn_id:=MySQL Connect (DB_GetLogin ("hostname");DB_GetLogin ("user");DB_GetLogin ("password");$database;Num(DB_GetLogin ("port")))
		//If (Not(conn_id>0))
		//utl_Logfile ("wms_api.log";"### ERROR: Could not establish connection to "+<>ttWMS_CONFIG_MySQL)
		//End if 
		
	: ($1="Close")
		//If (conn_id#0)
		//MySQL Close (conn_id)
		//conn_id:=0
		//End if 
		
End case 

$0:=conn_id

//DB_LoadCatalog 
//DB_LoadSchema ("")