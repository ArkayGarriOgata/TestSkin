//bDupPSpec2   Duplicate Process spec record
$recNo:=PSPEC_Duplicate
If ($recNo>=0)
	GOTO RECORD:C242([Process_Specs:18]; $recNo)
	MODIFY RECORD:C57([Process_Specs:18]; *)
Else 
	BEEP:C151
	ALERT:C41("That Pspec already exists for that customer, no duplication occurred.")
End if 
//