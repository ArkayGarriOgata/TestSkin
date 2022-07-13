//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/05/06, 11:35:38
// ----------------------------------------------------
// Method: util_IncludedSubformWithOpen
// Description
// 
//
// Parameters
// ----------------------------------------------------
C_POINTER:C301($1; $2)  //->[relation]foreignkey;->[target]primaryKey
C_LONGINT:C283($e)
$e:=Form event code:C388
Case of 
	: ($e=On Display Detail:K2:22)
		util_alternateBackground
		
	: ($e=On Selection Change:K2:29)
		SET TIMER:C645(10)
		
	: ($e=On Double Clicked:K2:5)
		util_openTheSelectRecordInList($1; $2; 3)
		
End case 
