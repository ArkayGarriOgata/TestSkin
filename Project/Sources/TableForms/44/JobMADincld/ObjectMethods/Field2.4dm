//(S)[jmi].jobmadincld.ItemNumber

//060898 mlb

//•070299  mlb  show sales value of release

QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=[Job_Forms_Items:44]OrderItem:2; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39>0; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5#!00-00-00!)

If (Records in selection:C76([Customers_ReleaseSchedules:46])=0)  //060898 mlb
	
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=[Job_Forms_Items:44]ProductCode:3; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39>0; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5#!00-00-00!)
End if 
ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >)

If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)  //•070299  mlb  show sales value of release
	
	SET QUERY LIMIT:C395(1)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=[Customers_ReleaseSchedules:46]OrderLine:4)
	SET QUERY LIMIT:C395(0)
	If (Records in selection:C76([Customers_Order_Lines:41])>0)
		$rev:=[Customers_ReleaseSchedules:46]Sched_Qty:6/1000*[Customers_Order_Lines:41]Price_Per_M:8
		xText:=String:C10($rev; "$#,###,##0.00")
		r1:=r1+$rev
		r2:=r2+$rev
		//utl_Trace 
		
		
	Else 
		xText:="No order"
	End if 
	
Else 
	xText:="No Release"
End if 
//