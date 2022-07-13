// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 04/12/13, 10:50:36
// ----------------------------------------------------
// Object Method: HelpVidsViewer.bExpand
// ----------------------------------------------------

If (OBJECT Get title:C1068(bExpand)="Expand")
	LISTBOX EXPAND:C1100(abVideoLB)
	SetObjectProperties(""; ->bExpand; True:C214; "Collapse")
	OBJECT SET ENABLED:C1123(bSearch; True:C214)
	
Else 
	LISTBOX COLLAPSE:C1101(abVideoLB)
	SetObjectProperties(""; ->bExpand; True:C214; "Expand")
	OBJECT SET ENABLED:C1123(bSearch; False:C215)
End if 