//%attributes = {"publishedWeb":true}
//PM: pattern_WhileRecords() -> 
//@author mlb - 8/27/02  16:34

C_LONGINT:C283($i; $numRecs)

$numRecs:=Records in selection:C76([zz_control:1])
$i:=0
uThermoInit($numRecs; "Updating Records")
While (Not:C34(End selection:C36([zz_control:1])))
	
	SAVE RECORD:C53([zz_control:1])
	NEXT RECORD:C51([zz_control:1])
	uThermoUpdate($i)
	$i:=$i+1
End while 

uThermoClose