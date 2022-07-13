//%attributes = {"publishedWeb":true}
//(P) sPOstReceipts: Accept Raw Materials Received and Create [RM_XFER] Record.
//BAK 10/5/94
//MLB 10/20/94
//mlb 10/25/94`REL_ReleaseShipped(8775;!11/19/07!;842037;"mlb";91611)
//mlb 10/26/94 don't default to receipt type 3
//upr 1257 10/27/94
//11/3/94 make issue a negative
//upr1427 2/9/95 allow posting of multiple POs
//•051095 upr 1498
//1/02/97 upr 0235 -cs - updates for charge code change
//•2/13/97 cs onsite alow user to change location without changing company
//• 5/1/97 cs print report if one or more items are recieved at a site different t
//owning division (PO_item charge code company id)
//• 10/20/97 cs moved to this procedure from button script
//• 11/6/97 cs added string to reason field to track receipt type
//• 1/28/98 cs NAN checking
//• 4/30/98 cs Receiving number auto generation
//• 5/21/98 cs posting for 3 uoms was not working correctly
//• 6/5/98 cs canceling a transaction due to locked record did not reset receving 
//• 6/15/98 cs added so that from closeout screeen can determine where issue occur
//• 6/30/98 cs make this a little smarter about updating the budgets - by issuing
//  against the same commcode if avail
//• 8/4/98 cs insure that the jobform start date has been set
//•081399  mlb Make sure latest RMgroup record
// • mel (11/9/04, 11:55:35) fixedCost aware
// • mel  1/11/06 SupplyChain_BinManager
// • mel  2/6/12 SupplyChain_BinManager abs the cost so that unit add-on works
// Modified by: Mel Bohince (6/22/16) don't warn of closed jobs on DP, traps user interface
// Added $stockThisItem by: Mel Bohince (5/31/19) for  method MRO_ControlCenter parts

C_LONGINT:C283($i)
C_TEXT:C284($note)  //• 2/13/97
C_TEXT:C284($chargecode; $fixedCost)
C_BOOLEAN:C305($stockThisItem; $receivingBoard; $success)  //• mlb - 3/27/02  14:44
$success:=True:C214
$stockThisItem:=False:C215
$receivingBoard:=False:C215
$Note:=""  //• 2/13/97

$winRef:=NewWindow(300; 400; 6; 1; "Posting Receipts")
fCnclTrn:=False:C215
START TRANSACTION:C239
READ WRITE:C146([Raw_Materials_Locations:25])
READ WRITE:C146([Raw_Materials:21])
READ WRITE:C146([Purchase_Orders_Items:12])

$numToPost:=Size of array:C274(aRMCode)  //upr1427 2/9/95
//xText2:=""  `• 4/30/98 cs clear PO/Receiving number tracker

For ($i; 1; $numToPost)
	MESSAGE:C88(Char:C90(13)+"  PO Nº: "+aRMPONum{$i}+aRMPOItem{$i})
	MESSAGE:C88(Char:C90(13)+"    searching for r/m: "+aRMCode{$i})
	QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=aRMCode{$i})
	
	//must have a valid r/m number
	//point of entry for r/m's is at po create time or via new r/m
	If (Records in selection:C76([Raw_Materials:21])=1)
		$receivingBoard:=([Raw_Materials:21]CommodityCode:26=1)
		$stockThisItem:=[Raw_Materials:21]Stocked:5
		If ($stockThisItem)
			$_PerferedBin:=[Raw_Materials:21]PreferedBin:37
		End if 
		[Raw_Materials:21]LastPurDate:44:=4D_Current_date
		SAVE RECORD:C53([Raw_Materials:21])
		
		If (SupplyChain_BinManager("material-at-vendor?"; aRMPONum{$i})="YES")
			$costToApply:=Abs:C99(Num:C11(SupplyChain_BinManager("relieve-material-at-vendor"; aRMPONum{$i})))  // /2/6/12abs the cost so that unit add-on works
		Else 
			$costToApply:=0
		End if 
		$costToApplyPerUnit:=0  //base this on the count being received write now.
		
		MESSAGE:C88(Char:C90(13)+"    searching the r/m group")
		qryRMgroup([Raw_Materials:21]Commodity_Key:2; !00-00-00!)  //•081399  mlb  incase there are duplicates use latest one
		$ReceiptType:=[Raw_Materials_Groups:22]ReceiptType:13
		
		
		If ($ReceiptType>3) | ($ReceiptType<1)  //• 8/ 20/97 cs invalid receipt type
			$Comm:=Num:C11(Substring:C12(aComm{aPoItem}; 1; 2))  //• 8/20/97 cs 
			
			If ($Comm<=9)  //• 8/20/97 cs this is a production/inventory material & no Recpt type was found
				$ReceiptType:=1
			Else   //• 8/20/97 cs Commodity is an expense material & no Recpt type was found
				$ReceiptType:=3
			End if 
		End if 
		MESSAGE:C88(Char:C90(13)+"    receipt type = "+String:C10($ReceiptType))
		
		//• upr 0235 1/2/97 added so that company, depart * expense can be assigned correc
		QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=aRMPONum{$i}+aRMPOItem{$i})
		
		If ([Purchase_Orders_Items:12]FixedCost:51)  // • mel (11/9/04, 11:55:35)
			$fixedCost:=aRMPONum{$i}+aRMPOItem{$i}
		Else 
			$fixedCost:=""
		End if 
		
		//•2/13/97 make charge code correct here then pass through
		//$ChargeCode:=[PO_ITEMS]CompanyID+[PO_ITEMS]DepartmentID+[PO_ITEMS]ExpenseCode
		If (aRmCompany{$i}#[Purchase_Orders_Items:12]CompanyID:45)
			$Note:="Moved to "+aRmBinNo{$i}
			[Purchase_Orders_Items:12]RM_Description:7:=[Purchase_Orders_Items:12]RM_Description:7+Char:C90(13)+$Note
			SAVE RECORD:C53([Purchase_Orders_Items:12])
		End if 
		$ChargeCode:=aRmCompany{$i}+[Purchase_Orders_Items:12]DepartmentID:46+[Purchase_Orders_Items:12]ExpenseCode:47
		
		Case of 
			: ($stockThisItem)  // Added by: Mel Bohince (5/31/19) 
				MESSAGE:C88(Char:C90(13)+"    trying to put away part")
				//try to put it with others of same kind
				// Modified by: Mel Bohince (8/22/19) don't do this, some are used without ever stocking to drawers
				//QUERY([MaintRepairSupply_Bins];[MaintRepairSupply_Bins]PartNumber=aRMCode{$i})
				
				//If (Records in selection([MaintRepairSupply_Bins])=0)
				//  // or try to put it in its perferred place
				//If (Length($_PerferedBin)>0)
				//QUERY([MaintRepairSupply_Bins];[MaintRepairSupply_Bins]Bin=$_PerferedBin)
				//End if 
				//End if 
				// else assume it ended up on the desk to be put away later
				//If (Records in selection([MaintRepairSupply_Bins])=0)
				QUERY:C277([MaintRepairSupply_Bins:161]; [MaintRepairSupply_Bins:161]Bin:2="ToPutAway")  //this should aways be there
				If (Records in selection:C76([MaintRepairSupply_Bins:161])=0)
					CREATE RECORD:C68([MaintRepairSupply_Bins:161])
					[MaintRepairSupply_Bins:161]Bin:2:="ToPutAway"
					[MaintRepairSupply_Bins:161]PartNumber:3:="Miscellaneous"
				End if 
				//End if 
				
				[MaintRepairSupply_Bins:161]Quantity:4:=[MaintRepairSupply_Bins:161]Quantity:4+aRMSTKQty{$i}
				SAVE RECORD:C53([MaintRepairSupply_Bins:161])
				aRMBinNo{$i}:=[MaintRepairSupply_Bins:161]Bin:2
				UNLOAD RECORD:C212([MaintRepairSupply_Bins:161])
				
				//standard stuff:
				MESSAGE:C88(Char:C90(13)+"    creating a r/m xfer")
				RM_XferCreate($i; dDate; $ChargeCode; $Note+" MRO item")
				MESSAGE:C88(Char:C90(13)+"    updating a po item")
				POI_itemUpdate($i; dDate)  //•051095 upr 1498
				
			: ($ReceiptType=1)
				QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=aRMCode{$i}; *)
				QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]Location:2=aRMBinNo{$i}; *)
				QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]POItemKey:19=aRMPONum{$i}+aRMPOItem{$i})
				If (Records in selection:C76([Raw_Materials_Locations:25])=0)
					MESSAGE:C88(Char:C90(13)+"    creating a r/m location")
					RM_BinCreate($i; $ChargeCode)  //• upr 0235 added second parameter
				Else 
					MESSAGE:C88(Char:C90(13)+"    updating a r/m location")
					RM_BinUpdate($i; $ChargeCode)  //upr 0235  
				End if 
				MESSAGE:C88(Char:C90(13)+"    creating a r/m xfer")
				
				If (Not:C34(User in group:C338(Current user:C182; "RoleCostAccountant"))) & (dDate#4D_Current_date)  // Added by: Mark Zinke (11/20/12)
					dDate:=4D_Current_date  //Only members of "RoleCostAccountant" group can use a date that isn't the current date.
				End if 
				$xferRecNumber:=RM_XferCreate($i; dDate; $ChargeCode; $note+" Inventory")  //• upr 0235 added third parameter`• 11/6/97 cs 
				MESSAGE:C88(Char:C90(13)+"    updating a po item")
				POI_itemUpdate($i; dDate)  //•051095 upr 1498
				If (Length:C16($fixedCost)=9) & (False:C215)  //mel 051006 already done on poi ` • mel (11/9/04, 12:01:36)
					CUT NAMED SELECTION:C334([Purchase_Orders_Items:12]; "beforeFixed")
					QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=aRMPONum{$i}+aRMPOItem{$i})
					POI_FixedCostCorrection
					USE NAMED SELECTION:C332("beforeFixed")
				End if 
				
				If ($costToApply>0)  //add-in the cost to the bins unit cost so issues will get the bucks
					$costToApplyPerUnit:=Num:C11(SupplyChain_BinManager("unit-cost-add-on"; String:C10($costToApply); (aRMPONum{$i}+aRMPOItem{$i})))
				End if 
				
				If ($receivingBoard)
					RM_MillRelieveInventory(aRMPONum{$i}+aRMPOItem{$i}; aRMSTKQty{$i}; $xferRecNumber)
					UNLOAD RECORD:C212([Raw_Materials_Transactions:23])
				End if 
				
				// Modified by: Mel Bohince (2/14/17) 
				If ([Raw_Materials_Groups:22]Commodity_Code:1=1) | ([Raw_Materials_Groups:22]Commodity_Code:1=20)  // Modified by: Mel Bohince (2/23/16) direct purchase of sheet initiative, (7/22/16 comm 20 added
					
					QUERY:C277([Purchase_Orders_Job_forms:59]; [Purchase_Orders_Job_forms:59]POItemKey:1=aRMPONum{$i}+aRMPOItem{$i}; *)
					QUERY:C277([Purchase_Orders_Job_forms:59];  & ; [Purchase_Orders_Job_forms:59]JobFormID:2#"")
					If (Records in selection:C76([Purchase_Orders_Job_forms:59])>0)
						$success:=JML_setStockReceivedSheeted([Purchase_Orders_Job_forms:59]JobFormID:2; [Purchase_Orders_Items:12]UM_Arkay_Issue:28)
						If (Not:C34($success))
							//uCancelTran
							$body:="Job Master Log record for "+[Purchase_Orders_Job_forms:59]JobFormID:2+" was locked at the time of Stock receipt. Please set the date manually so schedules show green."
							$from:=Email_WhoAmI
							distributionList:=Batch_GetDistributionList(""; "PROD")
							$subject:="Stock Received Not Set for "+[Purchase_Orders_Job_forms:59]JobFormID:2
							EMAIL_Sender($subject; ""; $body; distributionList; ""; $from; $from)
						End if 
					End if   //job assigned to po
				End if   //comm=1
				
			: ([Raw_Materials_Groups:22]ReceiptType:13=2)  //direct purchase      
				MESSAGE:C88(Char:C90(13)+"    creating a r/m xfer")
				RM_XferCreate($i; dDate; $ChargeCode; $note+" Direct Purchase")  //• upr 0235 added third parameter`• 11/6/97 cs 
				MESSAGE:C88(Char:C90(13)+"    updating a po item")
				POI_itemUpdate($i; dDate)  //•051095 upr 1498
				QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=aRMPONum{$i}+aRMPOItem{$i})  //10/25/94
				
				If ([Raw_Materials:21]Raw_Matl_Code:1#aRMCode{$i})  //upr 1257 10/27/94
					READ ONLY:C145([Raw_Materials:21])
					QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=aRMCode{$i})
				End if 
				
				MESSAGE:C88(Char:C90(13)+"    issuing to job")
				QUERY:C277([Purchase_Orders_Job_forms:59]; [Purchase_Orders_Job_forms:59]POItemKey:1=aRMPONum{$i}+aRMPOItem{$i})
				
				If (Records in selection:C76([Purchase_Orders_Job_forms:59])>0)  //BAK 10/12/94 - Do not create Budget if no Job#
					QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=[Purchase_Orders_Job_forms:59]JobFormID:2)
					$jobform:=[Purchase_Orders_Job_forms:59]JobFormID:2
				Else   //• 6/30/98 cs locate jobform based on default job form (used by Ink forms)
					QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=[Purchase_Orders:11]DefaultJobId:3)
					$jobform:=[Purchase_Orders:11]DefaultJobId:3
				End if 
				$sequence:=0
				QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$jobform)
				If (Records in selection:C76([Job_Forms:42])>0) & ([Job_Forms:42]Status:6="Close@")
					// Modified by: Mel Bohince (6/22/16) modal dialog traps user interface, rely on emailing "Batch_TransactionOnClosedJob_" to catch these.
					//uConfirm ("Job "+$jobform+" is CLOSED. PLEASE, Notify Chris that you got this message receiving PO "+aRMPONum{$i}+aRMPOItem{$i};"OK";"Help")
				End if 
				
				If (Records in selection:C76([Job_Forms_Materials:55])>0)  //• 6/30/98 cs 
					CREATE SET:C116([Job_Forms_Materials:55]; "matl")
					// ******* Verified  - 4D PS - January  2019 ********
					QUERY SELECTION:C341([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Raw_Matl_Code:7=aRMCode{$i})
					
					// ******* Verified  - 4D PS - January 2019 (end) *********
					
					If (Records in selection:C76([Job_Forms_Materials:55])=0)
						USE SET:C118("matl")
						// ******* Verified  - 4D PS - January  2019 ********
						QUERY SELECTION:C341([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Commodity_Key:12=[Raw_Materials:21]Commodity_Key:2)
						
						// ******* Verified  - 4D PS - January 2019 (end) *********
						
						If (Records in selection:C76([Job_Forms_Materials:55])=0)  //• 6/30/98 cs cant locate a specific comm key - try for a more general match
							USE SET:C118("Matl")
							// ******* Verified  - 4D PS - January  2019 ********
							QUERY SELECTION:C341([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Commodity_Key:12=String:C10([Raw_Materials:21]CommodityCode:26; "00")+"@")
							
							// ******* Verified  - 4D PS - January 2019 (end) *********
							
							If (Records in selection:C76([Job_Forms_Materials:55])=0)  //• 6/30/98 cs still nothing found
								If (False:C215)  //see below also • mlb - 11/21/02  11:51
									MESSAGE:C88(Char:C90(13)+"    creating job budget")
									CREATE RECORD:C68([Job_Forms_Materials:55])
									[Job_Forms_Materials:55]JobForm:1:=[Purchase_Orders_Job_forms:59]JobFormID:2
									[Job_Forms_Materials:55]Sequence:3:=0  //? make zero
									[Job_Forms_Materials:55]Comments:4:="Non-budgeted item. Found at Receiving"
									[Job_Forms_Materials:55]ModDate:10:=4D_Current_date
									[Job_Forms_Materials:55]ModWho:11:=<>zResp
									[Job_Forms_Materials:55]Raw_Matl_Code:7:=aRMCode{$i}
								End if 
							End if 
							
						Else 
							If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
								
								FIRST RECORD:C50([Job_Forms_Materials:55])
								
								
							Else 
								
								// see line 197 204
								
								
							End if   // END 4D Professional Services : January 2019 First record
							// 4D Professional Services : after Order by , query or any query type you don't need First record  
							fLockNLoad(->[Job_Forms_Materials:55])
							uCancelTran
						End if 
					Else 
						fLockNLoad(->[Job_Forms_Materials:55])
						uCancelTran
						$sequence:=[Job_Forms_Materials:55]Sequence:3
					End if 
					
					If (Not:C34(fCnclTrn))
						aRMPOQty{$i}:=uNANCheck(aRMPOQty{$i})  //• 1/28/98 cs NAN checking
						If (Records in selection:C76([Job_Forms_Materials:55])#0)  //• mlb - 11/21/02  11:53
							[Job_Forms_Materials:55]Actual_Qty:14:=uNANCheck([Job_Forms_Materials:55]Actual_Qty:14+aRMPOQty{$i})
							[Job_Forms_Materials:55]Actual_Price:15:=uNANCheck(aRMStdPrice{$i})
							//More BAK Mod
							SAVE RECORD:C53([Job_Forms_Materials:55])
						End if 
						UNLOAD RECORD:C212([Job_Forms_Materials:55])
						//End of Mod
						MESSAGE:C88(Char:C90(13)+"    creating a r/m to job xfer")
						
						CREATE RECORD:C68([Raw_Materials_Transactions:23])
						[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=aRMCode{$i}
						[Raw_Materials_Transactions:23]Xfer_Type:2:="Issue"
						[Raw_Materials_Transactions:23]XferDate:3:=dDate
						[Raw_Materials_Transactions:23]POItemKey:4:=aRMPONum{$i}+aRMPOItem{$i}
						//[RM_XFER]JobForm:=[Material_Job]JobForm
						//BAK 10/5/94 - may not have if non-Budgeted Item and unloaded above
						[Raw_Materials_Transactions:23]JobForm:12:=[Purchase_Orders_Job_forms:59]JobFormID:2
						[Raw_Materials_Transactions:23]Sequence:13:=$sequence
						[Raw_Materials_Transactions:23]ReferenceNo:14:=""
						[Raw_Materials_Transactions:23]ActCost:9:=uNANCheck(aRMStdPrice{$i})
						
						[Raw_Materials_Transactions:23]viaLocation:11:=aRMBinNo{$i}
						[Raw_Materials_Transactions:23]Location:15:="WIP"
						[Raw_Materials_Transactions:23]Qty:6:=-aRMStkQty{$i}  //`• 5/21/98 cs was - aRMPOQty
						[Raw_Materials_Transactions:23]ActExtCost:10:=uNANCheck(Round:C94(-aRMStkQty{$i}*[Raw_Materials_Transactions:23]ActCost:9; 2))  //`• 5/21/98 cs was - aRMPOQty
						[Raw_Materials_Transactions:23]zCount:16:=1
						[Raw_Materials_Transactions:23]ModDate:17:=4D_Current_date
						[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
						//• upr -235 related chages
						[Raw_Materials_Transactions:23]CompanyID:20:=ChrgCodeParse($ChargeCode; 1)
						[Raw_Materials_Transactions:23]DepartmentID:21:=ChrgCodeParse($ChargeCode; 2)
						[Raw_Materials_Transactions:23]ExpenseCode:26:=ChrgCodeParse($ChargeCode; 3)
						//end upr 0235
						[Raw_Materials_Transactions:23]ReferenceNo:14:="Direct Bill"  //• 6/15/98 cs added so that from closeout screeen can determine where issue occur
						[Raw_Materials_Transactions:23]Commodity_Key:22:=[Raw_Materials:21]Commodity_Key:2
						[Raw_Materials_Transactions:23]CommodityCode:24:=[Raw_Materials:21]CommodityCode:26  //upr 1257 10/27/94
						[Raw_Materials_Transactions:23]Reason:5:=[Raw_Materials_Transactions:23]Reason:5+" "+$Note+" Direct Purchase"  //• 11/6/97 cs 
						SAVE RECORD:C53([Raw_Materials_Transactions:23])
						UNLOAD RECORD:C212([Raw_Materials_Transactions:23])
						
						$success:=uVerifyJobStart([Purchase_Orders_Job_forms:59]JobFormID:2)  //• 8/4/98 cs insure that the jobform start date has been set
						If (Not:C34($success))
							//uCancelTran
							// Modified by: Mel Bohince (1/31/20) add poitem to body
							$body:="Job form record for "+[Purchase_Orders_Job_forms:59]JobFormID:2+" was locked at the time of direct purchase receipt on "+[Purchase_Orders_Job_forms:59]POItemKey:1
							$body:=$body+". Please set the Started date manually so WIP inventory reflects the issue "
							$body:=$body+"by Modifying Job, drilldown to form and set status to WIP."
							$from:=Email_WhoAmI
							distributionList:=Batch_GetDistributionList(""; "ACCTG")
							$subject:="Start Date Not Set for "+[Purchase_Orders_Job_forms:59]JobFormID:2  // Modified by: Mel Bohince (1/31/20) remove the 'Stock Received' misleading subject
							EMAIL_Sender($subject; ""; $body; distributionList; ""; $from; $from)
						End if 
						
						If ([Raw_Materials_Groups:22]Commodity_Code:1=1) | ([Raw_Materials_Groups:22]Commodity_Code:1=20)  // Modified by: Mel Bohince (2/23/16) direct purchase of sheet initiative, (7/22/16 comm 20 added
							$success:=JML_setStockReceivedSheeted([Purchase_Orders_Job_forms:59]JobFormID:2; [Purchase_Orders_Items:12]UM_Arkay_Issue:28)
							If (Not:C34($success))
								//uCancelTran
								$body:="Job Master Log record for "+[Purchase_Orders_Job_forms:59]JobFormID:2+" was locked at the time of Stock receipt. Please set the date manually so schedules show green."
								$from:=Email_WhoAmI
								distributionList:=Batch_GetDistributionList(""; "PROD")
								$subject:="Stock Received Not Set for "+[Purchase_Orders_Job_forms:59]JobFormID:2
								EMAIL_Sender($subject; ""; $body; distributionList; ""; $from; $from)
							End if 
						End if   //comm=1
						
						OS_receivedQty(aRMPONum{$i}+aRMPOItem{$i}; aRMStkQty{$i})
						
						If (Length:C16($fixedCost)=9)  // • mel (11/9/04, 12:01:36)
							CUT NAMED SELECTION:C334([Purchase_Orders_Items:12]; "beforeFixed")
							QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=aRMPONum{$i}+aRMPOItem{$i})
							POI_FixedCostCorrection
							USE NAMED SELECTION:C332("beforeFixed")
						End if 
					End if 
					CLEAR SET:C117("matl")
				End if 
				
			: ($ReceiptType=3)  //expense item   
				MESSAGE:C88(Char:C90(13)+"    creating a r/m xfer")
				RM_XferCreate($i; dDate; $ChargeCode; $Note+" expense item")  //• upr 0235 added third parameter`• 11/6/97 cs 
				MESSAGE:C88(Char:C90(13)+"    updating a po item")
				POI_itemUpdate($i; dDate)  //•051095 upr 1498
				If (Length:C16($fixedCost)=9)  // • mel (11/9/04, 12:01:36)
					CUT NAMED SELECTION:C334([Purchase_Orders_Items:12]; "beforeFixed")
					QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=aRMPONum{$i}+aRMPOItem{$i})
					POI_FixedCostCorrection
					USE NAMED SELECTION:C332("beforeFixed")
				End if 
				
			Else   //no valid receipt type
				uConfirm("Receipt Type could not be determined for "+aRMCode{$i}+". Its receipt was not recorded."; "OK"; "Help")
		End case 
		
	Else 
		BEEP:C151
		ALERT:C41(aRMCode{$i}+" not found, its receipt was not recorded.")
	End if 
	MESSAGE:C88(Char:C90(13)+String:C10(($numToPost-$i))+" More to Post ")
End for 

If (fCnclTrn=True:C214)
	CANCEL TRANSACTION:C241
	BEEP:C151
	ALERT:C41("This transaction has been cancelled!")
Else 
	MESSAGE:C88(Char:C90(13)+"validating")
	VALIDATE TRANSACTION:C240
End if 

CANCEL:C270
CLOSE WINDOW:C154
BEEP:C151
BEEP:C151