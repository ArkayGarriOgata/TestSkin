//%attributes = {"publishedWeb":true}
//uInvoAdjustment
//upr 1309 11/8/94
//11/18/94 send api unit price as new-old, and quantity=#shippedNet
//11/21/94 change search since it was picking up receipts as well
//1/25/95 differenciate returns(+) from shipments(-)
//2/10/95 invoice(credit ok, but fg_trans wrong
//2/14/95 upr 1270 spl billing test
//•081595  MLB   add denominator to calc
//• 8/15/97 cs COGS reporting problems prep not working correctly, price 
//  adjustments included 'free' cartons
//• 9/2/97 cs overship quatites were counted 2 times
//• 9/11/97 cs problem the new system did not concider previous price change(s)
//•121699  mlb  unbilled preps were getting price change invoice
C_LONGINT:C283($i; $xfers; $invoiceNum; $arkayRel; $0; $Denom; $1; $err)
C_REAL:C285($TotalOld; $TotalNew; $Adjustment; $QtyAffected; $MaxAllowed; $PriceChange)
C_BOOLEAN:C305($Continue)
//determine if the item has been invoiced already
$0:=-1  //indicate failure
$Denom:=$1  //•081595  MLB  
MESSAGES ON:C181
utl_Trace
If ([Customers_Order_Lines:41]ProductCode:5#"Prep@")  //• 8/15/97 cs do not do this for prep
	If ([Customers:16]ID:1#[Customers_Order_Lines:41]CustID:4)
		READ ONLY:C145([Customers:16])
		QUERY:C277([Customers:16]; [Customers:16]ID:1=[Customers_Order_Lines:41]CustID:4)
	End if 
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]JobForm:5="Price@"; *)  //• 9/11/97 cs locate price changes
	QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]OrderItem:16=[Customers_Order_Lines:41]OrderLine:3+"@")  //this should return the smallest group to continue searching
	//FIRST RECORD([FG_Transactions])
	$PriceChange:=0
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		
		For ($i; 1; Records in selection:C76([Finished_Goods_Transactions:33]))  //• 9/11/97 cs sum price changes
			$PriceChange:=$PriceChange+[Finished_Goods_Transactions:33]ExtendedPrice:20
			NEXT RECORD:C51([Finished_Goods_Transactions:33])
		End for 
		
	Else 
		
		ARRAY REAL:C219($_ExtendedPrice; 0)
		SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]ExtendedPrice:20; $_ExtendedPrice)
		
		For ($i; 1; Size of array:C274($_ExtendedPrice); 1)  //• 9/11/97 cs sum price changes
			
			$PriceChange:=$PriceChange+$_ExtendedPrice{$i}
			
		End for 
		
	End if   // END 4D Professional Services : January 2019 First record
	
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]JobForm:5#"Price@"; *)  //`• 8/15/97 cs I prefer to be safe, break search into 'Ors' & Ands seperatly
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]OrderItem:16=[Customers_Order_Lines:41]OrderLine:3+"@")  //this should return the smallest group to continue searching
		QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Ship"; *)  //
		QUERY SELECTION:C341([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]XactionType:2="Return@"; *)  //Returns`11/21/94
		QUERY SELECTION:C341([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]XactionType:2="RevShip@"; *)  //RevShips`11/21/94
		QUERY SELECTION:C341([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]XactionType:2="B&H@")  //Bill and HOlds
		
	Else 
		
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Return@"; *)  //Returns`11/21/94
		QUERY:C277([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]XactionType:2="RevShip@"; *)  //RevShips`11/21/94
		QUERY:C277([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]XactionType:2="B&H@"; *)  //Bill and HOlds
		QUERY:C277([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]XactionType:2="Ship"; *)  //
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]JobForm:5#"Price@"; *)  //`• 8/15/97 cs I prefer to be safe, break search into 'Ors' & Ands seperatly
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]OrderItem:16=[Customers_Order_Lines:41]OrderLine:3+"@")  //this should return the smallest group to continue searching
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	MESSAGES OFF:C175
	$xfers:=Records in selection:C76([Finished_Goods_Transactions:33])
	
	If ($xfers>0)  //determine the quantity of cartons & Original price total
		$PriceOld:=[Customers_Order_Changed_Items:176]OldPrice:3  //set up for summation
		$PriceNew:=[Customers_Order_Changed_Items:176]NewPrice:5
		$TotalOld:=0
		$TotalNew:=0
		$QtyAffected:=0  //11/18/94
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			For ($i; 1; $xfers)  //for each transaction sum its values
				Case of   //1/25/95
					: (([Finished_Goods_Transactions:33]XactionType:2="Return@") | ([Finished_Goods_Transactions:33]XactionType:2="RevShip@"))
						$QtyAffected:=$QtyAffected-[Finished_Goods_Transactions:33]Qty:6  //11/18/94
						$TotalOld:=$TotalOld-([Finished_Goods_Transactions:33]ExtendedPrice:20)
					: ([Finished_Goods_Transactions:33]ExtendedPrice:20<0)  //• 9/2/97 cs over ship record
						//ignore qty since these have already been included elsewhere          
						$TotalOld:=$TotalOld+([Finished_Goods_Transactions:33]ExtendedPrice:20)
					Else 
						$QtyAffected:=$QtyAffected+[Finished_Goods_Transactions:33]Qty:6  //11/18/94
						$TotalOld:=$TotalOld+([Finished_Goods_Transactions:33]ExtendedPrice:20)
				End case 
				NEXT RECORD:C51([Finished_Goods_Transactions:33])
			End for 
			
		Else 
			
			ARRAY TEXT:C222($_XactionType; 0)
			ARRAY LONGINT:C221($_Qty; 0)
			ARRAY REAL:C219($_ExtendedPrice; 0)
			
			SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]XactionType:2; $_XactionType; [Finished_Goods_Transactions:33]Qty:6; $_Qty; [Finished_Goods_Transactions:33]ExtendedPrice:20; $_ExtendedPrice)
			
			For ($i; 1; $xfers; 1)  //for each transaction sum its values
				Case of   //1/25/95
					: (($_XactionType{$i}="Return@") | ($_XactionType{$i}="RevShip@"))
						$QtyAffected:=$QtyAffected-$_Qty{$i}  //11/18/94
						$TotalOld:=$TotalOld-($_ExtendedPrice{$i})
					: ($_ExtendedPrice{$i}<0)  //• 9/2/97 cs over ship record
						//ignore qty since these have already been included elsewhere          
						$TotalOld:=$TotalOld+($_ExtendedPrice{$i})
					Else 
						$QtyAffected:=$QtyAffected+$_Qty{$i}  //11/18/94
						$TotalOld:=$TotalOld+($_ExtendedPrice{$i})
				End case 
				
			End for 
			
		End if   // END 4D Professional Services : January 2019 First record
		
		$Continue:=True:C214
	Else 
		$Continue:=False:C215
		BEEP:C151
		ALERT:C41("Please contact aMs Support for missing Ship record")
		//. When this error occurs it is because the [Finished_Goods_Transactions] records
		//.   are messed up. This needs to be fixed by finding the missing shipped record
		//.   Importing (or creating it) then delete the [Customers_Order_Change_Orders] and 
		//.   [Customers_Order_Changed_Items] records and have them try again.
	End if 
	
Else   //• 8/15/97 cs start - prep only
	//*Preparatory item  
	$PriceOld:=[Customers_Order_Changed_Items:176]OldPrice:3
	$PriceNew:=[Customers_Order_Changed_Items:176]NewPrice:5
	$TotalOld:=$PriceOld
	$TotalNew:=$PriceNew
	$QtyAffected:=1
	
	If ([Customers_Order_Lines:41]InvoiceNum:38=0)  //•051999  mlb  
		$Continue:=False:C215  //`•121699  mlb was true not yet billed
	Else 
		$Continue:=True:C214
	End if 
End if 

If ($Continue)
	$MaxAllowed:=[Customers_Order_Lines:41]Quantity:6+([Customers_Order_Lines:41]Quantity:6*([Customers_Order_Lines:41]OverRun:25/100))  //• 8/15/97 cs allow for calculation to concider 'free' cartons
	
	If ($MaxAllowed>=$QtyAffected) | ([Customers:16]Pays_Overship:42)  //if the delivered qty<= max chargable ($MaxAllowed) or Cust with pay
		$TotalNew:=Round:C94(($QtyAffected/$Denom)*$PriceNew; 2)  //use delivered amount to calc New price total
	Else   //delivered more than chargeable DO NOT calc pricechange for free items
		$TotalNew:=Round:C94(($MaxAllowed/$Denom)*$PriceNew; 2)
		//insert here calc same as above for OLD ???
	End if 
	//• 8/15/97 cs end
	
	$Adjustment:=($TotalNew-$TotalOld)-$PriceChange  //this is the overall extended price change, `• 9/11/97 cs adjust for old price ch
	
	$invoiceNum:=Invoice_GetNewNumber  //3/14/95 so it can be posted to transfer record
	
	//create xfer record
	If ([Customers_Order_Lines:41]SpecialBilling:37)  //2/14/95
		sCriterion1:="SpecialBilling"
	Else 
		sCriterion1:=[Customers_Order_Lines:41]ProductCode:5
	End if 
	sCriterion2:=[Customers_Order_Lines:41]CustID:4
	sCriterion3:=""
	sCriterion4:=""
	sCriterion5:="PriceChg"  //2/10/95`  3/14/95 it was lost, now it has been found!
	i1:=0
	sCriterion6:=[Customers_Order_Lines:41]OrderLine:3
	sCriterion9:="Price Change"
	
	If ($Adjustment>0)
		rReal1:=1
		sCriterion7:="Price Increase"
		sCriterion8:=String:C10($invoiceNum)  //"Invoice issued" `3/14/95 so it can be posted to transfer record
	Else 
		rReal1:=-1
		sCriterion7:="Price Reduction"
		sCriterion8:=String:C10($invoiceNum)  //"Credit issued." `3/14/95 so it can be posted to transfer record
	End if 
	FGX_post_transaction(dAppDate; 1; "Ship")
	LOAD RECORD:C52([Finished_Goods_Transactions:33])  //reload
	[Finished_Goods_Transactions:33]PricePerM:19:=Abs:C99($Adjustment)
	[Finished_Goods_Transactions:33]ExtendedPrice:20:=$Adjustment
	SAVE RECORD:C53([Finished_Goods_Transactions:33])
	UNLOAD RECORD:C212([Finished_Goods_Transactions:33])
	
	//send invoice to A4
	//$invoiceNum:=fGetInvoiceNum 3/14/95
	$arkayRel:=0  // triggers spl handling in the api send invoice
	$billto:=[Customers_Order_Lines:41]defaultBillto:23
	$shipto:=""
	$cpn:=sCriterion1
	$custRel:=""
	$custPO:=[Customers_Order_Lines:41]PONumber:21  // 11/18/94
	$BOLnum:=0
	$FOB:=""
	
	//• 8/15/97 cs must make api reflect Fg_transaction regarding billing change on 
	//   charge vers Free items
	If ($MaxAllowed>=$QtyAffected) | ([Customers:16]Pays_Overship:42)  //if the delivered qty<= max chargable ($MaxAllowed) or Cust will pay
		$subamt:=$QtyAffected  //use delivered amount
	Else   //delivered more than chargeable DO NOT count free items
		$subamt:=$MaxAllowed
	End if 
	//• 8/15/97 cs  end
	
	$custID:=sCriterion2
	If ([Customers_Order_Lines:41]SpecialBilling:37)
		$ReMark:="Price change for Special Billing Charge for Service: "+[Customers_Order_Lines:41]ProductCode:5
	Else 
		$Remark:="Price change after shipment"
	End if 
	
	$err:=Invoice_NewAdjustment([Customers_Order_Lines:41]OrderLine:3; $invoiceNum; $Remark; $subamt; $Adjustment)
	
	//API_SendInvTran (254;255;$invoiceNum;$arkayRel;$billto;$shipto;$cpn;$custPO
	//«;$custRel;$BOLnum;$FOB;$subamt;$custID;"New";$Remark;($PriceNew-$PriceOld))  
	//«`$Adjustment)  11/18/94
	
	$0:=$InvoiceNum
End if   //`• 8/15/97 cs continue OK
//