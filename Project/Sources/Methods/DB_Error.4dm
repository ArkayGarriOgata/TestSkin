//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 05/29/08, 11:59:38
// Modified by: mel (2/12/10) try to make connection resurrect itself without getting out of sequence
//retain err# and log it instead of alert dialog
// ----------------------------------------------------
// Method: DB_Error
// Description
// MySQL Set Error Handler ("DB_Error" )--> result
// called in Startup
// Parameters - on err call
// ----------------------------------------------------

C_LONGINT:C283($1; $2)
C_TEXT:C284($3)

<>WMS_ERROR:=$2
zwStatusMsg("Error: "+String:C10($2); $3+" occurred on connection "+String:C10($1))
//ALERT("Error: "+String($2)+" ["+$3+"]";"Dang")
utl_Logfile("server.log"; "### MySQL ERROR:"+String:C10($2)+" ["+$3+"]"+" ###")