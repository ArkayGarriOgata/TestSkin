//%attributes = {"publishedWeb":true}
//PM: qryByDateRange(->dateField;msg{;begin;end}) -> num of records
//@author mlb - 9/26/01  14:03

C_POINTER:C301($1)  //to a date field
C_TEXT:C284($2; windowTitle)  //window title
C_DATE:C307(dDateEnd; dDateBegin; $3; $4)
C_LONGINT:C283($0)

$0:=-1

If (Count parameters:C259=2)
	windowTitle:=$2
Else 
	windowTitle:="Enter a date range"
End if 

$fieldPtr:=$1
$tablePtr:=Table:C252(Table:C252($fieldPtr))

//NewWindow (240;115;6;0;windowTitle)
$winRef:=OpenFormWindow(->[zz_control:1]; "DateRange2"; ->windowTitle; windowTitle)
dDateBegin:=UtilGetDate(Current date:C33; "ThisMonth")  // the first
$To:=UtilGetDate(Current date:C33; "ThisMonth"; ->dDateEnd)  //last day of month
If (Count parameters:C259=4)
	dDateBegin:=$3
	dDateEnd:=$4
End if 

DIALOG:C40([zz_control:1]; "DateRange2")
CLOSE WINDOW:C154($winRef)
If (ok=1)
	If (bSearch=1)
		QUERY:C277($tablePtr->)  //the Find Button
	Else 
		QUERY:C277($tablePtr->; $fieldPtr->>=dDateBegin; *)
		QUERY:C277($tablePtr->;  & ; $fieldPtr-><=dDateEnd)
	End if 
	$0:=Records in selection:C76($tablePtr->)
End if 