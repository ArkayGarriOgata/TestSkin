//(s) [machineticket]jobform
xText:=Substring:C12([Customers:16]Name:2; 1; 15)+" | "+Substring:C12([Finished_Goods:26]Line_Brand:15; 1; 15)
aText{Selected record number:C246([Job_Forms_Machine_Tickets:61])}:=xText

If ([Job_Forms_Items:44]JobForm:1#[Job_Forms_Machine_Tickets:61]JobForm:1)
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=[Job_Forms_Machine_Tickets:61]JobForm:1)
End if 

If ([Finished_Goods:26]ProductCode:1#[Job_Forms_Items:44]ProductCode:3)
	QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=[Job_Forms_Items:44]ProductCode:3)
End if 

If ([Customers:16]ID:1#[Job_Forms_Items:44]CustId:15)
	QUERY:C277([Customers:16]; [Customers:16]ID:1=[Job_Forms_Items:44]CustId:15)
End if 
//