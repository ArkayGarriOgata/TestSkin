//%attributes = {"publishedWeb":true}
//(P) ReqCancel: called from (S) [PURCHASE_ORDER]Requisitions'hcPO
//• 6/24/97 cs made this check the record number (there is a possiblity of saving 
//BEFORE this point (req approve button)

If (Is new record:C668([Purchase_Orders:11]))
	uResetID(Table:C252(->[Purchase_Orders:11]); Num:C11([Purchase_Orders:11]PONo:1))
	uResetID(8888; Num:C11([Purchase_Orders:11]ReqNo:5))  //return Requisition too
	RELATE MANY:C262([Purchase_Orders:11]PONo:1)
	DELETE SELECTION:C66([Purchase_Orders_Items:12])
End if 

fCancel:=True:C214
fPOMaint:=False:C215

REDUCE SELECTION:C351([Purchase_Orders_Items:12]; 0)