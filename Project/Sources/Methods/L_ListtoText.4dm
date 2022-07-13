//%attributes = {"publishedWeb":true}
//(p) l_listtoText
//export a selected list to a text file for other uses

C_TEXT:C284(xText)

If (Size of array:C274(<>aListNames)=0)
	L_ListNames
End if 

uDialog("SelectList"; 200; 230)
ON EVENT CALL:C190("")  //turn off event call from dialog

If (OK=1)
	$list:=<>aListNames{<>aListNames}
	ARRAY TEXT:C222($ListItems; 0)
	LIST TO ARRAY:C288($List; $ListItems)
	
	For ($i; 1; Size of array:C274($ListItems))
		xText:=xText+$ListItems{$i}+Char:C90(13)
	End for 
	
	xTitle:=$List+" items"
	rPrintText($List)
	ALERT:C41("List exported to File '"+$list+"'")
End if 