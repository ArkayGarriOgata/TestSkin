//lop rtransactionsrm
Case of 
	: (Form event code:C388=On Header:K2:17)
		lPageNum:=Printing page:C275
	: (Form event code:C388=On Display Detail:K2:22)
		rPiQty:=0
		rPerpQty:=0
		QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]MillNumber:25=[Raw_Materials_Transactions:23]ReceivingNum:23; *)
		QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]Location:2=[Raw_Materials_Transactions:23]Location:15)
		QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Raw_Materials_Transactions:23]Raw_Matl_Code:1)  //get description
		
		If (Records in selection:C76([Raw_Materials_Locations:25])#0)
			rPerpQty:=[Raw_Materials_Locations:25]PiFreezeQty:23
			rPiQty:=[Raw_Materials_Locations:25]LastPhyCount:5
		End if 
	: (Form event code:C388=On Printing Break:K2:19)
		rDiffTot:=Subtotal:C97([Raw_Materials_Transactions:23]Qty:6)
		rPiTot:=Subtotal:C97(rPiQty)
		rPerpTot:=Subtotal:C97(rPerpQty)
		rDifFValTot:=Round:C94(Subtotal:C97([Raw_Materials_Transactions:23]ActExtCost:10); 2)
		If (Level:C101=2)
			If (Position:C15("."; [Raw_Materials_Transactions:23]Commodity_Key:22)>0)
				sGroup:=Substring:C12([Raw_Materials_Transactions:23]Commodity_Key:22; 4; Position:C15("."; [Raw_Materials_Transactions:23]Commodity_Key:22)-4)
			Else 
				sGroup:=Substring:C12([Raw_Materials_Transactions:23]Commodity_Key:22; 4; Length:C16([Raw_Materials_Transactions:23]Commodity_Key:22))
			End if 
		Else 
			sGroup:=Substring:C12([Raw_Materials_Transactions:23]Commodity_Key:22; 1; 2)
		End if 
End case 
//eop