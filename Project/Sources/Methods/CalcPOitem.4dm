//%attributes = {"publishedWeb":true}
//Procedure: CalcPOitem()  121698  Systems G3
//figure out qty's and dollars
//•011299  MLB  UPR flip converion
//•070199  mlb  created/used converion function POIpriceToCost, POIpriceToInvoice
// • mel (11/9/04, 11:22:47) fixed price allowance

If ([Purchase_Orders_Items:12]FactDship2price:38=0)  //this was #0 but i think that was a typo
	[Purchase_Orders_Items:12]FactDship2price:38:=1
End if 
If ([Purchase_Orders_Items:12]FactNship2price:25=0)
	[Purchase_Orders_Items:12]FactNship2price:25:=1
End if 
//added 12/28/94
If ([Purchase_Orders_Items:12]FactNship2cost:29=0)  //added 12/28/94
	[Purchase_Orders_Items:12]FactNship2cost:29:=1
End if 
If ([Purchase_Orders_Items:12]FactDship2cost:37=0)
	[Purchase_Orders_Items:12]FactDship2cost:37:=1
End if 

Case of 
	: ([Purchase_Orders_Items:12]FixedCost:51)  // • mel (11/9/04, 11:22:47)
		[Purchase_Orders_Items:12]Qty_Billing:17:=[Purchase_Orders_Items:12]Qty_Received:14
		[Purchase_Orders_Items:12]ExtPrice:11:=Round:C94([Purchase_Orders_Items:12]UnitPrice:10*[Purchase_Orders_Items:12]Qty_Received:14; 2)  //•••••BASED ON RECEIPTS
		[Purchase_Orders_Items:12]Qty_Open:27:=[Purchase_Orders_Items:12]Qty_Shipping:4-[Purchase_Orders_Items:12]Qty_Received:14
		[Purchase_Orders_Items:12]Qty_Ordered:30:=Round:C94([Purchase_Orders_Items:12]Qty_Shipping:4*[Purchase_Orders_Items:12]FactDship2cost:37/[Purchase_Orders_Items:12]FactNship2cost:29; 3)
		rPOPrice:=POIpriceToInvoice  //[PO_Items]UnitPrice*[PO_Items]FactNship2price/[PO_Items]FactDship2price
		rActPrice:=POIpriceToCost  //rPOPrice*[PO_Items]FactNship2cost/[PO_Items]FactDship2cost  `•011299  MLB  UPR f
		r21:=Round:C94([Purchase_Orders_Items:12]Qty_Received:14*rPOPrice; 2)
		
	: ([Purchase_Orders_Items:12]Qty_Shipping:4#0)
		[Purchase_Orders_Items:12]Qty_Billing:17:=Round:C94([Purchase_Orders_Items:12]Qty_Shipping:4*[Purchase_Orders_Items:12]FactNship2price:25/[Purchase_Orders_Items:12]FactDship2price:38; 3)
		[Purchase_Orders_Items:12]ExtPrice:11:=Round:C94([Purchase_Orders_Items:12]UnitPrice:10*[Purchase_Orders_Items:12]Qty_Billing:17; 2)
		[Purchase_Orders_Items:12]Qty_Open:27:=[Purchase_Orders_Items:12]Qty_Shipping:4-[Purchase_Orders_Items:12]Qty_Received:14
		[Purchase_Orders_Items:12]Qty_Ordered:30:=Round:C94([Purchase_Orders_Items:12]Qty_Shipping:4*[Purchase_Orders_Items:12]FactDship2cost:37/[Purchase_Orders_Items:12]FactNship2cost:29; 3)
		rPOPrice:=POIpriceToInvoice  //[PO_Items]UnitPrice*[PO_Items]FactNship2price/[PO_Items]FactDship2price
		rActPrice:=POIpriceToCost  //rPOPrice*[PO_Items]FactNship2cost/[PO_Items]FactDship2cost  `•011299  MLB  UPR f
		r21:=Round:C94([Purchase_Orders_Items:12]Qty_Received:14*rPOPrice; 2)
		
	: ([Purchase_Orders_Items:12]Qty_Ordered:30#0)
		[Purchase_Orders_Items:12]Qty_Shipping:4:=Round:C94([Purchase_Orders_Items:12]Qty_Ordered:30*[Purchase_Orders_Items:12]FactNship2cost:29/[Purchase_Orders_Items:12]FactDship2cost:37; 3)
		[Purchase_Orders_Items:12]Qty_Billing:17:=Round:C94([Purchase_Orders_Items:12]Qty_Shipping:4*[Purchase_Orders_Items:12]FactNship2price:25/[Purchase_Orders_Items:12]FactDship2price:38; 3)
		[Purchase_Orders_Items:12]ExtPrice:11:=Round:C94([Purchase_Orders_Items:12]UnitPrice:10*[Purchase_Orders_Items:12]Qty_Billing:17; 2)
		[Purchase_Orders_Items:12]Qty_Open:27:=[Purchase_Orders_Items:12]Qty_Shipping:4-[Purchase_Orders_Items:12]Qty_Received:14
		rPOPrice:=POIpriceToInvoice  //[PO_Items]UnitPrice*[PO_Items]FactNship2price/[PO_Items]FactDship2price
		rActPrice:=POIpriceToCost  //rPOPrice*[PO_Items]FactNship2cost/[PO_Items]FactDship2cost  `•011299  MLB  UPR f
		r21:=Round:C94([Purchase_Orders_Items:12]Qty_Received:14*rPOPrice; 2)
		
	Else 
		[Purchase_Orders_Items:12]Qty_Shipping:4:=0
		[Purchase_Orders_Items:12]Qty_Billing:17:=0
		[Purchase_Orders_Items:12]Qty_Ordered:30:=0
		[Purchase_Orders_Items:12]ExtPrice:11:=0
		rPOPrice:=0
		rActPrice:=0
		r21:=0
End case 