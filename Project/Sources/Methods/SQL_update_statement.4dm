//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 10/26/10, 13:24:17
// ----------------------------------------------------
// Method: SQL_update_statement
// Description
// 
//
// Parameters
// ----------------------------------------------------

C_TEXT:C284($1)
If (Count parameters:C259=0)
	$pid:=New process:C317("SQL_update_statement"; <>lMinMemPart; "SQL UPDATE"; "init")
Else 
	$winRef:=Open form window:C675("SQLupdate")
	DIALOG:C40("SQLupdate")
	CLOSE WINDOW:C154($winRef)
End if 
