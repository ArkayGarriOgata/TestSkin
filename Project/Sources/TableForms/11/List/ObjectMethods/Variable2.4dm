//(s)[purchase order]list'bcombine
//allows user to combine items from diffeent requistions & same vendor to one Req
//• 6/13/97 cs created
//• 6/3/98 cs when move is complete mark secondary POs as 'canceled'

If (User in group:C338(Current user:C182; "Purchasing"))
	Case of 
		: (Records in set:C195("UserSet")=1)
			CREATE SET:C116([Purchase_Orders:11]; "Current")
			USE SET:C118("UserSet")
			CREATE SET:C116([Purchase_Orders:11]; "Primary")  //everything is fine and happy - user selected primary PO 
			CombinePoItems
			USE SET:C118("Current")
			
		: (Records in set:C195("UserSet")>1)
			uConfirm("You must select ONLY ONE PO or Requisition as Primary for combining."; "OK"; "Help")
			
		: (Records in set:C195("UserSet")=0)  //not OK -first
			uConfirm("You must select at least ONE PO or Requisition as Primary for combining."; "OK"; "Help")
	End case 
	
Else 
	uNotAuthorized
End if 