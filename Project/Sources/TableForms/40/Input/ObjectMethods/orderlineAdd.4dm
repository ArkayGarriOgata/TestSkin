//(s) bAddPS [custord]input pg 1
//mod 4/19/95 chip
//•051595  MLB  UPR 1508
//•071195  MLB  UPR §
//•110195
//•021997  MLB  UPR 1853 add qty Open
//•111298  MLB  fix OL key
C_TEXT:C284($Cpn)
C_REAL:C285(r1; r2; r3; r4; r5; r6; r7)  //the item, class, qty, cost, & price of the spl billing item
C_TEXT:C284(sDesc)
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
	
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
		
		CREATE SET:C116([Customers_Order_Lines:41]; "OL")  //110195
		
	Else 
		
		ARRAY LONGINT:C221($_OL; 0)
		SELECTION TO ARRAY:C260([Customers_Order_Lines:41]; $_OL)
		
	End if   // END 4D Professional Services : January 2019 
	
Else 
	
	ARRAY LONGINT:C221($_OL; 0)
	LONGINT ARRAY FROM SELECTION:C647([Customers_Order_Lines:41]; $_OL)
	
	
End if   // END 4D Professional Services : January 2019 

$winRef:=OpenSheetWindow(->[zz_control:1]; "NewOrdItem")
DIALOG:C40([zz_control:1]; "NewOrdItem")

If (OK=1)
	
	If (bPick=1)  //spl billing
		i1:=OL_incrementItemNumber
		$i:=sMakeSplOrdLn
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
			
			ADD TO SET:C119([Customers_Order_Lines:41]; "OL")
			
			
		Else 
			
			APPEND TO ARRAY:C911($_OL; Record number:C243([Customers_Order_Lines:41]))
			
		End if   // END 4D Professional Services : January 2019 
		fItemChg:=True:C214
		
	Else 
		$cpn:=Substring:C12(Request:C163("Enter Product Code (20 Characters Max):"; ""); 1; 20)
		If (ok=1) & ($cpn#"")
			qryFinishedGood([Customers_Orders:40]CustID:2; $cpn)  //•110195
			
			If (Records in selection:C76([Finished_Goods:26])=0)
				FG_SelectFromList([Customers_Orders:40]CustID:2)
				If (Records in selection:C76([Finished_Goods:26])=1)
					$cpn:=[Finished_Goods:26]ProductCode:1
				End if 
			End if 
			
			If (Records in selection:C76([Finished_Goods:26])>0)
				i1:=OL_incrementItemNumber
				CREATE RECORD:C68([Customers_Order_Lines:41])
				uLinesLikeOrder
				[Customers_Order_Lines:41]LineItem:2:=i1
				[Customers_Order_Lines:41]OrderLine:3:=fMakeOLkey([Customers_Order_Lines:41]OrderNumber:1; i1)  //•111298  MLB 
				[Customers_Order_Lines:41]ProductCode:5:=Substring:C12($cpn; 1; 20)
				[Customers_Order_Lines:41]SpecialBilling:37:=[Finished_Goods:26]SpecialBilling:23  //•052599  mlb 
				[Customers_Order_Lines:41]CostOH_Per_M:31:=[Finished_Goods:26]LastCost:26  //•071495  MLB  UPR §
				[Customers_Order_Lines:41]Classification:29:=[Finished_Goods:26]ClassOrType:28  //•110195
				// [OrderLines]Cost_Per_M:=[Finished_Goods]LastCost`•111495  MLB  UPR §
				If ([Finished_Goods:26]RKContractPrice:49#0)
					[Customers_Order_Lines:41]Price_Per_M:8:=[Finished_Goods:26]RKContractPrice:49
				Else 
					[Customers_Order_Lines:41]Price_Per_M:8:=[Finished_Goods:26]LastPrice:27  //110195
				End if 
				
				[Customers_Order_Lines:41]CustID:4:=[Customers_Orders:40]CustID:2
				If ([Customers_Orders:40]IsContract:52)  //•111398  MLB  
					[Customers_Order_Lines:41]Status:9:="CONTRACT"
					[Customers_Order_Lines:41]PONumber:21:=""
				Else 
					[Customers_Order_Lines:41]Status:9:="Opened"
				End if 
				[Customers_Order_Lines:41]DateOpened:13:=4D_Current_date
				[Customers_Order_Lines:41]Quantity:6:=r3  //•111495  MLB 
				[Customers_Order_Lines:41]Qty_Open:11:=r3  //•021997  MLB  UPR 1853 
				If (r5#0)
					[Customers_Order_Lines:41]Price_Per_M:8:=r5  //•051595  MLB  UPR 1508
				End if 
				[Customers_Order_Lines:41]CostMatl_Per_M:32:=r4  //•071495  MLB  UPR §
				[Customers_Order_Lines:41]CostLabor_Per_M:30:=r6  //•071495  MLB  UPR §
				[Customers_Order_Lines:41]CostOH_Per_M:31:=r7  //•071495  MLB  UPR §
				[Customers_Order_Lines:41]Cost_Per_M:7:=r4+r6+r7  //•071495  MLB  UPR §        
				SAVE RECORD:C53([Customers_Order_Lines:41])
				If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
					
					ADD TO SET:C119([Customers_Order_Lines:41]; "OL")
					
				Else 
					
					APPEND TO ARRAY:C911($_OL; Record number:C243([Customers_Order_Lines:41]))
					
				End if   // END 4D Professional Services : January 2019 
				
				fItemChg:=True:C214
			End if   //ok to request
			
		End if 
		
	End if 
	
	UNLOAD RECORD:C212([Finished_Goods:26])
	
	//SEARCH([OrderLines];[OrderLines]Order=[CustomerOrder]OrderNumber)
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
		
		USE SET:C118("OL")
		
	Else 
		
		CREATE SELECTION FROM ARRAY:C640([Customers_Order_Lines:41]; $_OL)
		
	End if   // END 4D Professional Services : January 2019 
	Invoice_SetInvoiceBtnState
	ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3; >)
	
End if   //not canceled
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
	
	CLEAR SET:C117("OL")
	
Else 
	
	
End if   // END 4D Professional Services : January 2019 

If (fItemChg)
	rReal1:=fTotalOrderLine
End if 
//