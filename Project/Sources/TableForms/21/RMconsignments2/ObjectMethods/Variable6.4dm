Case of 
	: (Records in selection:C76([Raw_Materials_Locations:25])=0)
		BEEP:C151
		ALERT:C41("Invalid bin.")
		REJECT:C38
	: (Records in selection:C76([Purchase_Orders_Items:12])=0)
		BEEP:C151
		ALERT:C41("Invalid po item.")
		REJECT:C38
	: (Records in selection:C76([Raw_Materials:21])=0)
		BEEP:C151
		ALERT:C41("Invalid R/M code.")
		REJECT:C38
	: (rReal1=0)
		BEEP:C151
		ALERT:C41("Invalid Quantity.")
		REJECT:C38
	Else 
		
		uMsgWindow("Posting. Please Wait...")
		If (fLockNLoad(->[Raw_Materials_Locations:25]))
			[Raw_Materials_Locations:25]QtyOH:9:=[Raw_Materials_Locations:25]QtyOH:9-rReal1
			[Raw_Materials_Locations:25]QtyAvailable:13:=[Raw_Materials_Locations:25]QtyAvailable:13-rReal1
			[Raw_Materials_Locations:25]ConsignmentQty:26:=[Raw_Materials_Locations:25]ConsignmentQty:26+rReal1
			[Raw_Materials_Locations:25]ModDate:21:=4D_Current_date
			[Raw_Materials_Locations:25]ModWho:22:=<>zResp
			SAVE RECORD:C53([Raw_Materials_Locations:25])
			
			CREATE RECORD:C68([Raw_Materials_Transactions:23])
			[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=sCriterion1
			[Raw_Materials_Transactions:23]Xfer_Type:2:="ConSet"
			[Raw_Materials_Transactions:23]XferDate:3:=4D_Current_date
			[Raw_Materials_Transactions:23]POItemKey:4:=sCriterion2
			[Raw_Materials_Transactions:23]Qty:6:=-rReal1
			[Raw_Materials_Transactions:23]UnitPrice:7:=[Purchase_Orders_Items:12]UnitPrice:10
			[Raw_Materials_Transactions:23]ActCost:9:=uNANCheck([Raw_Materials_Locations:25]ActCost:18)
			[Raw_Materials_Transactions:23]ActExtCost:10:=uNANCheck(Round:C94([Raw_Materials_Transactions:23]Qty:6*[Raw_Materials_Locations:25]ActCost:18; 2))
			[Raw_Materials_Transactions:23]viaLocation:11:=sCriterion3
			[Raw_Materials_Transactions:23]Location:15:=sCriterion3
			[Raw_Materials_Transactions:23]zCount:16:=1
			[Raw_Materials_Transactions:23]ModDate:17:=4D_Current_date
			[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
			SAVE RECORD:C53([Raw_Materials_Transactions:23])
			
			UNLOAD RECORD:C212([Raw_Materials_Transactions:23])
			
			rreal1:=0
		End if 
		
		CLOSE WINDOW:C154
End case 