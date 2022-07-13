// ----------------------------------------------------
// User name (OS): MLB
// ----------------------------------------------------
// Object Method: [Customers_Orders].Input.Variable37
// ----------------------------------------------------
//`Script: asOrdStat
//•051595  MLB  UPR 1508 
//•060195  MLB  UPR 184
//•062695  MLB 
//•071295  MLB  UPR 223
//•092595  MLB  can't chg est stat to ordered on prep
//•110795  MLB 1764
//• 3/6/98 cs added this code to check for locked records during 
//   order item status up date

C_TEXT:C284($oldStat)
$oldStat:=[Customers_Orders:40]Status:10

If (util_PopUpDropDownAction(->asOrdStat; ->[Customers_Orders:40]Status:10))
	SELECTION TO ARRAY:C260([Customers_Order_Lines:41]Classification:29; $aClass; [Customers_Order_Lines:41]defaultBillto:23; $aBillto)
	$hit:=Find in array:C230($aClass; "")
	If ($hit>-1)
		$missingClass:=True:C214
	Else 
		$missingClass:=False:C215
	End if 
	
	$hit:=Find in array:C230($aBillto; "")
	If ($hit>-1)
		$missingBillto:=True:C214
	Else 
		$missingBillto:=False:C215
	End if 
	
	Case of 
		: ([Customers_Orders:40]Status:10="Opened") & (Not:C34(User in group:C338(Current user:C182; "CustomerOrdering")))  //BAK 8/30/94 was "CO_Approval"
			[Customers_Orders:40]Status:10:=$oldStat
			uConfirm("Must be in 'CustomerOrdering' to Open a Customer Order!"; "OK"; "Help")
		: ([Customers_Orders:40]Status:10="Accepted") & (Not:C34(User in group:C338(Current user:C182; "CO_Approval")))
			[Customers_Orders:40]Status:10:=$oldStat
			uConfirm("Must be in 'CO_Approval' to Accept a Customer Order!"; "OK"; "Help")
		: ([Customers_Orders:40]Status:10="Rejected") & (Not:C34(User in group:C338(Current user:C182; "CO_Approval")))
			[Customers_Orders:40]Status:10:=$oldStat
			uConfirm("Must be in 'CO_Approval' to Reject a Customer Order!"; "OK"; "Help")
			
		: ([Customers_Orders:40]Status:10="Accepted") & ([Customers_Orders:40]CustomerLine:22="")  //•110795  MLB 1764
			[Customers_Orders:40]Status:10:=$oldStat
			uConfirm("Must have a 'Brand/Line' to Accept a Customer Order!"; "OK"; "Help")
			
		: ([Customers_Orders:40]Status:10="Accepted") & ([Customers_Orders:40]defaultBillTo:5="")  //•110795  MLB 1764
			[Customers_Orders:40]Status:10:=$oldStat
			uConfirm("Must have a 'BillTO' to Accept a Customer Order!"; "OK"; "Help")
			
		: ([Customers_Orders:40]Status:10="Accepted") & ($missingBillto)  //•110795  MLB 1764
			[Customers_Orders:40]Status:10:=$oldStat
			uConfirm("Must have a 'BillTO' on each Orderline to Accept a Customer Order!"; "OK"; "Help")
			
		: ([Customers_Orders:40]Status:10="Accepted") & ($missingClass)  //•110795  MLB 1764
			[Customers_Orders:40]Status:10:=$oldStat
			uConfirm("Must have a 'FG Classification' on each Orderline to Accept a Customer Order!"; "OK"; "Help")
			
		Else 
			ChgCOrderStatus($oldStat)
	End case 
	
	Case of 
		: ([Customers_Orders:40]Status:10="hold")
			OBJECT SET ENABLED:C1123(bValidate; True:C214)
			
		: ([Customers_Orders:40]Status:10="Opened")
			OBJECT SET ENABLED:C1123(CreateCO; False:C215)
			OBJECT SET ENABLED:C1123(EditCO; False:C215)
		: ([Customers_Orders:40]Status:10="New")
			OBJECT SET ENABLED:C1123(CreateCO; False:C215)
			OBJECT SET ENABLED:C1123(EditCO; False:C215)
		: ([Customers_Orders:40]Status:10="CONTRACT")  //•060195  MLB  UPR 184
			OBJECT SET ENABLED:C1123(CreateCO; False:C215)
			OBJECT SET ENABLED:C1123(EditCO; False:C215)
		Else   // lock it down, must now use cco
			OBJECT SET ENABLED:C1123(bAddPS; False:C215)
			OBJECT SET ENABLED:C1123(bDelPS; False:C215)
			SetObjectProperties(""; ->bEditpspec; True:C214; "View")  // Modified by: Mark Zinke (5/15/13)
			OBJECT SET ENABLED:C1123(bUp; False:C215)
			OBJECT SET ENABLED:C1123(bDown; False:C215)
			OBJECT SET ENABLED:C1123(bUp2; False:C215)
			OBJECT SET ENABLED:C1123(bDown2; False:C215)
			OBJECT SET ENABLED:C1123(bZoomBill; False:C215)
			OBJECT SET ENABLED:C1123(bZoomBill2; False:C215)
			uSetEntStatus(->[Customers_Orders:40]; False:C215)
			
			SetObjectProperties(""; ->[Customers_Orders:40]PONumber:11; True:C214; ""; True:C214)
			ARRAY TEXT:C222(aBrand; 1)
			aBrand{1}:=[Customers_Orders:40]CustomerLine:22
			aBrand:=1
	End case 
	
	If (([Customers_Orders:40]Status:10#"Accepted") | ([Customers_Orders:40]Status:10#"Budgeted"))
		OBJECT SET ENABLED:C1123(PrtOrdAckn; False:C215)
		
	Else 
		OBJECT SET ENABLED:C1123(PrtOrdAckn; True:C214)
		If (([Customers_Orders:40]Status:10="Accepted") & ($oldStat#"Accepted"))  //2/14/95
			<>EstStatus:="Accepted Order"
			<>EstNo:=[Customers_Orders:40]EstimateNo:3
			OBJECT SET ENABLED:C1123(CreateCO; True:C214)
			OBJECT SET ENABLED:C1123(EditCO; True:C214)
			// If (◊EstNo#"0-0000.00")  `•062695  MLB 
			If ([Customers_Orders:40]CaseScenario:4#"**")  //•092595  MLB      
				$id:=New process:C317("uChgEstStatus"; <>lMinMemPart; "Estimate Status Change")
			End if 
			
		End if 
		Invoice_SetInvoiceBtnState  //•051595  MLB  UPR 1508 added here
	End if 
	
	If ([Customers_Orders:40]Status:10#$oldStat)
		uConfirm("Apply this status change to the order's lines?"; "Yes"; "Do manually")
		If (ok=1)
			If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
				
				COPY NAMED SELECTION:C331([Customers_Order_Lines:41]; "before")  //•071295  MLB  UPR 223
				
			Else 
				
				ARRAY LONGINT:C221($_before; 0)
				LONGINT ARRAY FROM SELECTION:C647([Customers_Order_Lines:41]; $_before)
				
			End if   // END 4D Professional Services : January 2019 
			
			// ******* Verified  - 4D PS - January  2019 ********
			
			QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9=$oldStat)  // only get the ones that match
			
			
			// ******* Verified  - 4D PS - January 2019 (end) *********
			Repeat   //• 3/6/98 cs added this code to check for locked records during this command
				APPLY TO SELECTION:C70([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9:=[Customers_Orders:40]Status:10)
			Until (uChkLockedSet(->[Customers_Order_Lines:41]))
			If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
				
				USE NAMED SELECTION:C332("before")
				CLEAR NAMED SELECTION:C333("before")
				
			Else 
				
				CREATE SELECTION FROM ARRAY:C640([Customers_Order_Lines:41]; $_before)
				
			End if   // END 4D Professional Services : January 2019 
			
		End if 
	End if 
	
End if 
util_ComboBoxSetup(->asOrdStat; [Customers_Orders:40]Status:10)