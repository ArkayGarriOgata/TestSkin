//%attributes = {"publishedWeb":true}
//PM: pattern_LoopRecords() -> 
//@author mlb - 8/27/02  16:30

C_LONGINT:C283($i; $numRecs)
C_BOOLEAN:C305($break)

$break:=False:C215
$numRecs:=Records in selection:C76([zz_control:1])

uThermoInit($numRecs; "Updating Records")
For ($i; 1; $numRecs)
	If ($break)
		$i:=$i+$numRecs
	End if 
	
	SAVE RECORD:C53([zz_control:1])
	NEXT RECORD:C51([zz_control:1])
	uThermoUpdate($i)
End for 

uThermoClose