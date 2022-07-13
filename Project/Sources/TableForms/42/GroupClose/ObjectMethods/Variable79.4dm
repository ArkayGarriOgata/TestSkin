// ----------------------------------------------------
// Object Method: [Job_Forms].GroupClose.Variable79
// ----------------------------------------------------

$CDate:=4D_Current_date
dDateEnd:=$CDate-Day of:C23($CDate)
dDateBegin:=dDateEnd-(Day of:C23(dDateEnd))+1
SetObjectProperties(""; ->dDateBegin; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
SetObjectProperties(""; ->dDateEnd; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
SetObjectProperties(""; ->aJobNo; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
aJobNo:=""
vTotRec:=0
ARRAY TEXT:C222(aRpt; vTotRec)  //TJF 052896
ARRAY TEXT:C222(aJFID; vTotRec)
ARRAY TEXT:C222(aCustName; vTotRec)
ARRAY TEXT:C222(aLine; vTotRec)
GOTO OBJECT:C206(dDateBegin)