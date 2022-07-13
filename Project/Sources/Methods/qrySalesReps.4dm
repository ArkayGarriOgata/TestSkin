//%attributes = {"publishedWeb":true}
//Procedure: qrySalesReps(reps initials)  112597  MLB
//load a [SALESMAN] record

C_LONGINT:C283($0)
C_TEXT:C284($1)

If (Count parameters:C259=1)
	QUERY:C277([Salesmen:32]; [Salesmen:32]ID:1=$1)
Else 
	BEEP:C151
End if 

$0:=Records in selection:C76([Salesmen:32])