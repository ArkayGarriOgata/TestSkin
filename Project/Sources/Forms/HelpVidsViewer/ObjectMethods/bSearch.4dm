// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 06/03/13, 10:27:09
// ----------------------------------------------------
// Object Method: HelpVidsViewer.bSearch
// Description:
// Searches the array atSearch for keywords and
// highlights the proper videos.
// ----------------------------------------------------

C_LONGINT:C283($i; $xlArray)
C_LONGINT:C283($x; $xlSearch)

NewWindow(320; 270; 6; Modal dialog box:K34:2; "Video Search")
DIALOG:C40("HelpVidsSearch")
CLOSE WINDOW:C154

If (OK=1)
	LISTBOX EXPAND:C1100(abVideoLB)
	SetObjectProperties(""; ->bExpand; True:C214; "Collapse")
	LISTBOX SELECT ROW:C912(abVideoLB; 0; lk remove from selection:K53:3)  //Deselect all the rows.
	
	$xlArray:=Size of array:C274(atSearch)  //Built array of search terms.
	$xlSearch:=util_text2array(->tSearch)  //Returns results in the array axText.
	
	For ($i; 1; $xlArray)  //Loop thru the array with the terms in it.
		For ($x; 1; $xlSearch)
			If (Position:C15(axText{$x}; atSearch{$i})>0)  //Found it so highlight the $i of the listboxes
				LISTBOX SELECT ROW:C912(abVideoLB; $i; lk add to selection:K53:2)
				
			End if 
		End for 
	End for 
End if 