//%attributes = {}
// Method: JMI_excessPromoGlued () -> 
// ----------------------------------------------------
// by: mel: 06/22/04, 14:21:53
// ----------------------------------------------------
// Description:
// email completed promo jobits that glued too high
// • mel (8/24/05, 16:35:26) add email for regular cartons also
//090706 mlb add distribution list, salesmen, and verbose body adn subject
// Modified by: Mel Bohince (5/8/19) always CC the distro list passed in arg[2]

READ ONLY:C145([Users:5])
READ ONLY:C145([Customers:16])

C_TEXT:C284($2; $CC_to; $subject; $body)
C_DATE:C307($1)
C_TEXT:C284($overproduction)

$overproduction:=""

If (Count parameters:C259>0)
	$date:=$1
	$CC_to:=$2
Else 
	$date:=Current date:C33(*)
	$CC_to:="mel.bohince@arkay.com"+Char:C90(9)
End if 

QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39=$date)
C_LONGINT:C283($i; $numRecs)
C_BOOLEAN:C305($break)
$break:=False:C215
$numRecs:=Records in selection:C76([Job_Forms_Items:44])

uThermoInit($numRecs; "Updating Records")
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
	
	For ($i; 1; $numRecs)
		If ($break)
			$i:=$i+$numRecs
		End if 
		
		$numFG:=qryFinishedGood([Job_Forms_Items:44]CustId:15; [Job_Forms_Items:44]ProductCode:3)
		If ($numFG>0)
			
			If ([Job_Forms_Items:44]SubFormNumber:32=0)  //• mlb - 10/8/02  09:43 treat qty_act different if subforms
				$qtyGlued:=JOB_CalcQtyGlued([Job_Forms_Items:44]Jobit:4)  //same
			Else 
				$qtyGlued:=[Job_Forms_Items:44]Qty_Actual:11  //different
			End if 
			
			If ($qtyGlued>[Job_Forms_Items:44]Qty_Want:24)
				$excess:=$qtyGlued-[Job_Forms_Items:44]Qty_Want:24
				If ([Finished_Goods:26]OrderType:59="Promo@")
					QUERY:C277([Customers:16]; [Customers:16]ID:1=[Job_Forms_Items:44]CustId:15)
					QUERY:C277([Users:5]; [Users:5]Initials:1=[Customers:16]PlannerID:5)  //• mlb - 2/21/02  11:34
					If (Records in selection:C76([Users:5])>0)
						$plannerEmail:=Email_WhoAmI([Users:5]UserName:11)+Char:C90(9)
					End if 
					
					QUERY:C277([Users:5]; [Users:5]Initials:1=[Customers:16]SalesmanID:3)  //• mlb - 2/21/02  11:34
					If (Records in selection:C76([Users:5])>0)
						$plannerEmail:=$plannerEmail+Email_WhoAmI([Users:5]UserName:11)+Char:C90(9)
					End if 
					
					//If ([Customers]ParentCorp="Est@") & (False)
					//$plannerEmail:=$plannerEmail+"cathy.falk@arkay.com"+Char(9)
					//End if 
					
					$plannerEmail:=$plannerEmail+$CC_to
					
					QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=[Job_Forms_Items:44]OrderItem:2)
					If (Records in selection:C76([Customers_Order_Lines:41])=1)
						$qty:=String:C10([Customers_Order_Lines:41]Quantity:6*(1+([Customers_Order_Lines:41]OverRun:25/100)))
					Else 
						$qty:="?not found?"
					End if 
					$subject:="Excess ["+String:C10($excess)+"] Promo Item Glued - "+[Job_Forms_Items:44]ProductCode:3+" - "+[Finished_Goods:26]Line_Brand:15
					$body:="See job "+[Job_Forms_Items:44]Jobit:4+" completed on "+String:C10([Job_Forms_Items:44]Completed:39; System date short:K1:1)+" which glued "+String:C10($excess)+" more cartons than the Want Qty of "+String:C10([Job_Forms_Items:44]Qty_Want:24)+" for promo item '"+[Job_Forms_Items:44]ProductCode:3+"'."
					$body:=$body+"This is an "+[Customers:16]Name:2+" - "+[Finished_Goods:26]Line_Brand:15+" item that was produce against orderline '"+[Job_Forms_Items:44]OrderItem:2+"' which was for "+$qty+" cartons."
					EMAIL_Sender($subject; ""; $body; $plannerEmail)
					
				Else 
					//$overproduction:=$overproduction+[JobMakesItem]ProductCode+" "+String($qtyGlued-[JobMakesItem]Qty_Want)+" cartons"+" see job "+[JobMakesItem]Jobit
					//$overproduction:=$overproduction+" completed on "+String([JobMakesItem]Completed;Short )+Char(13)
					//
					//EMAIL_Sender ("Excess glued ";"";$plannerEmail)
				End if 
			End if 
			
		End if 
		
		NEXT RECORD:C51([Job_Forms_Items:44])
		uThermoUpdate($i)
	End for 
	
Else 
	
	SELECTION TO ARRAY:C260([Job_Forms_Items:44]CustId:15; $_CustId; \
		[Job_Forms_Items:44]ProductCode:3; $_ProductCode; \
		[Job_Forms_Items:44]SubFormNumber:32; $_SubFormNumber; \
		[Job_Forms_Items:44]Jobit:4; $_Jobit; \
		[Job_Forms_Items:44]Qty_Actual:11; $_Qty_Actual; \
		[Job_Forms_Items:44]Qty_Want:24; $_Qty_Want; \
		[Job_Forms_Items:44]OrderItem:2; $_OrderItem; \
		[Job_Forms_Items:44]Completed:39; $_Completed)
	
	
	For ($i; 1; $numRecs)
		If ($break)
			$i:=$i+$numRecs
		End if 
		
		$numFG:=qryFinishedGood($_CustId{$i}; $_ProductCode{$i})
		If ($numFG>0)
			
			If ($_SubFormNumber{$i}=0)  //• mlb - 10/8/02  09:43 treat qty_act different if subforms
				$qtyGlued:=JOB_CalcQtyGlued($_Jobit{$i})  //same
			Else 
				$qtyGlued:=$_Qty_Actual{$i}  //different
			End if 
			
			If ($qtyGlued>$_Qty_Want{$i})
				$excess:=$qtyGlued-$_Qty_Want{$i}
				If ([Finished_Goods:26]OrderType:59="Promo@")
					QUERY:C277([Customers:16]; [Customers:16]ID:1=$_CustId{$i})
					QUERY:C277([Users:5]; [Users:5]Initials:1=[Customers:16]PlannerID:5)  //• mlb - 2/21/02  11:34
					If (Records in selection:C76([Users:5])>0)
						$plannerEmail:=Email_WhoAmI([Users:5]UserName:11)+Char:C90(9)
					End if 
					
					QUERY:C277([Users:5]; [Users:5]Initials:1=[Customers:16]SalesmanID:3)  //• mlb - 2/21/02  11:34
					If (Records in selection:C76([Users:5])>0)
						$plannerEmail:=$plannerEmail+Email_WhoAmI([Users:5]UserName:11)+Char:C90(9)
					End if 
					
					//If ([Customers]ParentCorp="Est@") & (False)
					//$plannerEmail:=$plannerEmail+"cathy.falk@arkay.com"+Char(9)
					//End if 
					
					$plannerEmail:=$plannerEmail+$CC_to
					
					QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$_OrderItem{$i})
					If (Records in selection:C76([Customers_Order_Lines:41])=1)
						$qty:=String:C10([Customers_Order_Lines:41]Quantity:6*(1+([Customers_Order_Lines:41]OverRun:25/100)))
					Else 
						$qty:="?not found?"
					End if 
					$subject:="Excess ["+String:C10($excess)+"] Promo Item Glued - "+$_ProductCode{$i}+" - "+[Finished_Goods:26]Line_Brand:15
					$body:="See job "+$_Jobit{$i}+" completed on "+String:C10($_Completed{$i}; System date short:K1:1)+" which glued "+String:C10($excess)+" more cartons than the Want Qty of "+String:C10($_Qty_Want{$i})+" for promo item '"+$_ProductCode{$i}+"'."
					$body:=$body+"This is an "+[Customers:16]Name:2+" - "+[Finished_Goods:26]Line_Brand:15+" item that was produce against orderline '"+$_OrderItem{$i}+"' which was for "+$qty+" cartons."
					EMAIL_Sender($subject; ""; $body; $plannerEmail)
					
				Else 
				End if 
			End if 
			
		End if 
		
		uThermoUpdate($i)
	End for 
	
End if   // END 4D Professional Services : January 2019 

uThermoClose