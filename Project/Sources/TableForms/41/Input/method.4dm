// ----------------------------------------------------
// Form Method: [Customers_Order_Lines].Input
// ----------------------------------------------------
// Modified by: Mel Bohince (10/11/19) require change order after shipped
// Modified by: Garri Ogata (11/13/20) - added <>PHYSICAL_INVENORY_IN_PROGRESS

Case of 
	: (Form event code:C388=On Load:K2:1)
		pendingChange:=""
		
		
		If (Not:C34(User_AllowedCustomer([Customers_Order_Lines:41]CustID:4; ""; "via OL:"+[Customers_Order_Lines:41]OrderLine:3)))
			bDone:=1
			CANCEL:C270
		End if 
		
		If (cancelLineItemInputForm)  //coming from the Show PV button on the order header
			CANCEL:C270
		End if 
		READ ONLY:C145([Customers:16])  // Modified by: Mel Bohince (1/16/20) 
		
		READ ONLY:C145([Customers_Addresses:31])
		QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustID:1=[Customers_Order_Lines:41]CustID:4; *)
		QUERY:C277([Customers_Addresses:31];  & ; [Customers_Addresses:31]AddressType:3="Bill to")
		SELECTION TO ARRAY:C260([Customers_Addresses:31]CustAddrID:2; aBilltos)
		aBilltos{0}:=[Customers_Order_Lines:41]CustID:4
		SORT ARRAY:C229(aBilltos; >)
		
		QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustID:1=[Customers_Order_Lines:41]CustID:4; *)
		QUERY:C277([Customers_Addresses:31];  & ; [Customers_Addresses:31]AddressType:3="Ship to")
		SELECTION TO ARRAY:C260([Customers_Addresses:31]CustAddrID:2; aShiptos)
		aShiptos{0}:=[Customers_Order_Lines:41]CustID:4
		SORT ARRAY:C229(aShiptos; >)
		
		Text24:=fGetAddressText([Customers_Order_Lines:41]defaultBillto:23)
		a1:=1
		a2:=0
		SetObjectProperties(""; ->bContract; True:C214)  // Modified by: Mark Zinke (5/10/13)
		OBJECT SET ENABLED:C1123(*; "edi@"; False:C215)
		Core_ObjectSetColor("*"; "edi@"; -(Red:K11:4+(256*White:K11:1)))
		
		If ([Customers_Order_Lines:41]SpecialBilling:37)
			SetObjectProperties("invoice@"; -><>NULL; True:C214)  // Modified by: Mark Zinke (5/10/13)
			SetObjectProperties("rel@"; -><>NULL; False:C215)  // Modified by: Mark Zinke (5/10/13)
		Else 
			SetObjectProperties("invoice@"; -><>NULL; False:C215)  // Modified by: Mark Zinke (5/10/13)
			SetObjectProperties("rel@"; -><>NULL; True:C214)  // Modified by: Mark Zinke (5/10/13)
		End if 
		
		Case of 
			: (Is new record:C668([Customers_Order_Lines:41]))
				uNewOrderline
				SetObjectProperties("invoice@"; -><>NULL; False:C215)  // Modified by: Mark Zinke (5/10/13)
				
			: (iMode>2)
				uReviewOrderlin
				
				READ ONLY:C145([Customers_ReleaseSchedules:46])
				QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=[Customers_Order_Lines:41]OrderLine:3)
				
			Else   //modify mode
				READ WRITE:C146([Customers_ReleaseSchedules:46])
				QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=[Customers_Order_Lines:41]OrderLine:3)
				
				If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
					$sched:=Sum:C1([Customers_ReleaseSchedules:46]Sched_Qty:6)
				Else 
					$sched:=0
				End if 
				[Customers_Order_Lines:41]QtyWithRel:20:=$sched
				
				uVerifyShipment
				
				
				If ([Customers_Order_Lines:41]edi_dock_date:64#!00-00-00!) & ([Customers_Order_Lines:41]edi_dock_date:64#[Customers_Order_Lines:41]NeedDate:14)
					OBJECT SET ENABLED:C1123(edi2; True:C214)
					Core_ObjectSetColor(->[Customers_Order_Lines:41]NeedDate:14; -(Purple:K11:5+(256*White:K11:1)))
				End if 
				
				If ([Customers_Order_Lines:41]edi_price:66#0) & ([Customers_Order_Lines:41]edi_price:66#[Customers_Order_Lines:41]Price_Per_M:8)
					OBJECT SET ENABLED:C1123(edi4; True:C214)
					Core_ObjectSetColor(->[Customers_Order_Lines:41]Price_Per_M:8; -(Purple:K11:5+(256*White:K11:1)))
				End if 
				
				If ([Customers_Order_Lines:41]edi_quantity:65#0) & ([Customers_Order_Lines:41]edi_quantity:65#[Customers_Order_Lines:41]Quantity:6)
					OBJECT SET ENABLED:C1123(edi3; True:C214)
					Core_ObjectSetColor(->[Customers_Order_Lines:41]Quantity:6; -(Purple:K11:5+(256*White:K11:1)); True:C214)
				End if 
				
				If ([Customers_Order_Lines:41]edi_shipto:63#"") & ([Customers_Order_Lines:41]edi_shipto:63#[Customers_Order_Lines:41]defaultShipTo:17)
					OBJECT SET ENABLED:C1123(edi1; True:C214)
					Core_ObjectSetColor(->[Customers_Order_Lines:41]defaultShipTo:17; -(Purple:K11:5+(256*White:K11:1)); True:C214)
				End if 
				
		End case 
		
		wWindowTitle("push"; "Orderline "+[Customers_Order_Lines:41]OrderLine:3+" for "+[Customers_Order_Lines:41]CustomerName:24)
		
		If ([Customers_Order_Lines:41]Qty_Returned:35>0)
			SetObjectProperties("ret@"; -><>NULL; True:C214)  // Modified by: Mark Zinke (5/10/13)
		Else 
			SetObjectProperties("ret@"; -><>NULL; False:C215)  // Modified by: Mark Zinke (5/10/13)
		End if 
		
		If ([Customers_Order_Lines:41]PayUse:47)
			SetObjectProperties(""; ->bPU; True:C214)  // Modified by: Mark Zinke (5/10/13)
		Else 
			SetObjectProperties(""; ->bPU; False:C215)  // Modified by: Mark Zinke (5/10/13)
		End if 
		
		READ ONLY:C145([Finished_Goods_Classifications:45])
		QUERY:C277([Finished_Goods_Classifications:45]; [Finished_Goods_Classifications:45]Class:1=[Customers_Order_Lines:41]Classification:29)
		
		READ ONLY:C145([Job_Forms_Items:44])
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]OrderItem:2=[Customers_Order_Lines:41]OrderLine:3)
		
		ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >)
		
		//status things
		Case of 
			: ([Customers_Order_Lines:41]Status:9="New")
				
			: ([Customers_Order_Lines:41]Status:9="Opened")
				//
			: ([Customers_Order_Lines:41]Status:9="CONTRACT")
				
			: ([Customers_Order_Lines:41]Status:9="Accepted")
				If (iMode<3)
					If (Not:C34(User in group:C338(Current user:C182; "CCO_Approval")))
						uSetEntStatus(->[Customers_Order_Lines:41]; False:C215)
						SetObjectProperties(""; ->[Customers_Order_Lines:41]PONumber:21; True:C214; ""; True:C214)
						SetObjectProperties(""; ->[Customers_Order_Lines:41]InvoiceComment:43; True:C214; ""; True:C214)
						SetObjectProperties(""; ->[Customers_Order_Lines:41]SpecialBilling:37; True:C214; ""; True:C214)
					End if 
				End if 
				
			Else   //closed, rejected, kill, credithold, cancel
				//uSplStatOrderli 
				If (iMode<3)
					If (Not:C34(User in group:C338(Current user:C182; "CCO_Approval")))
						uSetEntStatus(->[Customers_Order_Lines:41]; False:C215)
						SetObjectProperties(""; ->[Customers_Order_Lines:41]PONumber:21; True:C214; ""; True:C214)
						SetObjectProperties(""; ->[Customers_Order_Lines:41]InvoiceComment:43; True:C214; ""; True:C214)
						SetObjectProperties(""; ->[Customers_Order_Lines:41]SpecialBilling:37; True:C214; ""; True:C214)
						
						If ([Customers_Order_Lines:41]SpecialBilling:37)  // so debra can copy/paste
							SetObjectProperties(""; ->[Customers_Order_Lines:41]InvoiceComment:43; True:C214; ""; True:C214)
						End if 
					End if 
					
				End if 
				
		End case 
		
		SetObjectProperties(""; ->[Customers_Order_Lines:41]UserDefined_1:70; True:C214; ""; True:C214)
		
		COPY ARRAY:C226(<>asOrdStat; asOrderlineStatus)  //upr 1326 2/15/95
		util_ComboBoxSetup(->asOrderLineStatus; [Customers_Order_Lines:41]Status:9)
		
		ARRAY TEXT:C222(asEDI_Status; 0)
		LIST TO ARRAY:C288("EDI_Status"; asEDI_Status)
		util_ComboBoxSetup(->asEDI_Status; [Customers_Order_Lines:41]edi_line_status:55)
		
		If ([Customers_Order_Lines:41]Qty_Shipped:10>0)  // Modified by: Mel Bohince (10/11/19) require change order after shipped
			OBJECT SET ENTERABLE:C238(*; "ccoRequired@"; False:C215)
			OBJECT SET BORDER STYLE:C1262(*; "ccoRequired@"; Border None:K42:27)
			
		Else 
			OBJECT SET ENTERABLE:C238(*; "ccoRequired@"; True:C214)
			OBJECT SET BORDER STYLE:C1262(*; "ccoRequired@"; Border Sunken:K42:31)
		End if 
		
		If (<>PHYSICAL_INVENORY_IN_PROGRESS)  // Modified by: Garri Ogata (11/13/20) 
			
			OBJECT SET ENABLED:C1123(*; "asOrderLineStatus"; False:C215)
			
		End if 
		
	: (Form event code:C388=On Validate:K2:3)
		If (Length:C16(pendingChange)>0)
			pendingChange:="## "+TS2String(TSTimeStamp)+" by "+<>zResp+" status="+[Customers_Order_Lines:41]Status:9+" ##"+Char:C90(Carriage return:K15:38)+pendingChange
			[Customers_Order_Lines:41]ChangeHistory:74:=pendingChange+[Customers_Order_Lines:41]ChangeHistory:74
			
			If ([Customers_Order_Lines:41]Qty_Shipped:10>0)  //this should not be hitting anymore, cco required for price change after shipping
				If (Old:C35([Customers_Order_Lines:41]Price_Per_M:8)#[Customers_Order_Lines:41]Price_Per_M:8)  //email accounting to do an adjustment
					$subject:="Price Change - Adjustment needed"
					$body:="See orderline "+[Customers_Order_Lines:41]OrderLine:3+" "+[Customers_Order_Lines:41]ProductCode:5+" had a price change, please create an adjustment. Price Changed from "+String:C10(Old:C35([Customers_Order_Lines:41]Price_Per_M:8))+" to "+String:C10([Customers_Order_Lines:41]Price_Per_M:8)
					$tSender:=Email_WhoAmI
					$tRecepients:=Batch_GetDistributionList(""; "A/R")
					EMAIL_Sender($subject; ""; $body; $tRecepients; ""; ""; $tSender)
				End if 
			End if 
		End if 
		
		fItemChg:=True:C214  //force recalc on header
		$testForBlank:=Replace string:C233([Customers_Order_Lines:41]PONumber:21; " "; "")  //• mlb - 5/22/01 
		If (Length:C16($testForBlank)=0)
			[Customers_Order_Lines:41]PONumber:21:=""
		End if 
		
		uUpdateTrail(->[Customers_Order_Lines:41]ModDate:15; ->[Customers_Order_Lines:41]ModWho:16; ->[Customers_Order_Lines:41]zCount:18)
		
	: (Form event code:C388=On Unload:K2:2)
		wWindowTitle("pop")
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
End case 