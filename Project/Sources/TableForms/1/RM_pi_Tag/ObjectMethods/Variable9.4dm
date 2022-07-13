// ----------------------------------------------------
// Object Method: [zz_control].RM_pi_Tag.Variable9
// SetObjectProperties, Modified by: Mark Zinke (5/14/13)
// ----------------------------------------------------

If (Length:C16(tText)=0)
	Case of 
		: (sCriterion3="Roanoke")
			tText:="2"
		: (sCriterion3="Vista")
			tText:="2"
		: (sCriterion3="Hauppauge")
			tText:="1"
		Else 
			tText:="2"
	End case 
End if 

Case of 
	: (Records in selection:C76([Purchase_Orders_Items:12])=0)
		BEEP:C151
		ALERT:C41(" PO item not found.")  //3/27/95    
		REJECT:C38
		
	: (rReal1=0)  //• 3/26/97 call from Mellisa problem when bin was not in existance
		BEEP:C151
		ALERT:C41("Please enter quantity.")
		REJECT:C38
		
	: (Num:C11(sCriterion5)=0)
		BEEP:C151
		ALERT:C41("Please enter a non-zero tag number.")
		REJECT:C38
		
	: (Records in selection:C76([Raw_Materials:21])=0)
		BEEP:C151
		ALERT:C41(" R/M item master record not found.")  //3/27/95    
		REJECT:C38
		
	: (sCriterion4="")
		BEEP:C151
		ALERT:C41("Please enter a Unit of Measure.")
		REJECT:C38
		
	: (sCriterion3="") | (sCriterion3=" ")
		BEEP:C151
		ALERT:C41("Please enter a Location.")
		REJECT:C38
		
	: (Not:C34(sVerifyLocation(->sCriterion3)))  //• mlb - 4/3/03  12:58
		BEEP:C151
		ALERT:C41("Please enter a VALID Location.")
		REJECT:C38
		
	: (Position:C15(tText; " 1 2 4 ")=0)
		BEEP:C151
		ALERT:C41("Please enter a Company as 1 or 2.")
		REJECT:C38
		
	Else   //do it
		
		If ([Raw_Materials_Locations:25]Location:2#sCriterion3)  //• mlb - 4/3/03  12:59
			If (Records in selection:C76([Raw_Materials_Locations:25])>1)  //already found by POitem script
				
				// ******* Verified  - 4D PS - January  2019 ********
				
				QUERY SELECTION:C341([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Location:2=sCriterion3)
				
				// ******* Verified  - 4D PS - January 2019 (end) *********
				
			End if 
			
			Case of 
				: (Records in selection:C76([Raw_Materials_Locations:25])=0)
					//it will be created during post
					
				: (fLockNLoad(->[Raw_Materials_Locations:25]))
					
				Else 
					BEEP:C151
					ALERT:C41("Bin record is in use. Try again later.")
					REJECT:C38
					GOTO OBJECT:C206(sCriterion3)
			End case 
		End if 
		
		SET WINDOW TITLE:C213("Posting tag "+sCriterion5)
		If (Records in selection:C76([Raw_Materials_Locations:25])=0)
			CREATE RECORD:C68([Raw_Materials_Locations:25])
			[Raw_Materials_Locations:25]Raw_Matl_Code:1:=[Purchase_Orders_Items:12]Raw_Matl_Code:15
			[Raw_Materials_Locations:25]ActCost:18:=uNANCheck(POIpriceToCost)
			[Raw_Materials_Locations:25]CompanyID:27:=tText  //•1/2/97 upr 0235
			[Raw_Materials_Locations:25]Commodity_Key:12:=[Purchase_Orders_Items:12]Commodity_Key:26  //• 4/3/97 cs found that the commodity key was NOT being assigned
			[Raw_Materials_Locations:25]Location:2:=sCriterion3  //•1/2/97 upr 0235
			[Raw_Materials_Locations:25]POItemKey:19:=sCriterion2
			[Raw_Materials_Locations:25]zCount:20:=1
			QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]POItemKey:4=sCriterion2; *)
			QUERY:C277([Raw_Materials_Transactions:23];  & [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt")
			If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
				[Raw_Materials_Locations:25]BinCreated:4:=[Raw_Materials_Transactions:23]XferDate:3
				REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
			Else 
				[Raw_Materials_Locations:25]BinCreated:4:=4D_Current_date
			End if 
		End if 
		
		[Raw_Materials_Locations:25]ModWho:22:=<>zResp
		[Raw_Materials_Locations:25]ModDate:21:=4D_Current_date
		[Raw_Materials_Locations:25]QtyOH:9:=[Raw_Materials_Locations:25]QtyOH:9+rReal1
		[Raw_Materials_Locations:25]QtyAvailable:13:=[Raw_Materials_Locations:25]QtyOH:9
		[Raw_Materials_Locations:25]AdjQty:14:=[Raw_Materials_Locations:25]QtyOH:9-[Raw_Materials_Locations:25]PiFreezeQty:23
		[Raw_Materials_Locations:25]AdjDate:17:=dDate
		[Raw_Materials_Locations:25]AdjTo:15:="Phys Inv"
		[Raw_Materials_Locations:25]AdjBy:16:=<>zResp
		SAVE RECORD:C53([Raw_Materials_Locations:25])
		
		//next create transfer OUT record
		CREATE RECORD:C68([Raw_Materials_Transactions:23])
		[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=[Purchase_Orders_Items:12]Raw_Matl_Code:15
		[Raw_Materials_Transactions:23]UnitPrice:7:=[Purchase_Orders_Items:12]UnitPrice:10
		[Raw_Materials_Transactions:23]ActCost:9:=uNANCheck([Raw_Materials_Locations:25]ActCost:18)
		//[RM_XFER]ActExtCost:=Round(rReal1*[RM_XFER]ActCost;2)  `•3/4/97 cs
		//« upr 1858       
		[Raw_Materials_Transactions:23]ActExtCost:10:=uNANCheck(Round:C94(rReal1*[Raw_Materials_Transactions:23]ActCost:9; 2))  //•3/4/97 cs upr 1858 use adjustment qty instead of entered value
		//• upr 0235 1/2/97
		[Raw_Materials_Transactions:23]Location:15:=sCriterion3
		//[RM_XFER]CompanyID:=[PO_ITEMS]CompanyID `•2/13/97 company should come from bin
		[Raw_Materials_Transactions:23]CompanyID:20:=tText
		[Raw_Materials_Transactions:23]DepartmentID:21:=[Purchase_Orders_Items:12]DepartmentID:46
		[Raw_Materials_Transactions:23]ExpenseCode:26:=[Purchase_Orders_Items:12]ExpenseCode:47
		//end upr 0235
		
		[Raw_Materials_Transactions:23]Xfer_Type:2:="ADJUST"
		[Raw_Materials_Transactions:23]XferDate:3:=dDate
		[Raw_Materials_Transactions:23]POItemKey:4:=sCriterion2
		// [RM_XFER]Qty:=rReal1  `•3/4/97 cs upr 1858 
		[Raw_Materials_Transactions:23]Qty:6:=rReal1  //•3/4/97 cs upr 1858 use adjustment qty instead of entered value
		[Raw_Materials_Transactions:23]Reason:5:="Phys Inv"
		[Raw_Materials_Transactions:23]viaLocation:11:="Tag: "+sCriterion5+" in "+sCriterion4  //this is the Tag Number
		//[RM_XFER]ReceivingNum:=
		[Raw_Materials_Transactions:23]ReferenceNo:14:=sCriterion5
		[Raw_Materials_Transactions:23]ReceivingNum:23:=Num:C11(sCriterion5)
		[Raw_Materials_Transactions:23]zCount:16:=1
		[Raw_Materials_Transactions:23]ModDate:17:=4D_Current_date
		[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
		[Raw_Materials_Transactions:23]Commodity_Key:22:=[Purchase_Orders_Items:12]Commodity_Key:26
		[Raw_Materials_Transactions:23]CommodityCode:24:=[Purchase_Orders_Items:12]CommodityCode:16
		
		SAVE RECORD:C53([Raw_Materials_Transactions:23])
		SET WINDOW TITLE:C213("Enter R/M Tags")
		tTitle:="Last tag recorded was: "+sCriterion5+Char:C90(13)+String:C10(rReal1)+" ("+sCriterion4+") of "+sCriterion2
		sCriterion1:=""
		sCriterion2:=""
		//sCriterion3:=""
		sCriterion4:=""
		sCriterion5:=""
		rReal1:=0
		tText:=""
		REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
		REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
		REDUCE SELECTION:C351([Purchase_Orders_Items:12]; 0)
		REDUCE SELECTION:C351([Vendors:7]; 0)
		
		SetObjectProperties(""; ->sCriterion2; True:C214; ""; True:C214)
		SetObjectProperties(""; ->rReal1; True:C214; ""; False:C215)
		SetObjectProperties(""; ->sCriterion5; True:C214; ""; False:C215)
		SetObjectProperties(""; ->tText; True:C214; ""; False:C215)
		SetObjectProperties(""; ->sCriterion3; True:C214; ""; False:C215)
		SetObjectProperties(""; ->sCriterion4; True:C214; ""; False:C215)
		GOTO OBJECT:C206(sCriterion2)
End case 