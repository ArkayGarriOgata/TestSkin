//(lp) [ReleaseSchedule]Unplanned report
//created cs 2/28/97 upr 1848
Case of 
	: (Form event code:C388=On Header:K2:17) & (Printing page:C275=1)
		t2:="Unplanned Report "+t2
	: (Form event code:C388=On Display Detail:K2:22)
		RELATE ONE:C42([Customers_ReleaseSchedules:46]OrderLine:4)
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=[Customers_ReleaseSchedules:46]ProductCode:11)
End case 