//%attributes = {"publishedWeb":true}
//(p) ReqCombineVend
//combine multiple Requisitions to the same vender
//• 7/17/97 cs incldued 'Reveiwed' pos also

C_BOOLEAN:C305(<>fButtonOn)

READ WRITE:C146([Purchase_Orders:11])

qryPo2Combine
ORDER BY:C49([Purchase_Orders:11]; [Purchase_Orders:11]VendorID:2; >)

If (Records in selection:C76([Purchase_Orders:11])>1)  //if something was found
	ALERT:C41("Select a Single record as the Primary (move to) PO."+Char:C90(13)+"Then click the 'Combine Reqs' button."+Char:C90(13)+Char:C90(13)+"Click 'Done' to cancel.")
	<>fButtonOn:=True:C214
	<>iMode:=2
	<>filePtr:=->[Purchase_Orders:11]
	FORM SET INPUT:C55(<>filePtr->; "Input")
	FORM SET OUTPUT:C54(<>filePtr->; "List")
	sFile:=Table name:C256(<>filePtr)
	<>Passthrough:=True:C214
	CREATE SET:C116([Purchase_Orders:11]; "◊PassThroughSet")  //set up for modify found records
	doModifyRecord  //every thing else will happen from the buuton on the list layout
	
Else 
	fCombing:=False:C215
	If (Records in selection:C76([Purchase_Orders:11])=1)
		ALERT:C41("There was only one Approved Requisition found."+Char:C90(13)+"This is NOT enough to combine.")
	Else 
		ALERT:C41("No Approved Requisitions found.")
	End if 
End if 