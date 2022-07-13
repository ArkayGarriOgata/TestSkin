// _______
// Method: [zz_control].FGAdjust.bPost   ( ) ->
//  120996  mBohince
//•121196  mBohince allow final qty instead of delta to be entered
//• 3/26/97 cs upr 1529 confirm open releases if scrapping material
//• 3/27/97 cs set up screen so that only 'Phys Inv' is only reason if this screen
//   is called from PI palette
// Modified by: Mel Bohince (5/25/18) remove cases from wms if deleting skid
// Modified by: Mel Bohince (10/30/19) set kris as default for adj email

C_LONGINT:C283($adjustment; $beforeQty; $wmsDeletes)  //
$wmsDeletes:=0  // Modified by: Mel Bohince (5/25/18) remove cases from wms if deleting skid
Case of 
		//: (rReal1=0)
		//BEEP
		//ALERT("Please enter the new quantity.")
		//GOTO AREA(rReal1)
		//REJECT
		
	: ((sCriterion1=CorektBlank) | (Position:C15("not found"; sCriterion1)>0))
		BEEP:C151
		ALERT:C41("Please enter a valid skid number.")
		GOTO OBJECT:C206(tSkidNumber)
		REJECT:C38
		
	: (sCriterion3="")
		BEEP:C151
		ALERT:C41("Please enter the F/G bin location.")
		GOTO OBJECT:C206(sCriterion3)
		REJECT:C38
		
	: (sCriterion4="")
		BEEP:C151
		If (Not:C34(<>PHYSICAL_INVENORY_IN_PROGRESS))
			ALERT:C41("Please enter the reason for the adjustment.")
		Else 
			ALERT:C41("Please enter the TAG NUMBER for the adjustment.")
		End if 
		GOTO OBJECT:C206(sCriterion4)
		REJECT:C38
		
	: (sCriterion9="")
		BEEP:C151
		ALERT:C41("Please enter an adjustment type.")
		GOTO OBJECT:C206(sCriterion9)
		REJECT:C38
		
	Else 
		//*Validate entries  
		If (<>PHYSICAL_INVENORY_IN_PROGRESS)
			sCriterion4:="TAG#"+sCriterion4
		End if 
		NewWindow(200; 50; 2; -720; "Posting Fg Adjustment")
		MESSAGE:C88("Posting...\r")
		C_BOOLEAN:C305($valid)
		C_TEXT:C284($custId)
		C_TEXT:C284($cpn)
		C_DATE:C307($today)
		$today:=4D_Current_date
		$valid:=True:C214
		//*    Find the Job it record
		$jobForm:=sCriterion5+"."+sCriterion6
		//qryJMI ($jobForm;i1)
		//If (Records in selection([Job_Forms_Items])>0)
		//$cpn:=[Job_Forms_Items]ProductCode
		//$custid:=[Job_Forms_Items]CustId
		
		If ((sCriterion1#CorektBlank) & (sCriterion2#CorektBlank))
			
			$cpn:=sCriterion1
			$custid:=sCriterion2
			
		Else 
			$valid:=False:C215
			BEEP:C151
			uConfirm($jobForm+"."+String:C10(i1; "00")+" is an invalid Job Item."+Char:C90(13)+"Do you wish to create a marker?"; "Create"; "Cancel")
			If (ok=1)  //*       Create the Job it record just for a marker of the missing data
				CREATE RECORD:C68([Job_Forms_Items:44])
				[Job_Forms_Items:44]JobForm:1:=$jobForm
				[Job_Forms_Items:44]ItemNumber:7:=i1
				[Job_Forms_Items:44]ProductCode:3:=Request:C163("Enter the customer's product code:"; "")
				[Job_Forms_Items:44]CustId:15:=Request:C163("Enter the customer's id #:"; "00000")
				//[JobMakesItem]____:=sCriterion3
				//[JobMakesItem]___1:=sCriterion9
				[Job_Forms_Items:44]Qty_Actual:11:=rReal1
				[Job_Forms_Items:44]ModDate:29:=$today
				[Job_Forms_Items:44]ModWho:30:=<>zResp
				[Job_Forms_Items:44]PlnnrWho:34:="ADJU"
				[Job_Forms_Items:44]PlnnrDate:35:=dDate
				[Job_Forms_Items:44]OrderItem:2:="CycleCnt"
				SAVE RECORD:C53([Job_Forms_Items:44])
				$cpn:=[Job_Forms_Items:44]ProductCode:3
				$custid:=[Job_Forms_Items:44]CustId:15
				$valid:=True:C214
			End if 
			
		End if 
		
		//*    Find the f/g record
		MESSAGE:C88("Posting...\r")  //• 11/13/97 cs 
		If ($valid)
			$numRecs:=qryFinishedGood($custid; $cpn)
			If ($numRecs<1)
				$valid:=False:C215
				BEEP:C151
				ALERT:C41("WARNING: Finished good record not found.")
				
			Else 
				//• 3/26/97 cs upr 1529 
				If (sCriterion4="Scrap") | (sCriterion9="Scrap")  //scrapping inventory`• 11/13/97 cs added test for criterion 9
					qryReleases($CustId; $Cpn)  //locate open release(s)
					If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)  //if there are any
						uConfirm("There are open release(s) against this product."+Char:C90(13)+"Do You want to continue scrapping it?")
						$Valid:=(OK=1)
					End if 
				End if 
				
				If ($valid)
					//• 3/26/97 cs upr 1529 end          
					
					//*    Find the bin it record
					If (Records in selection:C76([Finished_Goods_Locations:35])<1)
						CREATE RECORD:C68([Finished_Goods_Locations:35])
						[Finished_Goods_Locations:35]Jobit:33:=sJobit
						[Finished_Goods_Locations:35]JobForm:19:=$jobForm
						[Finished_Goods_Locations:35]JobFormItem:32:=i1
						[Finished_Goods_Locations:35]ProductCode:1:=[Job_Forms_Items:44]ProductCode:3
						[Finished_Goods_Locations:35]Location:2:=sCriterion3
						[Finished_Goods_Locations:35]CustID:16:=[Job_Forms_Items:44]CustId:15
						[Finished_Goods_Locations:35]OrigDate:27:=$today  //•121296  mBohince 
					Else 
						If (Not:C34(fLockNLoad(->[Finished_Goods_Locations:35])))
							$valid:=False:C215
						End if   //locked
						
					End if   //bin
				End if   //Valid,   `• 3/26/97 cs upr 1529 
			End if 
			
		End if   //fg record
		
		If ($valid)
			$adjustment:=rReal1-qtyBeforeAdj
			
			If (rReal1=0)
				If (Not:C34([Finished_Goods_Locations:35]PiDoNotDelete:29))  //• 4/2/97 cs found this might delete locations un intensionally
					DELETE RECORD:C58([Finished_Goods_Locations:35])  // check this routine if a change is needed uChgFGqty
				Else   //• 4/3/97 above Fix stopped the abiltly to zero a location
					[Finished_Goods_Locations:35]QtyOH:9:=rReal1
					[Finished_Goods_Locations:35]AdjQty:12:=$adjustment
					[Finished_Goods_Locations:35]LastCycleDate:8:=dDate
					[Finished_Goods_Locations:35]AdjDate:15:=dDate
					[Finished_Goods_Locations:35]ModDate:21:=$today
					[Finished_Goods_Locations:35]ModWho:22:=<>zResp
					SAVE RECORD:C53([Finished_Goods_Locations:35])
					UNLOAD RECORD:C212([Finished_Goods_Locations:35])
				End if 
				
			Else 
				[Finished_Goods_Locations:35]QtyOH:9:=rReal1
				[Finished_Goods_Locations:35]AdjQty:12:=$adjustment
				[Finished_Goods_Locations:35]AdjTo:13:="set to "+String:C10(rReal1)+" for "+sCriterion4
				[Finished_Goods_Locations:35]LastCycleDate:8:=dDate
				[Finished_Goods_Locations:35]AdjDate:15:=dDate
				[Finished_Goods_Locations:35]AdjBy:14:=<>zResp
				[Finished_Goods_Locations:35]ModDate:21:=$today
				[Finished_Goods_Locations:35]ModWho:22:=<>zResp
				SAVE RECORD:C53([Finished_Goods_Locations:35])
				UNLOAD RECORD:C212([Finished_Goods_Locations:35])
			End if   //not zero
			
			If (Length:C16(tSkidNumber)>0) & (makeSkidDisappear)  // Modified by: Mel Bohince (7/13/16) skid eradication option
				C_OBJECT:C1216($sscc_es)
				$sscc_es:=ds:C1482.WMS_SerializedShippingLabels.query("HumanReadable = :1"; tSkidNumber)  //Modified by: Mel Bohince (4/28/21)
				If ($sscc_es.length=1)
					//remove qty from jobit
					[Job_Forms_Items:44]Qty_Actual:11:=[Job_Forms_Items:44]Qty_Actual:11-qtyBeforeAdj
					SAVE RECORD:C53([Job_Forms_Items:44])
					
					//remove the transactions of this skid, leaving the adjustment transaction
					QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Skid_number:29=tSkidNumber)
					If (Records in selection:C76([Finished_Goods_Transactions:33])>0) & (Records in selection:C76([Finished_Goods_Transactions:33])<10)  // Modified by: Mel Bohince (4/28/21) limit destruction
						util_DeleteSelection(->[Finished_Goods_Transactions:33])
					End if 
					
					$wmsDeletes:=WMS_Delete_Skid(tSkidNumber)  // Modified by: Mel Bohince (5/25/18) remove cases from wms if deleting skid
					
				Else   //can't find the pallet id in the sscc table
					ALERT:C41(tSkidNumber+" doesn't appear to be a valid SSCC pallet id")
				End if 
			End if 
			
			$fgx_id:=FGX_NewFG_Transaction(sCriterion9; dDate; <>zResp)
			[Finished_Goods_Transactions:33]ProductCode:1:=$cpn
			[Finished_Goods_Transactions:33]CustID:12:=$custId  //
			[Finished_Goods_Transactions:33]JobNo:4:=sCriterion5
			[Finished_Goods_Transactions:33]JobForm:5:=$jobForm
			[Finished_Goods_Transactions:33]JobFormItem:30:=i1  //•080495  MLB  UPR 1490
			[Finished_Goods_Transactions:33]Reason:26:=sCriterion4  //subject for reason-used in reporting, sorting, very uniform
			[Finished_Goods_Transactions:33]Qty:6:=$adjustment
			[Finished_Goods_Transactions:33]Location:9:=sCriterion3
			[Finished_Goods_Transactions:33]viaLocation:11:="CYCLE CNT"
			[Finished_Goods_Transactions:33]FG_Classification:22:=[Finished_Goods:26]ClassOrType:28
			[Finished_Goods_Transactions:33]CoGS_M:7:=[Job_Forms_Items:44]PldCostTotal:21
			[Finished_Goods_Transactions:33]CoGSExtended:8:=uNANCheck(Round:C94(($adjustment/1000)*[Job_Forms_Items:44]PldCostTotal:21*(Num:C11(Not:C34([Finished_Goods_Transactions:33]SkipTrigger:14))); 2))
			[Finished_Goods_Transactions:33]Skid_number:29:=tSkidNumber
			If ($wmsDeletes>0)
				[Finished_Goods_Transactions:33]ActionTaken:27:=String:C10($wmsDeletes)+" cases removed from wms"
			End if 
			SAVE RECORD:C53([Finished_Goods_Transactions:33])  //*. SAVE THE TRANSACTION  
			
			UNLOAD RECORD:C212([Finished_Goods_Transactions:33])
			UNLOAD RECORD:C212([Job_Forms_Items:44])
			UNLOAD RECORD:C212([Finished_Goods_Transactions:33])
			sCriterion1:="Adjustment posted"
			
			$subject:=sCriterion1+" notification for "+$cpn
			C_TEXT:C284(distributionList)
			distributionList:=""
			C_TEXT:C284(plannerOnRecord)
			// Modified by: Mel Bohince (10/30/19) set kris as default
			plannerOnRecord:="KK"  //"jek"  //"joan.kepko@arkay.com"
			READ ONLY:C145([Customers:16])
			QUERY:C277([Customers:16]; [Customers:16]ID:1=$custId)
			If (Records in selection:C76([Customers:16])>0)
				plannerOnRecord:=[Customers:16]PlannerID:5
				custServiceRep:=[Customers:16]CustomerService:46
			End if 
			QUERY:C277([Users:5]; [Users:5]Initials:1=plannerOnRecord)
			If (Records in selection:C76([Users:5])>0)
				$planner:=Email_WhoAmI([Users:5]UserName:11)+Char:C90(9)
				If (Position:C15($planner; distributionList)=0)
					distributionList:=distributionList+$planner
				End if 
			End if 
			QUERY:C277([Users:5]; [Users:5]Initials:1=custServiceRep)  //• mlb - 2/21/02  11:34
			If (Records in selection:C76([Users:5])>0)
				$planner:=Email_WhoAmI([Users:5]UserName:11)+Char:C90(9)
				If (Position:C15($planner; distributionList)=0)
					distributionList:=distributionList+$planner
				End if 
			End if 
			
			If (Not:C34(<>PHYSICAL_INVENORY_IN_PROGRESS))
				// Modified by: Mel Bohince (4/7/16) don't send to acctg
				//distributionList:=distributionList+Batch_GetDistributionList ("";"ACCTG")
			End if 
			$body:=String:C10($adjustment; "###,###,##0")+" unit adjustment posted to jobit: "+JMI_makeJobIt($jobForm; i1)+" in bin "+sCriterion3+Char:C90(13)
			$body:=$body
			$from:=Email_WhoAmI
			$subject:=$subject+" of "+[Finished_Goods_Specifications:98]ProductCode:3+" "+[Customers:16]Name:2
			EMAIL_Sender($subject; ""; $body; distributionList; ""; $from; $from)
			zwStatusMsg("EMail"; "Adjustment Notification has been sent to "+distributionList)
			
		Else 
			BEEP:C151
			REJECT:C38
			sCriterion1:="Adjustment rejected"
		End if 
		
		sJobit:=""
		tSkidNumber:=""  // Modified by: Mel Bohince (12/3/15) added
		sCriterion1:=""
		sCriterion2:=""
		sCriterion3:=""
		sCriterion4:="CycleCnt"
		sCriterion5:=""
		sCriterion6:=""
		sCriterion9:="Adjust"
		i1:=0
		rReal1:=0
		wms_number_cases:=0
		qtyBeforeAdj:=0
		makeSkidDisappear:=False:C215
		GOTO OBJECT:C206(sJobit)
End case 

//
//EOS