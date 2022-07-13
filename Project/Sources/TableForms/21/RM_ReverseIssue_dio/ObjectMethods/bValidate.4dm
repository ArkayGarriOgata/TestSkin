
// Modified by: Mel Bohince (11/7/12) test for locked bin record before committing


Case of 
	: (sJobform="")
		BEEP:C151
		ALERT:C41("Enter a Jobform")
		GOTO OBJECT:C206(sJobform)
		REJECT:C38
		
	: (sCriterion2="")
		BEEP:C151
		ALERT:C41("Select a PO")
		GOTO OBJECT:C206(aText)
		REJECT:C38
		
	: (sCriterion3="")
		BEEP:C151
		ALERT:C41("Enter a Location to put the material")
		GOTO OBJECT:C206(sCriterion3)
		REJECT:C38
		
	: (rReal1<=0)
		BEEP:C151
		ALERT:C41("Enter a positive quantity")
		GOTO OBJECT:C206(rReal1)
		REJECT:C38
		
	: (rb1=0) & (rb2=0)
		BEEP:C151
		ALERT:C41("Choose whether to cost the inventory or leave in job")
		GOTO OBJECT:C206(rb1)
		REJECT:C38
		
	Else   //good to go
		
		If (dDate=!00-00-00!)
			dDate:=4D_Current_date
		End if 
		
		//create xfer record
		$ChargeCode:=[Purchase_Orders_Items:12]CompanyID:45+[Purchase_Orders_Items:12]DepartmentID:46+[Purchase_Orders_Items:12]ExpenseCode:47
		CREATE RECORD:C68([Raw_Materials_Transactions:23])
		[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=[Purchase_Orders_Items:12]Raw_Matl_Code:15
		[Raw_Materials_Transactions:23]Xfer_Type:2:="issuE"
		[Raw_Materials_Transactions:23]XferDate:3:=dDate
		[Raw_Materials_Transactions:23]POItemKey:4:=sCriterion2  //BAK 8/25/94 Buuuuggggg Fix
		[Raw_Materials_Transactions:23]JobForm:12:=sJobform
		[Raw_Materials_Transactions:23]Sequence:13:=0
		
		[Raw_Materials_Transactions:23]Location:15:=sCriterion3
		[Raw_Materials_Transactions:23]viaLocation:11:=sJobform
		[Raw_Materials_Transactions:23]CompanyID:20:=ChrgCodeParse($ChargeCode; 1)
		[Raw_Materials_Transactions:23]DepartmentID:21:=ChrgCodeParse($ChargeCode; 2)
		[Raw_Materials_Transactions:23]ExpenseCode:26:=ChrgCodeParse($ChargeCode; 3)
		[Raw_Materials_Transactions:23]Qty:6:=rReal1
		If (rb1=1)
			[Raw_Materials_Transactions:23]ActCost:9:=0
			[Raw_Materials_Transactions:23]ReferenceNo:14:="without cost"
		Else 
			[Raw_Materials_Transactions:23]ActCost:9:=POIpriceToCost
			[Raw_Materials_Transactions:23]ReferenceNo:14:="costed"
		End if 
		[Raw_Materials_Transactions:23]ActExtCost:10:=Round:C94(rReal1*[Raw_Materials_Transactions:23]ActCost:9; 2)
		[Raw_Materials_Transactions:23]zCount:16:=1
		[Raw_Materials_Transactions:23]ModDate:17:=4D_Current_date
		[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
		[Raw_Materials_Transactions:23]Commodity_Key:22:=[Purchase_Orders_Items:12]Commodity_Key:26
		[Raw_Materials_Transactions:23]CommodityCode:24:=[Purchase_Orders_Items:12]CommodityCode:16
		[Raw_Materials_Transactions:23]Reason:5:="REVERSED"
		[Raw_Materials_Transactions:23]consignment:27:=False:C215
		
		//create a bin from transaction
		READ WRITE:C146([Raw_Materials_Locations:25])
		QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Location:2=[Raw_Materials_Transactions:23]Location:15; *)
		QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]POItemKey:19=[Raw_Materials_Transactions:23]POItemKey:4; *)  //This is the correct PO Number
		QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]ActCost:18=[Raw_Materials_Transactions:23]ActCost:9)
		If (Records in selection:C76([Raw_Materials_Locations:25])=0)
			CREATE RECORD:C68([Raw_Materials_Locations:25])
			[Raw_Materials_Locations:25]Raw_Matl_Code:1:=[Raw_Materials_Transactions:23]Raw_Matl_Code:1
			[Raw_Materials_Locations:25]Location:2:=[Raw_Materials_Transactions:23]Location:15
			[Raw_Materials_Locations:25]CompanyID:27:=[Raw_Materials_Transactions:23]CompanyID:20
			[Raw_Materials_Locations:25]POItemKey:19:=[Raw_Materials_Transactions:23]POItemKey:4
			[Raw_Materials_Locations:25]QtyOH:9:=0
			[Raw_Materials_Locations:25]QtyAvailable:13:=0
			[Raw_Materials_Locations:25]ActCost:18:=[Raw_Materials_Transactions:23]ActCost:9
			[Raw_Materials_Locations:25]Commodity_Key:12:=[Raw_Materials_Transactions:23]Commodity_Key:22  // added 1/24/06 mlb
			$continue:=True:C214  // Modified by: Mel Bohince (11/7/12) test for locked bin record before committing
			
		Else 
			$continue:=fLockNLoad(->[Raw_Materials_Locations:25])  // Modified by: Mel Bohince (11/7/12) test for locked bin record before committing
		End if 
		
		If ($continue)  // Modified by: Mel Bohince (11/7/12) test for locked bin record before committing
			[Raw_Materials_Locations:25]QtyOH:9:=[Raw_Materials_Locations:25]QtyOH:9+[Raw_Materials_Transactions:23]Qty:6
			[Raw_Materials_Locations:25]QtyAvailable:13:=[Raw_Materials_Locations:25]QtyAvailable:13+[Raw_Materials_Transactions:23]Qty:6
			[Raw_Materials_Locations:25]ModDate:21:=4D_Current_date
			[Raw_Materials_Locations:25]ModWho:22:=<>zResp
			SAVE RECORD:C53([Raw_Materials_Locations:25])
			SAVE RECORD:C53([Raw_Materials_Transactions:23])  // this was up above in the create transaction block
			//show reminder of last entry
			If (rb1=1)
				$cost:=" without cost"
			Else 
				$cost:=" with cost"
			End if 
			zwStatusMsg("Reversed"; "Jobform="+sJobform+" PO="+sCriterion2+" Quantity="+String:C10(rReal1)+" to Location="+sCriterion3+$cost)
			
			//redisplay dialog
			dDate:=4D_Current_date
			sJobForm:=""
			sCriterion1:=""
			sCriterion2:=""
			sCriterion3:=""
			sCriterion4:=""
			rReal1:=0
			tText:="Enter a Jobform with issues"
			ARRAY TEXT:C222(aPOIpoiKey; 0)
			ARRAY REAL:C219(asQty; 0)
			ARRAY TEXT:C222(aComm; 0)
			ARRAY TEXT:C222(aRMcode; 0)
			ARRAY TEXT:C222(aText; 0)
			aText{0}:=""
			rb1:=0
			rb2:=0
			
		Else 
			BEEP:C151
			ALERT:C41("Error: Bin record locked, PO="+sCriterion2+" Quantity="+String:C10(rReal1)+" to Location="+sCriterion3+" Transaction Not Saved")
			zwStatusMsg("Error"; "Bin record locked, PO="+sCriterion2+" Quantity="+String:C10(rReal1)+" to Location="+sCriterion3)
		End if 
		UNLOAD RECORD:C212([Raw_Materials_Locations:25])
		UNLOAD RECORD:C212([Raw_Materials_Transactions:23])
		
End case 

