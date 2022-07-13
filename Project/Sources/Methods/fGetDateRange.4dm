//%attributes = {"publishedWeb":true}
//Procedure: fGetDateRange(»beg;»end)->ok  090998  MLB
//get a begining and ending date

C_DATE:C307(dDateBegin; dDateEnd)

NewWindow(250; 115; 6; 8; "Enter Dates")
DIALOG:C40([zz_control:1]; "DateRangeSimple")
CLOSE WINDOW:C154

If (OK=1)
	$1->:=dDateBegin
	$2->:=dDateEnd
Else 
	$1->:=!00-00-00!
	$2->:=!00-00-00!
End if 

$0:=OK