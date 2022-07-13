//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 08/18/09, 17:20:56
// -----------------------------------------$pending_-----------
// Method: EDI_Map_EDIFACT_Order
// Description
// convert back to code based from the table driven mapping of edirk
//using loaded arrays:$numberOfSegments:=$cursor-1
//   ARRAY TEXT(aEDI_Tag;$numberOfSegments)
//     ARRAY TEXT(aEDI_Elements;$numberOfSegments)
// Parameters
//8/12/12 mlb  -- when multi LIN's then first release isn't saved
// Modified by: Mel Bohince (10/2/12) when LIN doesn't have a cpn specified
// Modified by: Mel Bohince (12/26/12) remove BP0 prefix when Ovel
// Modified by: Mel Bohince (4/10/13) test for release existence by po rather than orderline#, and move creation to RFF tag, also save orig code to EDI_Map_EDIFACT_Order_orig

//typical structure  
//UNB+UNOA:1+6315311578:12:6315311578+001635622:01:001635622+130312:0401+00000000063025++ORDERS+A'
//UNH+00000000029758+ORDERS:91:1:UN:EDIFCT'
//BGM+105+4500509364+9'
//DTM+4:130311:101'
//NAD+SU+0010011470::92+ARKAY PACKAGING CORP'
//NAD+BY+5411111000017::92+Estee Lauder Oevel BELGIUM'
//CTA+OC+0AA:Buyens Nancy'
//NAD+ST+30201000::92+Oevel Manufacturing:NIJVERHEIDSTRAAT 15:OEVEL, NA 2260 BE'
//PAT+ZZ+6:::Within 30 days due net'
//TDT+20++++SSI'
//TOD+1++EXW::::HAUPPAGE,US'
// UNS+D'
//  LIN+10+1+60QH01011E'
//  IMD+++DESC:::FOLDING CARTON SUPERBAL-'
//  QTY+21:133900:PCE'
//  MOA+146:0.056:USD:9'
//  SCC+9'
//  FTX+CUR'
//    RFF+RE:001'
//    QTY+1:133900:PCE'
//    DTM+2:130619:101'
//  UNS+S'
// UNT+22+00000000029758'
//UNZ+1+00000000063025'
// ----------------------------------------------------

C_BOOLEAN:C305(save_log_file; $ok_to_save; $_cancel_orderline)  //change this to an option, default false
C_REAL:C285($price)
C_BOOLEAN:C305($inHeader; changeOrderOpened; $new_release)  //keep track of the level on indent
C_TEXT:C284(sCPN)
C_LONGINT:C283($0; $numberOfSegments)
C_TEXT:C284($r)

save_log_file:=False:C215
$ok_to_save:=True:C214  //if the LIN segment refers to a line# 0, don't save
$0:=-99999
$r:=Char:C90(13)
sCPN:=""
$numberOfSegments:=Size of array:C274(aEDI_Tag)

uThermoInit($numberOfSegments; "Verifing Section Controls")

For ($segment; 1; $numberOfSegments)
	$errMsg:=util_TextParser(7; aEDI_Elements{$segment}; iElementDelimitor; iSegmentDelimitor)
	$tag:=aEDI_Tag{$segment}
	If (save_log_file)
		utl_Logfile("EDI_MAPPING"; (aEDI_Tag{$segment}+"+"+aEDI_Elements{$segment}))
	End if 
	Case of 
		: ($tag="UNB")
			$_ICN:=util_TextParser(5)
			$message_type:=util_TextParser(7)
			$_Msg_Date:=util_TextParser(4)
			
		: ($tag="UNH")
			$_GCN:=util_TextParser(1)
			
		: ($tag="BGM")
			$inHeader:=True:C214
			$ok_to_save:=True:C214
			changeOrderOpened:=False:C215  //used by cco_set_change_order_type
			$_PO:=util_TextParser(2)
			$limitor:=Add to date:C393(4D_Current_date; 0; -6; 0)
			$_order_comments:=""  //get all the comments then prepend to any existing comments
			QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]PONumber:11=$_PO; *)
			QUERY:C277([Customers_Orders:40];  & ; [Customers_Orders:40]Status:10#"Cancel"; *)
			QUERY:C277([Customers_Orders:40];  & ; [Customers_Orders:40]DateOpened:6>$limitor)
			//QUERY([Customers_Orders]; & ;[Customers_Orders]Senders_EDI_ID=$_PO)
			If (Records in selection:C76([Customers_Orders:40])=0)
				QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]PONumber:11="BP0"+$_PO)  //havent seen the NAD BY yet, so could be
			End if 
			
			//If (Records in selection([Customers_Orders])=0)
			//QUERY([Customers_Orders];[Customers_Orders]PONumber="BR0"+$_PO)  //old edirk style po
			//End if 
			
			If (Records in selection:C76([Customers_Orders:40])=0)
				CREATE RECORD:C68([Customers_Orders:40])  //see ORD_NewOrder
				C_TEXT:C284($server)
				$server:="?"
				app_getNextID(Table:C252(->[Customers_Orders:40]); ->$server; ->vord)
				[Customers_Orders:40]OrderNumber:1:=vord
				[Customers_Orders:40]edi_status:58:="NEW"
				[Customers_Orders:40]Status:10:="CONTRACT"
				If (save_log_file)
					utl_Logfile("EDI_MAPPING"; "#### NEW ORDER "+String:C10(vord)+" ####")
				End if 
				[Customers_Orders:40]DateOpened:6:=util_dateFromYYYYMMDD(Substring:C12($_Msg_Date; 1; 6))
				[Customers_Orders:40]EnteredBy:7:=<>zResp
				[Customers_Orders:40]PONumber:11:=$_PO
			Else 
				[Customers_Orders:40]edi_status:58:="CHANGE"
				If (save_log_file)
					utl_Logfile("EDI_MAPPING"; "#### CHG ORDER "+String:C10([Customers_Orders:40]OrderNumber:1)+" ####")
				End if 
			End if 
			[Customers_Orders:40]edi_sender_id:57:=Senders_ID
			[Customers_Orders:40]ModWho:8:=<>zResp
			[Customers_Orders:40]ModDate:9:=4D_Current_date
			[Customers_Orders:40]edi_response_code:59:=29  // 34 for change, verified in EDI_send_reponse
			[Customers_Orders:40]edi_ICN:56:=$_ICN  //only keep the freshest one, put history in comments
			$_order_comments:=$_order_comments+$_ICN+":"+$_Msg_Date+"*"+Char:C90(13)
			
			$_OrderType:=util_TextParser(1)
			Case of 
				: ($_OrderType="105")  //"Purchase Order"
					$_order_comments:=$_order_comments+" Purchase Order "
				: ($_OrderType="315")  //Contract
					$_order_comments:=$_order_comments+" Contract "
				: ($_OrderType="245")  //Delivery Release
					$_order_comments:=$_order_comments+" Delivery Release "
				: ($_OrderType="226")  //Call-Off
					$_order_comments:=$_order_comments+" Call-Off "
			End case 
			$_order_comments:=$_order_comments+" - "
			
			If (tPartnerName="Estee Lauder Belg")
				$_OrderStatus:=util_TextParser(4)
				[Customers_Orders:40]DateOpened:6:=util_dateFromYYYYMMDD(util_TextParser(3))
			Else 
				$_OrderStatus:=util_TextParser(3)
			End if 
			
			Case of 
				: ($_OrderStatus="4")  //Change
					$_order_comments:=$_order_comments+" Change"
					//gNewCustOrdCO ($_ICN)  ` make a change order
					changeOrderOpened:=True:C214  //used by cco_set_change_order_type
					
				: ($_OrderStatus="9")  //Original
					$_order_comments:=$_order_comments+" Original "
			End case 
			
		: ($tag="DTM") & ($inHeader)
			$errMsg:=util_TextParser(3; util_TextParser(1); iSubElementDelimitor; iSegmentDelimitor)
			[Customers_Orders:40]DateOpened:6:=util_dateFromYYYYMMDD(util_TextParser(2))
			
		: ($tag="DTM") & (Not:C34($inHeader)) & (Length:C16(sCPN)>0)
			If (Senders_ID="BEESL.ESL001")
				If ($new_order_line)
					[Customers_Order_Lines:41]NeedDate:14:=util_dateFromYYYYMMDD(util_TextParser(2))
				End if 
				[Customers_Order_Lines:41]edi_dock_date:64:=util_dateFromYYYYMMDD(util_TextParser(2))
			Else 
				$errMsg:=util_TextParser(3; util_TextParser(1); iSubElementDelimitor; iSegmentDelimitor)
				If ($new_order_line)
					[Customers_Order_Lines:41]NeedDate:14:=util_dateFromYYYYMMDD(util_TextParser(2))
				End if 
				[Customers_Order_Lines:41]edi_dock_date:64:=util_dateFromYYYYMMDD(util_TextParser(2))
			End if 
			//cco_set_change_order_type (->[Customers_Order_Lines]edi_dock_date;->[Customers_Order_Lines]NeedDate;->[Customers_Order_Change_Orders]ReleaseDate)
			
			If ($new_release)
				$lead_time_in_days:=ADDR_getLeadTime([Customers_Order_Lines:41]defaultShipTo:17)
				$release_date:=[Customers_Order_Lines:41]NeedDate:14-$lead_time_in_days
				[Customers_ReleaseSchedules:46]Sched_Date:5:=$release_date
				[Customers_ReleaseSchedules:46]Promise_Date:32:=[Customers_Order_Lines:41]NeedDate:14
			End if 
			
			If (True:C214)  //8/12/12 when multi LIN's then first release isn't saved
				SAVE RECORD:C53([Customers_ReleaseSchedules:46])
				SAVE RECORD:C53([Customers_Order_Lines:41])
				[Customers_Orders:40]Comments:15:=$_order_comments+Char:C90(13)+"+++"+Char:C90(13)+[Customers_Orders:40]Comments:15
				SAVE RECORD:C53([Customers_Orders:40])
			End if 
			
		: ($tag="NAD")  //NAD+ST+3530::92+UK HUB:Fulfood Road:Havant, HA PO0 5AX GB'
			$_Qualifier:=util_TextParser(1)  //ST
			$el_addree_id:=util_TextParser(2)  //3530::92
			$address_name:=util_TextParser(3)  //UK HUB:Fulfood Road:Havant, HA PO0 5AX GB
			$_order_comments:=$_order_comments+aEDI_Elements{$segment}
			$errMsg:=util_TextParser(3; $el_addree_id; iSubElementDelimitor; iSegmentDelimitor)
			$lauder_id:=util_TextParser(1)  //3530
			aMs_address_id:=ADDR_CrossIndexLauder("GET_AMS"; $lauder_id)
			If (aMs_address_id="n/f")  //create it
				aMs_address_id:=ADDR_CrossIndexLauder("GET_SPL"; $lauder_id; $address_name)
			End if 
			
			Case of 
				: ($_Qualifier="BY")  //BillTo ->NAD+BY+5411111000033::92+Estee Lauder Whitman UK
					//cco_set_change_order_type (->aMs_address_id;->[Customers_Orders]defaultBillTo;->[Customers_Order_Change_Orders]BillTo)
					[Customers_Orders:40]defaultBillTo:5:=aMs_address_id
					[Customers_Orders:40]defaultShipto:40:=aMs_address_id
					[Customers_Orders:40]edi_BillTo_text:60:=Replace string:C233(aEDI_Elements{$segment}; "BY+"; "")
					[Customers_Orders:40]edi_ShipTo_text:61:=Replace string:C233(aEDI_Elements{$segment}; "BY+"; "")  //from OEVEL` Modified by: mel (12/7/09)
					// Modified by: Mel Bohince (12/26/12)
					//If (Position("OEVEL";[Customers_Orders]edi_ShipTo_text)>0)
					//$_PO:="BP0"+$_PO
					//[Customers_Orders]PONumber:=$_PO
					//End if 
				: ($_Qualifier="ST")  //ShipTo ->NAD+ST+3530::92+UK HUB:Fulfood Road:Havant, HA PO0 5AX GB
					//cco_set_change_order_type (->aMs_address_id;->[Customers_Orders]defaultShipto;->[Customers_Order_Change_Orders]ShipTo)
					[Customers_Orders:40]edi_ShipTo_text:61:=Replace string:C233(aEDI_Elements{$segment}; "ST+"; "")
					//If (Position($lauder_id;" 1550 or 1560 ")=0)  `normal shipto
					[Customers_Orders:40]defaultShipto:40:=aMs_address_id
					//Else   `special case where text of shipto if important going to 3rd party
					//[Customers_Orders]defaultShipto:=ADDR_CrossIndexLauder ("GET_SPL";$lauder_id;$address_name)
					//End if 
					
				: ($_Qualifier="IV")  //Invoice To
					[Customers_Orders:40]defaultBillTo:5:=aMs_address_id
					[Customers_Orders:40]edi_BillTo_text:60:=Replace string:C233(aEDI_Elements{$segment}; "IV+"; "")  // Modified by: mel (12/7/09)
				: ($_Qualifier="FW")  //Instructions
				: ($_Qualifier="SU")  //Supplier ->NAD+SU+0010011470::92+ARKAY PACKAGING CORP
					If (Position:C15("arkay"; $address_name)=0)
						uConfirm($_ICN+" Looks like this order isn't for Arkay! "+aEDI_Elements{$segment}; "Call EL"; "Help")
					End if 
				: ($_Qualifier="SE")
					If (Position:C15("arkay"; $address_name)=0)
						uConfirm($_ICN+" Looks like this order isn't for Arkay! "+aEDI_Elements{$segment}; "Call EL"; "Help")
					End if 
			End case 
			
		: ($tag="UNS")
			Case of 
				: (util_TextParser(1)="D")
					$inHeader:=False:C215
					
				: (util_TextParser(1)="S")
					$inHeader:=True:C214
					If ($ok_to_save)
						SAVE RECORD:C53([Customers_ReleaseSchedules:46])
						SAVE RECORD:C53([Customers_Order_Lines:41])
						[Customers_Orders:40]Comments:15:=$_order_comments+Char:C90(13)+"+++"+Char:C90(13)+[Customers_Orders:40]Comments:15
						SAVE RECORD:C53([Customers_Orders:40])
					End if 
			End case 
			
		: ($tag="LIN")
			$_cancel_orderline:=False:C215
			$line_item:=Num:C11(util_TextParser(1))
			If ($line_item=0)
				$ok_to_save:=False:C215
			End if 
			Case of 
				: (Senders_ID="5164547103")
					$_PO_Item:=String:C10($line_item; "00")
				: (Senders_ID="BEESL.ESL001")
					$_PO_Item:=String:C10($line_item; "000")
				: (Senders_ID="6315311578")
					$_PO_Item:=String:C10($line_item; "00000")
					$line_item:=$line_item/10
				Else 
					$_PO_Item:=String:C10($line_item; "00000")
			End case 
			
			$_RequestCode:=util_TextParser(2)
			$_request_text:=""
			[Customers_Orders:40]edi_response_code:59:=Num:C11($_RequestCode)  //`this look misplaced????
			Case of 
				: ($_RequestCode="1")  //Add
					$_order_comments:=$_order_comments+" EDI Add Line "+String:C10($line_item)
					$_request_text:=" Add"
					//cco_set_change_order_type (->[Customers_Order_Change_Orders]AddOrDeleteItem)
					
				: ($_RequestCode="2")  //Omit
					$_cancel_orderline:=True:C214
					$_order_comments:=$_order_comments+" EDI Omit Line "+String:C10($line_item)
					$_request_text:=" Omit"
					//cco_set_change_order_type (->[Customers_Order_Change_Orders]AddOrDeleteItem)
				: ($_RequestCode="3")  //Change
					$_order_comments:=$_order_comments+" EDI Chg Line "+String:C10($line_item)
					$_request_text:=" Change"
					//cco_set_change_order_type (->[Customers_Order_Change_Orders]ContinueWith)
				: ($_RequestCode="4")  //Same
					$_order_comments:=$_order_comments+" EDI Same Line "+String:C10($line_item)
					$_request_text:=" Same"
					//cco_set_change_order_type (->[Customers_Order_Change_Orders]ContinueWithout)
			End case 
			
			$cpn:=util_TextParser(3)
			If (Senders_ID="BEESL.ESL001")
				$cpn:=Replace string:C233($cpn; ":IN"; "")
			End if 
			sCPN:=ELC_CPN_Format($cpn)
			
			// Modified by: Mel Bohince (10/2/12)
			If (Length:C16(sCPN)>0)  //EL User error: The event occurs when the planner adds TEXT at the header level and does not change anything in the detail.
				
				$orderline:=fMakeOLkey([Customers_Orders:40]OrderNumber:1; $line_item)
				//QUERY([Customers_Order_Lines];[Customers_Order_Lines]OrderLine=$orderline)
				//If (Records in selection([Customers_Order_Lines])=0)  // Modified by: mel (12/10/09)
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]PONumber:21=($_PO+"."+$_PO_Item); *)
				QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Cancel")
				//End if 
				If (Records in selection:C76([Customers_Order_Lines:41])=0)
					CREATE RECORD:C68([Customers_Order_Lines:41])  //see ORD_AddItemRegular
					[Customers_Order_Lines:41]OrderNumber:1:=[Customers_Orders:40]OrderNumber:1
					[Customers_Order_Lines:41]LineItem:2:=$line_item
					[Customers_Order_Lines:41]OrderLine:3:=$orderline
					[Customers_Order_Lines:41]PONumber:21:=[Customers_Orders:40]PONumber:11+"."+$_PO_Item
					[Customers_Order_Lines:41]Status:9:="CONTRACT"
					[Customers_Order_Lines:41]edi_line_status:55:="New"+$_request_text
					[Customers_Order_Lines:41]edi_orig_line_status:61:=[Customers_Order_Lines:41]edi_line_status:55
					[Customers_Order_Lines:41]DateOpened:13:=[Customers_Orders:40]DateOpened:6
					$new_order_line:=True:C214
				Else 
					$new_order_line:=False:C215
					[Customers_Order_Lines:41]edi_line_status:55:="Change"+$_request_text
					[Customers_Order_Lines:41]edi_orig_line_status:61:=[Customers_Order_Lines:41]edi_line_status:55
					If ([Customers_Order_Lines:41]DateOpened:13=!00-00-00!)
						[Customers_Order_Lines:41]DateOpened:13:=[Customers_Orders:40]DateOpened:6
					End if 
				End if 
				[Customers_Order_Lines:41]edi_ICN:67:=$_ICN
				[Customers_Order_Lines:41]edi_response_code:62:=5  //assuming acceptance
				
				[Customers_Order_Lines:41]ProductCode:5:=sCPN
				$num_FG:=qryFinishedGood("#CPN"; sCPN)
				If ($num_FG=0)
					$pending_cust:="?EDI?"
					$pending_Salesman:="gG"
					If (save_log_file)
						utl_Logfile("EDI_MAPPING"; "##### "+sCPN+" NEEDS TO BE ENTERED #####")
					End if 
					uConfirm("You need to create F/G record for "+sCPN+" on Pjt Screen, check logfile."; "Continue"; "Help")
					
				End if 
				
				If ($num_FG>0)  //see also button on fg.input "Update EDI ORders" **********
					[Customers_Order_Lines:41]CustID:4:=[Finished_Goods:26]CustID:2
					[Customers_Order_Lines:41]Classification:29:=[Finished_Goods:26]ClassOrType:28
					[Customers_Order_Lines:41]OrderType:22:=[Finished_Goods:26]OrderType:59
					[Customers_Order_Lines:41]CustomerLine:42:=[Finished_Goods:26]Line_Brand:15
					[Customers_Order_Lines:41]Price_Per_M:8:=[Finished_Goods:26]RKContractPrice:49
					READ ONLY:C145([Customers:16])
					SET QUERY LIMIT:C395(1)
					QUERY:C277([Customers:16]; [Customers:16]ID:1=[Customers_Order_Lines:41]CustID:4)
					[Customers_Order_Lines:41]CustomerName:24:=[Customers:16]Name:2  //CUST_getName ([Customers_Order_Lines]CustID)
					If ([Customers_Order_Lines:41]OrderType:22="Promotional")
						[Customers_Order_Lines:41]OverRun:25:=[Customers:16]Run_Over_Promo_Order:65
						[Customers_Order_Lines:41]UnderRun:26:=[Customers:16]Run_Under_Promo_Order:66
					Else 
						[Customers_Order_Lines:41]OverRun:25:=[Customers:16]Run_Over_Regular_Order:63
						[Customers_Order_Lines:41]UnderRun:26:=[Customers:16]Run_Under_Regular_Order:64
					End if 
					[Customers_Order_Lines:41]ProjectNumber:50:=[Finished_Goods:26]ProjectNumber:82
					//take care of the header info
					[Customers_Orders:40]ProjectNumber:53:=[Customers_Order_Lines:41]ProjectNumber:50
					[Customers_Orders:40]CustID:2:=[Customers_Order_Lines:41]CustID:4
					[Customers_Orders:40]CustomerName:39:=[Customers_Order_Lines:41]CustomerName:24
					[Customers_Orders:40]CustomerLine:22:=[Customers_Order_Lines:41]CustomerLine:42
					[Customers_Orders:40]CustomerService:47:=[Customers:16]CustomerService:46
					[Customers_Orders:40]PlannedBy:30:=[Customers:16]PlannerID:5
					[Customers_Orders:40]SalesCoord:46:=[Customers:16]SalesCoord:45
					[Customers_Orders:40]SalesRep:13:=[Customers:16]SalesmanID:3
					[Customers_Order_Lines:41]SalesRep:34:=[Customers:16]SalesmanID:3
					SET QUERY LIMIT:C395(0)
					REDUCE SELECTION:C351([Customers:16]; 0)
					
				Else   //no fg to go by
					[Customers_Orders:40]SalesRep:13:=$pending_Salesman
					[Customers_Order_Lines:41]SalesRep:34:=$pending_Salesman
					[Customers_Order_Lines:41]CustID:4:=$pending_cust
					[Customers_Orders:40]CustID:2:=$pending_cust
				End if 
				
				[Customers_Order_Lines:41]defaultBillto:23:=[Customers_Orders:40]defaultBillTo:5
				If ($new_order_line) | (Length:C16([Customers_Order_Lines:41]defaultShipTo:17)<5)
					[Customers_Order_Lines:41]defaultShipTo:17:=[Customers_Orders:40]defaultShipto:40
				End if 
				[Customers_Order_Lines:41]edi_shipto:63:=[Customers_Orders:40]defaultShipto:40
				[Customers_Order_Lines:41]edi_arkay_planner:68:=[Customers_Orders:40]PlannedBy:30  //to make search easier
				
				If (Senders_ID="BEESL.ESL001")  //shouldn't happen anymore
					$qty_element:=util_TextParser(5)
					$price_element:=util_TextParser(6)
					$errMsg:=util_TextParser
					$errMsg:=util_TextParser(3; $qty_element; iSubElementDelimitor; iSegmentDelimitor)
					$_UOM:=util_TextParser(3)
					If ($new_order_line)
						[Customers_Order_Lines:41]Quantity:6:=Num:C11(util_TextParser(2))
						[Customers_Order_Lines:41]Qty_Open:11:=[Customers_Order_Lines:41]Quantity:6  //-[Customers_Order_Lines]Qty_Shipped+[Customers_Order_Lines]Qty_Returned
					End if 
					[Customers_Order_Lines:41]edi_quantity:65:=Num:C11(util_TextParser(2))
					//cco_set_change_order_type (->[Customers_Order_Lines]edi_quantity;->[Customers_Order_Lines]Quantity;->[Customers_Order_Change_Orders]QtyChg)
					
					If ($new_release)
						[Customers_ReleaseSchedules:46]Sched_Qty:6:=[Customers_Order_Lines:41]Qty_Open:11
						[Customers_ReleaseSchedules:46]OpenQty:16:=[Customers_ReleaseSchedules:46]Sched_Qty:6
					End if 
					
					[Customers_ReleaseSchedules:46]CustomerRefer:3:=[Customers_Orders:40]PONumber:11+".001"
					
					$errMsg:=util_TextParser
					$errMsg:=util_TextParser(4; $price_element; iSubElementDelimitor; iSegmentDelimitor)
					$_UOM:=util_TextParser(4)
					[Customers_Order_Lines:41]edi_UOM_price:57:=$_UOM
					$price:=Num:C11(util_TextParser(1))
					If ($_UOM#"MIL")
						$price:=$price*1000
					End if 
					//If ($new_order_line)
					//[Customers_Order_Lines]Price_Per_M:=$price
					//End if 
					[Customers_Order_Lines:41]edi_price:66:=$price
					//cco_set_change_order_type (->[Customers_Order_Lines]edi_price;->[Customers_Order_Lines]Price_Per_M;->[Customers_Order_Change_Orders]PriceChg)
				End if   //beesl
				
			End if   //cpn specified
			
		: ($tag="IMD")
			//$_Desc:="description" in util_TextParser (3;4), but not needed for orderline
			
		: ($tag="QTY") & (Length:C16(sCPN)>0)
			$errMsg:=util_TextParser(3; util_TextParser(1); iSubElementDelimitor; iSegmentDelimitor)
			[Customers_Order_Lines:41]edi_UOM_qty:56:=util_TextParser(3)
			If ($new_order_line)
				[Customers_Order_Lines:41]Quantity:6:=Num:C11(util_TextParser(2))
				[Customers_Order_Lines:41]Qty_Open:11:=[Customers_Order_Lines:41]Quantity:6
			End if 
			[Customers_Order_Lines:41]edi_quantity:65:=Num:C11(util_TextParser(2))
			If ($_cancel_orderline)
				[Customers_Order_Lines:41]edi_omit_flag:69:="CANCEL"
			Else 
				[Customers_Order_Lines:41]edi_omit_flag:69:=""
			End if 
			//cco_set_change_order_type (->[Customers_Order_Lines]edi_quantity;->[Customers_Order_Lines]Quantity;->[Customers_Order_Change_Orders]QtyChg)
			If ($new_release)
				[Customers_ReleaseSchedules:46]Sched_Qty:6:=[Customers_Order_Lines:41]Qty_Open:11
				[Customers_ReleaseSchedules:46]OpenQty:16:=[Customers_ReleaseSchedules:46]Sched_Qty:6
			End if 
			
		: ($tag="MOA") & (Length:C16(sCPN)>0)
			$errMsg:=util_TextParser(4; util_TextParser(1); iSubElementDelimitor; iSegmentDelimitor)
			[Customers_Order_Lines:41]edi_UOM_price:57:=util_TextParser(1)
			$price:=Num:C11(util_TextParser(2))
			If ([Customers_Order_Lines:41]edi_UOM_price:57="146") | ([Customers_Order_Lines:41]edi_UOM_price:57="MIL")
				$price:=$price*1000
			End if 
			//If ($new_order_line)
			//[Customers_Order_Lines]Price_Per_M:=$price
			//End if 
			[Customers_Order_Lines:41]edi_price:66:=$price
			//cco_set_change_order_type (->[Customers_Order_Lines]edi_price;->[Customers_Order_Lines]Price_Per_M;->[Customers_Order_Change_Orders]PriceChg)
			
		: ($tag="SCC")
			//nothing worthy
			
		: ($tag="FTX") & ($inHeader)
			$_order_comments:=$_order_comments+util_TextParser(4)+Char:C90(13)
			
		: ($tag="FTX") & (Not:C34($inHeader)) & (Length:C16(sCPN)>0)
			[Customers_Order_Lines:41]edi_FreeText2:59:=util_TextParser(1)+": "+util_TextParser(4)
			[Customers_Order_Lines:41]edi_FreeText2:59:=Replace string:C233([Customers_Order_Lines:41]edi_FreeText2:59; "CUR: DOCK"; "")
			
		: ($tag="RFF") & (Length:C16(sCPN)>0)
			$errMsg:=util_TextParser(2; util_TextParser(1); iSubElementDelimitor; iSegmentDelimitor)
			$_Release:=String:C10(Num:C11(util_TextParser(2)); "000")
			$_cust_refer:=[Customers_Order_Lines:41]PONumber:21+"."+$_Release
			
			//***
			//*** RELEASE TEST *** try YJCH-01-0111 and YJCH-01-1111
			//***
			//use an existing release if possible
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3=$_cust_refer)
			Case of 
				: (Records in selection:C76([Customers_ReleaseSchedules:46])=0)
					$new_release:=True:C214
					CREATE RECORD:C68([Customers_ReleaseSchedules:46])
					[Customers_ReleaseSchedules:46]ReleaseNumber:1:=app_AutoIncrement(->[Customers_ReleaseSchedules:46])
					
				: (Records in selection:C76([Customers_ReleaseSchedules:46])>1)
					$new_release:=False:C215
					$push_rel:=Record number:C243([Customers_ReleaseSchedules:46])
					QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=[Customers_Order_Lines:41]OrderLine:3)
					If (Records in selection:C76([Customers_ReleaseSchedules:46])=0)
						GOTO RECORD:C242([Customers_ReleaseSchedules:46]; $push_rel)
					End if 
					$push_rel:=-3
					
				Else 
					$new_release:=False:C215
			End case 
			
			[Customers_ReleaseSchedules:46]CustomerRefer:3:=$_cust_refer
			[Customers_ReleaseSchedules:46]OrderNumber:2:=[Customers_Order_Lines:41]OrderNumber:1
			[Customers_ReleaseSchedules:46]OrderLine:4:=[Customers_Order_Lines:41]OrderLine:3
			[Customers_ReleaseSchedules:46]Shipto:10:=[Customers_Order_Lines:41]defaultShipTo:17
			[Customers_ReleaseSchedules:46]Billto:22:=[Customers_Order_Lines:41]defaultBillto:23
			[Customers_ReleaseSchedules:46]ProductCode:11:=[Customers_Order_Lines:41]ProductCode:5
			[Customers_ReleaseSchedules:46]CustID:12:=[Customers_Order_Lines:41]CustID:4
			[Customers_ReleaseSchedules:46]CustomerLine:28:=[Customers_Order_Lines:41]CustomerLine:42  //•060295  MLB  UPR 184
			[Customers_ReleaseSchedules:46]PayU:31:=0
			[Customers_ReleaseSchedules:46]Entered_Date:34:=4D_Current_date
			[Customers_ReleaseSchedules:46]THC_State:39:=9  //•102297  MLB  was, -4, chg so it show up as not being processed yet
			[Customers_ReleaseSchedules:46]ProjectNumber:40:=[Customers_Order_Lines:41]ProjectNumber:50  //•5/04/00  mlb 
			[Customers_ReleaseSchedules:46]ChangeLog:23:=$_order_comments+[Customers_ReleaseSchedules:46]ChangeLog:23
			[Customers_ReleaseSchedules:46]ModDate:18:=4D_Current_date
			[Customers_ReleaseSchedules:46]ModWho:19:=<>zResp
			// SAVE RECORD([Customers_ReleaseSchedules]) wait til we get the date! in DTM
			
		: ($tag="CUX")
			$_order_comments:=$_order_comments+Substring:C12(util_TextParser(1); 1; 3)+Char:C90(13)
			
		: ($tag="PAT")
			If (Senders_ID#"BEESL.ESL001")
				$errMsg:=util_TextParser(4; util_TextParser(2); iSubElementDelimitor; iSegmentDelimitor)
				[Customers_Orders:40]Terms:23:=util_TextParser(4)
			Else 
				[Customers_Orders:40]Terms:23:=util_TextParser(8)
			End if 
			
			If ([Customers_Orders:40]Terms:23="Within 15 days 1 % cash discount") | (True:C214)
				[Customers_Orders:40]Terms:23:="1%15-Net 30"
			End if 
			
		: ($tag="CTA")
			$errMsg:=util_TextParser(2; util_TextParser(2); iSubElementDelimitor; iSegmentDelimitor)
			[Customers_Orders:40]Contact_Agent:36:="("+util_TextParser(1)+") "+util_TextParser(2)
			
		: ($tag="TDT")
			[Customers_Orders:40]ShipVia:24:=util_TextParser(5)
			
		: ($tag="TOD")
			$errMsg:=util_TextParser(5; util_TextParser(3); iSubElementDelimitor; iSegmentDelimitor)
			[Customers_Orders:40]FOB:25:=util_TextParser(1)+" "+util_TextParser(5)
			
		: ($tag="UNT")
			//nothing worthy
			
		: ($tag="UNZ")
			//nothing worthy
	End case 
	
	$errMsg:=util_TextParser
	uThermoUpdate($segment)
End for 

uThermoClose

$0:=0

SAVE RECORD:C53([Customers_Orders:40])
SAVE RECORD:C53([Customers_Order_Lines:41])
SAVE RECORD:C53([Customers_ReleaseSchedules:46])
UNLOAD RECORD:C212([Finished_Goods:26])
UNLOAD RECORD:C212([Customers_Order_Lines:41])
UNLOAD RECORD:C212([Customers_Order_Change_Orders:34])
UNLOAD RECORD:C212([Customers_Orders:40])
UNLOAD RECORD:C212([Customers_ReleaseSchedules:46])