//%attributes = {"publishedWeb":true}
//rptFuckMe mlb 082698
//try to create a report so simple, 
//that even a saleman can understand.
//given a date and a customer, rpt open order whic
//have inventory which should be shipped
//•100698  mlb  UPR 1979 remove bill & holds
// Modified by: Mel Bohince (2/15/16) clean up the file names
C_TEXT:C284($t; $cr)
C_TIME:C306($docRef)
C_LONGINT:C283($hit; $billHold)

$t:=Char:C90(9)
$cr:=Char:C90(13)
If (Count parameters:C259=0)
	$cust:=Request:C163("Customer:")
	$date:=Date:C102(Request:C163("Date:"; "mm/dd/yy"))
	$path:=""
Else 
	$cust:=$1
	$date:=$2
	$path:=$3
End if 

READ ONLY:C145([Finished_Goods:26])
READ ONLY:C145([Job_Forms_Items:44])

QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]DateOpened:13<$date; *)
QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Qty_Open:11>0; *)
QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Cancel@"; *)  //•080195  MLB 1490
QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Kill"; *)  //•080195  MLB 1490 
QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Closed"; *)  //•080195  MLB 1490 
QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]CustomerName:24=$cust)

//DELETE DOCUMENT($cust+String($date))
If (Records in selection:C76([Customers_Order_Lines:41])>0)
	$shortName:=[Customers:16]ShortName:57  // Modified by: Mel Bohince (2/15/16) clean up the file names
	If (Length:C16($shortName)<3)
		$shortName:=$cust
	End if 
	$shortName:=Replace string:C233($shortName; " Corp"; "")
	$shortName:=Replace string:C233($shortName; " Co. "; "")
	$shortName:=Replace string:C233($shortName; " Inc. "; "")
	$shortName:=Replace string:C233($shortName; " Co"; "")
	$shortName:=Replace string:C233($shortName; " Inc"; "")
	$shortName:=Replace string:C233($shortName; " and "; "&")
	$shortName:=Replace string:C233($shortName; " "; "")
	$shortName:=Replace string:C233($shortName; "."; "")
	$shortName:=Replace string:C233($shortName; ","; "")
	$shortName:=Replace string:C233($shortName; "'"; "")
	docName:=$path+Substring:C12($shortName; 1; 22)+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
	$docRef:=util_putFileName(->docName; "path provided")
	If (OK=1)
		//•100698  mlb  UPR 1979 Remove B&H from open quantity
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]Bill_and_Hold_Qty:108>0)
		ARRAY TEXT:C222($aHasBillHol; 0)
		ARRAY LONGINT:C221($aBillHoldQty; 0)
		SELECTION TO ARRAY:C260([Finished_Goods:26]ProductCode:1; $aHasBillHol; [Finished_Goods:26]Bill_and_Hold_Qty:108; $aBillHoldQty)
		SORT ARRAY:C229($aHasBillHol; $aBillHoldQty; >)
		
		SEND PACKET:C103($docRef; "Customer: "+$cust+$cr)
		SEND PACKET:C103($docRef; "Orders Older than: "+String:C10($date; <>MIDDATE)+$cr)
		SEND PACKET:C103($docRef; "Reported quantities subject to QA Verification"+$cr+$cr)
		SEND PACKET:C103($docRef; "Purchase Order"+$t)
		SEND PACKET:C103($docRef; "DateOpened"+$t)
		SEND PACKET:C103($docRef; "ProductCode"+$t)
		SEND PACKET:C103($docRef; "Line"+$t)
		SEND PACKET:C103($docRef; "Price/M"+$t)
		SEND PACKET:C103($docRef; "Order Quantity"+$t)
		SEND PACKET:C103($docRef; "Responsibility(onhand)"+$t)
		SEND PACKET:C103($docRef; "$ Liability"+$t)
		SEND PACKET:C103($docRef; "Excess(onhand)"+$t+$t)
		SEND PACKET:C103($docRef; "Glued"+$t)
		SEND PACKET:C103($docRef; "Expires"+$t)
		SEND PACKET:C103($docRef; "PackSpec"+$t)
		SEND PACKET:C103($docRef; "NextRelease"+$cr)
		
		$lastCPN:=""
		$lastPO:=""
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
			
			ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5; >; [Customers_Order_Lines:41]DateOpened:13; >)
			
			While (Not:C34(End selection:C36([Customers_Order_Lines:41])))
				QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Customers_Order_Lines:41]ProductCode:5; *)
				QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=[Customers_Order_Lines:41]CustID:4)
				//QUERY([Finished_Goods_Locations]; & ;[Finished_Goods_Locations]Location="FG@")
				
				If (Records in selection:C76([Finished_Goods_Locations:35])>0)
					If ($lastCPN#[Customers_Order_Lines:41]ProductCode:5)
						$lastCPN:=[Customers_Order_Lines:41]ProductCode:5
						$lastPO:=[Customers_Order_Lines:41]PONumber:21
						$onhand:=uNANCheck(Sum:C1([Finished_Goods_Locations:35]QtyOH:9))
						$priorOrder:=""
					Else 
						$priorOrder:=" PRIOR ORDER "
						$onhand:=$excess
					End if 
					
					If ($onhand>0)
						//•100698  mlb  UPR 1979
						$qtyOpen:=[Customers_Order_Lines:41]Qty_Open:11
						
						$hit:=Find in array:C230($aHasBillHol; [Customers_Order_Lines:41]ProductCode:5)
						If ($hit>-1)  //this customer has some bill and holds, so check this orderline
							$billHold:=$aBillHoldQty{$hit}
							$qtyOpen:=$qtyOpen-$billHold
						End if 
						
						If ($onhand>$qtyOpen)
							$respons:=$qtyOpen
							$excess:=$onhand-$respons
						Else 
							$respons:=$onhand
							$excess:=0
						End if 
						
						$numFG:=qryFinishedGood([Finished_Goods_Locations:35]CustID:16; [Finished_Goods_Locations:35]ProductCode:1)
						If ($numFG>0) & (Length:C16([Finished_Goods:26]OutLine_Num:4)>1)
							$caseCnt:=PK_getCaseCount([Finished_Goods:26]OutLine_Num:4)
							$skid:=PK_getSkidCount([Finished_Goods:26]OutLine_Num:4)
							$pakspec:=String:C10($caseCnt)+"/"+String:C10($skid)
						Else 
							$pakspec:="not found"
						End if 
						
						If (Not:C34(<>modification4D_10_05_19))  // BEGIN 4D Professional Services : Query With array
							
							SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Jobit:33; $ajobits)
							QUERY WITH ARRAY:C644([Job_Forms_Items:44]Jobit:4; $ajobits)
							
						Else 
							
							RELATE ONE SELECTION:C349([Finished_Goods_Locations:35]; [Job_Forms_Items:44])
							
						End if   // END 4D Professional Services : January 2019
						
						ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]Glued:33; <)
						$glued:=[Job_Forms_Items:44]Glued:33
						$expiration:=Add to date:C393($glued; 0; 6; 0)
						FIRST RECORD:C50([Finished_Goods_Locations:35])
						
						$nextRelease:=REL_getNextRelease([Finished_Goods_Locations:35]ProductCode:1)
						
						SEND PACKET:C103($docRef; [Customers_Order_Lines:41]PONumber:21+$t)
						SEND PACKET:C103($docRef; String:C10([Customers_Order_Lines:41]DateOpened:13; <>MIDDATE)+$t)
						SEND PACKET:C103($docRef; [Customers_Order_Lines:41]ProductCode:5+$t)
						SEND PACKET:C103($docRef; [Customers_Order_Lines:41]CustomerLine:42+$t)
						SEND PACKET:C103($docRef; String:C10([Customers_Order_Lines:41]Price_Per_M:8)+$t)
						SEND PACKET:C103($docRef; String:C10([Customers_Order_Lines:41]Quantity:6)+$t)
						SEND PACKET:C103($docRef; String:C10($respons)+$t)
						SEND PACKET:C103($docRef; String:C10(Round:C94(($respons/1000)*[Customers_Order_Lines:41]Price_Per_M:8; 2); "########0.00")+$t)
						SEND PACKET:C103($docRef; String:C10($excess)+$t+$priorOrder+$t+String:C10($glued; System date short:K1:1)+$t+String:C10($expiration; System date short:K1:1)+$t+$pakspec+$t+String:C10($nextRelease; System date short:K1:1)+$cr)
						
					End if 
				End if 
				
				NEXT RECORD:C51([Customers_Order_Lines:41])
			End while 
			
		Else 
			// PS 4D REMOVE NEXT AND SELECTION TO ARRAY([Finished_Goods_Locations]Jobit;$ajobits) QUERY WITH ARRAY([Job_Forms_Items]Jobit;$ajobits) AND ORDRE BY 
			//FIRST RECORD([Finished_Goods_Locations])
			ARRAY TEXT:C222($_ProductCode; 0)
			ARRAY DATE:C224($_DateOpened; 0)
			ARRAY TEXT:C222($_CustID; 0)
			ARRAY TEXT:C222($_PONumber; 0)
			ARRAY LONGINT:C221($_Qty_Open; 0)
			ARRAY TEXT:C222($_CustomerLine; 0)
			ARRAY REAL:C219($_Price_Per_M; 0)
			ARRAY LONGINT:C221($_Quantity; 0)
			
			SELECTION TO ARRAY:C260([Customers_Order_Lines:41]ProductCode:5; $_ProductCode; \
				[Customers_Order_Lines:41]DateOpened:13; $_DateOpened; \
				[Customers_Order_Lines:41]CustID:4; $_CustID; \
				[Customers_Order_Lines:41]PONumber:21; $_PONumber; \
				[Customers_Order_Lines:41]Qty_Open:11; $_Qty_Open; \
				[Customers_Order_Lines:41]CustomerLine:42; $_CustomerLine; \
				[Customers_Order_Lines:41]Price_Per_M:8; $_Price_Per_M; \
				[Customers_Order_Lines:41]Quantity:6; $_Quantity)
			
			SORT ARRAY:C229($_ProductCode; $_DateOpened; $_CustID; $_PONumber; $_Qty_Open; $_CustomerLine; $_Price_Per_M; $_Quantity; >)
			
			For ($Iter; 1; Size of array:C274($_CustID); 1)
				QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=$_ProductCode{$Iter}; *)
				QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=$_CustID{$Iter})
				
				If (Records in selection:C76([Finished_Goods_Locations:35])>0)
					If ($lastCPN#$_ProductCode{$Iter})
						$lastCPN:=$_ProductCode{$Iter}
						$lastPO:=$_PONumber{$Iter}
						$onhand:=uNANCheck(Sum:C1([Finished_Goods_Locations:35]QtyOH:9))
						$priorOrder:=""
					Else 
						$priorOrder:=" PRIOR ORDER "
						$onhand:=$excess
					End if 
					
					If ($onhand>0)
						//•100698  mlb  UPR 1979
						$qtyOpen:=$_Qty_Open{$Iter}
						
						$hit:=Find in array:C230($aHasBillHol; $_ProductCode{$Iter})
						If ($hit>-1)  //this customer has some bill and holds, so check this orderline
							$billHold:=$aBillHoldQty{$hit}
							$qtyOpen:=$qtyOpen-$billHold
						End if 
						
						If ($onhand>$qtyOpen)
							$respons:=$qtyOpen
							$excess:=$onhand-$respons
						Else 
							$respons:=$onhand
							$excess:=0
						End if 
						
						$numFG:=qryFinishedGood([Finished_Goods_Locations:35]CustID:16; [Finished_Goods_Locations:35]ProductCode:1)
						If ($numFG>0) & (Length:C16([Finished_Goods:26]OutLine_Num:4)>1)
							$caseCnt:=PK_getCaseCount([Finished_Goods:26]OutLine_Num:4)
							$skid:=PK_getSkidCount([Finished_Goods:26]OutLine_Num:4)
							$pakspec:=String:C10($caseCnt)+"/"+String:C10($skid)
						Else 
							$pakspec:="not found"
						End if 
						
						RELATE ONE SELECTION:C349([Finished_Goods_Locations:35]; [Job_Forms_Items:44])
						
						ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]Glued:33; <)
						$glued:=[Job_Forms_Items:44]Glued:33
						$expiration:=Add to date:C393($glued; 0; 6; 0)
						
						$nextRelease:=REL_getNextRelease([Finished_Goods_Locations:35]ProductCode:1)
						
						SEND PACKET:C103($docRef; $_PONumber{$Iter}+$t)
						SEND PACKET:C103($docRef; String:C10($_DateOpened{$Iter}; <>MIDDATE)+$t)
						SEND PACKET:C103($docRef; $_ProductCode{$Iter}+$t)
						SEND PACKET:C103($docRef; $_CustomerLine{$Iter}+$t)
						SEND PACKET:C103($docRef; String:C10($_Price_Per_M{$Iter})+$t)
						SEND PACKET:C103($docRef; String:C10($_Quantity{$Iter})+$t)
						SEND PACKET:C103($docRef; String:C10($respons)+$t)
						SEND PACKET:C103($docRef; String:C10(Round:C94(($respons/1000)*$_Price_Per_M{$Iter}; 2); "########0.00")+$t)
						SEND PACKET:C103($docRef; String:C10($excess)+$t+$priorOrder+$t+String:C10($glued; System date short:K1:1)+$t+String:C10($expiration; System date short:K1:1)+$t+$pakspec+$t+String:C10($nextRelease; System date short:K1:1)+$cr)
						
					End if 
				End if 
				
				
			End for 
			
		End if   // END 4D Professional Services : January 2019 
		
		REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)
		ARRAY TEXT:C222($aHasBillHol; 0)
		ARRAY LONGINT:C221($aBillHoldQty; 0)
		
		CLOSE DOCUMENT:C267($docRef)
		// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
	End if 
End if 