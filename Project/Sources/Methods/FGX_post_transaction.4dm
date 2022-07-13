//%attributes = {"publishedWeb":true}
// Method: FGX_post_transaction
// was uPostFGxaction(date;+in | -out;xactionType)  depends on process vars:
//9/30/94
//2/10/95 test for find in the [jmi],[ol],[fg] file when getting costs
//•051595  MLB  UPR 1508
//•080495  MLB  UPR 1490 add jobit
//•030896  MLB  spl billing get classification from ol instead of fg
//• 4/9/98 cs nan checking
//•011599  MLB  allow 3 digit order items
//•012299  MLB  fix for spl billing
//•102999  mlb  use contract price if necessary
//•4/10/00  mlb  calc trans cost
//•4/14/00  mlb  undo last change, looses important current seleciton
// NOT, undo Modified by: Mel Bohince (11/20/18) use spl billing flag so to match OL's trigger on extended price

//*Explain use global Varible used
//     sCriterion1 - cpn
//     sCriterion2 - cust
//     sCriterion3 - from location
//     sCriterion4 - to location
//     sCriterion5 - job form
//     sCriterion6 - order line
//     sCriterion7 - reason comments
//     sCriterion8 - action taken
//     sCriterion9 - reason title
//     rReal1 - the quantity
//     fFlag1 -  true if from excess stock
C_LONGINT:C283($ordLineLen)  //•011599  MLB  
$ordLineLen:=Position:C15("/"; sCriterion6)
If ($ordLineLen>1)
	$ordLineLen:=$ordLineLen-1
Else   //•012299  MLB  fix for spl billing
	$ordLineLen:=Length:C16(sCriterion6)
End if 
C_DATE:C307($1)
C_LONGINT:C283($2)  //positive for to, negative for from
C_TEXT:C284($3)  //xaction type
C_TEXT:C284($uom)
C_TIME:C306($4)
If ($2>=0)  //skip double entry xActions 
	//*Create the transaction record using the global vars
	If (Count parameters:C259>3)
		$id:=FGX_NewFG_Transaction($3; $1; <>zResp; $4)
	Else 
		$id:=FGX_NewFG_Transaction($3; $1; <>zResp)
	End if 
	
	[Finished_Goods_Transactions:33]ProductCode:1:=sCriterion1
	[Finished_Goods_Transactions:33]CustID:12:=sCriterion2  //
	
	[Finished_Goods_Transactions:33]JobNo:4:=Substring:C12(sCriterion5; 1; 5)
	[Finished_Goods_Transactions:33]JobForm:5:=sCriterion5
	[Finished_Goods_Transactions:33]JobFormItem:30:=i1  //•080495  MLB  UPR 1490
	[Finished_Goods_Transactions:33]OrderNo:15:=Substring:C12(sCriterion6; 1; 5)
	[Finished_Goods_Transactions:33]OrderItem:16:=sCriterion6
	
	[Finished_Goods_Transactions:33]Reason:26:=sCriterion9  //subject for reason-used in reporting, sorting, very uniform
	[Finished_Goods_Transactions:33]ReasonNotes:28:=sCriterion7  //indicates specific percentages, special notes...
	[Finished_Goods_Transactions:33]ActionTaken:27:=sCriterion8
	[Finished_Goods_Transactions:33]Qty:6:=rReal1
	[Finished_Goods_Transactions:33]Location:9:=sCriterion4
	[Finished_Goods_Transactions:33]viaLocation:11:=sCriterion3
	[Finished_Goods_Transactions:33]Skid_number:29:=sCriter10
	//*Get the related records required to finish the transaction
	//*.   Get the FG info
	qryFinishedGood(sCriterion2; sCriterion1)  //•051595  MLB  UPR 1508  
	If (Records in selection:C76([Finished_Goods:26])#0)  //2/10/95 test for hit
		[Finished_Goods_Transactions:33]FG_Classification:22:=[Finished_Goods:26]ClassOrType:28
	Else 
		[Finished_Goods_Transactions:33]FG_Classification:22:="F/G rec not found"
	End if 
	// Modified by: Mel Bohince (11/20/18) switching to OL's spl billing, see below
	// that way if the OL is wrong, common, then invoice will be wrong and more likely 
	// that it will be reviewed
	$uom:=[Finished_Goods:26]Acctg_UOM:29
	
	//*.   Get the orderIt price info
	If ([Customers_Order_Lines:41]OrderLine:3#Substring:C12(sCriterion6; 1; $ordLineLen))
		READ ONLY:C145([Customers_Order_Lines:41])
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=Substring:C12(sCriterion6; 1; $ordLineLen))
	End if 
	
	If (Records in selection:C76([Customers_Order_Lines:41])#0)  //2/10/95 test for hit
		If (sCriterion3="Spl Billing")  //•030896  MLB 
			[Finished_Goods_Transactions:33]FG_Classification:22:=[Customers_Order_Lines:41]Classification:29
		End if 
	End if 
	//•102999  mlb  use contract price if necessary
	[Finished_Goods_Transactions:33]PricePerM:19:=fGetSalesValue(Substring:C12(sCriterion6; 1; $ordLineLen); sCriterion1)
	
	//  // Modified by: Mel Bohince (11/20/18) 
	//If (Not([Customers_Order_Lines]SpecialBilling))
	//$uom:="M"  //per thousand
	//Else 
	//$uom:="E"  //per each
	//End if 
	
	If ($uom="M")  //•051595  MLB  UPR 1508
		[Finished_Goods_Transactions:33]ExtendedPrice:20:=Round:C94(((rReal1/1000)*[Finished_Goods_Transactions:33]PricePerM:19); 2)
	Else 
		[Finished_Goods_Transactions:33]ExtendedPrice:20:=Round:C94((rReal1*[Finished_Goods_Transactions:33]PricePerM:19); 2)
	End if 
	
	//*.   Get the JobIt cost info
	//TRACE
	Case of 
			//: (True)  `•4/14/00  mlb  turn off costing
			
			//: (True)  `•4/10/00  mlb  leave until FIFO gets fixed
			//xFGXestimateCostasPlanned `cost the old way, per jobit's data
			
			//* ••• incremental FIFO maintenance ••••
		: ($3="Ship") & ($uom="M")  //•2/25/00  mlb  
			[Finished_Goods_Transactions:33]CoGSExtended:8:=JIC_Relieve((sCriterion2+":"+sCriterion1); rReal1; ->[Finished_Goods_Transactions:33]CoGSextendedMatl:32; ->[Finished_Goods_Transactions:33]CoGSextendedLabor:33; ->[Finished_Goods_Transactions:33]CoGSextendedBurden:34)
			[Finished_Goods_Transactions:33]CoGS_M:7:=[Finished_Goods_Transactions:33]CoGSExtended:8/rReal1*1000
			//ALERT("[FG_Transactions]CoGS_M= "+String([FG_Transactions]CoGS_M))
			
		: ($3="Receipt") & ($uom="M") & (rReal1>0)
			[Finished_Goods_Transactions:33]CoGSExtended:8:=JIC_Replenish((sCriterion2+":"+sCriterion1); rReal1; ->[Finished_Goods_Transactions:33]CoGSextendedMatl:32; ->[Finished_Goods_Transactions:33]CoGSextendedLabor:33; ->[Finished_Goods_Transactions:33]CoGSextendedBurden:34)
			[Finished_Goods_Transactions:33]CoGS_M:7:=[Finished_Goods_Transactions:33]CoGSExtended:8/rReal1*1000
			//ALERT("[FG_Transactions]CoGS_M= "+String([FG_Transactions]CoGS_M))
			
		: ($3="Receipt") & ($uom="M") & (rReal1<0)
			[Finished_Goods_Transactions:33]CoGSExtended:8:=JIC_Relieve((sCriterion2+":"+sCriterion1); (rReal1*-1); ->[Finished_Goods_Transactions:33]CoGSextendedMatl:32; ->[Finished_Goods_Transactions:33]CoGSextendedLabor:33; ->[Finished_Goods_Transactions:33]CoGSextendedBurden:34)
			[Finished_Goods_Transactions:33]CoGS_M:7:=[Finished_Goods_Transactions:33]CoGSExtended:8/rReal1*1000
			
		: ($3="Scrap") & ($uom="M") & (rReal1>0)  //•2/25/00  mlb  
			[Finished_Goods_Transactions:33]CoGSExtended:8:=JIC_Scrap((sCriterion2+":"+sCriterion1); rReal1; ->[Finished_Goods_Transactions:33]CoGSextendedMatl:32; ->[Finished_Goods_Transactions:33]CoGSextendedLabor:33; ->[Finished_Goods_Transactions:33]CoGSextendedBurden:34)
			[Finished_Goods_Transactions:33]CoGS_M:7:=[Finished_Goods_Transactions:33]CoGSExtended:8/rReal1*1000
			
		: ($3="Scrap") & ($uom="M") & (rReal1<0)  //•072002  mlb reverse scrap 
			[Finished_Goods_Transactions:33]CoGSExtended:8:=JIC_Replenish((sCriterion2+":"+sCriterion1); (rReal1*-1); ->[Finished_Goods_Transactions:33]CoGSextendedMatl:32; ->[Finished_Goods_Transactions:33]CoGSextendedLabor:33; ->[Finished_Goods_Transactions:33]CoGSextendedBurden:34)
			[Finished_Goods_Transactions:33]CoGS_M:7:=[Finished_Goods_Transactions:33]CoGSExtended:8/rReal1*1000
			
		: ($3="RevShip") & ($uom="M")
			[Finished_Goods_Transactions:33]CoGSExtended:8:=JIC_Replenish((sCriterion2+":"+sCriterion1); rReal1; ->[Finished_Goods_Transactions:33]CoGSextendedMatl:32; ->[Finished_Goods_Transactions:33]CoGSextendedLabor:33; ->[Finished_Goods_Transactions:33]CoGSextendedBurden:34)
			[Finished_Goods_Transactions:33]CoGS_M:7:=[Finished_Goods_Transactions:33]CoGSExtended:8/rReal1*1000
			
		: ($3="Return") & ($uom="M")
			[Finished_Goods_Transactions:33]CoGSExtended:8:=JIC_Replenish((sCriterion2+":"+sCriterion1); rReal1; ->[Finished_Goods_Transactions:33]CoGSextendedMatl:32; ->[Finished_Goods_Transactions:33]CoGSextendedLabor:33; ->[Finished_Goods_Transactions:33]CoGSextendedBurden:34)
			[Finished_Goods_Transactions:33]CoGS_M:7:=[Finished_Goods_Transactions:33]CoGSExtended:8/rReal1*1000
			
		: ($3="BACKFLUSH")
			[Finished_Goods_Transactions:33]CoGSExtended:8:=JIC_Relieve((sCriterion2+":"+sCriterion1); rReal1; ->[Finished_Goods_Transactions:33]CoGSextendedMatl:32; ->[Finished_Goods_Transactions:33]CoGSextendedLabor:33; ->[Finished_Goods_Transactions:33]CoGSextendedBurden:34)
			[Finished_Goods_Transactions:33]CoGS_M:7:=[Finished_Goods_Transactions:33]CoGSExtended:8/rReal1*1000
			
		Else   //the original code
			If (([Job_Forms_Items:44]ProductCode:3#sCriterion1) | ([Job_Forms_Items:44]JobForm:1#sCriterion5))  //9/30/94  | ([JobMakesItem]CustId#sCriterion2)
				READ ONLY:C145([Job_Forms_Items:44])
				qryJMI(sCriterion5; 0; sCriterion1)  //•051595  MLB  UPR 1508    
			End if 
			If (Records in selection:C76([Job_Forms_Items:44])#0)  //2/10/95 test for hit
				[Finished_Goods_Transactions:33]CoGS_M:7:=[Job_Forms_Items:44]PldCostTotal:21
				If ($uom="M")  //•051595  MLB  UPR 1508
					[Finished_Goods_Transactions:33]CoGSExtended:8:=uNANCheck(Round:C94((rReal1/1000)*[Job_Forms_Items:44]PldCostTotal:21*(Num:C11(Not:C34([Finished_Goods_Transactions:33]SkipTrigger:14))); 2))
				Else 
					[Finished_Goods_Transactions:33]CoGSExtended:8:=uNANCheck(Round:C94(rReal1*[Job_Forms_Items:44]PldCostTotal:21*(Num:C11(Not:C34([Finished_Goods_Transactions:33]SkipTrigger:14))); 2))
				End if 
				
			Else   //*.      If no job cost, try for the orderline cost (spl Billing style)
				If (Records in selection:C76([Customers_Order_Lines:41])#0)
					If ($uom="M")  //•051595  MLB  UPR 1508
						[Finished_Goods_Transactions:33]CoGSExtended:8:=uNANCheck(Round:C94((rReal1/1000)*[Customers_Order_Lines:41]Cost_Per_M:7; 2))
					Else 
						[Finished_Goods_Transactions:33]CoGSExtended:8:=uNANCheck(Round:C94(rReal1*[Customers_Order_Lines:41]Cost_Per_M:7; 2))
					End if 
				Else 
					[Finished_Goods_Transactions:33]CoGS_M:7:=0
					[Finished_Goods_Transactions:33]CoGSExtended:8:=0
				End if 
			End if 
	End case   //costing
	
	
	//*. SAVE THE TRANSACTION  
	SAVE RECORD:C53([Finished_Goods_Transactions:33])
	UNLOAD RECORD:C212([Finished_Goods_Transactions:33])  //DONT REDUCE THE SELECTION!
	
End if   //double entry xActions

//