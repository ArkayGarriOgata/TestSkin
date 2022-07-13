//%attributes = {"publishedWeb":true}
//PM:  rChanelRpt  5/12/00  mlb
//based on:  rProctorAndGamble()  3/22/00  mlb
//based on  `(p) rMaryKay5 `•091098  MLB  first clean up of rMaryKay3
//use bin counts, scraps and shippments and back into production,
//rather than the other way around
//•100798 mlb prblem when identical jobits exist

C_TEXT:C284(sCPN)
C_TEXT:C284(sDesc; $CustName)
C_TEXT:C284(aSubtitle3)
C_DATE:C307(dDate; dDate1)
C_LONGINT:C283($i; $Printed; $linesOnPage; iPage; $Err; $numOL; $pegged)
C_BOOLEAN:C305($Print2Disk; $Continue)
C_TEXT:C284(xText; t2; t2b; $Path)
C_TEXT:C284($t; $Cr)
C_REAL:C285(rReal1; rReal2; rReal3; rReal4; rReal5; rReal6; rReal7; rReal8; rReal9; rReal10; rreal11; rReal12; rBH)  //report layout vars

$t:=Char:C90(9)
$cr:=Char:C90(13)
$CustName:="Chanel"

MESSAGES OFF:C175
//*   read only files
READ ONLY:C145([Customers:16])
READ ONLY:C145([Customers_Order_Lines:41])
READ ONLY:C145([Job_Forms_Items:44])
READ ONLY:C145([Finished_Goods_Locations:35])
READ ONLY:C145([Finished_Goods:26])

zwStatusMsg("Chanel"; " Searching for "+$CustName)
QUERY:C277([Customers:16]; [Customers:16]Name:2=$CustName+"@")  //load customer name
$CustId:=[Customers:16]ID:1

tCust:=[Customers:16]Name:2
t2:=tCust+" Order Summary"
t2b:=""
$linesOnPage:=34  //this is an estimated starting point/guess,`• 12/4/97 cs 

//*Print or Disk?
uYesNoCancel("Do you want to print this report to a Excel file?"; "Excel"; "Paper"; "Cancel")
//CONFIRM("Do you want to print this report to a Excel file?";"Excel";"Paper")
Case of 
	: (bCancel=1)
		$Continue:=False:C215
	: (bAccept=1)
		$Print2Disk:=True:C214
		$Path:=uCreateFolder("ChanelReports_"+fYYMMDD(4D_Current_date))  //•091098  MLB 
		$Continue:=True:C214
	: (bNo=1)
		util_PAGE_SETUP(->[Finished_Goods:26]; "rMaryKay.h")
		PRINT SETTINGS:C106
		$Continue:=(ok=1)
		$Print2Disk:=False:C215
End case 

//*Chk for missing Billtos
If ($Continue)  //•091098  MLB  give earlyer warning
	MESSAGE:C88($CR+" Searching Orderlines, limiting to Custid: "+$CustId)
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
		
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4=$CustId; *)
			QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Cancel@"; *)  //•080195  MLB 1490
			QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Kill"; *)  //•080195  MLB 1490    
			QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]SpecialBilling:37=False:C215)
			CREATE SET:C116([Customers_Order_Lines:41]; "All")  //• 5/18/98 cs create set of located orderlines, to split them by ship tos
			QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]defaultBillto:23="")
			
		Else 
			
			SET QUERY DESTINATION:C396(Into set:K19:2; "All")
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4=$CustId; *)
			QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Cancel@"; *)  //•080195  MLB 1490
			QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Kill"; *)  //•080195  MLB 1490    
			QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]SpecialBilling:37=False:C215)
			
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4=$CustId; *)
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Cancel@"; *)  //•080195  MLB 1490
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Kill"; *)  //•080195  MLB 1490    
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]SpecialBilling:37=False:C215; *)
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]defaultBillto:23="")
			
		End if   // END 4D Professional Services : January 2019 query selection
		
	Else 
		
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4=$CustId; *)
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Cancel@"; *)  //•080195  MLB 1490
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Kill"; *)  //•080195  MLB 1490    
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]SpecialBilling:37=False:C215; *)
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]defaultBillto:23="")
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	If (Records in selection:C76([Customers_Order_Lines:41])=0)
		$Continue:=True:C214
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
			
			USE SET:C118("All")
			
			
		Else 
			
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4=$CustId; *)
			QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Cancel@"; *)  //•080195  MLB 1490
			QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Kill"; *)  //•080195  MLB 1490    
			QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]SpecialBilling:37=False:C215)
			
		End if   // END 4D Professional Services : January 2019 query selection
		$numOL:=Records in selection:C76([Customers_Order_Lines:41])
		If ($numOL=0)
			$Continue:=False:C215
		End if 
		
	Else   //*    Bail out if any found
		$Continue:=False:C215
		ALERT:C41("One or more Orderlines for Chanel have no 'Bill to'"+Char:C90(13)+"Please correct this before running this report."+Char:C90(13)+"See report currently printing to determine which orderlines.")
		xText:=""
		xTitle:="Chanel Orderlines without 'Bill Tos'"
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			For ($i; 1; Records in selection:C76([Customers_Order_Lines:41]))
				xText:=xText+[Customers_Order_Lines:41]OrderLine:3+Char:C90(13)
				NEXT RECORD:C51([Customers_Order_Lines:41])
			End for 
			
		Else 
			
			ARRAY TEXT:C222($_OrderLine; 0)
			SELECTION TO ARRAY:C260([Customers_Order_Lines:41]OrderLine:3; $_OrderLine)
			
			For ($i; 1; Size of array:C274($_OrderLine); 1)
				xText:=xText+$_OrderLine{$i}+Char:C90(13)
			End for 
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		rPrintText("No_Bill_Tos")
	End if 
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
		
		CLEAR SET:C117("All")
		
	Else 
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	
End if 

If ($Continue)
	rInitMKRptVars  //*Clear report's variables
	MESSAGE:C88($cr+" Loading the orderlines...")
	//*Load the Orderlines  
	ARRAY TEXT:C222(aCPN; $numOL)  //selection to arrays
	ARRAY TEXT:C222($aPO; $numOL)
	ARRAY TEXT:C222($aOL; $numOL)
	ARRAY LONGINT:C221($aOrdQty; $numOL)
	ARRAY REAL:C219($aOverRun; $numOL)
	ARRAY DATE:C224($aDateOpen; $numOL)
	ARRAY LONGINT:C221($aShipped; $numOL)
	ARRAY LONGINT:C221($aReturned; $numOL)
	ARRAY REAL:C219($aPrice; $numOL)
	ARRAY TEXT:C222($aStatus; $numOL)  //• 1/14/98 cs added status to arrays loaded
	ARRAY LONGINT:C221($aOpenQty; $numOL)  //• 1/14/98 cs qty open on order
	ARRAY TEXT:C222($aOrdBillto; $numOL)
	ARRAY TEXT:C222($aSortKey; $numOL)  //•091098  MLB 
	ARRAY TEXT:C222($exception; $numOL)  //•091098  MLB 
	ARRAY DATE:C224($aProdDate; $numOL)  //• 8/14/98 cs track production date
	
	ARRAY LONGINT:C221($aORqty; $numOL)  //other totals, accumulators
	ARRAY LONGINT:C221($aNetShipped; $numOL)
	ARRAY LONGINT:C221($aProduced; $numOL)
	ARRAY LONGINT:C221($aOrdLinEx; $numOL)
	ARRAY LONGINT:C221($aTotOnHand; $numOL)
	ARRAY LONGINT:C221($aQAQty; $numOL)
	ARRAY LONGINT:C221($aBHQty; $numOL)
	ARRAY LONGINT:C221($aPayUseQty; $numOL)
	//• 5/18/98 cs added sort by ship to  
	//• 1/14/98 cs added status to arrays loaded,`• 5/18/98 cs added default ship to
	SELECTION TO ARRAY:C260([Customers_Order_Lines:41]OrderLine:3; $aOL; [Customers_Order_Lines:41]ProductCode:5; aCPN; [Customers_Order_Lines:41]Quantity:6; $aOrdQty; [Customers_Order_Lines:41]Price_Per_M:8; $aPrice; [Customers_Order_Lines:41]Qty_Shipped:10; $aShipped; [Customers_Order_Lines:41]DateOpened:13; $aDateOpen; [Customers_Order_Lines:41]PONumber:21; $aPO; [Customers_Order_Lines:41]OverRun:25; $aOverRun; [Customers_Order_Lines:41]Qty_Returned:35; $aReturned; [Customers_Order_Lines:41]Status:9; $aStatus; [Customers_Order_Lines:41]Qty_Open:11; $aOpenQty; [Customers_Order_Lines:41]defaultBillto:23; $aOrdBillto)
	//*     make billto key
	For ($i; 1; $numOL)  //•091098  MLB 
		$aSortKey{$i}:=$aOrdBillto{$i}+aCPN{$i}+$aOL{$i}
	End for 
	SORT ARRAY:C229($aSortKey; $aOL; aCPN; $aOrdQty; $aPrice; $aShipped; $aDateOpen; $aPO; $aOverRun; $aReturned; $aStatus; $aOpenQty; $aOrdBillto; >)  //•091098  MLB 
	ARRAY TEXT:C222($aSortKey; 0)  //•091098  MLB
	//MESSAGE($cr+"   Building excess tallies")
	//MkBuildUniques   ` ($numOL)  `setup arrays of unique CPNs  
	
	
	//*Process each Orderline
	MESSAGE:C88($cr+" Processing the orderlines...")
	uThermoInit($numOL; "Processing Orderlines")
	
	For ($i; 1; $numOL)  //*For every orderline to print
		//*    Orderline stuff            
		$aORqty{$i}:=$aOrdQty{$i}*($aOverRun{$i}/100)
		$aNetShipped{$i}:=$aShipped{$i}-$aReturned{$i}
		
		//If (aCpn{$i}="427545-1")
		//utl_Trace 
		//End if 
		
		$onHandFG:=0
		$Scrap:=0  //accum scrap transactions
		$Relieved:=0  //accum receipt transactions
		$ProdPerJMI:=0  //stated actual qty produced
		$calcMade:=0  //based on bin, scrap, and ship qtys
		//*    Find production qtys
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]OrderItem:2=$aOL{$i})
		ARRAY TEXT:C222($ajmiJF; 0)
		ARRAY LONGINT:C221($ajmiItem; 0)
		ARRAY LONGINT:C221($ajmiAct; 0)
		ARRAY DATE:C224($ajmiGlued; 0)
		SELECTION TO ARRAY:C260([Job_Forms_Items:44]JobForm:1; $ajmiJF; [Job_Forms_Items:44]ItemNumber:7; $ajmiItem; [Job_Forms_Items:44]Qty_Actual:11; $ajmiAct; [Job_Forms_Items:44]Glued:33; $ajmiGlued)
		//•100798 mlb prblem when identical jobits exist
		ARRAY TEXT:C222($ajmiJobit; Size of array:C274($ajmiJF))
		For ($pegged; 1; Size of array:C274($ajmiJF))
			$ajmiJobit{$pegged}:=$ajmiJF{$pegged}+"."+String:C10($ajmiItem{$pegged}; "00")
		End for 
		SORT ARRAY:C229($ajmiJobit; $ajmiJF; $ajmiItem; $ajmiAct; $ajmiGlued; >)
		$lastJobit:=""
		
		For ($pegged; 1; Size of array:C274($ajmiJF))
			$ProdPerJMI:=$ProdPerJMI+$ajmiAct{$pegged}  //stated actual qty produced
			
			If ($aJmiGlued{$pegged}#!00-00-00!)  //get earliest production date recorded
				If ($aJmiGlued{$pegged}<$aProdDate{$i}) | ($aProdDate{$i}=!00-00-00!)
					$aProdDate{$i}:=$aJmiGlued{$pegged}
				End if 
			End if 
			
			If ($lastJobit#$ajmiJobit{$pegged})  //•100798 mlb prblem when identical jobits exist
				//*      Tally FG_locations for this jobit
				$numBins:=qryFGbins($ajmiJF{$pegged}; ""; $ajmiItem{$pegged})
				ARRAY TEXT:C222($aBinLoc; 0)
				ARRAY LONGINT:C221($aBinQty; 0)
				SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]QtyOH:9; $aBinQty; [Finished_Goods_Locations:35]Location:2; $aBinLoc)
				For ($bin; 1; $numBins)
					Case of 
						: (Position:C15(Substring:C12($aBinLoc{$bin}; 1; 2); " CC EX XC ")>0)  //*         QA 
							$aQAQty{$i}:=$aQAQty{$i}+$aBinQty{$bin}
						: (Position:C15(Substring:C12($aBinLoc{$bin}; 4; 2); " AV ")>0)  //*         PayUse
							$aPayUseQty{$i}:=$aPayUseQty{$i}+$aBinQty{$bin}  //give me total Payuse for order line
						: (Position:C15(Substring:C12($aBinLoc{$bin}; 1; 2); " BH ")>0)  //*         bill and hold
							$aBHQty{$i}:=$aBHQty{$i}+$aBinQty{$bin}
						Else 
							$onHandFG:=$onHandFG+$aBinQty{$bin}
					End case 
				End for   //bin     
				ARRAY TEXT:C222($aBinLoc; 0)
				ARRAY LONGINT:C221($aBinQty; 0)
				
				//*      Tally FG_xfers
				$numXfers:=qryFGxfers($ajmiJF{$pegged}; ""; $ajmiItem{$pegged})
				ARRAY LONGINT:C221($aTranQty; 0)
				ARRAY TEXT:C222($aTranType; 0)  //• 8/20/98 cs need to trac transaction type to invert some transactionvalues     
				SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]Qty:6; $aTranQty; [Finished_Goods_Transactions:33]XactionType:2; $aTranType)
				For ($xfer; 1; $numXfers)
					Case of 
						: ($aTranType{$xfer}="Receipt")  //*   Receipt
							$Relieved:=$Relieved+$aTranQty{$xfer}
						: ($aTranType{$xfer}="Scrap")  //*   Scrap
							$Scrap:=$Scrap+$aTranQty{$xfer}
					End case 
				End for   //$xfer
				ARRAY LONGINT:C221($aTranQty; 0)
				ARRAY TEXT:C222($aTranType; 0)
				$lastJobit:=$ajmiJobit{$pegged}  //•100798 mlb prblem when identical jobits exist
			End if 
			
		End for   //$pegged jobit
		
		ARRAY TEXT:C222($ajmiJF; 0)
		ARRAY LONGINT:C221($ajmiItem; 0)
		ARRAY LONGINT:C221($ajmiAct; 0)
		ARRAY DATE:C224($ajmiGlued; 0)
		
		$calcMade:=$onHandFG+$aQAQty{$i}+$aPayUseQty{$i}+$Scrap+$aNetShipped{$i}+$aBHQty{$i}
		$aTotOnHand{$i}:=$onHandFG+$aQAQty{$i}+$aPayUseQty{$i}  //-$Scrap  `-$aNetShipped{$i}
		
		$exception{$i}:=""
		If ($calcMade#$ProdPerJMI)
			$exception{$i}:=$exception{$i}+"j"
		End if 
		If ($calcMade#$Relieved)
			$exception{$i}:=$exception{$i}+"x"
		End if 
		
		$aProduced{$i}:=$calcMade
		
		//$Uniq:=Find in array(aUniqCpn;aCPN{$i})
		//aUniqProd{$Uniq}:=aUniqProd{$Uniq}+$calcMade  `sum all production for
		//« this product
		//aUniqPayUse{$Uniq}:=aUniqPayUse{$Uniq}+$aPayUseQty{$i}  `sum all
		//« payuse for this product
		
		If ($aStatus{$i}#"Closed")
			$aOrdLinEx{$i}:=$aTotOnHand{$i}-($aOpenQty{$i}+$aORqty{$i})  //Excess for orderline = qty on hand for order - (open qty for order+overrun)
		Else 
			$aOrdLinEx{$i}:=$aTotOnHand{$i}
		End if 
		If ($aOrdLinEx{$i}<0)  //if negative set to zero
			$aOrdLinEx{$i}:=0
		End if 
		
		
		uThermoUpdate($i)
	End for   //i   end preprocessing 
	uThermoClose
	
	//*-----
	//*Print the damn thing    
	
	If ($Print2Disk)
		MESSAGE:C88($cr+" Saving Orderlines in "+$path)
	Else 
		MESSAGE:C88($cr+" Printing the orderlines...")
	End if 
	$CurrentBill:=$aOrdBillto{1}  //• 5/18/98 cs set current shiping destination
	$Continue:=MKHeader4Chanel($Print2Disk; $CurrentBill; $Path)  //this places the correct header on the first report
	If ($Continue)
		xText:=""
		REDUCE SELECTION:C351([Finished_Goods:26]; 0)
		uThermoInit($numOL; "Printing Orderlines")
		For ($i; 1; $numOL)
			//If (aCpn{$i}="20-025408-01")
			//utl_Trace 
			//End if 
			If ($aStatus{$i}="Closed") & ($aOrdLinEx{$i}<=0) & ($aPayUseQty{$i}<=0)
				//$exception{$i}:=$exception{$i}+"H"          `hide
			Else 
				//* assign layout vars the correct values
				If ([Finished_Goods:26]ProductCode:1#aCPN{$i})
					qryFinishedGood($CustId; aCPN{$i})
					//$Uniq:=Find in array(aUniqCPN;aCPN{$i})
				End if 
				
				$CalcedExces:=0
				If ($aStatus{$i}="Closed")  //•r e8/20/98 cs placed above to get closed orer not to think they should
					//roll forward excess                
					If (($i+1)<=$numOL)
						MkSetupClosed(aCPN{$i}; $aOrdLinEx{$i})
						rBH:=$aBHQty{$i}
					End if 
					
				Else 
					sCPN:=aCPN{$i}
					aSubtitle3:=$aPo{$i}
					sDesc:=[Finished_Goods:26]CartonDesc:3
					rReal1:=$aOrdQty{$i}  //ordered quantity
					rReal2:=rReal1+$aOrQty{$I}  //allowable (sellable) ordered + overage allowance
					rReal3:=$aProduced{$i}  //qty produced (calculated)
					rReal4:=$aNetShipped{$i}+$aPayUseQty{$i}  //qty transfered = qty shipped - returns + payuse
					rReal5:=$aQAQty{$i}  //QA - quantity in CC & EX xc
					rBH:=$aBHQty{$i}
					rReal6:=$aPayUseQty{$i}  //Qty in Pay-use bin (Alford Tx)
					//rReal7:=rReal3-rReal4-rReal5  `qty on hand for this order = qty
					//« produced - total shipped - `• 5/29/98 cs QA
					//$aTotOnHand{$i} all bin locations, Arkay property, no scrap or shipments
					rReal7:=$aTotOnHand{$i}-$aPayUseQty{$i}-$aQAQty{$i}  // shippable FG in arkay warehouses
					If (rReal7<0)
						rReal7:=0
					End if 
					rReal8:=rReal2-rReal4-rBH  //QtyDueTotranfer = Ordered(w/Over) - (Netshipped & Payuse)
					
					If (rReal8<0)  //• 5/22/98 cs DO NOT display negative balance due
						rReal8:=0
					End if 
					
					rReal9:=rReal6  //custoemr responseibility at least`set amount Payuse bin
					Case of 
						: (rReal7>rReal8)  //on hand > Balance due
							rReal9:=rReal9+rReal8  // take all Bal due+Payuse
						Else   //less available than due
							rReal9:=rReal9+rReal7  //take our on hand+Payuse
					End case 
					
					If (rReal4=0)  //if qty shipped is 0 clear last ship date
						dDate1:=!00-00-00!
					Else   //used FG record as last ship
						dDate1:=[Finished_Goods:26]LastShipDate:19
					End if 
					
					$Divisor:=1000
					If ([Finished_Goods:26]Acctg_UOM:29#"M")
						$Divisor:=1
					End if 
					rReal10:=Round:C94((rReal9*$aPrice{$i})/$Divisor; 2)
					//   $aOrdLinEx{$i}:=$onHandFG-($aOpenQty{$i}+$aORqty{$i}) 
					rReal11:=$aOrdLinEx{$i}  //Arkay excess
					rReal12:=$aPrice{$i}
					$CalcedExces:=(rReal3-rReal4-rReal5)-rReal8  //(produced-transfered-QA)-BalDue
					
					If ($CalcedExces<0)  //• 8/14/98 cs 
						$CalcedExces:=0
					End if 
				End if 
				
				If ($CurrentBill#$aOrdBillto{$i})  //• 5/18/98 cs this item is a change of shipping company            
					If ($Print2Disk)
						SEND PACKET:C103(vDoc; xText)
						$fileName:=Document
						CLOSE DOCUMENT:C267(vDoc)  //close disk file
						// obsolete call, method deleted 4/28/20 uDocumentSetType ($fileName)
					Else 
						PAGE BREAK:C6(>)  //send report page to printer                
					End if 
					$CurrentBill:=$aOrdBillto{$i}
					MKHeader4Chanel($Print2Disk; $CurrentBill; $Path)  //start new report for different shipping address
					xText:=""
				End if 
				
				If ($Print2Disk)  //*    Save to disk file
					uSendPacket(vDoc; $exception{$i}+$T+$T+aSubtitle3+$T+sCPN+$T+sDesc+$t+String:C10(rReal12)+$t)
					uSendPacket(vDoc; String:C10(rReal1)+$t+String:C10(rReal2)+$t)
					Case of 
						: (rReal3=0) & (aSubTitle3#"Closed")  //donot put 'I/P' if order is close
							uSendPacket(vDoc; " I/P"+$t)
						: (rReal3<0) & (aSubTitle3="Closed")  //• 6/18/98 cs do put 'Complete' if order is closed
							uSendPacket(vDoc; " Complete"+$t)
						Else 
							uSendPacket(vDoc; String:C10(rReal3)+$t)
					End case   //qty produced = 0            
					uSendPacket(vDoc; String:C10(rReal4)+$t+String:C10(rReal5)+$t+String:C10(rBH)+$t+String:C10(rReal6)+$t+String:C10($aTotOnHand{$i})+$t+String:C10(rReal7)+$t)
					uSendPacket(vDoc; String:C10(rReal8)+$t+String:C10(rReal9)+$t+String:C10(Round:C94(rReal10; 2))+$t+String:C10(rReal11)+$t)
					uSendPacket(vDoc; String:C10($CalcedExces)+$t+String:C10(dDate1; <>MIDDATE)+$t+String:C10($aProdDate{$i}; <>MIDDATE)+$cr)
					If (Length:C16(xText)>28000)
						SEND PACKET:C103(vDoc; xText)
						xText:=""
					End if 
					
				Else 
					$Printed:=MkDetailPrint3($Print2Disk; $Printed; $linesOnPage; $aStatus{$i}; $aTotOnHand{$i}; $CalcedExces; $aProdDate{$i})  //print to report
				End if 
				
			End if   //hide
			
			uThermoUpdate($i)
		End for 
		uThermoClose
	Else 
		ALERT:C41("Document for "+$aOrdBillto{$i}+" could not be opened.  Please try again, or print this report to "+"the printer")
	End if 
	
	If (Not:C34($print2Disk))
		//CLOSE WINDOW  `message window
		PAGE BREAK:C6
	Else 
		SEND PACKET:C103(vDoc; xText)
		xText:=""
		$fileName:=Document
		CLOSE DOCUMENT:C267(vDoc)
		// obsolete call, method deleted 4/28/20 uDocumentSetType ($fileName)
	End if 
	CLOSE WINDOW:C154  //message window
	//*-
	$numOL:=0  //*CLEAR ARRAYS
	ARRAY TEXT:C222(aCPN; $numOL)  //selection to arrays
	ARRAY TEXT:C222($aPO; $numOL)
	ARRAY TEXT:C222($aOL; $numOL)
	ARRAY LONGINT:C221($aOrdQty; $numOL)
	ARRAY REAL:C219($aOverRun; $numOL)
	ARRAY DATE:C224($aDateOpen; $numOL)
	ARRAY LONGINT:C221($aShipped; $numOL)
	ARRAY LONGINT:C221($aReturned; $numOL)
	ARRAY REAL:C219($aPrice; $numOL)
	ARRAY TEXT:C222($aStatus; $numOL)  //• 1/14/98 cs added status to arrays loaded
	ARRAY LONGINT:C221($aOpenQty; $numOL)  //• 1/14/98 cs qty open on order
	
	ARRAY LONGINT:C221($aORqty; $numOL)  //other totals, accumulators
	ARRAY LONGINT:C221($aNetShipped; $numOL)
	ARRAY LONGINT:C221($aProduced; $numOL)
	ARRAY LONGINT:C221($aOrdLinEx; $numOL)
	ARRAY LONGINT:C221($aTotOnHand; $numOL)
	ARRAY LONGINT:C221($aQAQty; $numOL)
	ARRAY LONGINT:C221($aBHQty; $numOL)
	ARRAY LONGINT:C221($aPayUseQty; $numOL)
	ARRAY TEXT:C222($aOrdBillto; $numOL)
	ARRAY TEXT:C222($aSortKey; $numOL)  //•091098  MLB 
	ARRAY TEXT:C222($exception; $numOL)  //•091098  MLB 
	
	//MkBuildUniques 
End if   //continue

uClearSelection(->[Customers_Order_Lines:41])
uClearSelection(->[Customers:16])
uClearSelection(->[Job_Forms_Items:44])
uClearSelection(->[Finished_Goods_Locations:35])
uClearSelection(->[Finished_Goods:26])
uWinListCleanup