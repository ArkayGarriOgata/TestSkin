//%attributes = {"publishedWeb":true}
//fCOrderRules4
//upr 1221 11/22/94
//fax 12/22/94
//2/14/95 upr 1326
//2/15/95
//•051595  MLB  UPR 1508
//•060195  MLB  UPR 184
//•071295  MLB  UPR 223
//•102396    fix if branching
//•102896   ( re?)-allow contracts to be set back to open|new so they may be delet
//•061797  mBohince  allow an orderline to be "UN"-closed
//•062497  MLB  make sure orderlines aren't looped when called by orderline
//•112697  MLB  set DateBooked when contracts are accepted
// Modified by Mel Bohince on 1/17/07 at 10:32:47 : always recalc when contract to accept
//•060311  mBohince  make sure contract items are treated as such
// Modified by: Mel Bohince (5/28/19) ignore spl billing orderlines, these will be in EA uom
// Modified by: MelvinBohince (1/12/22) validate defaultBillto before Accepting the booking

C_LONGINT:C283($shipped; $i)
C_BOOLEAN:C305($0; $viaOrderHdr; $is_contract)
C_TEXT:C284($1; $newStat)  //old status/new status
C_POINTER:C301($2)  //status field of either the order or the orderline

$newStat:=$2->
$oldStat:=$1
$0:=True:C214
$viaOrderHdr:=(Field:C253($2)=10)  //•062497  MLB  Status is fld 10 in hdr, fld 9 in lines
$is_contract:=False:C215

Case of 
	: ($newStat="Accepted")  //•062497  MLB check for prerequists to enter this status
		ARRAY TEXT:C222($aClassif; 0)
		ARRAY TEXT:C222($aLine; 0)
		ARRAY TEXT:C222($aPO; 0)
		ARRAY TEXT:C222($aCPN; 0)
		ARRAY TEXT:C222($aCust; 0)
		ARRAY TEXT:C222($aBillTo; 0)  // Modified by: MelvinBohince (1/12/22) 
		
		If ($viaOrderHdr)
			If (ELC_isEsteeLauderCompany([Customers_Orders:40]CustID:2))
				$is_contract:=FG_is_Contract_Item([Customers_Orders:40]CustID:2; [Customers_Orders:40]CustomerLine:22)
				If ($is_contract)
					If ($oldStat#"CONTRACT")
						uConfirm("Contract Line detected on Brand record, treating order as contract."; "OK"; "Help")
						$oldStat:="CONTRACT"
					End if 
				End if 
			End if 
			SELECTION TO ARRAY:C260([Customers_Order_Lines:41]Classification:29; $aClassif; [Customers_Order_Lines:41]CustomerLine:42; $aLine; [Customers_Order_Lines:41]PONumber:21; $aPO; [Customers_Order_Lines:41]ProductCode:5; $aCPN; [Customers_Order_Lines:41]CustID:4; $aCust; [Customers_Order_Lines:41]defaultBillto:23; $aBillTo)
		Else 
			ARRAY TEXT:C222($aClassif; 1)
			ARRAY TEXT:C222($aLine; 1)
			ARRAY TEXT:C222($aPO; 1)
			ARRAY TEXT:C222($aCPN; 1)
			ARRAY TEXT:C222($aCust; 1)  // Added by: Mark Zinke (3/27/13)
			ARRAY TEXT:C222($aBillTo; 1)  // Modified by: MelvinBohince (1/12/22) 
			
			$aClassif{1}:=[Customers_Order_Lines:41]Classification:29
			$aLine{1}:=[Customers_Order_Lines:41]CustomerLine:42
			$aPO{1}:=[Customers_Order_Lines:41]PONumber:21
			$aCPN{1}:=[Customers_Order_Lines:41]ProductCode:5
			$aCust{1}:=[Customers_Order_Lines:41]CustID:4
			$aBillTo{1}:=[Customers_Order_Lines:41]defaultBillto:23
		End if 
		
		For ($i; 1; Size of array:C274($aClassif))
			
			$failedTests:=True:C214  //must have FG Classification, Line, PO, & valid Billto
			Case of 
				: (Length:C16($aClassif{$i})=0)
				: (Length:C16($aLine{$i})=0)
				: (Length:C16($aPO{$i})=0)
				: (Length:C16($aBillTo{$i})=0)  // Modified by: MelvinBohince (1/12/22) 
				: (Not:C34(ADDR_isValid($aBillTo{$i})))  // Modified by: MelvinBohince (1/12/22) 
					
				Else   //passed all the tests
					$failedTests:=False:C215
			End case 
			
			If ($failedTests)
				uConfirm("Orderlines need a Billto, Class, Line, and PO to be accepted."; "OK"; "Help")
				$2->:=$oldStat
				$i:=$i+Size of array:C274($aClassif)  //break
			End if 
			
			//If (Length($aClassif{$i})=0) | (Length($aLine{$i})=0) | (Length($aPO{$i})=0)
			//$i:=$i+Size of array($aClassif)
			//uConfirm ("Orderlines need a Class, Line, and PO to be accepted.";"OK";"Help")
			//$2->:=$oldStat
			//End if 
		End for 
		
	: ($newStat="Cancel")  //•071295  MLB  UPR 223
		If ($viaOrderHdr)  //•062497  MLB  
			$shipped:=Sum:C1([Customers_Order_Lines:41]Qty_Shipped:10)
		Else   //•062497  MLB 
			$shipped:=[Customers_Order_Lines:41]Qty_Shipped:10  //•062497  MLB
		End if   //•062497  MLB 
		
		If ($shipped>0)
			uConfirm("Cannot Cancel a shipped order."; "OK"; "Help")
			$2->:=$oldStat
			$newStat:=$oldStat  //•102396   don't change state
			
		Else 
			uConfirm("Are you sure you want to "+$newStat+" this order?"; "Yes"; "No")
			If (OK=0)
				$2->:=$oldStat
			End if 
		End if   //•102396   
End case   //•102396   

Case of 
	: ($2->=$oldStat)  //•062497  MLB  pre-recks failed
		//do nothing  
		
	: ($oldStat="CONTRACT")  //•060195  MLB  UPR 184
		Case of 
			: ($newStat="Cancel")
				
			: ($newStat="Accepted")
				If ($viaOrderHdr)  //•062497  MLB  
					FIRST RECORD:C50([Customers_Order_Lines:41])
					While (Not:C34(End selection:C36([Customers_Order_Lines:41])))
						//*Get the contract price and cost
						If ($is_contract)
							If (Not:C34([Customers_Order_Lines:41]SpecialBilling:37))  // Modified by: Mel Bohince (5/28/19) 
								[Customers_Order_Lines:41]Price_Per_M:8:=SetContractCost([Customers_Order_Lines:41]CustID:4; [Customers_Order_Lines:41]ProductCode:5; ->[Customers_Order_Lines:41]Cost_Per_M:7; ->[Customers_Order_Lines:41]CostMatl_Per_M:32; ->[Customers_Order_Lines:41]CostLabor_Per_M:30; ->[Customers_Order_Lines:41]CostOH_Per_M:31; ->[Customers_Order_Lines:41]CostScrap_Per_M:33)  //•102396 
							End if   //spl billing
						End if   //contract
						If (([Customers_Order_Lines:41]Cost_Per_M:7=0) | ([Customers_Order_Lines:41]Price_Per_M:8=0)) & ($is_contract)
							uConfirm("Pricing & Costing could not be established, "+Char:C90(13)+"Check the Brand & F/G records for Orderline:"+[Customers_Order_Lines:41]OrderLine:3; "OK"; "Help")  //•102896   
							$2->:=$oldStat
							
						Else 
							[Customers_Order_Lines:41]DateBooked:49:=4D_Current_date  //•112697  MLB 
							[Customers_Order_Lines:41]Qty_Booked:48:=[Customers_Order_Lines:41]Quantity:6  //•112697  MLB  UPR               
							SAVE RECORD:C53([Customers_Order_Lines:41])  //•102396    
						End if 
						
						NEXT RECORD:C51([Customers_Order_Lines:41])
					End while 
					
				Else   //•062497  MLB via orderline            
					If (([Customers_Order_Lines:41]Cost_Per_M:7=0) | ([Customers_Order_Lines:41]CostMatl_Per_M:32=0) | ([Customers_Order_Lines:41]CostLabor_Per_M:30=0) | ([Customers_Order_Lines:41]CostOH_Per_M:31=0) | ([Customers_Order_Lines:41]Price_Per_M:8=0))
						//•050396  MLB  UPR 184
						If (Not:C34([Customers_Order_Lines:41]SpecialBilling:37))  // Modified by: Mel Bohince (5/28/19) 
							//*Get the contract price and cost
							[Customers_Order_Lines:41]Price_Per_M:8:=SetContractCost([Customers_Order_Lines:41]CustID:4; [Customers_Order_Lines:41]ProductCode:5; ->[Customers_Order_Lines:41]Cost_Per_M:7; ->[Customers_Order_Lines:41]CostMatl_Per_M:32; ->[Customers_Order_Lines:41]CostLabor_Per_M:30; ->[Customers_Order_Lines:41]CostOH_Per_M:31; ->[Customers_Order_Lines:41]CostScrap_Per_M:33)  //•102396  
							If ([Customers_Order_Lines:41]Cost_Per_M:7=0) | ([Customers_Order_Lines:41]Price_Per_M:8=0)
								uConfirm("Pricing & Costing could not be established, "+Char:C90(13)+"Check the Brand & F/G records for Orderline:"+[Customers_Order_Lines:41]OrderLine:3; "OK"; "Help")  //•102896   
								$2->:=$oldStat
								
							Else 
								[Customers_Order_Lines:41]DateBooked:49:=4D_Current_date  //•112697  MLB   
								[Customers_Order_Lines:41]Qty_Booked:48:=[Customers_Order_Lines:41]Quantity:6  //•112697  MLB  UPR 
								SAVE RECORD:C53([Customers_Order_Lines:41])  //•102396    
							End if 
						End if   //spl billing
					End if   //need costs
				End if   //•062497  MLB  
				
				If ($2->=$newStat)  //success
					[Customers_Orders:40]DateApproved:45:=4D_Current_date
				End if 
				
			Else 
				uConfirm("Status must be left as 'CONTRACT' or changed to 'Accepted' or 'Cancel'."; "OK"; "Help")
				$2->:=$oldStat
		End case 
		
	: ($oldStat="New")
		Case of 
			: ($newStat="CONTRACT")  //•060195  MLB  UPR 184
				[Customers_Orders:40]IsContract:52:=True:C214  //•062497  MLB  
				
			: ($newStat="Opened")
				
			: ($newStat="Accepted")
				[Customers_Orders:40]DateApproved:45:=4D_Current_date
				
			: ($newStat="Cancel")
				
			Else 
				uConfirm("Can only go from New to Opened, Contract, or Accepted."; "OK"; "Help")
				$2->:=$oldStat
		End case 
		
	: ($oldStat="Opened")
		Case of 
			: ($newStat="New")
				
			: ($newStat="Accepted")
				[Customers_Orders:40]DateApproved:45:=4D_Current_date
				
			: ($newStat="Hold@")
				
			: ($newStat="Cancel")
				
			Else 
				uConfirm("Can't go from "+$oldStat+" to "+$newStat; "OK"; "Help")
		End case 
		
	: ($oldStat="Credit Hold")
		Case of 
			: ($newStat="Accepted")
				[Customers_Orders:40]DateApproved:45:=4D_Current_date
				
			: ($newStat="Hold@")
				
			: ($newStat="Cancel")
				
			Else 
				$2->:=$oldStat
		End case 
		
	: ($oldStat="Accepted")
		Case of 
			: ($newStat="Budgeted")
				uConfirm("Are you sure you want to set this to Budgeted?"; "Close"; "Cancel")
				If (OK=0)
					$2->:=$oldStat
				End if 
				
			: ($newStat="Hold@")
				
			: ($newStat="Cancel")
				
			: ($newStat="Close@")
				uConfirm("Are you sure you want to Close this?"; "Close"; "Cancel")
				If (OK=0)
					$2->:=$oldStat
				End if 
				
			Else 
				$2->:=$oldStat
		End case 
		
	: ($oldStat="Close@")
		Case of   //•061797  mBohince allow this to be backed up to correct errors
			: ($newStat="Accepted")
				uConfirm("Are you sure you want to remove the 'Closed' status?"; "Yes"; "No")
				If (OK=0)
					$2->:=$oldStat
				End if 
				
			Else 
				uConfirm("Not able to Change."; "OK"; "Help")
				$2->:=$oldStat
		End case 
		
	: ($oldStat="Hold@")
		Case of 
			: ($newStat="Opened")
			: ($newStat="Accepted") & ([Customers_Orders:40]DateApproved:45#!00-00-00!)
				//[Customers_Orders]DateApproved:=4D_Current_date
			: ($newStat="Accepted") & ([Customers_Orders:40]DateApproved:45=!00-00-00!)
				uConfirm("Try going to 'Opened' first so order books properly."; "OK"; "Help")
				$2->:=$oldStat
			Else 
				$2->:=$oldStat
		End case 
		
	: ($oldStat="Chg Order")
		Case of 
			: ($newStat="Accepted")
			Else 
				$2->:=$oldStat
		End case 
		
	: ($oldStat="Budgeted")
		Case of 
			: ($newStat="Hold@")
				
			: ($newStat="Close@")
				uConfirm("Are you sure you want to Close this?"; "Close"; "Cancel")
				If (OK=0)
					$2->:=$oldStat
				End if 
				
			Else 
				$2->:=$oldStat
		End case 
		
	: ($OldStat="Adjusted")  //• 7/8/97 cs upr 1846 allow old adjusted status -> closed
		If ($NewStat="Closed")
			uConfirm("Are you sure you want to Close this?"; "Close"; "Cancel")
			If (OK=0)
				$2->:=$oldStat
			End if 
		Else 
			$0:=False:C215
		End if 
		
	: ($OldStat="Cancel")
		Case of 
			: ($newStat="Opened")
				
			Else 
				uConfirm("Try going to 'Opened' first so order books properly."; "OK"; "Help")
				$2->:=$oldStat
		End case 
		
	Else 
		uConfirm("Status "+$oldStat+" is invalid.  Notify System Manager."; "OK"; "Help")
		$2->:=$oldStat
End case 

If ($2->=$oldStat)
	$0:=False:C215
End if 

If ($0=False:C215)
	uConfirm("Status Change Failed.  "+$oldStat+" -> "+$newStat; "OK"; "Help")
	
Else 
	If (Position:C15($newStat; " Closed Cancel Kill ")>0)
		uConfirm("Remember to delete any open releases."; "OK"; "Help")
	End if 
End if 