//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 01/11/06, 14:59:47
// ----------------------------------------------------
// Method: SupplyChain_BinManager
// Description
// 
//
// Parameters
// ----------------------------------------------------
C_TEXT:C284($1; $0; $2; $poThatNeedsTheMatl; $poThatIsBeingReceived)
$0:=""

Case of 
	: ($1="material-at-vendor?")
		$0:="NO"
		$poThatNeedsTheMatl:=$2
		$found:=0  // Modified by: Mel Bohince (10/28/21) 
		
		SET QUERY DESTINATION:C396(Into variable:K19:4; $found)
		QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Location:2=$poThatNeedsTheMatl)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		If ($found>0)
			$0:="YES"
		End if 
		
	: ($1="relieve-material-at-vendor")  //do this when the value-added material is received
		//gather the costs
		$poThatNeedsTheMatl:=$2
		QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Location:2=$poThatNeedsTheMatl)
		$cost:=Round:C94(-[Raw_Materials_Locations:25]QtyOH:9*[Raw_Materials_Locations:25]ActCost:18; 2)
		//create issue transactions
		CREATE RECORD:C68([Raw_Materials_Transactions:23])
		[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=[Raw_Materials_Locations:25]Raw_Matl_Code:1
		[Raw_Materials_Transactions:23]Xfer_Type:2:="SupplyChain"
		[Raw_Materials_Transactions:23]XferDate:3:=4D_Current_date
		[Raw_Materials_Transactions:23]POItemKey:4:=[Raw_Materials_Locations:25]POItemKey:19  //this is the originating po
		[Raw_Materials_Transactions:23]JobForm:12:=""
		[Raw_Materials_Transactions:23]ReferenceNo:14:=""
		[Raw_Materials_Transactions:23]ActCost:9:=[Raw_Materials_Locations:25]ActCost:18
		
		[Raw_Materials_Transactions:23]viaLocation:11:=$poThatNeedsTheMatl
		[Raw_Materials_Transactions:23]Location:15:="SUPPLIER"
		[Raw_Materials_Transactions:23]Qty:6:=-[Raw_Materials_Locations:25]QtyOH:9
		[Raw_Materials_Transactions:23]ActExtCost:10:=$cost
		[Raw_Materials_Transactions:23]zCount:16:=1
		[Raw_Materials_Transactions:23]ModDate:17:=4D_Current_date
		[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
		
		[Raw_Materials_Transactions:23]CompanyID:20:=[Raw_Materials_Locations:25]CompanyID:27
		[Raw_Materials_Transactions:23]DepartmentID:21:=""
		[Raw_Materials_Transactions:23]ExpenseCode:26:=""
		
		[Raw_Materials_Transactions:23]ReferenceNo:14:=""
		[Raw_Materials_Transactions:23]Commodity_Key:22:=[Raw_Materials_Locations:25]Commodity_Key:12
		[Raw_Materials_Transactions:23]CommodityCode:24:=Num:C11(Substring:C12([Raw_Materials_Locations:25]Commodity_Key:12; 1; 2))  //upr 1257 10/27/94
		[Raw_Materials_Transactions:23]Reason:5:="SupplyChain"  //• 11/6/97 cs 
		SAVE RECORD:C53([Raw_Materials_Transactions:23])
		UNLOAD RECORD:C212([Raw_Materials_Transactions:23])
		
		//clear the bins
		util_DeleteSelection(->[Raw_Materials_Locations:25])
		//add the cost to current material
		$0:=String:C10($cost)
		
	: ($1="supplied-to-vendor?")  //do this when receiving matl that is actually going to another supplier
		$poThatIsBeingReceived:=$2
		If ([Purchase_Orders:11]PONo:1#$poThatIsBeingReceived)
			QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]PONo:1=$poThatIsBeingReceived)
		End if 
		
		$0:=[Purchase_Orders:11]SupplyChainPO:55  //then a bin with location set $poThatNeedsTheMatl will be created
		
	: ($1="at-a-vendor?")  //called by trigger_RM_Bins
		$poThatHasTheMatl:=$2
		$0:="NO"
		If (util_isNumeric($poThatHasTheMatl))
			If (Length:C16($poThatHasTheMatl)=7) | (Length:C16($poThatHasTheMatl)=9)
				$0:="YES"
			End if 
		End if 
		
	: ($1="unit-cost-add-on")
		$totalCost:=Num:C11($2)
		READ WRITE:C146([Raw_Materials_Locations:25])
		QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]POItemKey:19=$3)
		$totalUnits:=Sum:C1([Raw_Materials_Locations:25]QtyOH:9)
		If ($totalCost>0) & ($totalUnits>0)
			$addedCost:=$totalCost/$totalUnits
		Else 
			$addedCost:=0
		End if 
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			FIRST RECORD:C50([Raw_Materials_Locations:25])
			
			
		Else 
			
			// see line 84 and sum don't change order
			
			
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record 
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			While (Not:C34(End selection:C36([Raw_Materials_Locations:25])))
				[Raw_Materials_Locations:25]SuppliedMatlUnitCost:30:=$addedCost
				[Raw_Materials_Locations:25]ActCost:18:=[Raw_Materials_Locations:25]ActCost:18+[Raw_Materials_Locations:25]SuppliedMatlUnitCost:30
				SAVE RECORD:C53([Raw_Materials_Locations:25])
				NEXT RECORD:C51([Raw_Materials_Locations:25])
			End while 
			
		Else 
			
			APPLY TO SELECTION:C70([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]SuppliedMatlUnitCost:30:=$addedCost)
			APPLY TO SELECTION:C70([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]ActCost:18:=[Raw_Materials_Locations:25]ActCost:18+[Raw_Materials_Locations:25]SuppliedMatlUnitCost:30)
			
		End if   // END 4D Professional Services : January 2019 First record
		
		$0:=String:C10($addedCost)
		REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
		
	: ($1="collect-bins")  // called by [rm]POArray onload
		//wtf
End case 
