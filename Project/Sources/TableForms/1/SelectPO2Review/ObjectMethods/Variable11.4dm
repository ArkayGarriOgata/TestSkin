//bdel [control]SelectPO2Reveiw

If (aText#0)  //determine that an Item has been selected
	uConfirm("Remove PO number "+aText{aText}+" from the list?")
	
	If (OK=1)
		$Size:=Size of array:C274(aText)
		ARRAY TEXT:C222($Text; $size)
		COPY ARRAY:C226(aText; $Text)
		$Item:=aText
		
		If ($Item=$Size)  //last item/only item
			ARRAY TEXT:C222(aText; $Size-1)
		Else 
			For ($i; 1; $Size-$Item)
				aText{$Item+($i-1)}:=$Text{$Item+$i}
			End for 
		End if 
		ARRAY TEXT:C222(aText; $Size-1)
		ARRAY TEXT:C222($Text; 0)
		aText:=0
	End if 
Else 
	
	If (Size of array:C274(aText)=0)
		ALERT:C41("There is nothing in the list to remove.")
	Else 
		ALERT:C41("You must first select an item from the list to remove.")
	End if 
End if 
//