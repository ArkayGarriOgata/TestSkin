//%attributes = {"publishedWeb":true}
//PM: JTB_PrintPackingList() -> 
//@author mlb - 2/7/02  14:50

C_TEXT:C284(xTitle; xText)

If (Count parameters:C259=1)
	BEEP:C151
	ALERT:C41("not implement at this time, go to bagTrack form.")
Else 
	$jtb:=sCriterion1
End if 

xTitle:="PACKING LIST for JOB TRANSFER BAG "+$jtb
xText:=$cr+"Project: "+sCriterion2+<>CR
xText:=xText+"Customer: "+sCriterion3+<>CR
//xText:=xText+"Line: "+sCriterion4+<>CR
xText:=xText+"Jobform: "+sCriterion5+<>CR+<>CR

xText:=xText+"JPSI_ID"+"  "+"DESCRIPTION"+<>CR
For ($i; 1; Size of array:C274(aKey))
	xText:=xText+aKey{$i}+"  "+axRelTemp{$i}+<>CR
End for 

xText:=xText+<>CR+<>CR+String:C10(4D_Current_date; <>LONGDATE)+"  "+String:C10(4d_Current_time; <>HMMAM)
xText:=xText+<>CR+<>CR+"_______________ END OF LIST ______________"
rPrintText

xTitle:=""
xText:=""