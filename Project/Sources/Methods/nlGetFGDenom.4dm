//%attributes = {"publishedWeb":true}
//(p) nlGetfgdenom
//return longint, denom to use for division of price based on per/1000 
//or per each
//5/8/95
//•111398  MLB  UPR pass in parameters

C_TEXT:C284($1)
C_TEXT:C284($2)

If (Count parameters:C259=0)  //original
	
	If ([Customers_Order_Lines:41]SpecialBilling:37)
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=[Customers_Order_Lines:41]ProductCode:5)
		
	Else 
		qryFinishedGood([Customers_Order_Lines:41]CustID:4; [Customers_Order_Lines:41]ProductCode:5)  //5/8/95
	End if 
	
Else 
	qryFinishedGood($1; $2)
End if 

Case of 
	: (Records in selection:C76([Finished_Goods:26])=0)
		$0:=1
	: ([Finished_Goods:26]Acctg_UOM:29="M")
		$0:=1000
	Else 
		$0:=1
End case 