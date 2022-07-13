//(S) [CONTROL]RMadjust'bPost
//upr 1263 10/29/94
//3/27/95 loosen poitem for batch ink problem
//1/2/97 - cs - upr 0235 charge code chaned, insure that the three new fields are 
// populated
//•2/13/97 cs get company id fr BIN not from PO if bin exists for rm_xfer 
//• 3/4/97 cs upr 1858 modify this adjustment screen so that user
//  enters final value instead of adjustment amount
//• 3/26/97 call from Mellisa problem when bin was not in existance,
//  also added window for message while processing
//• 4/3/97 cs found the Comodity key was not assigned o Rm_bin if record was creat

Case of 
		//: (rReal1=0)  `• 3/4/97 cs upr 1858
		//BEEP
		//ALERT("Please enter the adjustment quantity.")
		//REJECT
	: (rReal1<0)  //• 3/26/97 call from Mellisa problem when bin was not in existance
		BEEP:C151
		ALERT:C41("Please enter a a positive quantity.")
		REJECT:C38
	: (Records in selection:C76([Purchase_Orders_Items:12])=0) & (Records in selection:C76([Raw_Materials:21])=0)
		BEEP:C151
		ALERT:C41(" PO item or R/M not found.")  //3/27/95    
		REJECT:C38
	: (sCriterion4="")
		BEEP:C151
		ALERT:C41("Please enter a reason for this adjustment.")
		REJECT:C38
	: (sCriterion3="") | (sCriterion3=" ")  //• 3/26/97 call from Mellisa problem when bin was not in existance
		BEEP:C151
		ALERT:C41("Please enter a Location.")
		REJECT:C38
	Else 
		uMsgWindow("Posting...")
		
		If (Records in selection:C76([Raw_Materials_Locations:25])=0) & (rReal1>0)
			CREATE RECORD:C68([Raw_Materials_Locations:25])
			[Raw_Materials_Locations:25]BinCreated:4:=4D_Current_date
			If (Records in selection:C76([Purchase_Orders_Items:12])=1)  //  3/27/95
				[Raw_Materials_Locations:25]Raw_Matl_Code:1:=[Purchase_Orders_Items:12]Raw_Matl_Code:15
				[Raw_Materials_Locations:25]ActCost:18:=POIpriceToCost  //(uNANCheck ([PO_Items]UnitPrice*([PO_Items]FactNship2price/[PO_Items]FactDship2p
				[Raw_Materials_Locations:25]CompanyID:27:=[Purchase_Orders_Items:12]CompanyID:45  //•1/2/97 upr 0235
				[Raw_Materials_Locations:25]Commodity_Key:12:=[Purchase_Orders_Items:12]Commodity_Key:26  //• 4/3/97 cs found that the commodity key was NOT being assigned
				[Raw_Materials_Locations:25]Location:2:=sCriterion3  //•1/2/97 upr 0235        
			Else 
				[Raw_Materials_Locations:25]Raw_Matl_Code:1:=sCriterion1
				[Raw_Materials_Locations:25]ActCost:18:=uNANCheck([Raw_Materials:21]ActCost:45)
				//•upr 0235 1/2/97
				[Raw_Materials_Locations:25]Location:2:=sCriterion3
				[Raw_Materials_Locations:25]CompanyID:27:=ChrgCodeFrmLoc([Raw_Materials_Locations:25]Location:2)
				//end upr 0235         
			End if 
			QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]POItemKey:4=sCriterion2; *)
			QUERY:C277([Raw_Materials_Transactions:23];  & [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt")
			If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
				[Raw_Materials_Locations:25]BinCreated:4:=[Raw_Materials_Transactions:23]XferDate:3
				REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
			Else 
				[Raw_Materials_Locations:25]BinCreated:4:=4D_Current_date
			End if 
			[Raw_Materials_Locations:25]POItemKey:19:=sCriterion2
			[Raw_Materials_Locations:25]zCount:20:=1
		End if 
		[Raw_Materials_Locations:25]ModWho:22:=<>zResp
		[Raw_Materials_Locations:25]ModDate:21:=4D_Current_date
		$AdjustQty:=rReal1-[Raw_Materials_Locations:25]QtyOH:9  //•3/4/97 cs upr 1858 - quantity adjusted is final value - OH
		[Raw_Materials_Locations:25]QtyOH:9:=rReal1  //•3/4/97 cs upr 1858 - assign user entered value
		[Raw_Materials_Locations:25]QtyAvailable:13:=rReal1  //•3/4/97 cs upr 1858 - assign user entered value
		[Raw_Materials_Locations:25]AdjQty:14:=$AdjustQty
		[Raw_Materials_Locations:25]AdjDate:17:=dDate
		[Raw_Materials_Locations:25]AdjTo:15:=sCriterion4
		[Raw_Materials_Locations:25]AdjBy:16:=<>zResp
		SAVE RECORD:C53([Raw_Materials_Locations:25])
		$CompanyId:=[Raw_Materials_Locations:25]CompanyID:27  //save rm_bin company id since record is unloaded
		If ([Raw_Materials_Locations:25]QtyOH:9=0) & (Not:C34([Raw_Materials_Locations:25]PiDoNotDelete:24) & ([Raw_Materials_Locations:25]ConsignmentQty:26=0))  //10/13/94
			DELETE RECORD:C58([Raw_Materials_Locations:25])
		Else 
			UNLOAD RECORD:C212([Raw_Materials_Locations:25])
		End if 
		//next create transfer OUT record
		CREATE RECORD:C68([Raw_Materials_Transactions:23])
		//TRACE
		If (Records in selection:C76([Purchase_Orders_Items:12])=1)  //  3/27/95
			[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=[Purchase_Orders_Items:12]Raw_Matl_Code:15
			[Raw_Materials_Transactions:23]UnitPrice:7:=[Purchase_Orders_Items:12]UnitPrice:10
			[Raw_Materials_Transactions:23]ActCost:9:=POIpriceToCost  //uNANCheck ([PO_Items]UnitPrice*([PO_Items]FactNship2price/[PO_Items]FactDship2pr
			//[RM_XFER]ActExtCost:=Round(rReal1*[RM_XFER]ActCost;2)  `•3/4/97 cs
			//« upr 1858       
			[Raw_Materials_Transactions:23]ActExtCost:10:=uNANCheck(Round:C94($AdjustQty*[Raw_Materials_Transactions:23]ActCost:9; 2))  //•3/4/97 cs upr 1858 use adjustment qty instead of entered value
			//• upr 0235 1/2/97
			[Raw_Materials_Transactions:23]Location:15:=sCriterion3
			//[RM_XFER]CompanyID:=[PO_ITEMS]CompanyID `•2/13/97 company should come from bin
			[Raw_Materials_Transactions:23]CompanyID:20:=$CompanyId  //•2/13/97 get company from bin
			[Raw_Materials_Transactions:23]DepartmentID:21:=[Purchase_Orders_Items:12]DepartmentID:46
			[Raw_Materials_Transactions:23]ExpenseCode:26:=[Purchase_Orders_Items:12]ExpenseCode:47
			//end upr 0235
		Else 
			[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=sCriterion1
			[Raw_Materials_Transactions:23]UnitPrice:7:=[Raw_Materials:21]LastPurCost:43
			[Raw_Materials_Transactions:23]ActCost:9:=uNANCheck([Raw_Materials:21]ActCost:45)
			//[RM_XFER]ActExtCost:=Round(rReal1*[RM_XFER]ActCost;2)`•3/4/97 cs upr 1858
			[Raw_Materials_Transactions:23]ActExtCost:10:=uNANCheck(Round:C94($AdjustQty*[Raw_Materials_Transactions:23]ActCost:9; 2))  //•3/4/97 cs upr 1858 use adjustment qty instead of entered value
			//• upr 0235 1/2/97
			[Raw_Materials_Transactions:23]Location:15:=sCriterion3
			[Raw_Materials_Transactions:23]DepartmentID:21:=[Raw_Materials:21]DepartmentID:28  //assumed (as above use Raw Mat with no PO_Item)
			[Raw_Materials_Transactions:23]ExpenseCode:26:=RMG_getExpenseCode([Raw_Materials:21]Commodity_Key:2; "hold")  //[Raw_Materials]Obsolete_ExpCode
			
			Case of 
				: ([Raw_Materials_Transactions:23]Location:15="R@")  //Roanoke
					[Raw_Materials_Transactions:23]CompanyID:20:="2"
				: ([Raw_Materials_Transactions:23]Location:15="L@")  //labels
					[Raw_Materials_Transactions:23]CompanyID:20:="3"
				Else   //arkay
					[Raw_Materials_Transactions:23]CompanyID:20:="1"
			End case 
			//end upr 0235
		End if 
		[Raw_Materials_Transactions:23]Xfer_Type:2:="ADJUST"
		[Raw_Materials_Transactions:23]XferDate:3:=dDate
		[Raw_Materials_Transactions:23]POItemKey:4:=sCriterion2
		// [RM_XFER]Qty:=rReal1  `•3/4/97 cs upr 1858 
		[Raw_Materials_Transactions:23]Qty:6:=$AdjustQty  //•3/4/97 cs upr 1858 use adjustment qty instead of entered value
		[Raw_Materials_Transactions:23]Reason:5:=sCriterion4
		[Raw_Materials_Transactions:23]viaLocation:11:=sCriterion4
		//[RM_XFER]ReceivingNum:=
		//[RM_XFER]ReferenceNo:=sCriterion4
		[Raw_Materials_Transactions:23]zCount:16:=1
		[Raw_Materials_Transactions:23]ModDate:17:=4D_Current_date
		[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
		[Raw_Materials_Transactions:23]Commodity_Key:22:=[Raw_Materials_Groups:22]Commodity_Key:3
		[Raw_Materials_Transactions:23]CommodityCode:24:=[Raw_Materials_Groups:22]Commodity_Code:1
		SAVE RECORD:C53([Raw_Materials_Transactions:23])
		UNLOAD RECORD:C212([Raw_Materials_Transactions:23])
		zwStatusMsg("RM ADJUST:"; sCriterion1+" set to "+String:C10(rReal1)+" at "+sCriterion3)
		
		rReal1:=0
		sCriterion2:=""
		sCriterion1:=""
		sCriterion3:=""
		
		If (Not:C34(fPiActive))  //•3/27/97 cs if this was NOT called from Phys INv pallete
			sCriterion4:=""
		End if 
		GOTO OBJECT:C206(sCriterion2)
		
End case 
//
//EOS