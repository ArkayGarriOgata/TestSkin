If (Form event code:C388=On Double Clicked:K2:5)
	
	Case of 
		: (Substring:C12(aPallet{ListBox2}; 1; 2)="00")  //a pallet
			aNumCases{ListBox2}:=aQty{ListBox2}/std_case_count
			aPackQty{ListBox2}:=std_case_count
		Else   // a case
			aNumCases{ListBox2}:=1
			aPackQty{ListBox2}:=aQty{ListBox2}
	End case 
	
	If (std_wgt_case>0)
		aWgt{ListBox2}:=std_wgt_case
	Else 
		aWgt{ListBox2}:=30
	End if 
	
	aTotalPicked{ListBox2}:=aPackQty{ListBox2}*aNumCases{ListBox2}
	
End if 