//%attributes = {"publishedWeb":true}
// Method: fGetSalesValue (orderline;cpn) -> 
// ----------------------------------------------------
// by: mel:  102999  mlb
//return the orderline price or the contract price if necessary
// • mel (8/25/05, 11:37:38) deduct $15 if a Rama order
// • mel (1/12/06, add Rama shipmnets 01666 shit-to
C_BOOLEAN:C305(RAMA_PROJECT)  //change the soldTo to a billTo and reduce by $15/M
C_REAL:C285($0)
C_TEXT:C284($1; $2)
If ([Customers_Order_Lines:41]OrderLine:3#$1)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$1)
End if 

If ([Finished_Goods:26]ProductCode:1#$2)
	$numFG:=qryFinishedGood("#CPN"; $2)
Else 
	$numFG:=1
End if 

If (Records in selection:C76([Customers_Order_Lines:41])>0)
	RAMA_PROJECT:=CUST_isRamaProject([Customers_Order_Lines:41]defaultBillto:23; [Customers_Order_Lines:41]defaultShipTo:17)
	If (RAMA_PROJECT)
		//If ([Customers_Order_Lines]defaultBillto="02568") & (([Customers_Order_Lines]defaultShipTo="02563") | ([Customers_Order_Lines]defaultShipTo="01666"))
		READ ONLY:C145([Customers_Projects:9])
		QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=[Finished_Goods:26]ProjectNumber:82)
		If (Records in selection:C76([Customers_Projects:9])=1)
			If (Position:C15("Glued"; [Customers_Projects:9]Name:2)>0)  //then we are gluing it
				$0:=[Customers_Order_Lines:41]Price_Per_M:8
			Else 
				$0:=[Customers_Order_Lines:41]Price_Per_M:8-15
			End if 
			
		Else   //not in spl project so deduct
			$0:=[Customers_Order_Lines:41]Price_Per_M:8-15
		End if 
		REDUCE SELECTION:C351([Customers_Projects:9]; 0)
		
	Else 
		$0:=[Customers_Order_Lines:41]Price_Per_M:8
	End if 
	
Else 
	
	If ($numFG>0)
		$0:=[Finished_Goods:26]RKContractPrice:49
	Else 
		$0:=0
	End if 
End if 
//

