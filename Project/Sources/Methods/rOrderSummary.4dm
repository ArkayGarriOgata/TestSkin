//%attributes = {"publishedWeb":true}
//(p) rOrdersummary
//NOTE:: remember to examine rMaryKay &rMarykay2 for needed similar changes
//• 5/18/98 cs 
//this report was initailly written for Mary Kay - however, they
//changed their minds on what it was supposed to do, AFTER implementation
//At that point in time this report was being used for other customers

//this reports the total on-hand, qty in Payuse bins (if any)
//qty ordered, qty + overrun,+ qty produced & shipped.
//it aso values the remainder of the open order which has been produced)
//requested (as this was being designed) to make generict
//• 10/27/97 cs created
//• 12/4/97 cs changed number of item/page
//• 1/14/98 cs changes to report so that it includes closed orders with excess
//• 5/18/98 cs modified so that user has option to supppress excess roll forward
//• 6/18/98 cs needed to locate scrap - new code, cleared arrays
//• 8/24/98 cs changed search from customer name to Cust id - Paul Muniz request
//•091098  MLB  chgd fg trans stuff

C_TEXT:C284($Format)
C_TEXT:C284(sCPN)
C_TEXT:C284(sDesc)
C_TEXT:C284(aSubtitle3)
C_DATE:C307(dDate; dDate1)
C_LONGINT:C283($i; $ToPrint; $Printed; $Max; $QACount; $PayUseCount; iPage; $RecCount)
C_BOOLEAN:C305($Print2Disk; $IsRoom; $Continue)
C_TEXT:C284(xText; t2; t2b)
C_TEXT:C284($t; $Cr)
C_TEXT:C284(sCustName)
C_REAL:C285(rReal1; rReal2; rReal3; rReal4; rReal5; rReal6; rReal7; rReal8; rReal9; rReal10; rreal11; rReal12)  //report layout vars

sCustName:=""
READ ONLY:C145([Customers:16])
READ ONLY:C145([Customers_Order_Lines:41])
READ ONLY:C145([Job_Forms_Items:44])
READ ONLY:C145([Finished_Goods_Locations:35])
READ ONLY:C145([Finished_Goods:26])
uDialog("SelCustRollFwd"; 250; 130)

If (OK=1)
	QUERY:C277([Customers:16]; [Customers:16]ID:1=sCust)  //load customer `• 8/24/98 cs changed from customer name to Cust id
	//SEARCH([CUSTOMER];[CUSTOMER]ID=sCust)
	
	If (Records in selection:C76([Customers:16])=1)
		$CustId:=[Customers:16]ID:1
		$PayUse:="FG:Av"  //Default for start of Payuse bin
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2=$PayUse+"@")
		CREATE SET:C116([Finished_Goods_Locations:35]; "PayUse")
		
		If (OK=1)
			$T:=Char:C90(9)
			$Cr:=Char:C90(13)
			$Format:="###,###,##0"  //amount Format
			$IsRoom:=True:C214
			$Max:=34  //this is an estimated starting point/guess,`• 12/4/97 cs 
			$Print2Disk:=(uConfirm("Do you Want to print this report to a Disk File?"; "Disk"; "Printer")=1)
			rInitMKRptVars
			$Continue:=MkHeaderPrint($Print2Disk; $CustID)
			
			If ($Continue)
				MESSAGE:C88("Gathering FG & Order data please stand by..."+Char:C90(13))
				<>FgBatchDat:=!00-00-00!
				<>OrdBatchDat:=!00-00-00!
				BatchFGinventor
				BatchOrdcalc
				MESSAGE:C88("Processing Data......"+Char:C90(13))
				MESSAGES OFF:C175
				
				//*Load the all inventory & open demand  
				//load ◊aFGKey & ◊aQty_OH; ◊aOrdKey, ◊aQty_Open, & ◊aQty_ORun
				uINVauxil(1; tCust)
				//*Create a flag so that inv with out orders is not ommitted  
				$numFGs:=Size of array:C274(<>aFGKey)
				uINVauxil(2; ""; $numFGs)  //load aPayU2 & aQty which indicate if it is in the rpt, & the total excess 
				ARRAY LONGINT:C221($aExcessQty; Size of array:C274(aQty))
				COPY ARRAY:C226(aQty; $aExcessQty)  //this is for readability
				uINVauxil(5; $CustId; rMonth; dDateEnd)  //get OL, FG, Bin, and JMI
				$ToPrint:=Records in selection:C76([Customers_Order_Lines:41])
				
				If ($ToPrint>0)  //  there is something to print
					ARRAY TEXT:C222(aCpn; $ToPrint)  //selection to arrays
					ARRAY TEXT:C222($aPO; $ToPrint)
					ARRAY TEXT:C222($aOL; $ToPrint)
					ARRAY LONGINT:C221($OrdQty; $ToPrint)
					ARRAY REAL:C219($aOverRun; $ToPrint)
					ARRAY DATE:C224($aDateOpen; $ToPrint)
					ARRAY LONGINT:C221($aShipped; $ToPrint)
					ARRAY LONGINT:C221($aReturned; $ToPrint)
					ARRAY REAL:C219($aPrice; $ToPrint)
					ARRAY TEXT:C222($aStatus; $ToPrint)  //• 1/14/98 cs added status to arrays loaded
					ARRAY LONGINT:C221($aOpenQty; $ToPrint)  //• 1/14/98 cs qty open on order
					ARRAY LONGINT:C221($aORqty; $ToPrint)  //other totals, accumulators
					ARRAY LONGINT:C221($aNetShipped; $ToPrint)
					ARRAY LONGINT:C221($aProduced; $ToPrint)
					ARRAY LONGINT:C221($aOrdLinEx; $ToPrint)
					ARRAY LONGINT:C221($aTotOnHand; $ToPrint)
					ARRAY LONGINT:C221($aQAQty; $ToPrint)
					ARRAY LONGINT:C221($aPayUseQty; $ToPrint)
					
					ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5; >; [Customers_Order_Lines:41]OrderLine:3; >)  //easier than typig in all arrays that would need to be sorted together
					//• 1/14/98 cs added status to arrays loaded
					SELECTION TO ARRAY:C260([Customers_Order_Lines:41]OrderLine:3; $aOL; [Customers_Order_Lines:41]ProductCode:5; aCpn; [Customers_Order_Lines:41]Quantity:6; $OrdQty; [Customers_Order_Lines:41]Price_Per_M:8; $aPrice; [Customers_Order_Lines:41]Qty_Shipped:10; $aShipped; [Customers_Order_Lines:41]DateOpened:13; $aDateOpen; [Customers_Order_Lines:41]PONumber:21; $aPO; [Customers_Order_Lines:41]OverRun:25; $aOverRun; [Customers_Order_Lines:41]Qty_Returned:35; $aReturned; [Customers_Order_Lines:41]Status:9; $aStatus; [Customers_Order_Lines:41]Qty_Open:11; $aOpenQty)
					
					MkBuildUniques($ToPrint)  //setup arrays of unique CPNs
					//*   FG_locations
					$RecCount:=Records in selection:C76([Finished_Goods_Locations:35])
					ARRAY TEXT:C222($aBinJF; $RecCount)
					ARRAY LONGINT:C221($aBinQty; $RecCount)
					ARRAY INTEGER:C220($aBinItem; $RecCount)
					ARRAY TEXT:C222($aBinLoc; $RecCount)
					ARRAY TEXT:C222($aBinCPN; $RecCount)
					
					SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]JobForm:19; $aBinJF; [Finished_Goods_Locations:35]JobFormItem:32; $aBinItem; [Finished_Goods_Locations:35]QtyOH:9; $aBinQty; [Finished_Goods_Locations:35]Location:2; $aBinLoc; [Finished_Goods_Locations:35]ProductCode:1; $aBinCpn)
					SORT ARRAY:C229($aBinJF; $aBinItem; $aBinQty; $aBinLoc; $aBinCpn; >)
					//*   JMI
					$RecCount:=Records in selection:C76([Job_Forms_Items:44])
					ARRAY TEXT:C222($ajmiJF; $RecCount)
					ARRAY TEXT:C222($ajmiOL; $RecCount)
					ARRAY LONGINT:C221($ajmiItem; $RecCount)
					ARRAY LONGINT:C221($ajmiAct; $RecCount)
					
					SELECTION TO ARRAY:C260([Job_Forms_Items:44]OrderItem:2; $ajmiOL; [Job_Forms_Items:44]JobForm:1; $ajmiJF; [Job_Forms_Items:44]ItemNumber:7; $ajmiItem; [Job_Forms_Items:44]Qty_Actual:11; $ajmiAct)
					SORT ARRAY:C229($ajmiOL; $ajmiJF; $ajmiItem; $ajmiAct; >)  //by orderline`•073096  MLB  left the actual out of the search
					//•091098  MLB  chgd
					//SEARCH([FG_Transactions];[FG_Transactions]XactionType="Scrap")  
					//«`• 6/18/98 cs needed to locate scrap - was in mary kay orderline rountine
					//« but fai
					//$RecCount:=Records in selection([FG_Transactions])  `• 1/14/98
					//« cs added tracking of SCRAP transactions
					//ARRAY TEXT(aTranCPN;$RecCount)  `• 1/14/98 cs the current
					//« selection of fg_trans are scraps for the products on 
					//ARRAY TEXT(aTranJF;$RecCount)  `on the orderlines being
					//« processed
					//ARRAY REAL(aTranQty;$RecCount)
					//
					//SORT SELECTION([FG_Transactions];[FG_Transactions]JobFormItem;>;
					//«[FG_Transactions]ProductCode;>)
					//SELECTION TO ARRAY([FG_Transactions]ProductCode;aTranCPN;[FG
					//«_Transactions]Qty;aTranQty;[FG_Transactions]JobForm;aTranJF)
					//
					MESSAGE:C88($cr+" Loading the transactions...")
					
					QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Scrap"; *)  //• 6/18/98 cs needed to locate scrap - was in mary kay orderline rountine but fai
					QUERY SELECTION:C341([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]XactionType:2="Receipt")  //•091098  MLB  
					
					
					
					//$RecCount:=Records in selection([FG_Transactions])  `• 1/14/98 cs
					//« added tracking of SCRAP transactions
					// ARRAY TEXT(aTranCPN;0)  `• 1/14/98 cs the current selection of fg_trans ar
					ARRAY TEXT:C222($aTranJF; 0)  //on the orderlines being processed
					ARRAY LONGINT:C221(aTranQty; 0)
					ARRAY TEXT:C222(aTranType; 0)  //• 8/20/98 cs need to trac transaction type to invert some transactionvalues
					ARRAY INTEGER:C220($aTranItem; 0)
					ARRAY TEXT:C222(aTranJobit; 0)
					//SORT SELECTION([FG_Transactions];[FG_Transactions]JobFormItem;>;[FG
					//«_Transactions]ProductCode;>)`•091098  MLB  sort by jobit
					SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]Qty:6; aTranQty; [Finished_Goods_Transactions:33]JobForm:5; $aTranJF; [Finished_Goods_Transactions:33]XactionType:2; aTranType; [Finished_Goods_Transactions:33]JobFormItem:30; $aTranItem)
					ARRAY TEXT:C222(aTranJobit; Size of array:C274($aTranItem))
					For ($i; 1; Size of array:C274($aTranItem))  //•091098  MLB 
						aTranJobit{$i}:=$aTranJF{$i}+"."+String:C10($aTranItem{$i}; "00")
					End for 
					ARRAY TEXT:C222($aTranJF; 0)  //on the orderlines being processed    
					ARRAY INTEGER:C220($aTranItem; 0)
					SORT ARRAY:C229(aTranJobit; aTranQty; aTranType; >)
					
					//*Process arrays as required for report
					
					$PayUseTotal:=0
					For ($i; 1; $ToPrint)  //for every orderline to print
						//*    Orderline stuff            
						$aORqty{$i}:=$OrdQty{$i}*($aOverRun{$i}/100)
						$aNetShipped{$i}:=$aShipped{$i}-$aReturned{$i}
						//$qtyOH:=0  `temporay accumulators
						$QACount:=0
						$PayUseCount:=0
						$Excess:=0
						$JMIforOrder:=Find in array:C230($ajmiOL; $aOL{$i})  //*          goto the pegged jobs
						$OldJf:=""  //track old Job form to stop inner while loop from executing 2 or more times
						$Uniq:=Find in array:C230(aUniqCpn; aCpn{$i})
						$OrderOnHand:=0
						
						While ($JMIforOrder>0)  //make sure this jmi was for this order
							$Scrap:=MkSumTrans($ajmiJF{$JMIforOrder}+"."+String:C10($ajmiItem{$JMIforOrder}; "00"); "Scrap")  //• 1/14/98 cs ,`• 1/23/98 cs changed index from $i ->$JMIforOrder
							$aProduced{$i}:=$aProduced{$i}+$ajmiAct{$JMIforOrder}-$Scrap
							aUniqProd{$Uniq}:=aUniqProd{$Uniq}+$ajmiAct{$JMIforOrder}-$Scrap  //sum all production for this product
							$BinforOrder:=Find in array:C230($aBinJF; $ajmiJF{$JMIforOrder})  //*              get the qtyOH if they are FG: bins and the right item#
							
							While ($BinforOrder>0) & ($OldJf#($aJmiJf{$JMIforOrder}+String:C10($ajmiItem{$JMIforOrder})))  //this FG bin is for this job, and that it has not passed through loop before
								
								If ($aBinItem{$BinforOrder}=$ajmiItem{$JMIforOrder})  //we're on the same job form item
									$OrderOnhand:=$aBinQty{$BinforOrder}+$OrderOnHand  //sum On hand for this order
									
									If (Substring:C12($aBinLoc{$BinforOrder}; 1; 2)="CC") | (Substring:C12($aBinLoc{$BinforOrder}; 1; 2)="EX")  //see if there are any cartons in QA
										$aQAQty{$i}:=$aQAQty{$i}+$aBinQty{$BinforOrder}
									End if   //QA only   
									
									If (Position:C15($aPO{$i}; $aBinLoc{$BinforOrder})>0)  //see if there is anything in a Payuse bin for this PO
										$aPayUseQty{$i}:=$aPayUseQty{$i}+$aBinQty{$BinforOrder}  //give me total Payuse for order line
										$Temp:=$BinforOrder
										
										While ($Temp>0)  //locate other items which may have shipped on the same PO but come from differnt 
											$Temp:=Find in array:C230($aBinLoc; $PayUse+"@"; $Temp+1)  //jobform
											
											If ($Temp>0)
												If (Position:C15($aPO{$i}; $aBinLoc{$Temp})>0) & ($aBinCpn{$Temp}=aCpn{$i})
													$aPayUseQty{$i}:=$aPayUseQty{$i}+$aBinQty{$Temp}
													aUniqPayUse{$Uniq}:=aUniqPayUse{$Uniq}+$aBinQty{$Temp}  //sum all payuse for this product
													$aBinQty{$Temp}:=0  //zero quantity since thi has now been counted
												End if 
											End if 
										End while 
										
										aUniqPayUse{$Uniq}:=aUniqPayUse{$Uniq}+$aBinQty{$BinforOrder}  //sum all payuse for this product
									End if 
								End if   //same jobform.item  
								$BinforOrder:=Find in array:C230($aBinJF; $ajmiJF{$JMIforOrder}; $BinforOrder+1)
							End while 
							$OldJf:=$aJmiJf{$JMIforOrder}+String:C10($ajmiItem{$JMIforOrder})  //save item for later test
							$JMIforOrder:=Find in array:C230($ajmiOL; $aOL{$i}; ($JMIforOrder+1))
							
							If ($aQAQty{$i}>0)  //• 6/18/98 cs subtract scrap from QA bin(s) if there is QA
								$aQAQty{$i}:=$aQAQty{$i}-$Scrap
								
								If ($aQAQty{$i}<0)  //• 6/18/98 cs if the scrap is Larger than QA set QA = 0
									$aQAQty{$i}:=0
								End if 
							End if 
						End while 
						
						//*    Calc the customer inventory --- code at end of proc
						
						//*°    Calc the excess
						$hit:=Find in array:C230(<>aFGKey; ($CustId+":"+aCpn{$i}))
						
						If ($hit#-1)
							//       If (Not(aPayU2{$hit}))  `not already in the report
							If ($i-1>0)  //range check
								If (aCpn{$i-1}=aCpn{$i})  //if this CPN same as previous, get any Excess from previous
									$OrderOnHand:=$OrderOnHand+$aOrdLinEx{$i-1}  //add to qty avail for this line
								End if 
							End if 
							
							If ($aStatus{$i}#"Closed")
								$aOrdLinEx{$i}:=$OrderOnHand-($aOpenQty{$i}+$aORqty{$i})  //Excess for orderline = qty on hand for order - (open qty for order+overrun)
							Else 
								$aOrdLinEx{$i}:=$OrderOnHand
							End if 
							$aTotOnHand{$i}:=$OrderOnHand
							
							If ($aOrdLinEx{$i}<0)  //if negative set to zero
								$aOrdLinEx{$i}:=0
							End if 
							//       aPayU2{$hit}:=True  `tag it as being in the report
							//      End if 
							//  $aTotOnHand{$i}:=◊aQty_OH{$hit}  `•073096  MLB  save the total qty onhand
						Else 
							$aOrdLinEx{$i}:=0
							$aTotOnHand{$i}:=0
						End if 
					End for   //end preprocessing            
					
					For ($i; 1; $ToPrint)
						GOTO XY:C161(28; 11)
						MESSAGE:C88(String:C10($ToPrint-$i; "^^^,^^^"))
						//* assign layout vars the correct values
						If ([Finished_Goods:26]ProductCode:1#aCpn{$i})
							QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=aCpn{$i})
							$hit:=Find in array:C230(<>aFGKey; ($CustId+":"+aCpn{$i}))
							$Uniq:=Find in array:C230(aUniqCPN; aCpn{$i})
							$OldQtyOh:=$aTotOnHand{$i}
							$OldPayUse:=$aPayUseQty{$i}
							
							Case of 
								: (cbRollFwd=1)  //• 5/18/98 cs user set 'DO NOT ROLL FORWARD' in dialog          
									$CarryFwd:=$aOrdLinEx{$i}  //• 5/22/98 cs                  
								: ($Uniq>0) & ($Hit>0)
									$CarryFwd:=<>aQty_OH{$hit}-aUniqPayUse{$Uniq}
								Else 
									$CarryFwd:=0
							End case 
						End if 
						
						If (($i+1)<=$ToPrint)
							$NextCpn:=aCpn{$i+1}
						Else 
							$NextCpn:=""
						End if 
						
						If ($aStatus{$i}="Closed")
							If (($i+1)<=$ToPrint)
								If (aCPN{$i+1}=aCpn{$i})
									MkSetupClosed(aCpn{$i}; 0)
								Else 
									MkSetupClosed(aCpn{$i}; $aOrdLinEx{$i})
								End if 
							End if 
						Else 
							sCPN:=aCpn{$i}
							aSubtitle3:=$aPo{$i}
							sDesc:=[Finished_Goods:26]CartonDesc:3
							rReal1:=$OrdQty{$i}  //ordered quantity
							rReal2:=rReal1+$aOrQty{$I}  //allowable (sellable) ordered + overage allowance
							rReal3:=$aProduced{$i}  //qty produced
							rReal4:=$aNetShipped{$i}+$aPayUseQty{$i}  //qty shipped = qty shipped (Shipped - returns)+Qty in Tx
							rReal5:=$aQAQty{$i}  //QA - quantity in CC
							rReal6:=$aPayUseQty{$i}  //Qty in Pay-use bin (Alford Tx)
							rReal8:=rReal2-rReal4  //QtyDue = Ordered(w/Over) - (Netshipped + Payuse)
							
							If (rReal4=0)  //if qty shipped is 0 clear last ship date
								dDate1:=!00-00-00!
							Else   //used FG record as last ship
								dDate1:=[Finished_Goods:26]LastShipDate:19
							End if 
							
							If (cbRollFwd=1)  //• 5/18/98 cs user set 'DO NOT ROLL FORWARD' in dialog              
								rReal7:=rReal3-rReal4  //qty on hand for this order = qty produced - total shipped
								
								If (rReal7<0)
									rReal7:=0
								End if 
								
								If (rReal8<0)  //• 5/22/98 cs DO NOT display negative balance due
									rReal8:=0
								End if 
								
								Case of 
									: (rReal8<=0) & (rReal6>0)  //balance due on order is less than zero & some qty in Payuse
										rReal9:=rReal6  //set amount Cust resp = Payuse bin
									: (rReal7>rReal8)  //on hand > Balance due
										rReal9:=rReal8+rReal6  //Customer Resp =  Bal due+Payuse
									Else 
										rReal9:=rReal7+rReal6  //Customer Resp =  on hand+Payuse
								End case 
							Else 
								$CarryFwd:=MkSetupOnHand($NextCPN; $CarryFwd)
							End if 
							$Divisor:=(1000*(Num:C11([Finished_Goods:26]Acctg_UOM:29="M")))+(1*(Num:C11([Finished_Goods:26]Acctg_UOM:29#"M")))
							rReal10:=Round:C94((rReal9*$aPrice{$i})/$Divisor; 2)
							rReal11:=$aOrdLinEx{$i}  //Arkay excess
							rReal12:=$aPrice{$i}
						End if 
						$Printed:=MkDetailPrint($Print2Disk; $Printed; $Max; $aStatus{$i})  //print to report
						
					End for 
				End if 
			End if 
		Else 
			ALERT:C41("Document could not be opened.  Please try again, or print this report to "+"the printer")
		End if   //document was opened if printing to disk      
	Else 
		ALERT:C41("Customer Name entered not found , Please try again."+Char:C90(13)+"Enter Customer name for ONE customer at a time.")
	End if   //ID entered but either 2 or more or No customer records found
Else 
	If (OK=1)
		ALERT:C41("Customer Name entered not found , Please try again.")
	End if 
End if   //ID entered but invalid format

If (Not:C34($print2Disk))
	CLOSE WINDOW:C154  //message window
	PAGE BREAK:C6
Else 
	CLOSE DOCUMENT:C267(vDoc)
End if 

uClearSelection(->[Customers_Order_Lines:41])
uClearSelection(->[Customers:16])
uClearSelection(->[Job_Forms_Items:44])
uClearSelection(->[Finished_Goods_Locations:35])
uClearSelection(->[Finished_Goods:26])
uWinListCleanup