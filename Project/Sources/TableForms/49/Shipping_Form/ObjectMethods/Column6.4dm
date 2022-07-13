If (aTotalPicked{ListBox2}>aQty{ListBox2})
	uConfirm("Picking "+String:C10(aTotalPicked{ListBox2})+" would create a negative bin. Adjust the inventory!"; "Try Again"; "Help")
	aTotalPicked{ListBox2}:=0  //aPackQty{ListBox2}*aNumCases{ListBox2}
End if 