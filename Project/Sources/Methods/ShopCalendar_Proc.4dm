//%attributes = {}
//© 2015 Footprints Inc. All Rights Reserved.
//Method: Method: ShopCalendar_Proc - Created `v1.0.0-PJK (12/22/15)
C_BOOLEAN:C305(<>fDebug)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 
//$1=Department

C_TEXT:C284($1)
C_TEXT:C284(ttDept)

ttDept:=$1

$xlWin:=Open form window:C675("ShopCalendar"; Plain form window:K39:10)
DIALOG:C40("ShopCalendar")
CLOSE WINDOW:C154

