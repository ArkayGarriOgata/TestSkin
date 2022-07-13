//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 12/06/12, 15:01:40
// ----------------------------------------------------
// Method: SetUserDefaultWindows
// Description:
// Looks at the [WindowSetNames] table and sets the users
// window layout based on the Default, if there is one. If
// no default is set nothing is done.
// ----------------------------------------------------

QUERY:C277([WindowSetTitles:186]; [WindowSetTitles:186]UserName:2=Current user:C182; *)
QUERY:C277([WindowSetTitles:186];  & ; [WindowSetTitles:186]useDefault:5=True:C214)

If (Records in selection:C76([WindowSetTitles:186])=1)
	WindowPositionRestore([WindowSetTitles:186]SetName:3)
End if 

REDUCE SELECTION:C351([WindowSetTitles:186]; 0)