//%attributes = {"publishedWeb":true}
//(p) PiSetRmBins
//• 4/9/97 cs created
//Allows an admin person to set the bin value to an entered 
//quantity, while also creating a transaction for PI
//$1 - optional - indicate call is from Admin screen

C_TEXT:C284($1)
C_REAL:C285($Quantity; $Adjustment)
C_TEXT:C284($RMCode; $Temp; $PO)
C_BOOLEAN:C305($Continue)

READ WRITE:C146([Raw_Materials_Locations:25])
READ WRITE:C146([Raw_Materials_Transactions:23])

If (Count parameters:C259=1)
	$RmCode:=RequestBigger("Please enter RM Code to Locate (as it is in stored in database)")  // Modified by: Mark Zinke (12/26/12) Was uRequest
	
	If (OK=1) & ($RmCode#"")  //entered RMCOde
		QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=$RmCode)  //find record
		Case of 
			: (Records in selection:C76([Raw_Materials_Locations:25])=0)  //not found
				ALERT:C41("No RM_Bin record found")
				$Continue:=False:C215
				
			: (Records in selection:C76([Raw_Materials_Locations:25])>1)  //too many found
				$PO:=RequestBigger("More than one record RM_Bin found, Please enter a PO Item Key (PO_No)")  // Modified by: Mark Zinke (12/26/12) Was uRequest
				
				If ($PO#"") & (OK=1)
					// ******* Verified  - 4D PS - January  2019 ********
					
					QUERY SELECTION:C341([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]POItemKey:19=$PO)
					
					
					// ******* Verified  - 4D PS - January 2019 (end) *********
					Case of 
						: (Records in selection:C76([Raw_Materials_Locations:25])=0)
							$Continue:=False:C215
							ALERT:C41("No item with Raw PO : '"+$PO+"' was found.")
						: (Records in selection:C76([Raw_Materials_Locations:25])>1)
							ALERT:C41("More than one RM_Bin record found")
							$Continue:=False:C215
						Else   //just right
							$Continue:=True:C214
					End case 
				Else 
					If (OK=1) & ($PO="")
						ALERT:C41("You must enter a valid PO")
					End if 
				End if 
				
			Else   //just right
				$Continue:=True:C214
		End case 
	Else 
		
		If ($RmCode="") & (OK=1)
			ALERT:C41("You Must enter a valid RM Code")
		End if 
	End if   //end OK=1 & Location#""
Else   //called from user environment
	
	If (Records in selection:C76([Raw_Materials_Locations:25])#1)  //if record in selection NOT 1 = then selected record is NOT in [RM_BINS]
		ALERT:C41("You MUST select only one record in RM_BINS table")
		$Continue:=False:C215
	Else 
		FIRST RECORD:C50([Raw_Materials_Locations:25])  //insure that the record is ready
		$Continue:=True:C214
	End if 
End if 

If ($Continue)  //if it is OK to continue to create transaction
	$Temp:=Request:C163("Please enter NEW bin Quantity")
	
	If (OK=1) & ($Temp#"")  //if there was an entry
		$Quantity:=Num:C11($Temp)
		
		If ($Quantity>=0)  //if the entry was positive
			$Adjustment:=$Quantity-[Raw_Materials_Locations:25]QtyOH:9
			QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=[Raw_Materials_Locations:25]POItemKey:19)
			QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=$RmCode)
			CREATE RECORD:C68([Raw_Materials_Transactions:23])
			[Raw_Materials_Transactions:23]Location:15:=[Raw_Materials_Locations:25]Location:2
			[Raw_Materials_Transactions:23]CompanyID:20:=[Raw_Materials_Locations:25]CompanyID:27
			[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=$RmCode
			
			If (Records in selection:C76([Purchase_Orders_Items:12])=1)  //  3/27/95
				[Raw_Materials_Transactions:23]UnitPrice:7:=[Purchase_Orders_Items:12]UnitPrice:10
				[Raw_Materials_Transactions:23]ActCost:9:=uNANCheck([Purchase_Orders_Items:12]UnitPrice:10*([Purchase_Orders_Items:12]FactNship2price:25/[Purchase_Orders_Items:12]FactDship2price:38))
				[Raw_Materials_Transactions:23]ActExtCost:10:=uNANCheck(Round:C94($Adjustment*[Raw_Materials_Transactions:23]ActCost:9; 2))
				[Raw_Materials_Transactions:23]DepartmentID:21:=[Purchase_Orders_Items:12]DepartmentID:46
				[Raw_Materials_Transactions:23]ExpenseCode:26:=[Purchase_Orders_Items:12]ExpenseCode:47
			Else 
				[Raw_Materials_Transactions:23]UnitPrice:7:=[Raw_Materials:21]LastPurCost:43
				[Raw_Materials_Transactions:23]ActCost:9:=uNANCheck([Raw_Materials:21]ActCost:45)
				[Raw_Materials_Transactions:23]ActExtCost:10:=uNANCheck(Round:C94($Adjustment*[Raw_Materials_Transactions:23]ActCost:9; 2))
				[Raw_Materials_Transactions:23]DepartmentID:21:=[Raw_Materials:21]DepartmentID:28
				// [RM_XFER]ExpenseCode:=[RAW_MATERIALS]ExpenseCode
			End if 
			[Raw_Materials_Transactions:23]Xfer_Type:2:="ADJUST"
			[Raw_Materials_Transactions:23]XferDate:3:=4D_Current_date
			[Raw_Materials_Transactions:23]POItemKey:4:=[Raw_Materials_Locations:25]POItemKey:19
			[Raw_Materials_Transactions:23]Qty:6:=$Adjustment
			[Raw_Materials_Transactions:23]Reason:5:="Phys Inv"
			[Raw_Materials_Transactions:23]viaLocation:11:="Phys Inv"
			[Raw_Materials_Transactions:23]zCount:16:=1
			[Raw_Materials_Transactions:23]ModDate:17:=4D_Current_date
			[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
			[Raw_Materials_Transactions:23]Commodity_Key:22:=[Raw_Materials_Locations:25]Commodity_Key:12
			[Raw_Materials_Transactions:23]CommodityCode:24:=Num:C11(Substring:C12([Raw_Materials_Locations:25]Commodity_Key:12; 1; 2))
			SAVE RECORD:C53([Raw_Materials_Transactions:23])
			
			[Raw_Materials_Locations:25]ModWho:22:=<>zResp
			[Raw_Materials_Locations:25]ModDate:21:=4D_Current_date
			[Raw_Materials_Locations:25]QtyOH:9:=$Quantity
			[Raw_Materials_Locations:25]QtyAvailable:13:=$Quantity
			[Raw_Materials_Locations:25]AdjQty:14:=$Adjustment
			[Raw_Materials_Locations:25]AdjDate:17:=4D_Current_date
			[Raw_Materials_Locations:25]AdjTo:15:="Phys Inv"
			[Raw_Materials_Locations:25]AdjBy:16:=<>zResp
			SAVE RECORD:C53([Raw_Materials_Locations:25])
			ALERT:C41("Change Completed")
		Else 
			ALERT:C41("You Must Enter a POSITIVE Quantity")
		End if 
	End if 
End if 