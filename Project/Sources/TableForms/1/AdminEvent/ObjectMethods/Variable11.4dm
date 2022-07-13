// ----------------------------------------------------
// User name (OS): mel
// Date and time: 05/29/08, 12:14:45
// ----------------------------------------------------
// Method: Object Method: bTest
// Description
// test mysql connection
// ----------------------------------------------------

AdminEvent_TestWMSConnection(Form event code:C388)  //v0.1.0-JJG (05/04/16) - modularized

If (False:C215)  //v0.1.0-JJG (05/04/16) - replaced by modular method above
	//SAVE RECORD([zz_control])
	//$database:=Request("Which database?";DB_GetLogin ("database");"OK";"Cancel")
	//If (ok=1)
	//<>WMS_ERROR:=0
	//$conn_id:=DB_ConnectionManager ("Open";$database)
	//If ($conn_id>0)
	//ALERT("Successfully connected to "+$database+" with "+<>ttWMS_CONFIG)
	//$conn_id:=DB_ConnectionManager ("Close";String($conn_id))
	//Else 
	//ALERT("Failed to connect to "+$database+" with "+<>ttWMS_CONFIG)
	//End if 
	//End if 
	
End if   //v0.1.0-JJG (05/04/16) - end of commented block