
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 11/11/15, 11:13:35
// ----------------------------------------------------
// Method: [zz_control].ChgOrderEstLink.List Box
// Description
// replace grouped arrays with listbox
//
// ----------------------------------------------------

$selectedRow:=ListBox1
OBJECT SET ENABLED:C1123(*; "addon@"; False:C215)

For ($row; 1; Size of array:C274(asBull))
	asBull{$row}:=""
End for 
asBull{$selectedRow}:="•"

QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]estimateNum:2=sPONum; *)
QUERY:C277([Estimates_Differentials:38];  & ; [Estimates_Differentials:38]diffNum:3=asCaseID{$selectedRow})
If (Records in selection:C76([Estimates_Differentials:38])#0)
	If ([Estimates_Differentials:38]BreakOutSpls:18)
		OBJECT SET ENABLED:C1123(*; "addon@"; True:C214)
	End if 
	OBJECT SET ENABLED:C1123(bPick; True:C214)
	
Else 
	BEEP:C151
	ALERT:C41("Warning, that Estimate does not seem to be current.")
End if 
