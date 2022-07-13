//%attributes = {"publishedWeb":true}
//rOrderLineDetail: Order Line Detail
//upr 1085 10/11/94
//5/1/95 special billing

i5:=0
i6:=0
i7:=0
t10:=String:C10([Customers_Order_Lines:41]LineItem:2; "000")
t11:=[Customers_Order_Lines:41]ProductCode:5
READ ONLY:C145([Finished_Goods:26])
qryFinishedGood([Customers_Order_Lines:41]CustID:4; t11)  //•051595  MLB  UPR 1508

t12:=[Finished_Goods:26]CartonDesc:3
t13:=[Finished_Goods:26]Style:32
t13b:=[Finished_Goods:26]OutLine_Num:4
t13c:=String:C10([Finished_Goods:26]DateArtApproved:46; System date short:K1:1)
t16:=String:C10([Customers_Order_Lines:41]Price_Per_M:8; "###,###,##0.00")
If ([Finished_Goods:26]Acctg_UOM:29#"")
	t16:=t16+"/"+[Finished_Goods:26]Acctg_UOM:29
End if 
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
	
	UNLOAD RECORD:C212([Finished_Goods:26])
	
	
Else 
	
	// read only mode
	
	
	
End if   // END 4D Professional Services : January 2019 
t14:=String:C10([Customers_Order_Lines:41]NeedDate:14; 1)
t15:=String:C10([Customers_Order_Lines:41]Quantity:6; "###,###,##0")
t15b:=String:C10([Customers_Order_Lines:41]OverRun:25; "+#0%; ; ")  //upr 1085 10/11/94
t15c:=String:C10([Customers_Order_Lines:41]UnderRun:26; "-#0%; ; ")  //upr 1085 10/11/94

If (Position:C15("M"; t16)#0)
	$extended:=[Customers_Order_Lines:41]Price_Per_M:8*([Customers_Order_Lines:41]Quantity:6/1000)
	i1:=i1+[Customers_Order_Lines:41]Quantity:6  //upr 1085
	
Else 
	$extended:=[Customers_Order_Lines:41]Price_Per_M:8*([Customers_Order_Lines:41]Quantity:6)
End if 
i3:=i3+$extended
t17:=String:C10($extended; "$###,###,##0.00")
t18:=[Customers_Order_Lines:41]OrderType:22+"  "
If ([Customers_Order_Lines:41]PONumber:21#[Customers_Orders:40]PONumber:11)
	t18:=t18+"  *** PO Nº:  "+[Customers_Order_Lines:41]PONumber:21+"  ***"+Char:C90(13)
Else 
	If ([Customers_Order_Lines:41]PONumber:21="")
		t18:=t18+"  *** NO PURCHASE ORDER Nº"+"  ***"+Char:C90(13)
	Else 
		t18:=t18+" "
	End if 
End if 
If ([Customers_Order_Lines:41]defaultBillto:23#[Customers_Orders:40]defaultBillTo:5)
	If ([Addresses:30]ID:1#[Customers_Order_Lines:41]defaultBillto:23)
		QUERY:C277([Addresses:30]; [Addresses:30]ID:1=[Customers_Order_Lines:41]defaultBillto:23)
	End if 
	If (Records in selection:C76([Addresses:30])=1)
		t18:=t18+"Bill to: "+[Addresses:30]Name:2+"  "+[Addresses:30]Address1:3+" "+[Addresses:30]Address2:4+" "+[Addresses:30]Address3:5+" "+[Addresses:30]City:6+" "+[Addresses:30]State:7+" "+[Addresses:30]Zip:8+" "+[Addresses:30]Country:9+Char:C90(13)
	End if 
End if 

If ([Customers_Order_Lines:41]defaultShipTo:17#[Customers_Orders:40]defaultShipto:40)
	If ([Addresses:30]ID:1#[Customers_Order_Lines:41]defaultShipTo:17)
		QUERY:C277([Addresses:30]; [Addresses:30]ID:1=[Customers_Order_Lines:41]defaultShipTo:17)
	End if 
	If (Records in selection:C76([Addresses:30])=1)
		t18:=t18+"Ship to: "+[Addresses:30]Name:2+"  "+[Addresses:30]Address1:3+" "+[Addresses:30]Address2:4+" "+[Addresses:30]Address3:5+" "+[Addresses:30]City:6+" "+[Addresses:30]State:7+" "+[Addresses:30]Zip:8+" "+[Addresses:30]Country:9
	End if 
End if 