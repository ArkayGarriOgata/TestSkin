//FM: COAinput() -> 
//@author mlb - 3/18/02  10:40

Case of 
	: (Form event code:C388=On Load:K2:1)
		fRecalc:=False:C215
		MESSAGES OFF:C175
		QUERY:C277([Customers:16]; [Customers:16]ID:1=[Job_Forms_Items:44]CustId:15)
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=[Job_Forms_Items:44]OrderItem:2)
		qryFinishedGood([Job_Forms_Items:44]CustId:15; [Job_Forms_Items:44]ProductCode:3)
		QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ControlNumber:2=[Finished_Goods:26]ControlNumber:61)
		
		QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=[Job_Forms_Items:44]JobForm:1; *)
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue"; *)
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]CommodityCode:24=1)
		//QUERY([Material_Job];[Material_Job]JobForm=[JobMakesItem]JobForm;*)
		//QUERY([Material_Job]; & ;[Material_Job]Commodity_Key="01@")
		
		QUERY:C277([Job_Forms_Items_CertOfAnal:117]; [Job_Forms_Items_CertOfAnal:117]Jobit:1=[Job_Forms_Items:44]Jobit:4)
		ORDER BY:C49([Job_Forms_Items_CertOfAnal:117]; [Job_Forms_Items_CertOfAnal:117]Sample:2; >)
		
		JMI_CertOfAnal_Stats
		
	: (Form event code:C388=On Close Box:K2:21)
		SAVE RECORD:C53([Job_Forms_Items_CertOfAnal:117])
		ACCEPT:C269
		
	: (Form event code:C388=On Validate:K2:3)
		SAVE RECORD:C53([Job_Forms_Items_CertOfAnal:117])
		
End case 