//%attributes = {"publishedWeb":true}
//(p) sFillShipLabel
//either fills in data for this label or clears displayed data if 
//no Jobmakesitem record found
//12/29/94 truncate customer name to 27

If (Records in selection:C76([Job_Forms_Items:44])=1)  //on recrd selected above either by user or by search
	If ($1#"CPN")
		[WMS_Label_Tracking:75]CPN:3:=[Job_Forms_Items:44]ProductCode:3
	End if 
	
	lToShip:=[Job_Forms_Items:44]Qty_Yield:9  //12/28/94
	
	[WMS_Label_Tracking:75]CustId:2:=[Job_Forms_Items:44]CustId:15
	[WMS_Label_Tracking:75]Jobit:7:=[Job_Forms_Items:44]JobForm:1
	QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=[WMS_Label_Tracking:75]CPN:3)
	[WMS_Label_Tracking:75]QtyPerCase:8:=[Finished_Goods:26]PackingQty:45
	[WMS_Label_Tracking:75]Description:4:=[Finished_Goods:26]CartonDesc:3
	RELATE ONE:C42([Job_Forms_Items:44]OrderItem:2)  //get orderitem record
	[WMS_Label_Tracking:75]Ref_Destination:10:="ITEM # "+String:C10([Job_Forms_Items:44]ItemNumber:7; "00")  //12/28/94
	[WMS_Label_Tracking:75]PONo:6:=[Customers_Order_Lines:41]PONumber:21
	QUERY:C277([Customers:16]; [Customers:16]ID:1=[WMS_Label_Tracking:75]CustId:2)
	
	[WMS_Label_Tracking:75]CustName:1:=Uppercase:C13(Substring:C12([Customers:16]Name:2; 1; 27))  //12/29/94;NyrDyv;Force uppercase
	sCalcCopies("*")
Else 
	ALERT:C41($1+" Entry NOT Found, Please Check the Entry and Try Again.")
	If ($1="CPN")
		[WMS_Label_Tracking:75]Jobit:7:=""
		GOTO OBJECT:C206([WMS_Label_Tracking:75]CPN:3)
	Else 
		[WMS_Label_Tracking:75]CPN:3:=""
		GOTO OBJECT:C206([WMS_Label_Tracking:75]Jobit:7)
	End if 
	[WMS_Label_Tracking:75]CustId:2:=""
	[WMS_Label_Tracking:75]QtyPerCase:8:=0
	[WMS_Label_Tracking:75]Description:4:=""
	[WMS_Label_Tracking:75]Ref_Destination:10:=""
	[WMS_Label_Tracking:75]PONo:6:=""
	[WMS_Label_Tracking:75]CustName:1:=""
	lCopies:=0
	lToShip:=0  //12/28/94
End if 