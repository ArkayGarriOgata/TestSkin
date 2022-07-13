//%attributes = {"publishedWeb":true}
//rRelSchdDetail: Release Schedule Detail

t20:=String:C10([Customers_ReleaseSchedules:46]Sched_Date:5; 1)
t21:=String:C10([Customers_ReleaseSchedules:46]Actual_Date:7; 1)
t22:=[Customers_ReleaseSchedules:46]CustomerRefer:3
t23:=[Customers_ReleaseSchedules:46]Sched_Qty:6
t24:=[Customers_ReleaseSchedules:46]Actual_Qty:8
t25:=[Customers_ReleaseSchedules:46]InvoiceNumber:9
t26:=""
If ([Customers_ReleaseSchedules:46]Billto:22#[Customers_Order_Lines:41]defaultBillto:23)
	If ([Addresses:30]ID:1#[Customers_ReleaseSchedules:46]Billto:22)
		QUERY:C277([Addresses:30]; [Addresses:30]ID:1=[Customers_ReleaseSchedules:46]Billto:22)
	End if 
	If (Records in selection:C76([Addresses:30])=1)
		t26:="Bill to: "+[Addresses:30]Name:2+"  "+[Addresses:30]Address1:3+" "+[Addresses:30]Address2:4+" "+[Addresses:30]Address3:5+" "+[Addresses:30]City:6+" "+[Addresses:30]State:7+" "+[Addresses:30]Zip:8+" "+[Addresses:30]Country:9+Char:C90(13)
	End if 
End if 
If ([Customers_ReleaseSchedules:46]Shipto:10#[Customers_Order_Lines:41]defaultShipTo:17)
	If ([Addresses:30]ID:1#[Customers_ReleaseSchedules:46]Shipto:10)
		QUERY:C277([Addresses:30]; [Addresses:30]ID:1=[Customers_ReleaseSchedules:46]Shipto:10)
	End if 
	If (Records in selection:C76([Addresses:30])=1)
		t26:=t26+"Ship to: "+[Addresses:30]Name:2+"  "+[Addresses:30]Address1:3+" "+[Addresses:30]Address2:4+" "+[Addresses:30]Address3:5+" "+[Addresses:30]City:6+" "+[Addresses:30]State:7+" "+[Addresses:30]Zip:8+" "+[Addresses:30]Country:9
	End if 
End if 
i5:=i5+[Customers_ReleaseSchedules:46]Sched_Qty:6
i6:=i6+[Customers_ReleaseSchedules:46]Actual_Qty:8