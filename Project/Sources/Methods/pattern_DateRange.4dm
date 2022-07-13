//%attributes = {}
// Method: pattern_DateRange () -> 
// ----------------------------------------------------
// by: mel: 12/05/03, 10:22:22
// ----------------------------------------------------
//see fGetDateRange

C_DATE:C307($1; $2; dDateEnd; dDateBegin)

If (Count parameters:C259=2)
	dDateBegin:=$1
	dDateEnd:=$2
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]ClosedDate:11>=dDateBegin; *)
	QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]ClosedDate:11<=dDateEnd)
	OK:=1
Else 
	$numJobs:=qryByDateRange(->[Job_Forms:42]ClosedDate:11; "Select Closed Date")
End if   //params