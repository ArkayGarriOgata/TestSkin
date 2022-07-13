C_LONGINT:C283($itemRef)
C_TEXT:C284($targetPage)
GET LIST ITEM:C378(iAskMeTabControl; *; $itemRef; $targetPage)
Case of 
	: ($targetPage="Ask Me")
		If ("@"=sCustID)
			sCustID:=""
		End if 
		REDUCE SELECTION:C351([Job_Forms_Items_Costs:92]; 0)  //•031297  mBohince  
		REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)
		//
	: ($targetPage="Transactions")
		READ ONLY:C145([Finished_Goods_Transactions:33])
		If (sCustID="")
			sCustID:="@"
		End if 
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ProductCode:1=sCPN; *)
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]CustID:12=sCustID)
		ORDER BY:C49([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]transactionDateTime:40; <)
		//
	: ($targetPage="FiFo Costs")
		READ ONLY:C145([Job_Forms_Items_Costs:92])
		If (sCustID="")
			sCustID:="@"
		End if 
		QUERY:C277([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]FG_Key:13=(sCustID+":"+sCPN))
		ORDER BY:C49([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]Jobit:3; >)
		
		//
End case 

