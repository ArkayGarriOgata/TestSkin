Case of 
	: (Form event code:C388=On Load:K2:1)
		READ ONLY:C145([Job_Forms_Items:44])
		qryJMI([Job_Forms_Items_Costs:92]Jobit:3)
		READ ONLY:C145([Finished_Goods_Locations:35])
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33=[Job_Forms_Items_Costs:92]Jobit:3)
		
End case 