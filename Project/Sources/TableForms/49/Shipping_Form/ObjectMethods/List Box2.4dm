// _______
// Method: [Customers_Bills_of_Lading].Shipping_Form.List Box2   ( ) ->
// By: Mel Bohince @ 11/06/19, 08:11:48
// Description
// 
// ----------------------------------------------------


If (Form event code:C388=On Double Clicked:K2:5)  //consume the total onhand for this row
	If (std_case_count>0)  //lets add some sparkle
		$needed:=[Customers_ReleaseSchedules:46]Sched_Qty:6-iTotal
		
		If (aQty{ListBox2}<=$needed)
			aNumCases{ListBox2}:=aQty{ListBox2}/std_case_count
			aPackQty{ListBox2}:=std_case_count
			$pickQty:=aPackQty{ListBox2}*aNumCases{ListBox2}
			If ($pickQty>aQty{ListBox2})
				aNumCases{ListBox2}:=aNumCases{ListBox2}-1
				$pickQty:=aPackQty{ListBox2}*aNumCases{ListBox2}
				uConfirm("Reduced case count by 1."; "Gotcha"; "Whatever")
			End if 
			aTotalPicked{ListBox2}:=$pickQty
			
		Else 
			aNumCases{ListBox2}:=$needed/std_case_count
			aPackQty{ListBox2}:=std_case_count
			$pickQty:=aPackQty{ListBox2}*aNumCases{ListBox2}
			If ($pickQty>aQty{ListBox2})
				aNumCases{ListBox2}:=aNumCases{ListBox2}-1
				$pickQty:=aPackQty{ListBox2}*aNumCases{ListBox2}
				uConfirm("Reduced case count by 1."; "Gotcha"; "Whatever")
			End if 
			aTotalPicked{ListBox2}:=$pickQty
			
		End if 
		
		
	End if   //case cnt
	
	If (aTotalPicked{ListBox2}>0)
		OBJECT SET ENABLED:C1123(*; "noChgAddToBOL"; True:C214)
	End if 
	
End if   //form envetn
