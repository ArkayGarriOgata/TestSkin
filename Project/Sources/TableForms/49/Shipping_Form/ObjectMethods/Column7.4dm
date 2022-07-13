Case of 
	: (std_wgt_case=0)
		//pass
		
	: (aWgt{ListBox2}>std_wgt_case)
		//$case_count_as_string:=Request("Confirm HIGH case Weight:";String(aWgt{ListBox2});"Confirm";"Ignor")
		//If (ok=1)
		//aWgt{ListBox2}:=Num($case_count_as_string)
		//End if 
		//BEEP
		
	: (aWgt{ListBox2}<std_wgt_case)
		//$case_count_as_string:=Request("Confirm LOW case Weight:";String(aWgt{ListBox2});"Confirm";"Ignor")
		//If (ok=1)
		//aWgt{ListBox2}:=Num($case_count_as_string)
		//End if 
		//BEEP
End case 

