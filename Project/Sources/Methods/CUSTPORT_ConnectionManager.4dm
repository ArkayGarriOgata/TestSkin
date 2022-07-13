//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 12/09/10, 10:56:12
// ----------------------------------------------------
// Method: CUSTPORT_ConnectionManager
// Description
// 
//see also DB_ConnectionManager
//
// Parameters
// $1 = Action string
// ----------------------------------------------------

C_TEXT:C284($1)
C_LONGINT:C283(custport_conn_id; $0; <>CUSTPORT_ERROR)

$0:=-1
Case of 
	: (<>CUSTPORT_ERROR#0)  // Modified by: mel (2/12/10) try to make connection resurrect itself without getting out of sequence
		//error occurred, so wait until next loop
		
	: ($1="Connection")
		$0:=custport_conn_id
		
	: ($1="Open")
		//If (Not(<>MySQL_Registered))  // Modified by: Mel Bohince (1/25/17) this was missing after wms via 4D took effect
		//$error:=MySQL Register ("AJAUOAJ15D58M5DG")
		//If ($error=0)
		//utl_Logfile ("cust_portal.log";"MyConnect Registration Failed.")
		//Else 
		//<>MySQL_Registered:=True
		//End if 
		//$wasSet:=MySQL Set Error Handler ("DB_Error")
		//End if 
		
		CUSTPORT_ConnectionManager("Close")
		
		If (Application type:C494=4D Local mode:K5:1)  //& (False)  `root:root@127.0.0.1:3306/customer_porta
			$hostname:="mysql.arkayportal.com"  //"127.0.0.1"
			$username:="mel_at_work"  //"root"
			$password:="Y-had-I-8-so-much"  //"root"
			$database:="customer_portal"
			$port:="3306"
		Else 
			$hostname:="mysql.arkayportal.com"
			$username:="mysharona"  //"rk_administrator"
			$password:="wene-rta-quuh"  //"3WaWgc4X04KjS$>A"
			$database:="customer_portal"
			$port:="3306"
		End if 
		
		//custport_conn_id:=MySQL Connect ($hostname;$username;$password;$database;Num($port))
		//If (Not(custport_conn_id#0))
		//utl_Logfile ("cust_portal.log";"### ERROR: Could not establish connection to "+$hostname+":"+$port+"::"+$database+" as "+$username)
		//End if 
		
	: ($1="Close")
		If (custport_conn_id#0)
			//MySQL Close (custport_conn_id)s
			custport_conn_id:=0
		End if 
		
End case 

$0:=custport_conn_id