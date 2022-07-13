//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 08/27/13, 10:28:29
// ----------------------------------------------------
// Method: PSG_Sort
// Description:
// Replaces existing sort code.
// NOTE: Column 12 is "Seperate" it is still there even 
// if it's hidden. Take that into account if the user
// picks a column 12 or above.
// ----------------------------------------------------

// Modified by: Garri Ogata (9/10/20) added local values for columns so sorts can be changed easily should column order change

C_LONGINT:C283($xlWinRef)

C_LONGINT:C283($nColGluer; $nColPriority)
C_LONGINT:C283($nColCustomer)
C_LONGINT:C283($nColJobit)
C_LONGINT:C283($nColReleased)

$nColGluer:=1
$nColPriority:=2
$nColCustomer:=3
$nColJobit:=6
$nColReleased:=9

$xlWinRef:=Open form window:C675([ProductionSchedules:110]; "SortOptions"; 1)
DIALOG:C40([ProductionSchedules:110]; "SortOptions")
CLOSE WINDOW:C154

If (bOK=1)
	Case of 
		: (rOption1=1)
			LISTBOX SORT COLUMNS:C916(aGlueListBox; $nColGluer; >; $nColPriority; >; $nColJobit; >)
			
		: (rOption2=1)
			LISTBOX SORT COLUMNS:C916(aGlueListBox; $nColCustomer; >; $nColReleased; >; $nColPriority; >)
			
		: (rOption3=1)
			If (cbRemoveSeparate=1)  //It's hidden.
				If ((xl1<12) & (xl2<12) & (xl3<12))  //No need to worry about hidden "Seperate".
					LISTBOX SORT COLUMNS:C916(aGlueListBox; xl1; >; xl2; >; xl3; >)
				Else 
					If (xl1>=12)
						xl1:=xl1+1
					End if 
					If (xl2>=12)
						xl2:=xl2+1
					End if 
					If (xl3>=12)
						xl3:=xl3+1
					End if 
				End if 
				LISTBOX SORT COLUMNS:C916(aGlueListBox; xl1; >; xl2; >; xl3; >)
			Else 
				LISTBOX SORT COLUMNS:C916(aGlueListBox; xl1; >; xl2; >; xl3; >)
			End if 
	End case 
End if 