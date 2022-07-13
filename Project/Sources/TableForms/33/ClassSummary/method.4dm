//(LP)[FG_Transactions.ClassSummary
//mod 9/13/94 upr 120
//mod 9/14/94 negate returns
//upr 1309  11/7/94
//3/28/95 don't loop through multiple jmi's
//•101395  MLB  match to Cost of Sales By Job report
//111695 jb asked for it
//•070198  MLB  added to include B&H
Case of 
	: (Form event code:C388=On Display Detail:K2:22)  //each ORDER record    
		MESSAGES OFF:C175
		real1:=0
		real2:=0
		real3:=0
		real4:=0
		real5:=0
		real6:=0
		real7:=0
		real8:=0
		real9:=0
		real10:=0
		real11:=0
		rqty:=0
		//sCriterion6:=aOL2{$i}+"/"+String(aRel2{$i};"00000")
		If ([Customers_Order_Lines:41]OrderLine:3#Substring:C12([Finished_Goods_Transactions:33]OrderItem:16; 1; 8))
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=Substring:C12([Finished_Goods_Transactions:33]OrderItem:16; 1; 8))  //•101395  MLB  
		End if 
		//SEARCH([ReleaseSchedule];[ReleaseSchedule]ReleaseNumber=Num(Substring([FG_Transa
		Case of 
			: ([Finished_Goods_Transactions:33]XactionType:2="Ship")
				rqty:=[Finished_Goods_Transactions:33]Qty:6
			: ([Finished_Goods_Transactions:33]XactionType:2="B&H@")  //•070198  MLB   fix for the recent inclusion of B&H
				rqty:=[Finished_Goods_Transactions:33]Qty:6
			Else   //treat as a return
				rqty:=-[Finished_Goods_Transactions:33]Qty:6
		End case 
		
		READ ONLY:C145([Finished_Goods:26])
		C_LONGINT:C283($denom)
		qryFinishedGood([Finished_Goods_Transactions:33]CustID:12; [Finished_Goods_Transactions:33]ProductCode:1)
		//11/18/94
		If ([Finished_Goods:26]Acctg_UOM:29="M")
			$denom:=1000
		Else 
			$denom:=1
		End if 
		
		Case of   //•101395  MLB  
			: ([Finished_Goods_Transactions:33]JobForm:5="PriceChg")  //2/10/95 (set by uInvoAdjustment)
				uClearSelection(->[Job_Forms_Items:44])
				$denom:=1
				
			: ([Customers_Order_Lines:41]SpecialBilling:37)  //•101395  MLB  
				uClearSelection(->[Job_Forms_Items:44])
				$denom:=1  //111695 jb asked for it
				
			: ([Finished_Goods_Transactions:33]Reason:26="Overshipment")  //•021696  mBohince  shd be -qty, -extPrc, 0 costs
				uClearSelection(->[Job_Forms_Items:44])
				
			Else 
				qryJMI([Finished_Goods_Transactions:33]JobForm:5; [Finished_Goods_Transactions:33]JobFormItem:30)  //•101395  MLB  
				
		End case 
		
		
		real1:=real1+Round:C94(((rqty/$denom)*[Finished_Goods_Transactions:33]PricePerM:19); 2)  //accumulate total allowable 
		If ([Finished_Goods_Transactions:33]Reason:26="Overshipment")  //•021696  mBohince  shd be -qty, -extPrc, 0 costs
			rqty:=-[Finished_Goods_Transactions:33]Qty:6
		End if 
		
		// While (Not(End selection([JobMakesItem])))  `3/28/95 don't loop through multipl
		If (Records in selection:C76([Job_Forms_Items:44])#0)
			real2:=real2+Round:C94(([Job_Forms_Items:44]PldCostMatl:17*(rqty/$denom)); 0)
			real3:=real3+Round:C94(([Job_Forms_Items:44]PldCostLab:18*(rqty/$denom)); 0)
			real4:=real4+Round:C94(([Job_Forms_Items:44]PldCostOvhd:19*(rqty/$denom)); 0)
			real6:=real6+Round:C94(([Job_Forms_Items:44]PldCostS_E:20*(rqty/$denom)); 0)
			// NEXT RECORD([JobMakesItem])
			//End while 
		Else 
			If ([Customers_Order_Lines:41]SpecialBilling:37)  //•101395  MLB  see also 1508
				real2:=real2+0
				real3:=real3+0
				real4:=real4+Round:C94(([Customers_Order_Lines:41]Cost_Per_M:7*(rqty/$denom)); 0)
				real6:=real6+0
			End if 
		End if 
		real9:=real2+real3+real4
		// real10:=(1-(real9/real1))*100`•061998  MLB  
		$rebate:=fGetCustRebate([Customers_Order_Lines:41]CustID:4)  //•061998  MLB 
		real10:=fProfitVariable("PV"; real9; real1; 0; $rebate)  //•061998  MLB 
		
		MESSAGES ON:C181
End case 
//