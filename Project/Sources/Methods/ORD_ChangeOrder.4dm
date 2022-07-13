//%attributes = {"publishedWeb":true}
//(P) ORD_ChangeOrder: Post Estimate to Change Order  was doChangeOrder 
//upr 1303 11/10/94
//12/13/94
//upr 1411 1/25/95
//UPR 1415, 02/10/95 chip
//upr 1268 chip 02/15/95
//upr 1437 2/20/95
//upr 1447 3/6/95
//3/13/95 jb request
// Modified by: Mel Bohince (6/18/13) make doChangeOrder return error code and clear rev-est if not zero error

C_LONGINT:C283(vord; $num_cspecs; $selected_dif; $i; OrdLineNo; $item_number; $i; $0; $err)
C_TEXT:C284($case; vCust; $1)
C_REAL:C285(vestP; vestC; vordP; vordC)

$err:=0  // ever the optimist

uSetUp(1; 1)  //uEnterOrder()
gClearFlags
READ WRITE:C146(filePtr->)
MESSAGES OFF:C175
sPONum:=$1  //the new estimate number
sLinkEst
Open window:C153(2; 40; 508; 338; 8; fNameWindow(filePtr))
DIALOG:C40([zz_control:1]; "ChgOrderEstLink")
[Customers_Order_Change_Orders:34]NewEstimate:38:=sPONum
ERASE WINDOW:C160
If (OK=1)
	vord:=[Customers_Order_Change_Orders:34]OrderNo:5
	vcust:=[Estimates:17]Cust_ID:2
	$selected_dif:=Find in array:C230(asBull; "•")
	$case:=asCaseID{$selected_dif}
	QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]Id:1=[Estimates:17]EstimateNo:1+$case)
	
	MESSAGE:C88(Char:C90(13)+" Checking c-spec items...")  //upr 1437 2/20/95
	QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=[Customers_Order_Change_Orders:34]NewEstimate:38; *)
	QUERY:C277([Estimates_Carton_Specs:19];  & ; [Estimates_Carton_Specs:19]diffNum:11=$case)
	CREATE SET:C116([Estimates_Carton_Specs:19]; "ChgDifferentialCartons")
	Ord_ResequenceCartonsIfGaps([Customers_Order_Change_Orders:34]NewEstimate:38; $case; "ChgDifferentialCartons")  // Modified by: Mel Bohince (2/1/17) 
	// Modified by: Mel Bohince (6/18/13) use same method that is in Ord_NewOrder
	$err:=Ord_CheckItemsForConsistency(""; ""; "ChgDifferentialCartons")
	If ($err=0)
		[Customers_Order_Change_Orders:34]NewBrand:42:=[Estimates:17]Brand:3  //12/13/94
		[Customers_Order_Change_Orders:34]NewCaseScenario:40:=$case
		
		MESSAGE:C88(Char:C90(13)+" Deleting existing Change Order Items...")
		RELATE MANY:C262([Customers_Order_Change_Orders:34]OrderChg_Items:6)
		util_DeleteSelection(->[Customers_Order_Changed_Items:176])
		
		MESSAGE:C88(Char:C90(13)+" Opening Change Order Base Items...")
		//first get all the line items of the order as it currently stands
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderNumber:1=[Customers_Order_Change_Orders:34]OrderNo:5)
			ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3; >)
			FIRST RECORD:C50([Customers_Order_Lines:41])
			
		Else 
			
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderNumber:1=[Customers_Order_Change_Orders:34]OrderNo:5)
			ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3; >)
			
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
			
			CREATE EMPTY SET:C140([Customers_Order_Changed_Items:176]; "addedChangeOrderItems")  //used by ORD_ChangeOrder_add_item below
			
		Else 
			
			ARRAY LONGINT:C221($_addedChangeOrderItems; 0)
			
		End if   // END 4D Professional Services : January 2019 
		
		$highestItemNumber:=0
		For ($i; 1; Records in selection:C76([Customers_Order_Lines:41]))
			MESSAGE:C88("."+String:C10($i))
			CREATE RECORD:C68([Customers_Order_Changed_Items:176])
			[Customers_Order_Changed_Items:176]id_added_by_converter:41:=[Customers_Order_Change_Orders:34]OrderChg_Items:6
			uLoadChgOrdItem  //upr 1447 3/6/95
			[Customers_Order_Changed_Items:176]NewQty:4:=0  //used for bringing down estimate items   
			[Customers_Order_Changed_Items:176]NewExcessQty:40:=0  //  `upr 1447 3/6/95
			SAVE RECORD:C53([Customers_Order_Changed_Items:176])
			If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
				
				ADD TO SET:C119([Customers_Order_Changed_Items:176]; "addedChangeOrderItems")
				
				
			Else 
				
				APPEND TO ARRAY:C911($_addedChangeOrderItems; Record number:C243([Customers_Order_Changed_Items:176]))
				
			End if   // END 4D Professional Services : January 2019 
			$lineNumber:=Num:C11([Customers_Order_Lines:41]LineItem:2)
			If ($lineNumber>$highestItemNumber)
				$highestItemNumber:=$lineNumber
			End if 
			NEXT RECORD:C51([Customers_Order_Lines:41])
		End for 
		
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
			
		Else 
			
			CREATE SET FROM ARRAY:C641([Customers_Order_Changed_Items:176]; $_addedChangeOrderItems; "addedChangeOrderItems")
			
		End if   // END 4D Professional Services : January 2019 
		
		//---- create items ----
		USE SET:C118("ChgDifferentialCartons")
		CLEAR SET:C117("ChgDifferentialCartons")
		$num_cspecs:=Records in selection:C76([Estimates_Carton_Specs:19])
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1; >)
			FIRST RECORD:C50([Estimates_Carton_Specs:19])
			
			
		Else 
			
			ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1; >)
			
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		MESSAGE:C88(Char:C90(13)+" Creating New Change Order Items...")
		If ($num_cspecs>0)
			//now going to merge by item# the new info from [Estimates_Carton_Specs] and create new items if necessary
			
			// Modified by: Mel Bohince (2/15/17) base it on product code since item numbers may have been re
			For ($cspec; 1; $num_cspecs)
				MESSAGE:C88("\r"+String:C10($cspec)+")."+[Estimates_Carton_Specs:19]Item:1+" "+[Estimates_Carton_Specs:19]ProductCode:5)
				$highestItemNumber:=ORD_ChangeOrder_add_item($highestItemNumber)
				NEXT RECORD:C51([Estimates_Carton_Specs:19])
			End for 
			
		Else 
			uConfirm("No carton specification were found, better check the results"; "OK"; "Help")
		End if   //no cartons   
		
		$item_number:=89
		If (rInclPrep=1)
			ORD_ChangeOrder_add_spl("Preparatory"; ->$item_number)
		End if 
		
		If (rInclDups=1)
			ORD_ChangeOrder_add_spl("Dupes"; ->$item_number)
		End if 
		
		If (rInclPlates=1)
			ORD_ChangeOrder_add_spl("Plates"; ->$item_number)
		End if 
		
		If (rInclDies=1)
			ORD_ChangeOrder_add_spl("Dies"; ->$item_number)
		End if 
		
		If (rInclPnD=1)
			ORD_ChangeOrder_add_spl("Plates and Dies"; ->$item_number)
		End if 
		
		If (rInclFrate=1)
			ORD_ChangeOrder_add_spl("SpecialFreight"; ->$item_number)
		End if 
		
		If (rInclCull=1)
			ORD_ChangeOrder_add_spl("Culling"; ->$item_number)
		End if 
		
		If (rInclOther=1)  //upr 1268 chip 02/15/95
			For ($i; 1; Size of array:C274(aOrdNum))
				MESSAGE:C88(<>sCR+"."+String:C10($item_number)+" Others")
				CREATE RECORD:C68([Customers_Order_Changed_Items:176])
				[Customers_Order_Changed_Items:176]id_added_by_converter:41:=[Customers_Order_Change_Orders:34]OrderChg_Items:6
				[Customers_Order_Changed_Items:176]ItemNo:1:=$item_number
				[Customers_Order_Changed_Items:176]NewProductCode:10:=aOrdType{$i}
				[Customers_Order_Changed_Items:176]NewQty:4:=aOrdQty{$i}
				[Customers_Order_Changed_Items:176]NewCost:14:=aOrdCost{$i}
				[Customers_Order_Changed_Items:176]NewPrice:5:=aOrdCost{$i}
				[Customers_Order_Changed_Items:176]SpecialBilling:38:=True:C214
				[Customers_Order_Changed_Items:176]NewClassificati:35:="27"
				SAVE RECORD:C53([Customers_Order_Changed_Items:176])
				$item_number:=$item_number+1
			End for 
		End if 
		
		fLoop:=False:C215
		iMode:=2
		ARRAY TEXT:C222(aBilltos; 0)
		ARRAY TEXT:C222(aShiptos; 0)
		
		<>EstStatus:="Ordered"
		<>EstNo:=[Estimates:17]EstimateNo:1
		$id:=New process:C317("uChgEstStatus"; <>lMinMemPart; "Estimate Status Change")
		If (False:C215)
			uChgEstStatus
		End if 
		
	Else   //item on multiform errr
		$err:=3
	End if 
	
Else 
	$err:=2
End if   //if OK=1
CLOSE WINDOW:C154
MESSAGES ON:C181

CLEAR SET:C117("addedChangeOrderItems")
RELATE MANY:C262([Customers_Order_Change_Orders:34]OrderChg_Items:6)
ORDER BY:C49([Customers_Order_Changed_Items:176]; [Customers_Order_Changed_Items:176]ItemNo:1; >)

$0:=$err