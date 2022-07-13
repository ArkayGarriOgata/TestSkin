//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: AfterCustOrder
// ----------------------------------------------------

gCOApproval
gCODelete
<>AskMeCust:="KILL"
POST OUTSIDE CALL:C329(vAskMePID)

If (iMode=1)  //new record  `upr 1362 02/14/95 chip
	If ([Estimates:17]EstimateNo:1#[Customers_Orders:40]EstimateNo:3) & ([Customers_Orders:40]JobNo:44=0)
		READ WRITE:C146([Estimates:17])
		QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=[Customers_Orders:40]EstimateNo:3)
		$job:=[Estimates:17]JobNo:50
		READ WRITE:C146([Jobs:15])
		QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=$Job)
		[Jobs:15]OrderNo:15:=[Customers_Orders:40]OrderNumber:1
		[Customers_Orders:40]JobNo:44:=$Job
		SAVE RECORD:C53([Jobs:15])
	End if 
End if 

//If ([Customers_Orders]OrderSalesTotal#Old([Customers_Orders]OrderSalesTotal))
//READ WRITE([Customers])
//RELATE ONE([Customers_Orders]CustID)
//[Customers]ModAddress:=4D_Current_date
//[Customers]ModFlag:=True
//  //this next line looks incorrect! this is total orders not open orders
//[Customers]Open_Orders:=[Customers]Open_Orders-Old([Customers_Orders]OrderSalesTotal)+[Customers_Orders]OrderSalesTotal

//SAVE RECORD([Customers])
//UNLOAD RECORD([Customers])
//READ ONLY([Customers])  //••
//End if 

If ([Customers_Orders:40]SalesRep:13#Old:C35([Customers_Orders:40]SalesRep:13))
	READ WRITE:C146([Customers_Invoices:88])
	APPLY TO SELECTION:C70([Customers_Order_Lines:41]; [Customers_Order_Lines:41]SalesRep:34:=[Customers_Orders:40]SalesRep:13)
	RELATE MANY SELECTION:C340([Customers_Invoices:88]OrderLine:4)
	APPLY TO SELECTION:C70([Customers_Invoices:88]; [Customers_Invoices:88]SalesPerson:8:=[Customers_Orders:40]SalesRep:13)
	REDUCE SELECTION:C351([Customers_Invoices:88]; 0)
	READ ONLY:C145([Customers_Invoices:88])
End if 

If ([Customers_Orders:40]CustomerLine:22#Old:C35([Customers_Orders:40]CustomerLine:22))  //upr 1221 11/22/94
	READ WRITE:C146([Estimates:17])
	QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=[Customers_Orders:40]EstimateNo:3)
	[Estimates:17]Brand:3:=[Customers_Orders:40]CustomerLine:22
	[Estimates:17]ModDate:37:=4D_Current_date
	[Estimates:17]ModWho:38:=<>zResp
	SAVE RECORD:C53([Estimates:17])
	UNLOAD RECORD:C212([Estimates:17])
	
	READ WRITE:C146([Jobs:15])
	QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=[Customers_Orders:40]JobNo:44)
	[Jobs:15]Line:3:=[Customers_Orders:40]CustomerLine:22
	[Jobs:15]ModDate:8:=4D_Current_date
	[Jobs:15]ModWho:9:=<>zResp
	SAVE RECORD:C53([Jobs:15])
	UNLOAD RECORD:C212([Jobs:15])
	
	READ WRITE:C146([Finished_Goods:26])
	FIRST RECORD:C50([Customers_Order_Lines:41])
	While (Not:C34(End selection:C36([Customers_Order_Lines:41])))
		qryFinishedGood([Customers_Order_Lines:41]CustID:4; [Customers_Order_Lines:41]ProductCode:5)  //•060195  MLB
		If ([Finished_Goods:26]Status:14#"Final")  //•060195  MLB
			[Finished_Goods:26]Line_Brand:15:=[Customers_Orders:40]CustomerLine:22
			[Finished_Goods:26]ModDate:24:=4D_Current_date
			[Finished_Goods:26]ModWho:25:=<>zResp
			SAVE RECORD:C53([Finished_Goods:26])
			//API_FGTrans ("MOD")
		End if 
		If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
			
			UNLOAD RECORD:C212([Finished_Goods:26])
			
		Else 
			
			//You have next after
			
		End if   // END 4D Professional Services : January 2019 
		
		NEXT RECORD:C51([Customers_Order_Lines:41])
	End while 
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
		
		
		
	Else 
		
		UNLOAD RECORD:C212([Finished_Goods:26])
		
	End if   // END 4D Professional Services : January 2019 
End if 

uUpdateTrail(->[Customers_Orders:40]ModDate:9; ->[Customers_Orders:40]ModWho:8; ->[Customers_Orders:40]zCount:29)