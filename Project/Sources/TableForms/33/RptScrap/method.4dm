//(lp) RptScrap
//•3/26/97 cs upr 1614 add totals and costs to report
Case of 
	: (Form event code:C388=On Load:K2:1)
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=[Finished_Goods_Transactions:33]ProductCode:1)
		xLineName:=[Finished_Goods:26]CartonDesc:3
End case 