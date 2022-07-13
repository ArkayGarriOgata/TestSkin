//%attributes = {"publishedWeb":true}
//PM: FG_PrepSetupBill(controlnumber) -> 
//@author mlb - 7/5/01  12:21

C_TEXT:C284($1)
C_LONGINT:C283(vOrd; $i; $0; cb1; cb2; cb3; i1; i2; i3; b1; b2)
C_REAL:C285($totalCost; $totalPrice; rDistributed; r1; r2; r3; r4; r5; r6; r7)
C_POINTER:C301($qtyToUse)

rDistributed:=0
$0:=0

READ WRITE:C146([Customers_Orders:40])
READ WRITE:C146([Prep_Charges:103])
READ WRITE:C146([Customers:16])
READ ONLY:C145([Prep_CatalogItems:102])

CUT NAMED SELECTION:C334([Prep_Charges:103]; "hold")
$num:=FG_PrepServiceTotalCharges([Finished_Goods_Specifications:98]ControlNumber:2; ->r1; ->r2; ->r3)
USE NAMED SELECTION:C332("hold")

If ([Finished_Goods_Specifications:98]ControlNumber:2#$1)
	QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ControlNumber:2=$1)
	QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=[Finished_Goods_Specifications:98]FG_Key:1)
Else 
	SAVE RECORD:C53([Finished_Goods_Specifications:98])
	SAVE RECORD:C53([Finished_Goods:26])
End if 

If ([Finished_Goods_Specifications:98]DatePrepDone:6#!00-00-00!)
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
		
		COPY NAMED SELECTION:C331([Finished_Goods_Specifications:98]; "holdSpec")
		COPY NAMED SELECTION:C331([Finished_Goods:26]; "holdFG")
		
	Else 
		
		ARRAY LONGINT:C221($_holdSpec; 0)
		ARRAY LONGINT:C221($_holdFG; 0)
		LONGINT ARRAY FROM SELECTION:C647([Finished_Goods_Specifications:98]; $_holdSpec)
		LONGINT ARRAY FROM SELECTION:C647([Finished_Goods:26]; $_holdFG)
		
	End if   // END 4D Professional Services : January 2019 
	
	zwStatusMsg("ORDERING"; " Specify how you would like to handle the order")
	$winRef:=Open form window:C675([Finished_Goods_Specifications:98]; "MakeOrder"; 5)
	DIALOG:C40([Finished_Goods_Specifications:98]; "MakeOrder")  //present some options
	CLOSE WINDOW:C154($winRef)
	If (OK=1)
		zwStatusMsg("ORDERING"; " Processing Prep Order...")
		$custid:=Substring:C12([Finished_Goods_Specifications:98]FG_Key:1; 1; 5)
		QUERY:C277([Customers:16]; [Customers:16]ID:1=$custid)
		
		Case of 
			: (i0=1)
				
			: (i1=1)
				vOrd:=FG_PrepSetupBillHeader($custid)
				$existingLineItems:=0
				
			: (i2=1)
				uUpdateTrail(->[Customers_Orders:40]ModDate:9; ->[Customers_Orders:40]ModWho:8)
				RELATE MANY:C262([Customers_Orders:40]OrderNumber:1)
				$existingLineItems:=Records in selection:C76([Customers_Order_Lines:41])
				
			: (i3=1)
				If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
					
					RELATE MANY:C262([Finished_Goods_Specifications:98]ControlNumber:2)
					FIRST RECORD:C50([Prep_Charges:103])
					
					
				Else 
					
					RELATE MANY:C262([Finished_Goods_Specifications:98]ControlNumber:2)
					//see previous line
					
					
				End if   // END 4D Professional Services : January 2019 First record
				// 4D Professional Services : after Order by , query or any query type you don't need First record  
				APPLY TO SELECTION:C70([Prep_Charges:103]; [Prep_Charges:103]OrderNumber:8:=vOrd)
				
			Else 
				BEEP:C151
				BEEP:C151
		End case 
		
		Case of 
			: (i0=1)
				//do nothing here
			: (i3=1)
				//do nothing here        
			: (cb2=1)
				$qtyToUse:=->[Prep_Charges:103]QuantityActual:3
			: (cb1=1)
				$qtyToUse:=->[Prep_Charges:103]QuantityQuoted:2
			: (cb3=1)
				$qtyToUse:=->[Prep_Charges:103]QuantityRevised:10
			Else 
				$qtyToUse:=->[Prep_Charges:103]QuantityActual:3
		End case 
		
		Case of 
			: (i0=1)
				//do nothing here either 
			: (i3=1)
				//do nothing here either 
				
			: (b2=1)
				If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
					
					RELATE MANY:C262([Finished_Goods_Specifications:98]ControlNumber:2)
					ORDER BY:C49([Prep_Charges:103]; [Prep_Charges:103]PrepItemNumber:4; >)
					FIRST RECORD:C50([Prep_Charges:103])
					
					
				Else 
					
					RELATE MANY:C262([Finished_Goods_Specifications:98]ControlNumber:2)
					ORDER BY:C49([Prep_Charges:103]; [Prep_Charges:103]PrepItemNumber:4; >)
					
				End if   // END 4D Professional Services : January 2019 First record
				// 4D Professional Services : after Order by , query or any query type you don't need First record  
				$totalPrice:=0  //tally orders value and cost
				$totalCost:=0
				FG_PrepSetupBillDetail(vOrd; 1+$existingLineItems; $custid)
				[Customers_Order_Lines:41]Quantity:6:=1
				[Customers_Order_Lines:41]Qty_Open:11:=[Customers_Order_Lines:41]Quantity:6
				
				For ($i; 1; Records in selection:C76([Prep_Charges:103]))
					QUERY:C277([Prep_CatalogItems:102]; [Prep_CatalogItems:102]ItemNumber:1=[Prep_Charges:103]PrepItemNumber:4)
					If (($qtyToUse->)>0)
						[Customers_Order_Lines:41]InvoiceComment:43:=[Customers_Order_Lines:41]InvoiceComment:43+Char:C90(13)+"("+String:C10($qtyToUse->)+") "+[Prep_CatalogItems:102]Description:2+" @"+String:C10([Prep_CatalogItems:102]Price:4)+" EA."
						
						[Customers_Order_Lines:41]Cost_Per_M:7:=[Customers_Order_Lines:41]Cost_Per_M:7+[Prep_CatalogItems:102]Cost:3
						[Customers_Order_Lines:41]CostOH_Per_M:31:=[Customers_Order_Lines:41]Cost_Per_M:7
						[Customers_Order_Lines:41]Price_Per_M:8:=[Customers_Order_Lines:41]Price_Per_M:8+[Prep_CatalogItems:102]Price:4
						
						$totalPrice:=$totalPrice+($qtyToUse->*[Prep_CatalogItems:102]Price:4)
						$totalCost:=$totalCost+($qtyToUse->*[Prep_CatalogItems:102]Cost:3)
					End if 
					[Prep_Charges:103]OrderNumber:8:=vOrd
					SAVE RECORD:C53([Prep_Charges:103])
					NEXT RECORD:C51([Prep_Charges:103])
				End for 
				
				[Customers_Order_Lines:41]Cost_Per_M:7:=$totalCost
				[Customers_Order_Lines:41]CostOH_Per_M:31:=$totalCost
				[Customers_Order_Lines:41]Price_Per_M:8:=$totalPrice
				SAVE RECORD:C53([Customers_Order_Lines:41])
				
				$numFG:=qryFinishedGood("#PREP"; [Customers_Order_Lines:41]ProductCode:5)
				If ($numFG=0)  //4/26/95 chip
					r4:=[Prep_CatalogItems:102]Cost:3
					r5:=[Prep_CatalogItems:102]Price:4
					r6:=0
					r7:=0
					ORD_AddSpecialFG(vOrd; [Prep_CatalogItems:102]Description:2)
				End if 
				
			: (b1=1)
				If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
					
					RELATE MANY:C262([Finished_Goods_Specifications:98]ControlNumber:2)
					ORDER BY:C49([Prep_Charges:103]; [Prep_Charges:103]PrepItemNumber:4; >)
					FIRST RECORD:C50([Prep_Charges:103])
					
					
				Else 
					
					RELATE MANY:C262([Finished_Goods_Specifications:98]ControlNumber:2)
					ORDER BY:C49([Prep_Charges:103]; [Prep_Charges:103]PrepItemNumber:4; >)
					
				End if   // END 4D Professional Services : January 2019 First record
				// 4D Professional Services : after Order by , query or any query type you don't need First record  
				$totalPrice:=0  //tally orders value and cost
				$totalCost:=0
				For ($i; 1; Records in selection:C76([Prep_Charges:103]))
					If (($qtyToUse->)>0)
						FG_PrepSetupBillDetail(vOrd; $i+$existingLineItems; $custid)
						QUERY:C277([Prep_CatalogItems:102]; [Prep_CatalogItems:102]ItemNumber:1=[Prep_Charges:103]PrepItemNumber:4)
						$pCode:=Substring:C12([Prep_CatalogItems:102]Description:2; 1; 20)  //[CARTON_SPEC]ProductCode
						[Customers_Order_Lines:41]ProductCode:5:=$pCode
						[Customers_Order_Lines:41]Quantity:6:=$qtyToUse->
						If ([Customers_Order_Lines:41]Quantity:6<1)
							[Customers_Order_Lines:41]Quantity:6:=1
						End if 
						[Customers_Order_Lines:41]Qty_Open:11:=[Customers_Order_Lines:41]Quantity:6
						[Customers_Order_Lines:41]Cost_Per_M:7:=[Prep_CatalogItems:102]Cost:3
						[Customers_Order_Lines:41]CostOH_Per_M:31:=[Prep_CatalogItems:102]Cost:3  //•071495  MLB  UPR 222
						[Customers_Order_Lines:41]Price_Per_M:8:=[Prep_CatalogItems:102]Price:4
						$totalPrice:=$totalPrice+($qtyToUse->*[Customers_Order_Lines:41]Price_Per_M:8)
						$totalCost:=$totalCost+($qtyToUse->*[Customers_Order_Lines:41]Cost_Per_M:7)
						SAVE RECORD:C53([Customers_Order_Lines:41])
						
						$numFG:=qryFinishedGood("#PREP"; $pCode)
						If ($numFG=0)  //4/26/95 chip
							r4:=[Prep_CatalogItems:102]Cost:3
							r5:=[Prep_CatalogItems:102]Price:4
							r6:=0
							r7:=0
							ORD_AddSpecialFG(vOrd; [Prep_CatalogItems:102]Description:2)
						End if 
					End if 
					[Prep_Charges:103]OrderNumber:8:=vOrd
					SAVE RECORD:C53([Prep_Charges:103])
					NEXT RECORD:C51([Prep_Charges:103])
				End for 
				
		End case 
		
		If (i3=0) & (i0=0)  //orderline(s) were created
			//*Post booking info
			[Customers_Orders:40]EstSalesValue:18:=$totalPrice
			[Customers_Orders:40]OrderSalesTotal:19:=$totalPrice
			[Customers_Orders:40]BudgetCostTotal:20:=$totalCost
			[Customers_Orders:40]PV:21:=Round:C94(fProfitVariable("PV"; $totalCost; $totalPrice; 0; 0); 3)
			SAVE RECORD:C53([Customers_Orders:40])  //*.          SAVE THE ORDER
			
			[Customers:16]Active:15:=True:C214  //update the customer
			[Customers:16]ModAddress:35:=4D_Current_date
			[Customers:16]ModFlag:37:=True:C214
			[Customers:16]Open_Orders:34:=[Customers:16]Open_Orders:34+$totalPrice
			SAVE RECORD:C53([Customers:16])
			
			CREATE SET:C116([Customers_Orders:40]; "◊PassThroughSet")
			$sFile:=sFile  //cover a side effect of Viewsetter
			<>PassThrough:=True:C214
			ViewSetter(2; ->[Customers_Orders:40])
			sFile:=$sFile  //Table name(->[Request])  `reset this for normal exit
			zwStatusMsg("ORDERING"; " Please enter PO and Billto, then Accept and Invoice.")
		Else 
			zwStatusMsg("ORDERING"; " Distribution Complete")
		End if   //i3
		
		REDUCE SELECTION:C351([Customers:16]; 0)
		REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
		REDUCE SELECTION:C351([Customers_Orders:40]; 0)
		REDUCE SELECTION:C351([Prep_Charges:103]; 0)
		REDUCE SELECTION:C351([Prep_CatalogItems:102]; 0)
		
		$0:=vOrd
		If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
			
			USE NAMED SELECTION:C332("holdSpec")
			USE NAMED SELECTION:C332("holdFG")
			CLEAR NAMED SELECTION:C333("holdSpec")
			CLEAR NAMED SELECTION:C333("holdFG")
			
		Else 
			
			CREATE SELECTION FROM ARRAY:C640([Finished_Goods_Specifications:98]; $_holdSpec)
			CREATE SELECTION FROM ARRAY:C640([Finished_Goods:26]; $_holdFG)
			
			
		End if   // END 4D Professional Services : January 2019 
		
	End if   //not canceled
	
Else 
	BEEP:C151
	ALERT:C41("You can't set up the Customer Order until the Prep is marked as Done.")
	$0:=0
End if 