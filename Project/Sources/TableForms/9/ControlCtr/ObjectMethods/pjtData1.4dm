Case of 
	: (Old:C35([Customers_Projects:9]Name:2)="")
		ok:=1
	: (Old:C35([Customers_Projects:9]Name:2)#[Customers_Projects:9]Name:2)
		CONFIRM:C162("Change project's name from "+Old:C35([Customers_Projects:9]Name:2)+" to "+[Customers_Projects:9]Name:2+"?")
	Else 
		ok:=0
End case 

If (ok=1)
	SAVE RECORD:C53([Customers_Projects:9])
	$pjtSelected:=Selected list items:C379(pjt_picker)
	GET LIST ITEM:C378(pjt_picker; $pjtSelected; $itemRef; $itemText)
	SET LIST ITEM:C385(pjt_picker; $itemRef; [Customers_Projects:9]Name:2; $itemRef)
	//REDRAW LIST(pjt_picker)
Else 
	[Customers_Projects:9]Name:2:=Old:C35([Customers_Projects:9]Name:2)
End if 