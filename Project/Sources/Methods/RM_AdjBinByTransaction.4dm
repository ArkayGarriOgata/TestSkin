//%attributes = {"publishedWeb":true}
//RM_AdjBinByTransaction

C_DATE:C307(dDate)

dDate:=!2001-03-30!

QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="ADJUST"; *)
QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]XferDate:3>=dDate; *)
QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Reason:5="Phys Inv")

CONFIRM:C162("Batch in the "+String:C10(Records in selection:C76([Raw_Materials_Transactions:23]))+" transactions?"; "Yes"; "Abort")
If (OK=1)
	ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3; >; [Raw_Materials_Transactions:23]XferTime:25; >)
	READ WRITE:C146([Raw_Materials_Locations:25])
	For ($i; 1; Records in selection:C76([Raw_Materials_Transactions:23]))
		QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]POItemKey:19=[Raw_Materials_Transactions:23]POItemKey:4)
		If (Records in selection:C76([Raw_Materials_Locations:25])=0)
			CREATE RECORD:C68([Raw_Materials_Locations:25])
			[Raw_Materials_Locations:25]Raw_Matl_Code:1:=[Raw_Materials_Transactions:23]Raw_Matl_Code:1
			[Raw_Materials_Locations:25]ActCost:18:=uNANCheck(POIpriceToCost([Raw_Materials_Transactions:23]POItemKey:4))
			[Raw_Materials_Locations:25]CompanyID:27:=[Raw_Materials_Transactions:23]CompanyID:20  //•1/2/97 upr 0235
			[Raw_Materials_Locations:25]Commodity_Key:12:=[Purchase_Orders_Items:12]Commodity_Key:26  //• 4/3/97 cs found that the commodity key was NOT being assigned
			[Raw_Materials_Locations:25]Location:2:=[Raw_Materials_Transactions:23]Location:15  //•1/2/97 upr 0235
			[Raw_Materials_Locations:25]POItemKey:19:=[Raw_Materials_Transactions:23]POItemKey:4
			[Raw_Materials_Locations:25]zCount:20:=1
		End if 
		
		[Raw_Materials_Locations:25]ModWho:22:=[Raw_Materials_Transactions:23]ModWho:18
		[Raw_Materials_Locations:25]ModDate:21:=[Raw_Materials_Transactions:23]XferDate:3
		[Raw_Materials_Locations:25]QtyOH:9:=[Raw_Materials_Locations:25]QtyOH:9+[Raw_Materials_Transactions:23]Qty:6
		[Raw_Materials_Locations:25]QtyAvailable:13:=[Raw_Materials_Locations:25]QtyOH:9
		[Raw_Materials_Locations:25]AdjQty:14:=[Raw_Materials_Locations:25]QtyOH:9-[Raw_Materials_Locations:25]PiFreezeQty:23
		[Raw_Materials_Locations:25]AdjDate:17:=[Raw_Materials_Transactions:23]XferDate:3
		[Raw_Materials_Locations:25]AdjTo:15:="Phys Inv"
		[Raw_Materials_Locations:25]AdjBy:16:=[Raw_Materials_Transactions:23]ModWho:18
		SAVE RECORD:C53([Raw_Materials_Locations:25])
		NEXT RECORD:C51([Raw_Materials_Transactions:23])
	End for 
End if 