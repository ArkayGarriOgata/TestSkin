//%attributes = {}
// Method: BOL_ExecuteShipment --  context is trigger_BOL
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 05/10/07, 16:28:07
// ----------------------------------------------------
// Description
// invoice, relieve inventory, make transactions, update order and release
//This is done in to parts, things that need done for each bin that is involved and things done for each release involved
//this was put in in client server mode
// ----------------------------------------------------
// Modified by: Mel Bohince (9/19/13) a change to the "Convert" button moves to Rama Sleeve bin, so these were being missed
// Modified by: Mel Bohince (5/6/16) send email when there is a 'fail' -- EMAIL_Sender ("Check Shipping.log";"";"failure recorded")
// Modified by: Mel Bohince (5/12/16) don't allow backdating, messes up invoice dates


C_LONGINT:C283($1; $bol_number; $pid; $numElements; $i; invoiceNum; $hit; $0; $error_incountered; error)
C_TEXT:C284($custRefer)

$error_incountered:=0
error:=$error_incountered

If ([Customers_Bills_of_Lading:49]CanBill:35) & (Not:C34([Customers_Bills_of_Lading:49]WasBilled:29))  //do once 
	READ WRITE:C146([Customers_ReleaseSchedules:46])
	READ WRITE:C146([Customers_Order_Lines:41])
	READ WRITE:C146([Finished_Goods_Locations:35])
	READ WRITE:C146([Finished_Goods_Transactions:33])
	READ WRITE:C146([Finished_Goods:26])
	READ WRITE:C146([Job_Forms_Items:44])
	
	//QUERY([Customers_Bills_of_Lading];[Customers_Bills_of_Lading]ShippersNo=$bol_number)
	//If (Records in selection([Customers_Bills_of_Lading])=1)
	//$cust_id:=[Customers_Bills_of_Lading]CustID
	If ([Customers_Bills_of_Lading:49]ShipDate:20<4D_Current_date)  // Modified by: Mel Bohince (5/12/16) don't allow backdating, messes up invoice dates
		[Customers_Bills_of_Lading:49]ShipDate:20:=4D_Current_date
	End if 
	$ship_date:=[Customers_Bills_of_Lading:49]ShipDate:20
	$modified_by:=[Customers_Bills_of_Lading:49]QualityAssur:22
	$bol_number:=[Customers_Bills_of_Lading:49]ShippersNo:1
	
	BOL_ListBox1("restore-from-blob")
	$numElements:=Size of array:C274(aLocation2)
	
	ARRAY TEXT:C222($aTransactionID; $numElements)  //uses rtn of app_GetPrimaryKey
	ARRAY LONGINT:C221($aUniqueReleases; 0)
	ARRAY LONGINT:C221($aTotalShippedAgainstRelease; 0)
	
	utl_Logfile("shipping.log"; "BOL# "+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)+"; Execute Begin "+String:C10($numElements)+" bins")
	
	For ($i; 1; $numElements)
		$hit:=Find in array:C230($aUniqueReleases; aReleases{$i})
		If ($hit=-1)
			APPEND TO ARRAY:C911($aUniqueReleases; aReleases{$i})
			APPEND TO ARRAY:C911($aTotalShippedAgainstRelease; aTotalPicked2{$i})
		Else 
			$aTotalShippedAgainstRelease{$hit}:=$aTotalShippedAgainstRelease{$hit}+aTotalPicked2{$i}
		End if 
		
		$aTransactionID{$i}:=FGX_NewFG_Transaction("Ship"; $ship_date; $modified_by)
		[Finished_Goods_Transactions:33]ProductCode:1:=aCPN2{$i}
		
		[Finished_Goods_Transactions:33]JobNo:4:=Substring:C12(aJobit2{$i}; 1; 5)
		[Finished_Goods_Transactions:33]JobForm:5:=Substring:C12(aJobit2{$i}; 1; 8)
		[Finished_Goods_Transactions:33]JobFormItem:30:=Num:C11(Substring:C12(aJobit2{$i}; 10; 2))
		
		[Finished_Goods_Transactions:33]Location:9:="Customer"
		[Finished_Goods_Transactions:33]viaLocation:11:=aLocation2{$i}
		[Finished_Goods_Transactions:33]LocationFromRecNo:23:=aRecNo2{$i}
		[Finished_Goods_Transactions:33]Qty:6:=aTotalPicked2{$i}
		[Finished_Goods_Transactions:33]Skid_number:29:=aPallet2{$i}
		[Finished_Goods_Transactions:33]ActionTaken:27:="BOL# "+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)
		xMemo:=arValues{$i}
		$orderline:=util_TaggedText("get"; "orderline"; ""; ->xMemo)
		[Finished_Goods_Transactions:33]OrderNo:15:=Substring:C12(util_TaggedText("get"; "orderline"; ""; ->xMemo); 1; 5)
		[Finished_Goods_Transactions:33]OrderItem:16:=$orderline+"/"+String:C10(aReleases{$i})
		[Finished_Goods_Transactions:33]Reason:26:=util_TaggedText("get"; "remark1"; ""; ->xMemo)
		[Finished_Goods_Transactions:33]CustID:12:=util_TaggedText("get"; "cust-id"; ""; ->xMemo)  //can't use BOL's custid, cause it could vary by release if billto/shipto are same
		
		If ([Customers_Bills_of_Lading:49]PayUseFlag:11=1)
			[Finished_Goods_Transactions:33]Location:9:="FG:AV"+FG_Get_PayUse_Bin_Prefix([Customers_Bills_of_Lading:49]ShipTo:3)+"#"+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)
			[Finished_Goods_Transactions:33]XactionType:2:="Move"
		End if 
		
		[Finished_Goods_Transactions:33]CoGSExtended:8:=JIC_Relieve(([Finished_Goods_Transactions:33]CustID:12+":"+[Finished_Goods_Transactions:33]ProductCode:1); [Finished_Goods_Transactions:33]Qty:6; ->[Finished_Goods_Transactions:33]CoGSextendedMatl:32; ->[Finished_Goods_Transactions:33]CoGSextendedLabor:33; ->[Finished_Goods_Transactions:33]CoGSextendedBurden:34)
		[Finished_Goods_Transactions:33]CoGS_M:7:=[Finished_Goods_Transactions:33]CoGSExtended:8/[Finished_Goods_Transactions:33]Qty:6*1000
		
		[Finished_Goods_Transactions:33]PricePerM:19:=ORD_getPricePerM($orderline)
		[Finished_Goods_Transactions:33]ExtendedPrice:20:=[Finished_Goods_Transactions:33]PricePerM:19*[Finished_Goods_Transactions:33]Qty:6/1000
		//[Finished_Goods_Transactions]TransactionFailed set in trigger
		SAVE RECORD:C53([Finished_Goods_Transactions:33])
		///$$$$$$$$$$$$$$
		/// dependence on [Finished_Goods_Transactions]LocationFromRecNo can be a problem if the inventory has been moved with a scanner in the meantime
		///$$$$$$$$$$$$$$
		//bin updated by FG transaction trigger, see FGL_UpdateBinByTransaction ([Finished_Goods_Transactions]LocationFromRecNo)
		$error_incountered:=error
		
		// Modified by: Mel Bohince (9/11/14) issue rama costs to the job when first sent rather than when rama to cust (see below)
		//If (Position("RAMA";[Finished_Goods_Transactions]Location)>0)  //shipped to a Rama warehouse
		//Rama_IssueCostToJob ("freight";[Finished_Goods_Transactions]ProductCode;[Finished_Goods_Transactions]Qty;[Finished_Goods_Transactions]viaLocation;[Finished_Goods_Transactions]SkidTicketNo;[Finished_Goods_Transactions]JobForm;[Finished_Goods_Transactions]XactionDate;[Finished_Goods_Transactions]ActionTaken)
		//End if 
		If (False:C215)  // Modified by: Mel Bohince (1/12/15) do the jobcost issue when first sent to rama
			//If (Position("RAMA";[Finished_Goods_Transactions]viaLocation)>0)  //shipped from a Rama warehouse
			//Rama_IssueCostToJob ("freight";[Finished_Goods_Transactions]ProductCode;[Finished_Goods_Transactions]Qty;[Finished_Goods_Transactions]viaLocation;[Finished_Goods_Transactions]SkidTicketNo;[Finished_Goods_Transactions]JobForm;[Finished_Goods_Transactions]XactionDate;[Finished_Goods_Transactions]ActionTaken)
			//
			//If (Position("GLUED";[Finished_Goods_Transactions]viaLocation)>0)  //glued by rama, ours would just have the bol#
			//Rama_IssueCostToJob ("gluing";[Finished_Goods_Transactions]ProductCode;[Finished_Goods_Transactions]Qty;[Finished_Goods_Transactions]viaLocation;[Finished_Goods_Transactions]SkidTicketNo;[Finished_Goods_Transactions]JobForm;[Finished_Goods_Transactions]XactionDate;[Finished_Goods_Transactions]ActionTaken)
			//End if 
			//  // Modified by: Mel Bohince (9/19/13) a change to the "Convert" button moves to Rama Sleeve bin, so these were being missed
			//If (Position("SLEEVE";[Finished_Goods_Transactions]viaLocation)>0)  //glued by rama, ours would just have the bol#
			//Rama_IssueCostToJob ("gluing";[Finished_Goods_Transactions]ProductCode;[Finished_Goods_Transactions]Qty;[Finished_Goods_Transactions]viaLocation;[Finished_Goods_Transactions]SkidTicketNo;[Finished_Goods_Transactions]JobForm;[Finished_Goods_Transactions]XactionDate;[Finished_Goods_Transactions]ActionTaken)
			//End if 
			//End if 
		End if 
		
		JMI_setOrderItem(aJobit2{$i}; $orderline)
		
		$certified:=RM_isCertified_FSC_orSFI("jobit"; aJobit2{$i})
		If (Length:C16($certified)>0)
			If (Position:C15($certified; [Customers_Bills_of_Lading:49]ChainOfCustody:30)=0)  //◊CHAIN_OF_CUSTODY ` used as a marker to find in database
				[Customers_Bills_of_Lading:49]ChainOfCustody:30:=[Customers_Bills_of_Lading:49]ChainOfCustody:30+$certified
			End if 
		End if 
		
		UNLOAD RECORD:C212([Finished_Goods_Transactions:33])
	End for 
	
	If (TriggerMessage_NoErrors)
		//relieve inventory and post to releases, orderlines
		[Customers_Bills_of_Lading:49]DeclaredValue:33:=0
		utl_Logfile("shipping.log"; "BOL# "+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)+"; Execute "+String:C10(Size of array:C274($aUniqueReleases))+" rels")
		$msg:=""
		For ($i; 1; Size of array:C274($aUniqueReleases))
			//update release and   `invoice in trigger
			utl_Logfile("shipping.log"; "BOL# "+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)+";    Release "+String:C10($aUniqueReleases{$i}))
			$invoice_number:=REL_ReleaseShipped($aTotalShippedAgainstRelease{$i}; $ship_date; $aUniqueReleases{$i}; $modified_by)  //*        Post to the release schedule 
			If ($invoice_number>0)  //else error or b&h
				RELATE MANY:C262([Customers_Bills_of_Lading:49]Manifest:16)
				QUERY SELECTION:C341([Customers_Bills_of_Lading_Manif:181]; [Customers_Bills_of_Lading_Manif:181]Arkay_Release:4=$aUniqueReleases{$i})
				APPLY TO SELECTION:C70([Customers_Bills_of_Lading_Manif:181]; [Customers_Bills_of_Lading_Manif:181]InvoiceNumber:13:=$invoice_number)
				//QUERY SUBRECORDS([Customers_Bills_of_Lading]Manifest;[Customers_Bills_of_Lading]Manifest'Arkay_Release=$aUniqueReleases{$i})
				//APPLY TO SUBSELECTION([Customers_Bills_of_Lading]Manifest;[Customers_Bills_of_Lading]Manifest'InvoiceNumber:=$invoice_number)
				
				$pricePerM:=ORD_getPricePerM([Customers_ReleaseSchedules:46]OrderLine:4)
				If ($pricePerM>0)
					[Customers_Bills_of_Lading:49]DeclaredValue:33:=[Customers_Bills_of_Lading:49]DeclaredValue:33+($pricePerM*($aTotalShippedAgainstRelease{$i}/1000))
				Else 
					utl_Logfile("shipping.log"; "BOL# "+String:C10($bol_number)+"; "+"Release# "+String:C10($aUniqueReleases{$i})+" failed to get a PricePerM")
					EMAIL_Sender("Check Shipping.log"; ""; "failure recorded by BOL_ExecuteShipment line 141"; ""; ""; ""; "mel.bohince@arkay.com")
				End if 
			End if 
			
			If (TriggerMessage_HasErrors)
				$i:=1+Size of array:C274($aUniqueReleases)  //break
			End if 
		End for   //update releases
		[Customers_Bills_of_Lading:49]DeclaredValue:33:=Round:C94([Customers_Bills_of_Lading:49]DeclaredValue:33; 2)
		
		//clean up on any bins that only supplied some of their content
		If (TriggerMessage_NoErrors)
			READ WRITE:C146([Finished_Goods_Locations:35])
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]BOL_Pending:31=[Customers_Bills_of_Lading:49]ShippersNo:1)
			If (Records in selection:C76([Finished_Goods_Locations:35])>0)
				APPLY TO SELECTION:C70([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]BOL_Pending:31:=0)
			End if 
			If (Records in set:C195("LockedSet")>0)
				utl_Logfile("shipping.log"; "PendingBOL# "+String:C10($bol_number)+" Could not be removed from "+String:C10(Records in set:C195("LockedSet"))+"locked bin records")
				EMAIL_Sender("Check Shipping.log"; ""; "failure recorded by BOL_ExecuteShipment line 160"; ""; ""; ""; "mel.bohince@arkay.com")
			End if 
			REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
			
			[Customers_Bills_of_Lading:49]WasBilled:29:=True:C214
			If ([Customers_Bills_of_Lading:49]PayUseFlag:11=0)
				[Customers_Bills_of_Lading:49]Status:32:="BILLED"
			Else 
				[Customers_Bills_of_Lading:49]Status:32:="PAYUSE"
			End if 
			utl_Logfile("shipping.log"; "BOL# "+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)+"; Execute "+"End")
		End if 
	End if 
	REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
	REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
	REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
	REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)
	REDUCE SELECTION:C351([Finished_Goods:26]; 0)
	REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
	
End if   // ([Customers_Bills_of_Lading]WasPrinted) & (Not([Customers_Bills_of_Lading]BOL_Executed))


If ($error_incountered=0)
	If (TriggerMessage_HasErrors)
		$error_incountered:=-16000
	End if 
End if 

$0:=$error_incountered