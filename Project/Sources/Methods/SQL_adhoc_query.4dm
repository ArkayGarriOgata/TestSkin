//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 10/21/10, 20:48:08
// ----------------------------------------------------
// Method: SQL_adhoc_query
// Description
// 
//
// Parameters
// ----------------------------------------------------
C_TEXT:C284($1)
If (Count parameters:C259=0)
	$pid:=New process:C317("SQL_adhoc_query"; <>lMinMemPart; "Ad Hoc SQL"; "init")
Else 
	$winRef:=Open form window:C675("SQLquery")
	DIALOG:C40("SQLquery")
	CLOSE WINDOW:C154($winRef)
End if 
