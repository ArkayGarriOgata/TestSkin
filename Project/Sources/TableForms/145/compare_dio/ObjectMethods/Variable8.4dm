//zSetUsageStat ("AskMe";"Mod Rel";sCustID+":"+sCPN)
//• mlb - 2/12/03  16:19 use named selection
If (ListBox1#0) & (ListBox2#0)
	READ ONLY:C145([Finished_Goods_DeliveryForcasts:145])
	GOTO RECORD:C242([Finished_Goods_DeliveryForcasts:145]; aRecNo{ListBox1})
	READ WRITE:C146([Customers_ReleaseSchedules:46])
	GOTO RECORD:C242([Customers_ReleaseSchedules:46]; aRecNum{ListBox2})
	If ([Customers_ReleaseSchedules:46]OrderNumber:2=0)
		[Customers_ReleaseSchedules:46]OrderLine:4:=OL_findOpenMatch  // (sCPN)
		If (Length:C16([Customers_ReleaseSchedules:46]OrderLine:4)>7)
			[Customers_ReleaseSchedules:46]OrderNumber:2:=Num:C11(Substring:C12([Customers_ReleaseSchedules:46]OrderLine:4; 1; 5))
		Else 
			[Customers_ReleaseSchedules:46]OrderNumber:2:=0
		End if 
	End if 
	[Customers_ReleaseSchedules:46]Shipto:10:=[Finished_Goods_DeliveryForcasts:145]ShipTo:8
	If ([Customers_ReleaseSchedules:46]Shipto:10="02439") | ([Customers_ReleaseSchedules:46]Shipto:10="02033")
		[Customers_ReleaseSchedules:46]Billto_BOL:43:="02677"
	End if 
	If (Length:C16([Customers_ReleaseSchedules:46]Shipto:10)=0)
		[Customers_ReleaseSchedules:46]Shipto:10:=[Finished_Goods_DeliveryForcasts:145]ShipTo:8
	End if 
	If (Length:C16([Customers_ReleaseSchedules:46]Billto:22)=0)
		[Customers_ReleaseSchedules:46]Shipto:10:=[Finished_Goods_DeliveryForcasts:145]BillTo:16
	End if 
	If ([Customers_ReleaseSchedules:46]Promise_Date:32#aDateDue{ListBox1})
		[Customers_ReleaseSchedules:46]Promise_Date:32:=aDateDue{ListBox1}
		[Customers_ReleaseSchedules:46]Sched_Date:5:=aDateDue{ListBox1}-ADDR_getLeadTime([Customers_ReleaseSchedules:46]Shipto:10)
		[Customers_ReleaseSchedules:46]Sched_Date:5:=REL_NoWeekEnds([Customers_ReleaseSchedules:46]Sched_Date:5)  // • mel (6/22/05, 17:08:14)
	End if 
	
	If ([Customers_ReleaseSchedules:46]Sched_Qty:6#aQty{ListBox1})
		[Customers_ReleaseSchedules:46]Sched_Qty:6:=aQty{ListBox1}
	End if 
	[Customers_ReleaseSchedules:46]Entered_Date:34:=4D_Current_date
	[Customers_ReleaseSchedules:46]THC_State:39:=9
	[Customers_ReleaseSchedules:46]CustomerRefer:3:=asDiff{ListBox1}
	[Customers_ReleaseSchedules:46]EDI_Disposition:36:=[Finished_Goods_DeliveryForcasts:145]asOf:9
	uUpdateTrail(->[Customers_ReleaseSchedules:46]ModDate:18; ->[Customers_ReleaseSchedules:46]ModWho:19)
	
	SAVE RECORD:C53([Customers_ReleaseSchedules:46])
	REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
	REDUCE SELECTION:C351([Finished_Goods_DeliveryForcasts:145]; 0)
	
	PnP_DeliveryScheduleQry(sCPN)
	
Else 
	BEEP:C151
	ALERT:C41("Select one from theirs and ours.")
End if 
//