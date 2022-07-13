//%attributes = {}
// Method: QA_DefineTests () -> 
// ----------------------------------------------------
// by: mel: 10/19/04, 14:45:34
// ----------------------------------------------------

C_TEXT:C284($1)

If (Count parameters:C259=0)
	$pid:=New process:C317("QA_DefineTests"; <>lMinMemPart; "Define QA Tests"; "init")
	
Else 
	<>iMode:=2
	<>filePtr:=->[QA_Tests:134]
	uSetUp(1)
	ALL RECORDS:C47([QA_Tests:134])
	ORDER BY:C49([QA_Tests:134]; [QA_Tests:134]DisplayOrder:6; >)
	$winRef:=Open form window:C675([QA_Tests:134]; "input"; 8)
	FORM SET INPUT:C55([QA_Tests:134]; "input")
	FORM SET OUTPUT:C54([QA_Tests:134]; "List")
	MODIFY SELECTION:C204([QA_Tests:134]; *)
End if 