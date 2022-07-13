//(LP) [PO_CHG_ORDERS]'Input
Case of 
	: (Form event code:C388=On Load:K2:1)
		beforePOC
		
	: (Form event code:C388=On Validate:K2:3)
		uUpdateTrail(->[Purchase_Orders_Chg_Orders:13]ModDate:22; ->[Purchase_Orders_Chg_Orders:13]ModWho:23; ->[Purchase_Orders_Chg_Orders:13]zCount:21)
		If (Record number:C243([Purchase_Orders_Chg_Orders:13])=-3)  //new
			If ([Purchase_Orders_Chg_Orders:13]ChgOrdNo:5>[Purchase_Orders:11]LastChgOrdNo:18)
				[Purchase_Orders:11]LastChgOrdNo:18:=[Purchase_Orders_Chg_Orders:13]ChgOrdNo:5
			End if 
			If ([Purchase_Orders_Chg_Orders:13]ChgOrdDate:6>[Purchase_Orders:11]LastChgOrdDate:19)
				[Purchase_Orders:11]LastChgOrdDate:19:=[Purchase_Orders_Chg_Orders:13]ChgOrdDate:6
			End if 
			SAVE RECORD:C53([Purchase_Orders_Items:12])
		End if 
		QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]PONo:2=[Purchase_Orders:11]PONo:1)  //get back selection
		ORDER BY:C49([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1; >)
End case 
//