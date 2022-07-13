//%attributes = {"publishedWeb":true}
//gCustOrdDel:
//12/6/94 made more better : )
//•051095 added delete of cco's

If (([Customers_Orders:40]Status:10="Open@") | ([Customers_Orders:40]Status:10="New@"))
	$ordnum:=[Customers_Orders:40]OrderNumber:1
	
	If (gDeleteRecord(->[Customers_Orders:40]))
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderNumber:1=$ordnum)
		If (Records in selection:C76([Customers_Order_Lines:41])>0)
			DELETE SELECTION:C66([Customers_Order_Lines:41])
		End if 
		
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=(String:C10($ordnum; "00000")+"@"))
		If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
			DELETE SELECTION:C66([Customers_ReleaseSchedules:46])
		End if 
		
		QUERY:C277([Customers_Order_Change_Orders:34]; [Customers_Order_Change_Orders:34]OrderNo:5=$ordnum)  //•051095 addede
		If (Records in selection:C76([Customers_Order_Change_Orders:34])>0)
			DELETE SELECTION:C66([Customers_Order_Change_Orders:34])
		End if 
		
		<>EstStatus:="Quoted"
		<>EstNo:=[Customers_Orders:40]EstimateNo:3
		$id:=New process:C317("uChgEstStatus"; <>lMinMemPart; "Estimate Status Change")
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("The order must be in 'Open' or 'New' status to delete.")
End if 