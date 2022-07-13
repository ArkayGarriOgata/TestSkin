// ----------------------------------------------------
// User name (OS): MLB
// Date: 2/28/95
// ----------------------------------------------------
// Form Method: [Customers_Order_Change_Orders].Input
// ----------------------------------------------------

<>iLayout:=3401
Case of 
	: (Form event code:C388=On Load:K2:1)
		BeforeCCO
		
	: (Form event code:C388=On Clicked:K2:4)
		OBJECT SET ENABLED:C1123(bItemPage; True:C214)
		Case of   //• mel (11/4/04, 10:11:13) refactor
			: ([Customers_Order_Change_Orders:34]AddOrDeleteItem:13)
			: ([Customers_Order_Change_Orders:34]Cancel_:32)
			: ([Customers_Order_Change_Orders:34]GraphicChg:12)
			: ([Customers_Order_Change_Orders:34]HoldOtherReason:31)
			: ([Customers_Order_Change_Orders:34]ProcessChg:9)
			: ([Customers_Order_Change_Orders:34]QtyChg:8)
			: ([Customers_Order_Change_Orders:34]SizeChg:7)
			: ([Customers_Order_Change_Orders:34]SpecialServiceC:11)
			: ([Customers_Order_Change_Orders:34]PriceChg:21)
			Else 
				OBJECT SET ENABLED:C1123(bItemPage; False:C215)
				SetObjectProperties(""; ->[Customers_Order_Change_Orders:34]AddOrDeleteItem:13; True:C214; ""; True:C214)
				SetObjectProperties(""; ->[Customers_Order_Change_Orders:34]Cancel_:32; True:C214; ""; True:C214)
				SetObjectProperties(""; ->[Customers_Order_Change_Orders:34]GraphicChg:12; True:C214; ""; True:C214)
				SetObjectProperties(""; ->[Customers_Order_Change_Orders:34]HoldOtherReason:31; True:C214; ""; True:C214)
				SetObjectProperties(""; ->[Customers_Order_Change_Orders:34]ProcessChg:9; True:C214; ""; True:C214)
				SetObjectProperties(""; ->[Customers_Order_Change_Orders:34]QtyChg:8; True:C214; ""; True:C214)
				SetObjectProperties(""; ->[Customers_Order_Change_Orders:34]SizeChg:7; True:C214; ""; True:C214)
				SetObjectProperties(""; ->[Customers_Order_Change_Orders:34]SpecialServiceC:11; True:C214; ""; True:C214)
				SetObjectProperties(""; ->[Customers_Order_Change_Orders:34]PriceChg:21; True:C214; ""; True:C214)
		End case 
		
	: (Form event code:C388=On Validate:K2:3)  //• mel (11/4/04, 10:11:13) refactor
		
		Case of   //see if JOB was already put on hold
			: (Old:C35([Customers_Order_Change_Orders:34]AddOrDeleteItem:13))
			: (Old:C35([Customers_Order_Change_Orders:34]Cancel_:32))
			: (Old:C35([Customers_Order_Change_Orders:34]GraphicChg:12))
			: (Old:C35([Customers_Order_Change_Orders:34]HoldOtherReason:31))
			: (Old:C35([Customers_Order_Change_Orders:34]ProcessChg:9))
			: (Old:C35([Customers_Order_Change_Orders:34]QtyChg:8))
			: (Old:C35([Customers_Order_Change_Orders:34]SizeChg:7))
			: (Old:C35([Customers_Order_Change_Orders:34]SpecialServiceC:11))
			: (Old:C35([Customers_Order_Change_Orders:34]PriceChg:21))
			Else   //not was, see if now should be
				$jobHold:=True:C214
				Case of   //• mel (11/4/04, 10:11:13) refactor
					: ([Customers_Order_Change_Orders:34]AddOrDeleteItem:13)
					: ([Customers_Order_Change_Orders:34]Cancel_:32)
					: ([Customers_Order_Change_Orders:34]GraphicChg:12)
					: ([Customers_Order_Change_Orders:34]HoldOtherReason:31)
					: ([Customers_Order_Change_Orders:34]ProcessChg:9)
					: ([Customers_Order_Change_Orders:34]QtyChg:8)
					: ([Customers_Order_Change_Orders:34]SizeChg:7)
					: ([Customers_Order_Change_Orders:34]SpecialServiceC:11)
					: ([Customers_Order_Change_Orders:34]PriceChg:21)
					Else 
						$jobHold:=False:C215
				End case 
				If ($jobHold)  //at least one reason found to put on hold
					JOB_PutOnHold([Customers_Orders:40]JobNo:44; "See Change Order "+[Customers_Order_Change_Orders:34]ChangeOrderNumb:1)
				End if 
		End case 
		
		uUpdateTrail(->[Customers_Order_Change_Orders:34]ModDate:18; ->[Customers_Order_Change_Orders:34]ModWho:19; ->[Customers_Order_Change_Orders:34]zCount:17)
		gChgOApproval  //moved here on 2/28/95, was only in the accecpt btn
End case 