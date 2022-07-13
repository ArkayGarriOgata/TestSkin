//%attributes = {"publishedWeb":true}
//sRenameProdCod2 called by gChgOApproval  see also sRenameProdCode
//code simplification  11/8/94
//trap for blank cpns prior to api message ` 1/25/95
//3/27/95 spl billing search problem
//5/3/95 chip upr 1489
//5/8/95 adjusted
//• 4/14/98 cs Nan checking
//• 6/16/98 cs Duplicated Key problem from Combined customer
C_LONGINT:C283($csrec)
//TRACE
If ([Customers_Order_Change_Orders:34]NewEstimate:38="")  //BAK 9/15/94 to keep carton spec from being updated on Est Revision
	READ WRITE:C146([Estimates_Carton_Specs:19])
	QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=[Customers_Orders:40]EstimateNo:3; *)
	QUERY:C277([Estimates_Carton_Specs:19];  & ; [Estimates_Carton_Specs:19]diffNum:11=[Customers_Orders:40]CaseScenario:4; *)
	QUERY:C277([Estimates_Carton_Specs:19];  & ; [Estimates_Carton_Specs:19]ProductCode:5=[Customers_Order_Changed_Items:176]OldProductCode:9)
	
	Case of 
		: (Records in selection:C76([Estimates_Carton_Specs:19])=1)
			CONFIRM:C162("Rename "+[Estimates_Carton_Specs:19]ProductCode:5+" to "+[Customers_Order_Changed_Items:176]NewProductCode:10+" in the carton spec?"; "Rename"; "Ignor")
			
			If (ok=1)
				[Estimates_Carton_Specs:19]ProductCode:5:=[Customers_Order_Lines:41]ProductCode:5
				SAVE RECORD:C53([Estimates_Carton_Specs:19])
			End if 
			
		: (Records in selection:C76([Estimates_Carton_Specs:19])=0)
			
		Else 
			$csrec:=Record number:C243([Estimates_Carton_Specs:19])
			CONFIRM:C162("Rename the all "+[Estimates_Carton_Specs:19]ProductCode:5+"'s to "+[Customers_Order_Changed_Items:176]NewProductCode:10+" in the carton spec?"; "Rename"; "Ignor")
			
			If (ok=1)
				APPLY TO SELECTION:C70([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]ProductCode:5:=[Customers_Order_Lines:41]ProductCode:5)
			End if 
			GOTO RECORD:C242([Estimates_Carton_Specs:19]; $csrec)
	End case 
End if 

If ([Customers_Order_Lines:41]ProductCode:5#"")  //trap for blank cpns` 1/25/95  
	//• 6/16/98 cs when running this (changing Code) from a combined customer, 
	//   it is possible that the FG exists under the specific customer id BUT is not 
	//   found above because that search uses the combined Cust ID.    
	//  SO... we need to check using the CSPEC customer to insure that there is not
	//   going to create a dup, which generates an error on duplicated FG key 
	If ([Customers_Order_Change_Orders:34]CustID:2=<>sCombindID)
		
		If ([Estimates_Carton_Specs:19]CustID:6#"")
			qryFinishedGood([Estimates_Carton_Specs:19]CustID:6; [Customers_Order_Lines:41]ProductCode:5)
		Else 
			qryFinishedGood([Customers_Order_Lines:41]CustID:4; [Customers_Order_Lines:41]ProductCode:5)
		End if 
	Else 
		qryFinishedGood([Customers_Order_Change_Orders:34]CustID:2; [Customers_Order_Lines:41]ProductCode:5)
	End if 
	
	If (Records in selection:C76([Finished_Goods:26])=0)
		CREATE RECORD:C68([Finished_Goods:26])
		FG_Cspec2FG([Customers_Order_Lines:41]OrderNumber:1; 1)  //BAK 9/13/94 need to create F/G if CSpec not corrected
	End if 
	
	If ([Customers_Order_Lines:41]Price_Per_M:8#0)
		[Finished_Goods:26]LastPrice:27:=uNANCheck([Customers_Order_Lines:41]Price_Per_M:8)  //5/3/95
	End if 
	If ([Customers_Order_Lines:41]Cost_Per_M:7#0)
		[Finished_Goods:26]LastCost:26:=uNANCheck([Customers_Order_Lines:41]Cost_Per_M:7)  //5/3/95
	End if 
	If ([Customers_Order_Lines:41]OrderNumber:1#0)
		[Finished_Goods:26]LastOrderNo:18:=[Customers_Order_Lines:41]OrderNumber:1  //5/3/95
	End if 
	SAVE RECORD:C53([Finished_Goods:26])
	//end 5/8/95
	
Else 
	BEEP:C151
	ALERT:C41("CPN is empty on Orderline "+String:C10([Customers_Order_Lines:41]LineItem:2))
End if 
//