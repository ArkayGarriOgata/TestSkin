
If (ListBox1#0)  //aDateDue
	GOTO RECORD:C242([Finished_Goods_DeliveryForcasts:145]; aRecNo{ListBox1})
	CREATE RECORD:C68([Customers_ReleaseSchedules:46])
	[Customers_ReleaseSchedules:46]ReleaseNumber:1:=app_AutoIncrement(->[Customers_ReleaseSchedules:46])
	[Customers_ReleaseSchedules:46]OrderLine:4:=OL_findOpenMatch  // (sCPN)
	If (Length:C16([Customers_ReleaseSchedules:46]OrderLine:4)>7)
		[Customers_ReleaseSchedules:46]OrderNumber:2:=Num:C11(Substring:C12([Customers_ReleaseSchedules:46]OrderLine:4; 1; 5))
	Else 
		[Customers_ReleaseSchedules:46]OrderNumber:2:=0
	End if 
	[Customers_ReleaseSchedules:46]Shipto:10:=[Finished_Goods_DeliveryForcasts:145]ShipTo:8
	
	If ([Customers_ReleaseSchedules:46]Shipto:10="02439") | ([Customers_ReleaseSchedules:46]Shipto:10="02033")
		[Customers_ReleaseSchedules:46]Billto_BOL:43:="02677"
	End if 
	[Customers_ReleaseSchedules:46]Billto:22:=[Finished_Goods_DeliveryForcasts:145]BillTo:16
	[Customers_ReleaseSchedules:46]ProductCode:11:=sCPN
	[Customers_ReleaseSchedules:46]CustomerRefer:3:=asDiff{ListBox1}
	[Customers_ReleaseSchedules:46]CustID:12:=[Finished_Goods:26]CustID:2
	[Customers_ReleaseSchedules:46]CustomerLine:28:=[Finished_Goods:26]Line_Brand:15  //•060295  MLB  UPR 184
	[Customers_ReleaseSchedules:46]PayU:31:=0
	[Customers_ReleaseSchedules:46]Entered_Date:34:=4D_Current_date
	[Customers_ReleaseSchedules:46]THC_State:39:=9  //•102297  MLB  was, -4, chg so it show up as not being processed yet
	[Customers_ReleaseSchedules:46]ProjectNumber:40:=[Finished_Goods:26]ProjectNumber:82
	[Customers_ReleaseSchedules:46]Sched_Date:5:=aDateDue{ListBox1}-ADDR_getLeadTime([Customers_ReleaseSchedules:46]Shipto:10)
	[Customers_ReleaseSchedules:46]Sched_Date:5:=REL_NoWeekEnds([Customers_ReleaseSchedules:46]Sched_Date:5)  // • mel (6/22/05, 17:08:14)
	
	[Customers_ReleaseSchedules:46]Promise_Date:32:=aDateDue{ListBox1}
	[Customers_ReleaseSchedules:46]Sched_Qty:6:=aQty{ListBox1}
	[Customers_ReleaseSchedules:46]OpenQty:16:=aQty{ListBox1}
	[Customers_ReleaseSchedules:46]EDI_Disposition:36:=[Finished_Goods_DeliveryForcasts:145]asOf:9
	uUpdateTrail(->[Customers_ReleaseSchedules:46]ModDate:18; ->[Customers_ReleaseSchedules:46]ModWho:19)
	SAVE RECORD:C53([Customers_ReleaseSchedules:46])
	
	PnP_DeliveryScheduleQry(sCPN)
End if 
//