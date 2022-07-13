
If ([Purchase_Orders:11]Status:15="Req@") | ([Purchase_Orders:11]Status:15="Rev@")
	uConfirm("This PO has not yet been approved"+Char:C90(13)+"Print the Requistion instead of PO?"; "Print Req"; "Cancel")
	If (ok=1)
		ReqPrint([Purchase_Orders:11]PONo:1)  //print
	End if 
Else 
	//• 5/27/98 cs removed reference to impact printing version  
	rLaserPo("PO")
End if 
//