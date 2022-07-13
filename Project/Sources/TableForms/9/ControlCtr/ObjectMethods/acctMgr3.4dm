If (True:C214)
	SAVE RECORD:C53([Customers_Projects:9])
	$pjtSelected:=Selected list items:C379(pjt_picker)
	GET LIST ITEM:C378(pjt_picker; $pjtSelected; $itemRef; $itemText)
	SET LIST ITEM:C385(pjt_picker; $itemRef; [Customers_Projects:9]Name:2; $itemRef)
	//REDRAW LIST(pjt_picker)
	
Else 
	QUERY:C277([Estimates:17]; [Estimates:17]POnumber:18=[Customers_Projects:9]Name:2)
	
	If (Records in selection:C76([Estimates:17])>0)
		If (Length:C16([Customers_Projects:9]Customerid:3)=0)
			[Customers_Projects:9]Customerid:3:=[Estimates:17]Cust_ID:2
			[Customers_Projects:9]CustomerName:4:=[Estimates:17]CustomerName:47
			[Customers_Projects:9]CustomerLine:5:=[Estimates:17]Brand:3
		End if 
		ORDER BY:C49([Estimates:17]; [Estimates:17]EstimateNo:1; >)
	End if 
End if 