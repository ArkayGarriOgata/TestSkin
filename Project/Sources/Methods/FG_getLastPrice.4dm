//%attributes = {"publishedWeb":true,"publishedSql":true}
//PM:  FG_getLastPrice  2/13/01  mlb
//get a selling price first from fg record, else from orderlines

C_TEXT:C284($fgKey; $1; $2)  //$2 is flag to use [Finished_Goods]LastPrice before looking at Orderlines
C_REAL:C285($0; $lastPrice)

$fgKey:=$1
$lastPrice:=0

If (Count parameters:C259=2)
	If ([Finished_Goods:26]FG_KEY:47#$fgKey)
		$numFG:=qryFinishedGood("#KEY"; $fgKey)
	Else 
		$numFG:=Records in selection:C76([Finished_Goods:26])
	End if 
	
	If ($numFG>0)
		If ([Finished_Goods:26]LastPrice:27>0)
			$lastPrice:=[Finished_Goods:26]LastPrice:27
		End if 
	End if 
End if 

If ($lastPrice=0)  //look for orderlines
	READ ONLY:C145([Customers_Order_Lines:41])
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=Substring:C12($fgKey; 7); *)
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]CustID:4=Substring:C12($fgKey; 1; 5))
	If (Records in selection:C76([Customers_Order_Lines:41])>0)
		SELECTION TO ARRAY:C260([Customers_Order_Lines:41]Price_Per_M:8; $aPrice; [Customers_Order_Lines:41]DateOpened:13; $aDate)
		SORT ARRAY:C229($aDate; $aPrice; <)
		$lastPrice:=$aPrice{1}
	End if 
End if 

$0:=$lastPrice