// ----------------------------------------------------
// Object Method: [Job_Forms].GroupClose.Variable77
// ----------------------------------------------------

dDateBegin:=!00-00-00!
dDateEnd:=!00-00-00!
SetObjectProperties(""; ->dDateBegin; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
SetObjectProperties(""; ->dDateEnd; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
SetObjectProperties(""; ->aJobNo; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
aJobNo:=""
vTotRec:=0
ARRAY TEXT:C222(aRpt; vTotRec)  //TJF 052896
ARRAY TEXT:C222(aJFID; vTotRec)
ARRAY TEXT:C222(aCustName; vTotRec)
ARRAY TEXT:C222(aLine; vTotRec)

QUERY:C277([Job_Forms:42]; [Job_Forms:42]ClosedDate:11=!00-00-00!; *)
QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]Completed:18#!00-00-00!)

vTotRec:=Records in selection:C76([Job_Forms:42])
If (vTotRec>0)
	SELECTION TO ARRAY:C260([Job_Forms:42]JobFormID:5; aJFID; [Jobs:15]CustomerName:5; aCustName; [Jobs:15]Line:3; aLine)  //*dump into an array for user selection
	SORT ARRAY:C229(aJFID; aCustName; aLine)
	ARRAY TEXT:C222(aRpt; Size of array:C274(aJFID))
	For ($i; 1; Size of array:C274(aRpt))
		aRpt{$i}:=""
	End for 
Else 
	BEEP:C151
	ALERT:C41("There are no Closed Jobs in that date range.")
End if 
aJobNo:=""
vSel:=0