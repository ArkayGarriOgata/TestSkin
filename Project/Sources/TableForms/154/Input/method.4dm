// ----------------------------------------------------
// Form Method: [edi_Inbox].Input
// SetObjectProperties, Mark Zinke (5/16/13)
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Not:C34([edi_Inbox:154]WasRead:7))
			[edi_Inbox:154]WasRead:7:=True:C214
			SAVE RECORD:C53([edi_Inbox:154])
		End if 
		
		If (Length:C16([edi_Inbox:154]ICN:4)>0)
			If ([edi_Inbox:154]PO_Numbers:11#"DELFOR")
				SetObjectProperties("subform1"; -><>NULL; True:C214)
				SetObjectProperties("subform2"; -><>NULL; False:C215)
				QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]edi_ICN:56=[edi_Inbox:154]ICN:4)
				ORDER BY:C49([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1; >)
				
				QUERY:C277([edi_Outbox:155]; [edi_Outbox:155]CrossReference:6=[edi_Inbox:154]ICN:4)
				ORDER BY:C49([edi_Outbox:155]; [edi_Outbox:155]ID:1; >)
				
				ORDER BY:C49([edi_po_list:182]; [edi_po_list:182]customers_po:3; >)
				
				
			Else 
				SetObjectProperties("subform1"; -><>NULL; False:C215)
				SetObjectProperties("subform2"; -><>NULL; True:C214)
				QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]edi_ICN:14=[edi_Inbox:154]ICN:4)
				ORDER BY:C49([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]ProductCode:2; >; [Finished_Goods_DeliveryForcasts:145]DateDock:4; >)
			End if 
			
		Else 
			REDUCE SELECTION:C351([Customers_Orders:40]; 0)
		End if 
		
	: (Form event code:C388=On Validate:K2:3)
		//[edi_Inbox]Content_Text:=Old([edi_Inbox]Content_Text)  `don't allow changes, this is set in trigger
		
	: (Form event code:C388=On Close Box:K2:21)
		bDone:=1
		CANCEL:C270
End case 