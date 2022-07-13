Case of 
	: (std_cases_skid=0)
		//pass
		
	: (aNumCases{ListBox2}>std_cases_skid)
		//$skid_count_as_string:=Request("Confirm HIGH skid quantity:";String(aNumCases{ListBox2});"Confirm";"Ignor")
		//If (ok=1)
		//aNumCases{ListBox2}:=Num($skid_count_as_string)
		//End if 
		//BEEP
		
	: (aNumCases{ListBox2}<std_cases_skid)
		//$skid_count_as_string:=Request("Confirm LOW skid quantity:";String(aNumCases{ListBox2});"Confirm";"Ignor")
		//If (ok=1)
		//aNumCases{ListBox2}:=Num($skid_count_as_string)
		//End if 
		//BEEP
End case 


aTotalPicked{ListBox2}:=aPackQty{ListBox2}*aNumCases{ListBox2}
If (aTotalPicked{ListBox2}>aQty{ListBox2})
	uConfirm("Picking "+String:C10(aNumCases{ListBox2})+" cases would create a negative bin. Adjust the inventory!"; "Try Again"; "Help")
	aNumCases{ListBox2}:=0
	aTotalPicked{ListBox2}:=0
End if 

If (aTotalPicked{ListBox2}>0)
	OBJECT SET ENABLED:C1123(*; "noChgAddToBOL"; True:C214)
End if 

