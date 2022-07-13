Case of 
	: (std_case_count=0)
		//pass
		
	: (aPackQty{ListBox2}>std_case_count)
		//$case_count_as_string:=Request("Confirm HIGH case quantity:";String(aPackQty{ListBox2});"Confirm";"Ignor")
		//If (ok=1)
		//aPackQty{ListBox2}:=Num($case_count_as_string)
		//End if 
		BEEP:C151
		
	: (aPackQty{ListBox2}<std_case_count)
		//$case_count_as_string:=Request("Confirm LOW case quantity:";String(aPackQty{ListBox2});"Confirm";"Ignor")
		//If (ok=1)
		//aPackQty{ListBox2}:=Num($case_count_as_string)
		//End if 
		BEEP:C151
End case 


aTotalPicked{ListBox2}:=aPackQty{ListBox2}*aNumCases{ListBox2}
If (aTotalPicked{ListBox2}>aQty{ListBox2})
	uConfirm("A Pack Qty of "+String:C10(aPackQty{ListBox2})+" would create a negative bin. Adjust the inventory!"; "Try Again"; "Help")
	aPackQty{ListBox2}:=0
	aTotalPicked{ListBox2}:=0
End if 

If (aTotalPicked{ListBox2}>0)
	OBJECT SET ENABLED:C1123(*; "noChgAddToBOL"; True:C214)
End if 
