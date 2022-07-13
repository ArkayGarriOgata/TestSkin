//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: AdminEvent_TestWMSConnection - Created v0.1.0-JJG (05/04/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($1; $xlFormEvent)
C_TEXT:C284($ttMsg)
$xlFormEvent:=$1

SAVE RECORD:C53([zz_control:1])

<>fWMS_Use4D:=[zz_control:1]wms_connection_Use4D:66
<>ttWMS_CONFIG_4D:=[zz_control:1]wms_connection_4D:65
<>ttWMS_CONFIG_MySQL:=[zz_control:1]wms_connection_mysql:58
<>ttWMS_4D_URL:=[zz_control:1]wms_4D_url:67
<>WMS_ALT_LABELS:=[zz_control:1]wms_alternateLabel:59

DB_GetLogin

Case of 
	: ($xlFormEvent#On Clicked:K2:4)
		//do nothing unless clicked
		
	: ([zz_control:1]wms_connection_Use4D:66)  //original code in else
		
		ON ERR CALL:C155("WMS_API_4D_SQLErrorCatch")
		SQL LOGIN:C817("IP:"+DB_GetLogin("hostname")+":"+DB_GetLogin("port"); DB_GetLogin("user"); DB_GetLogin("password"))
		If (OK=1)
			$ttMsg:="Successfully connected to the 4D version of WMS with "+<>ttWMS_CONFIG_4D
			SQL LOGOUT:C872
		Else 
			$ttMsg:="Failed to connect to the 4D version of WMS with "+<>ttWMS_CONFIG_4D
		End if 
		ALERT:C41($ttMsg)
		ON ERR CALL:C155("")
		
	Else 
		
		$database:=Request:C163("Which database?"; DB_GetLogin("database"); "OK"; "Cancel")
		If (ok=1)
			<>WMS_ERROR:=0
			//$conn_id:=DB_ConnectionManager ("Open";$database)
			If ($conn_id>0)
				ALERT:C41("Successfully connected to "+$database+" with "+<>ttWMS_CONFIG_MySQL)
				//$conn_id:=DB_ConnectionManager ("Close";String($conn_id))
			Else 
				ALERT:C41("Failed to connect to "+$database+" with "+<>ttWMS_CONFIG_MySQL)
			End if 
		End if 
		
End case 

If (False:C215)  // Modified by: Mel Bohince (6/23/16) 
	//If (<>fDebug)
	//DODEBUG (Current method name)
	//End if 
	
	//C_LONGINT($1;$xlFormEvent)
	//C_TEXT($ttMsg)
	//$xlFormEvent:=$1
	
	//SAVE RECORD([zz_control])
	//DB_GetLogin 
	
	//Case of 
	//: ($xlFormEvent#On Clicked)
	//  //do nothing unless clicked
	
	//: ([zz_control]wms_connection_Use4D)  //original code in else
	
	//ON ERR CALL("WMS_API_4D_SQLErrorCatch")
	//SQL LOGIN("IP:"+DB_GetLogin ("hostname")+":"+DB_GetLogin ("port");DB_GetLogin ("user");DB_GetLogin ("password"))
	//If (OK=1)
	//$ttMsg:="Successfully connected to the 4D version of WMS with "+<>ttWMS_CONFIG_4D
	//SQL LOGOUT
	//Else 
	//$ttMsg:="Failed to connect to the 4D version of WMS with "+<>ttWMS_CONFIG_4D
	//End if 
	//ALERT($ttMsg)
	//ON ERR CALL("")
	
	//Else 
	
	//$database:=Request("Which database?";DB_GetLogin ("database");"OK";"Cancel")
	//If (ok=1)
	//<>WMS_ERROR:=0
	//$conn_id:=DB_ConnectionManager ("Open";$database)
	//If ($conn_id>0)
	//ALERT("Successfully connected to "+$database+" with "+<>ttWMS_CONFIG_MySQL)
	//$conn_id:=DB_ConnectionManager ("Close";String($conn_id))
	//Else 
	//ALERT("Failed to connect to "+$database+" with "+<>ttWMS_CONFIG_MySQL)
	//End if 
	//End if 
	
	//End case 
End if   //false
