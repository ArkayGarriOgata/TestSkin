//%attributes = {"publishedWeb":true}
//(p) l_listtoText
//export a selected list to a text file for other uses

C_TEXT:C284(xText)
C_TIME:C306($Doc)

If (Size of array:C274(<>aListNames)=0)
	L_ListNames
End if 

uDialog("SelectList"; 200; 230)
ON EVENT CALL:C190("")  //turn off event call from dialog

If (OK=1)
	$Doc:=Open document:C264(""; "TEXT")
	If (OK=1) & ($Doc#?00:00:00?)
		$list:=<>aListNames{<>aListNames}
		ARRAY TEXT:C222($ListItems; 100)
		RECEIVE PACKET:C104($Doc; xText; Char:C90(13))  //get header/title line
		RECEIVE PACKET:C104($Doc; xText; Char:C90(13))  //get spacing line  
		$Count:=1
		TRACE:C157
		Repeat 
			RECEIVE PACKET:C104($Doc; xText; Char:C90(13))  //get list item 
			If ((OK=1) & (Length:C16(xText)>1))
				$ListItems{$Count}:=xText
				$Count:=$Count+1
				If ($Count=100)
					ARRAY TEXT:C222($ListItems; Size of array:C274($ListItems)+100)
					$Count:=1
				End if 
			End if 
		Until (OK=0) | (Length:C16(xText)<2)
		ARRAY TEXT:C222($ListItems; $Count-1)
		ARRAY TO LIST:C287($Listitems; $list)
		ALERT:C41("List imported from File '"+Document+"'")
	End if 
End if 

CLOSE DOCUMENT:C267($Doc)