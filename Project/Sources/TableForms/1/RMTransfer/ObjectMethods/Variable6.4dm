//(S) [CONTROL]RMTransfer'bPost
//10/13/94 delete bin if 0 qty
//10/27/94 upr 1261 rewrite
//• 1/2/97  - upr 0235 - cs - charge code changes, need to insure that the company
//•4/26/00  mlb  added missing com key
// id is populated
// • mel (11/11/04, 11:44:36) Joe wants a reason when moving B&P

C_REAL:C285($actCost)

If ((Records in selection:C76([Raw_Materials_Locations:25])>0) & (rReal1#0) & (sCriterion4#""))
	If (rReal1<=[Raw_Materials_Locations:25]QtyOH:9)
		If (Substring:C12([Raw_Materials_Locations:25]Commodity_Key:12; 1; 2)="01")  // • mel (11/11/04, 11:44:36) Joe wants a reason
			Repeat 
				sRefNo:=Request:C163("Enter Jobform being staged or reason:"; ""; "Continue"; "Storage")
				If (ok=0)
					sRefNo:="Storage"
				End if 
			Until (Length:C16(sRefNo)>0)
			
		Else 
			sRefNo:=""
		End if 
		$actCost:=[Raw_Materials_Locations:25]ActCost:18
		//  $CompanyID:=[RM_BINS]CompanyID  `• 1/2/97  - upr 0235
		$CompanyId:=ChrgCodeFrmLoc(sCriterion4)  //get chargecode from location entered
		$comKey:=[Raw_Materials_Locations:25]Commodity_Key:12
		C_DATE:C307($binCreation)
		$binCreation:=[Raw_Materials_Locations:25]BinCreated:4  //•5/02/00  mlb 
		PUSH RECORD:C176([Raw_Materials_Locations:25])  //push to lock from location
		//search for TO bin
		QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=sCriterion1; *)
		QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]Location:2=sCriterion4; *)
		QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]POItemKey:19=sCriterion2)
		If (fLockNLoad(->[Raw_Materials_Locations:25]))
			zwStatusMsg("TRANSFER"; String:C10(rReal1)+" units of PO "+sCriterion2+" from "+sCriterion3+" to "+sCriterion4)
			If (Records in selection:C76([Raw_Materials_Locations:25])=0)
				CREATE RECORD:C68([Raw_Materials_Locations:25])
				[Raw_Materials_Locations:25]Raw_Matl_Code:1:=sCriterion1
				[Raw_Materials_Locations:25]Location:2:=sCriterion4
				[Raw_Materials_Locations:25]POItemKey:19:=sCriterion2
				[Raw_Materials_Locations:25]Commodity_Key:12:=$comKey  //•4/26/00  mlb 
				[Raw_Materials_Locations:25]BinCreated:4:=$binCreation  //•5/02/00  mlb  
			End if 
			[Raw_Materials_Locations:25]QtyOH:9:=[Raw_Materials_Locations:25]QtyOH:9+rReal1
			[Raw_Materials_Locations:25]QtyAvailable:13:=[Raw_Materials_Locations:25]QtyAvailable:13+rReal1
			[Raw_Materials_Locations:25]ActCost:18:=uNANCheck($actCost)
			[Raw_Materials_Locations:25]zCount:20:=1
			[Raw_Materials_Locations:25]ModDate:21:=4D_Current_date
			[Raw_Materials_Locations:25]CompanyID:27:=$CompanyID  //• 1/2/97  - upr 0235
			[Raw_Materials_Locations:25]ModWho:22:=<>zResp
			SAVE RECORD:C53([Raw_Materials_Locations:25])
			UNLOAD RECORD:C212([Raw_Materials_Locations:25])
			
			POP RECORD:C177([Raw_Materials_Locations:25])  //from location
			ONE RECORD SELECT:C189([Raw_Materials_Locations:25])
			[Raw_Materials_Locations:25]QtyOH:9:=[Raw_Materials_Locations:25]QtyOH:9-rReal1
			[Raw_Materials_Locations:25]QtyAvailable:13:=[Raw_Materials_Locations:25]QtyAvailable:13-rReal1
			SAVE RECORD:C53([Raw_Materials_Locations:25])
			If ([Raw_Materials_Locations:25]QtyOH:9=0) & (Not:C34([Raw_Materials_Locations:25]PiDoNotDelete:24) & ([Raw_Materials_Locations:25]ConsignmentQty:26=0))  //10/13/94
				DELETE RECORD:C58([Raw_Materials_Locations:25])
			Else 
				UNLOAD RECORD:C212([Raw_Materials_Locations:25])
			End if 
			//next create transfer OUT record
			CREATE RECORD:C68([Raw_Materials_Transactions:23])
			[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=sCriterion1
			[Raw_Materials_Transactions:23]Xfer_Type:2:="MOVE"
			[Raw_Materials_Transactions:23]XferDate:3:=4D_Current_date
			[Raw_Materials_Transactions:23]POItemKey:4:=sCriterion2
			[Raw_Materials_Transactions:23]Qty:6:=rReal1
			[Raw_Materials_Transactions:23]ActCost:9:=uNANCheck($actCost)
			[Raw_Materials_Transactions:23]viaLocation:11:=sCriterion3
			[Raw_Materials_Transactions:23]Location:15:=sCriterion4
			[Raw_Materials_Transactions:23]zCount:16:=1
			[Raw_Materials_Transactions:23]ModDate:17:=4D_Current_date
			[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
			[Raw_Materials_Transactions:23]Commodity_Key:22:=$comKey
			[Raw_Materials_Transactions:23]CommodityCode:24:=Num:C11(Substring:C12($comKey; 1; 2))
			[Raw_Materials_Transactions:23]CompanyID:20:=$CompanyID  //• 1/2/97  - upr 0235
			[Raw_Materials_Transactions:23]ReferenceNo:14:=sRefNo
			SAVE RECORD:C53([Raw_Materials_Transactions:23])
			UNLOAD RECORD:C212([Raw_Materials_Transactions:23])
			sCriterion1:=""
			sCriterion2:=""
			sCriterion3:=""
			sCriterion4:=""
			rReal1:=0
			sRefNo:=""
			GOTO OBJECT:C206(sCriterion2)
			
		Else   //to is locked
			BEEP:C151
			ALERT:C41("To location is locked. Try again later.")
			POP RECORD:C177([Raw_Materials_Locations:25])
			ONE RECORD SELECT:C189([Raw_Materials_Locations:25])
			UNLOAD RECORD:C212([Raw_Materials_Locations:25])
			sCriterion4:=""
			sCriterion3:=""
		End if   //to is locked
		
	Else 
		BEEP:C151
		ALERT:C41("ERROR: You tried to move more that was in the bin.")
		rReal1:=[Raw_Materials_Locations:25]QtyOH:9
		GOTO OBJECT:C206(rReal1)
		REJECT:C38
	End if 
	
Else 
	BEEP:C151
	REJECT:C38
End if 

//EOS