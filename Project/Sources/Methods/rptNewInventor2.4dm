//%attributes = {"publishedWeb":true}
//Procedure: rptNewInventor2(mths;title;cust)  030696  MLB
//yet another version of an aged open orders report with
//corresponding inventory. See also rptNewInventory,gPrintXMonthly
// (via doFGRptRecords) 
//& rRptMthInvent, both available from palette.popup and rRptMthEndSuite
//This report has a reduced number of attributes and is
//intended to be given to the customers in a "Simple" to 
//understand format. Btw, the users specified the last 2 formats as well.

//In an attempt to increase performance, array processing
//will be used instead of record access, and the report layout
//will be a single text object formated with mono spaced font
//•073096  MLB  correct Produced qty error and Need 2 Mfg error
//•080696  MLB  add Brand, Customer, and Grand Totals
//•121197  MLB  remove double call to Batch ORD and INV

C_LONGINT:C283($1; $i; $numOLs; $j; $hit; $target; $qtyOH)  //if $1 absent, goto interactive mode
C_REAL:C285(rReal1)  //number of months ago
C_TEXT:C284(t2; $2)  //report title
C_TEXT:C284(tCust; $3)  //customer limitor
C_TEXT:C284($CR)
C_BOOLEAN:C305($continue)
C_DATE:C307(dDateEnd)
C_TIME:C306($now)

READ ONLY:C145([Customers:16])
READ ONLY:C145([Customers_Order_Lines:41])
READ ONLY:C145([Job_Forms_Items:44])
READ ONLY:C145([Finished_Goods_Locations:35])
READ ONLY:C145([Finished_Goods:26])

$continue:=True:C214
dDateEnd:=4D_Current_date
$now:=4d_Current_time
$printed:="Printed: "+String:C10(dDateEnd; <>SHORTDATE)+"@"+String:C10($now; <>HHMM)
$CR:=Char:C90(13)

util_PAGE_SETUP(->[zz_control:1]; "BigTextAt75")

If (Count parameters:C259=0)  //*Interugate the user for time period and optionally specific customers
	$continue:=rptInvDialog
Else   //params sent in
	rReal1:=$1
	t2:=$2
	tCust:=$3
End if   //parameters

If ($continue)
	NewWindow(680; 400; 5; -722; "Simple Style Inventory Rpt")
	MESSAGE:C88(" Processing Data......"+Char:C90(13))
	MESSAGE:C88("   Gathering FG & Order data please stand by..."+Char:C90(13))
	MESSAGES OFF:C175  //•121197  MLB  they were here, and below in uINVauxil(1.. below
	//*Load the all inventory & open demand  
	//load ◊aFGKey & ◊aQty_OH; ◊aOrdKey, ◊aQty_Open, & ◊aQty_ORun
	<>FgBatchDat:=!00-00-00!
	<>OrdBatchDat:=!00-00-00!
	uINVauxil(1; tCust)
	//*Create a flag so that inv with out orders is not ommitted  
	$numFGs:=Size of array:C274(<>aFGKey)
	uINVauxil(2; ""; $numFGs)  //load aPayU2 & aQty which indicate if it is in the rpt, & the total excess  
	C_LONGINT:C283($fgCursor)  //this will be used in print phase to index the aInRpt array  
	ARRAY TEXT:C222($aCustId; 0)  //*Load all needed records into arrays 
	ARRAY TEXT:C222($aCPN; 0)
	ARRAY TEXT:C222($aPO; 0)
	ARRAY TEXT:C222($aBrand; 0)
	ARRAY TEXT:C222($aOL; 0)
	ARRAY LONGINT:C221($aQty; 0)
	ARRAY REAL:C219($aOverRun; 0)
	ARRAY DATE:C224($aDateOpen; 0)
	ARRAY LONGINT:C221($aShipped; 0)
	ARRAY LONGINT:C221($aReturned; 0)
	ARRAY LONGINT:C221($aAllowable; 0)
	ARRAY LONGINT:C221($aNetShipped; 0)
	ARRAY LONGINT:C221($aExcess; 0)
	ARRAY LONGINT:C221($aAccumEx; 0)
	ARRAY LONGINT:C221($aCustInv; 0)
	ARRAY LONGINT:C221($aProduced; 0)
	ARRAY LONGINT:C221($aORqty; 0)
	ARRAY TEXT:C222($ajmiJF; 0)
	ARRAY TEXT:C222($ajmiOL; 0)
	ARRAY LONGINT:C221($ajmiItem; 0)
	ARRAY TEXT:C222($ainvJF; 0)
	ARRAY LONGINT:C221($ainvQty; 0)
	ARRAY INTEGER:C220($ainvItem; 0)
	ARRAY TEXT:C222($ainvBin; 0)
	//*   Orderlines
	uINVauxil(3; tCust; rReal1; dDateEnd)  //get OL in the period of interest and there related FG, Bin, and JMI
	$numOLs:=Records in selection:C76([Customers_Order_Lines:41])
	If ($numOLs>0)
		SELECTION TO ARRAY:C260([Customers_Order_Lines:41]OrderLine:3; $aOL; [Customers_Order_Lines:41]CustID:4; $aCustId; [Customers_Order_Lines:41]ProductCode:5; $aCPN; [Customers_Order_Lines:41]Quantity:6; $aQty; [Customers_Order_Lines:41]Price_Per_M:8; $aPrice; [Customers_Order_Lines:41]Qty_Shipped:10; $aShipped; [Customers_Order_Lines:41]DateOpened:13; $aDateOpen; [Customers_Order_Lines:41]PONumber:21; $aPO; [Customers_Order_Lines:41]CustomerName:24; $aCustName; [Customers_Order_Lines:41]OverRun:25; $aOverRun; [Customers_Order_Lines:41]Qty_Returned:35; $aReturned; [Customers_Order_Lines:41]CustomerLine:42; $aBrand)
		ARRAY LONGINT:C221($aORqty; $numOLs)
		ARRAY LONGINT:C221($aAllowable; $numOLs)
		ARRAY LONGINT:C221($aNetShipped; $numOLs)
		ARRAY LONGINT:C221($aProduced; $numOLs)
		ARRAY LONGINT:C221($aExcess; $numOLs)
		ARRAY LONGINT:C221($aAccumEx; $numOLs)
		ARRAY LONGINT:C221($aCustInv; $numOLs)
		ARRAY LONGINT:C221($aTotOnHand; $numOLs)
		//*   Finished Goods solely for the descrption    
		//SELECTION TO ARRAY([Finished_Goods]ProductCode;$aFGcpn;[Finished_Goods]CartonDes
		//*   FG_locations
		If (Records in selection:C76([Finished_Goods_Locations:35])>0)
			SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]JobForm:19; $ainvJF; [Finished_Goods_Locations:35]JobFormItem:32; $ainvItem; [Finished_Goods_Locations:35]QtyOH:9; $ainvQty; [Finished_Goods_Locations:35]Location:2; $ainvBin)
			SORT ARRAY:C229($ainvJF; $ainvItem; $ainvQty; $ainvBin; >)
		End if 
		//*   JMI
		If (Records in selection:C76([Job_Forms_Items:44])>0)
			SELECTION TO ARRAY:C260([Job_Forms_Items:44]OrderItem:2; $ajmiOL; [Job_Forms_Items:44]JobForm:1; $ajmiJF; [Job_Forms_Items:44]ItemNumber:7; $ajmiItem; [Job_Forms_Items:44]Qty_Actual:11; $ajmiAct)
			SORT ARRAY:C229($ajmiOL; $ajmiJF; $ajmiItem; $ajmiAct; >)  //by orderline`•073096  MLB  left the actual out of the search
		End if 
		//*-
		//*Process arrays as required for report
		For ($i; 1; $numOLs)
			//*    Orderline stuff     
			GOTO XY:C161(28; 11)
			MESSAGE:C88(String:C10($numOLs-$i; "^^^,^^^"))
			$aORqty{$i}:=$aQty{$i}*($aOverRun{$i}/100)
			$aAllowable{$i}:=$aQty{$i}+($aQty{$i}*($aOverRun{$i}/100))
			$aNetShipped{$i}:=$aShipped{$i}-$aReturned{$i}
			//*    fg description
			//$hit:=Find in array($aFGcpn;$aCPN{$i})
			//If ($hit>0)
			//$aDesc{$i}:=$aFGdesc{$hit}
			//End if 
			
			//*    inventory  
			//*       for each job pegged to this orderline, gather the remaining onhand inven
			//        and the job's yield
			$qtyOH:=0  //temporay accumulator
			$hit:=Find in array:C230($ajmiOL; $aOL{$i})  //*          goto the pegged jobs
			While ($hit>0)  //make sure this jmi was for this order
				$aProduced{$i}:=$aProduced{$i}+$ajmiAct{$hit}
				$target:=Find in array:C230($ainvJF; $ajmiJF{$hit})  //*              get there qtyOH if they are FG: bins and the rite item#
				While ($target>0)  //make sure this fg location is for this job
					If ($ainvItem{$target}=$ajmiItem{$hit})  //we're on the same job form item
						If (Substring:C12($ainvBin{$target}; 1; 2)="FG")  //make sure this in shippable inventory
							$qtyOH:=$qtyOH+$ainvQty{$target}
						End if   //FG: only
					End if 
					$target:=Find in array:C230($ainvJF; $ajmiJF{$hit}; $target+1)
				End while 
				
				$hit:=Find in array:C230($ajmiOL; $aOL{$i}; ($hit+1))
			End while 
			//*    Calc the customer inventory
			// $open:=$aAllowable{$i}-$aNetShipped{$i}
			// If ($qtyOH>$open)
			//$aCustInv{$i}:=$open
			// Else 
			// $aCustInv{$i}:=$qtyOH
			// End if 
			
			$hit:=Find in array:C230(<>aOrdKey; ($aCustId{$i}+":"+$aCPN{$i}))
			If ($hit#-1)
				$aCustInv{$i}:=<>aQty_Open{$hit}+<>aQty_ORun{$hit}
			Else 
				$aCustInv{$i}:=0
			End if 
			//*°    Calc the inv value      
			//$aExtPrice{$i}:=($aCustInv{$i}/1000)*$aPrice{$i}
			//*°    Calc the excess
			$hit:=Find in array:C230(<>aFGKey; ($aCustId{$i}+":"+$aCPN{$i}))
			If ($hit#-1)
				$aAccumEx{$i}:=rNewInvPayUtest($Hit)
				$aExcess{$i}:=aQty{$hit}  //$qtyOH-$aCustInv{$i}
				If ($aExcess{$i}<0)
					$aExcess{$i}:=0
				End if 
				$aTotOnHand{$i}:=<>aQty_OH{$hit}  //•073096  MLB  save the total qty onhand
			Else 
				$aExcess{$i}:=0
			End if 
			
		End for 
		C_LONGINT:C283($linesPerPag; $lineWidth)
		C_TEXT:C284($blankLine; $formatLine; $titles2; $totals)
		C_TEXT:C284($currCust; $lastCust)
		C_LONGINT:C283($col1; $col2; $col3; $col4; $col5; $col6; $col7; $col8; $col9; $col10; $col11; $col12; $col13; $col14; $col15; $lineCounter; $QtyBookTot; $QtyOrdTot; $QtyShpTot; $QtyOpenTot; $QtyExcTot)  //Customer totals
		C_LONGINT:C283($QtyBookSub; $QtyOrdSub; $QtyShpSub; $QtyOpenSub; $QtyBookGrnd; $QtyOrdGrnd; $QtyShpGrnd; $QtyOpenGrnd)
		C_TEXT:C284(tText; $titles; $header)
		
		$linesPerPag:=50
		$lineWidth:=172
		$col1:=1  //po
		$col2:=14  //date
		$col3:=24  //cpn
		$col4:=40  //line
		//$col5:=55  `desc`•072696  MLB  
		$col5:=55  //booked
		$col6:=66  //overs
		$col7:=74  //sold
		$col8:=85  //net shipped
		$col9:=96  //open`•072696  MLB 
		$col10:=107  //yield
		$col11:=118  //over prod
		$col12:=129  //over excess
		$col13:=140  //total open
		$col14:=151  //total excess
		$col15:=162  //n2mfg
		$blankLine:=$lineWidth*" "
		$header:=$blankLine
		//*    header & column titles
		$header:=Change string:C234($header; (Uppercase:C13(t2)+", W/EXCESS"); 1)
		$header:=Change string:C234($header; "ARKAY PACKAGING CORPORATION"; 65)
		$header:=Change string:C234($header; "PERIOD ENDING: "+String:C10(dDateEnd; <>MIDDATE); 149)
		$header:=$header+$CR
		$titles:=$blankLine
		$titles:=Change string:C234($titles; "(sorted by Line, Code, & PO)"; 65)
		$titles:=Change string:C234($titles; $Printed; 149)
		$header:=$header+$titles+$CR
		$titles:="             Date                                         Booked    Over    "+"Cartons        Net       Open   Produced       Over      "+"Order   All Open      Total       Need "
		
		$titles2:="P.O. Nº      Opened    Product Code    Line             Quantity     Run       "+"Sold    Shipped   Quantity   Quantity   Produced"+"     Excess     Orders     Excess     to Mfg "
		$titles:=$titles+$CR+$titles2+$CR+($lineWidth*"_")+$CR
		//*    totals' underlines
		$totals:="                                                      "+" ---------"+"         "+" ---------"+"  ---------"+"  ---------"+(" "*44)+"  ---------"+$cr
		cNewInv2Titles  //all comments - helps determine columns
		$QtyBookGrnd:=0
		$QtyOrdGrnd:=0
		$QtyShpGrnd:=0
		$QtyOpenGrnd:=0
		$QtyExcGrnd:=0
		//*    Go through all the orderlines passed
		//note that these need to be sorted by customer name, or id
		For ($i; 1; $numOLs)
			GOTO XY:C161(10; 14)  //*       Display a counter    
			MESSAGE:C88(String:C10($numOLs-$i; "^^^,^^^")+" orderlines to go")
			GOTO XY:C161(10; 15)
			MESSAGE:C88($aCustname{$i}+(" "*60))
			$currCust:=$aCustId{$i}  //*       Process each customer as one block
			C_TEXT:C284($currLine)
			$currLine:=$aBrand{$i}
			$QtyBookSub:=0
			$QtyOrdSub:=0
			$QtyShpSub:=0
			$QtyOpenSub:=0
			$QtyExcSub:=0
			$lastCust:=$currCust  // this is require for boundary condition reset
			$j:=$i  //*          Set up inner loop
			tText:=$header+"••• "+Uppercase:C13($aCustName{$j})+" •••"+$CR+$titles  //*          print the header stuff
			$lineCounter:=1
			$QtyBookTot:=0  //*          init the totals' accumulators
			$QtyOrdTot:=0
			$QtyShpTot:=0
			$QtyOpenTot:=0
			$QtyExcTot:=0
			While ($aCustId{$j}=$currCust)  //process all of this customers ordelrines
				
				If ($lineCounter>$linesPerPag)  //*          page break if required within customer
					Print form:C5([zz_control:1]; "BigTextAt75")
					PAGE BREAK:C6(>)
					tText:=$header+$aCustName{$j}+"  (continued)"+$CR+$titles
					$lineCounter:=1
				End if 
				//*Total & Init the brand subtotals if required
				If ($currLine#$aBrand{$j})
					//*       Print the subtotals
					$lineCounter:=$lineCounter+4
					$formatLine:=$blankLine
					$formatLine:=Change string:C234($formatLine; ($currLine+" Totals:"); $col2)
					$formatLine:=Change string:C234($formatLine; String:C10($QtyBookSub; "^^^,^^^,^^0"); ($col5-1))
					$formatLine:=Change string:C234($formatLine; String:C10($QtyOrdSub; "^^^,^^^,^^0"); ($col7-1))
					$formatLine:=Change string:C234($formatLine; String:C10($QtyShpSub; "^^^,^^^,^^0"); ($col8-1))
					$formatLine:=Change string:C234($formatLine; String:C10($QtyOpenSub; "^^^,^^^,^^0"); ($col9-1))
					$formatLine:=Change string:C234($formatLine; String:C10($QtyExcSub; "^^^,^^^,^^0"); ($col14-1))
					tText:=tText+$totals+$formatLine+$cr+$cr
					//*       Init the subtotals
					$currLine:=$aBrand{$j}
					$QtyBookTot:=$QtyBookTot+$QtyBookSub
					$QtyOrdTot:=$QtyOrdTot+$QtyOrdSub
					$QtyShpTot:=$QtyShpTot+$QtyShpSub
					$QtyOpenTot:=$QtyOpenTot+$QtyOpenSub
					$QtyExcTot:=$QtyExcTot+$QtyExcSub
					$QtyBookSub:=0
					$QtyOrdSub:=0
					$QtyShpSub:=0
					$QtyOpenSub:=0
					$QtyExcSub:=0
				End if 
				//*          format the array info on one text line
				$lineCounter:=$lineCounter+1
				$formatLine:=$blankLine
				$formatLine:=Change string:C234($formatLine; $aPO{$j}; $col1)
				$formatLine:=Change string:C234($formatLine; String:C10($aDateOpen{$j}; <>MIDDATE); $col2)
				$formatLine:=Change string:C234($formatLine; $aCPN{$j}; $col3)
				$formatLine:=Change string:C234($formatLine; Substring:C12($aBrand{$j}; 1; 10); $col4)
				$formatLine:=Change string:C234($formatLine; String:C10($aQty{$j}; "^^,^^^,^^0"); $col5)
				$QtyBookSub:=$QtyBookSub+$aQty{$j}
				$formatLine:=Change string:C234($formatLine; String:C10($aORqty{$j}; "^^^,^^0"); $col6)
				$formatLine:=Change string:C234($formatLine; String:C10($aAllowable{$j}; "^^,^^^,^^0"); $col7)
				$QtyOrdSub:=$QtyOrdSub+$aAllowable{$j}
				$formatLine:=Change string:C234($formatLine; String:C10($aNetShipped{$j}; "^^,^^^,^^0"); $col8)
				$QtyShpSub:=$QtyShpSub+$aNetShipped{$j}
				$temp:=$aAllowable{$j}-$aNetShipped{$j}  //•072696  MLB  Quantity Open on this orderline
				If ($temp<0)
					$temp:=0
				End if 
				$formatLine:=Change string:C234($formatLine; String:C10($temp; "^^,^^^,^^0"); $col9)  //•072696  MLB 
				$QtyOpenSub:=$QtyOpenSub+$temp
				$formatLine:=Change string:C234($formatLine; String:C10($aProduced{$j}; "^^,^^^,^^0"); $col10)
				$temp:=$aProduced{$j}-$aAllowable{$j}
				
				If ($temp<0)
					$temp:=0
				End if 
				$formatLine:=Change string:C234($formatLine; String:C10($temp; "^^,^^^,^^0"); $col11)
				$temp:=$aProduced{$j}-$aAllowable{$j}-$aORqty{$j}
				
				If ($temp<0)
					$temp:=0
				End if 
				$formatLine:=Change string:C234($formatLine; String:C10($temp; "^^,^^^,^^0"); $col12)
				$formatLine:=Change string:C234($formatLine; String:C10($aCustInv{$j}; "^^,^^^,^^0"); $col13)
				$formatLine:=Change string:C234($formatLine; String:C10($aExcess{$j}; "^^,^^^,^^0"); $col14)
				
				If ($aExcess{$j}<=0)
					$temp:=$aCustInv{$j}-$aTotOnHand{$j}  //•073096  MLB  less the current ohand inv
					
					If ($temp<0)
						$temp:=0
					End if 
				Else 
					$temp:=0
				End if 
				$QtyExcSub:=$QtyExcSub+$aAccumEx{$j}  //accumulate the excess
				$formatLine:=Change string:C234($formatLine; String:C10($temp; "^^,^^^,^^0"); $col15)
				tText:=tText+$formatLine+$CR  //*          add that text line to the text block
				If ($j<$numOLs)  //keep it inbounds
					$j:=$j+1
				Else   //you just dit the last element
					$currCust:=""  //break out of the while loop, remember to restore this for next code block
				End if 
			End while 
			$lineCounter:=$lineCounter+4
			$formatLine:=$blankLine
			$formatLine:=Change string:C234($formatLine; ($currLine+" Totals:"); $col2)
			$formatLine:=Change string:C234($formatLine; String:C10($QtyBookSub; "^^^,^^^,^^0"); ($col5-1))
			$formatLine:=Change string:C234($formatLine; String:C10($QtyOrdSub; "^^^,^^^,^^0"); ($col7-1))
			$formatLine:=Change string:C234($formatLine; String:C10($QtyShpSub; "^^^,^^^,^^0"); ($col8-1))
			$formatLine:=Change string:C234($formatLine; String:C10($QtyOpenSub; "^^^,^^^,^^0"); ($col9-1))
			$formatLine:=Change string:C234($formatLine; String:C10($QtyExcSub; "^^^,^^^,^^0"); ($col14-1))
			tText:=tText+$totals+$formatLine+$cr+$cr
			$QtyBookTot:=$QtyBookTot+$QtyBookSub  //*       Init the subtotals
			$QtyOrdTot:=$QtyOrdTot+$QtyOrdSub
			$QtyShpTot:=$QtyShpTot+$QtyShpSub
			$QtyOpenTot:=$QtyOpenTot+$QtyOpenSub
			$QtyExcTot:=$QtyExcTot+$QtyExcSub
			$QtyBookSub:=0
			$QtyOrdSub:=0
			$QtyShpSub:=0
			$QtyOpenSub:=0
			$QtyExcSub:=0
			$currCust:=$lastCust  //reset currCust incase this was the last orderline
			$currLine:=$aBrand{$j}
			//*       Print the Inventory without any orders
			If (rReal1=0)  //zero month and up , this algo only works if all the cust orders were included
				$fgCursor:=Find in array:C230(<>aFGKey; ($currCust+"@"))
				
				If ($fgCursor#-1)
					GOTO XY:C161(10; 16)
					MESSAGE:C88(" "*60)
					GOTO XY:C161(10; 16)
					MESSAGE:C88("Checking for inventory against closed orders")
					
					For ($k; $fgCursor; $numFGs)
						If (Substring:C12(<>aFGKey{$k}; 1; 5)=$currCust)  //init the array  to true
							If (Not:C34(aPayU2{$k}))  //put it on the report
								aPayU2{$k}:=True:C214  // later we ll look for items of customer not on the report              
								
								If ($lineCounter>$linesPerPag)  //*          page break if required within customer
									Print form:C5([zz_control:1]; "BigTextAt75")
									PAGE BREAK:C6(>)
									tText:=$header+$aCustName{$j-1}+"  (continued)"+$CR+$titles
									$lineCounter:=1
								End if 
								$lineCounter:=$lineCounter+1
								$formatLine:=$blankLine
								$formatLine:=Change string:C234($formatLine; "CLOSED"; $col1)
								$formatLine:=Change string:C234($formatLine; Substring:C12(<>aFGKey{$k}; 7); $col3)
								$formatLine:=Change string:C234($formatLine; ("."*110); $col4)
								$formatLine:=Change string:C234($formatLine; String:C10(aQty{$k}; "^^,^^^,^^0"); $col14)
								//*          add that text line to the text block
								tText:=tText+$formatLine+$CR
							End if   //not in report        
						Else   //past this customers items, so break
							$k:=$k+$numFGs
						End if 
					End for 
					GOTO XY:C161(10; 16)
					MESSAGE:C88(" "*60)
				End if   //this customer has any invnetory
			Else 
				$lineCounter:=$lineCounter+1
				$formatLine:=$blankLine
				$formatLine:=Change string:C234($formatLine; "Excess inventory on closed orders is only"+" shown when the Zero Month & Up report option is choosen."; $col2)
				tText:=tText+$formatLine+$CR
			End if   //this was zero month and up    
			//*       Print the totals
			$lineCounter:=$lineCounter+3
			$formatLine:=$blankLine
			$formatLine:=Change string:C234($formatLine; "Customer's Totals:"; $col2)
			$formatLine:=Change string:C234($formatLine; String:C10($QtyBookTot; "^^^,^^^,^^0"); ($col5-1))
			$formatLine:=Change string:C234($formatLine; String:C10($QtyOrdTot; "^^^,^^^,^^0"); ($col7-1))
			$formatLine:=Change string:C234($formatLine; String:C10($QtyShpTot; "^^^,^^^,^^0"); ($col8-1))
			$formatLine:=Change string:C234($formatLine; String:C10($QtyOpenTot; "^^^,^^^,^^0"); ($col9-1))
			$formatLine:=Change string:C234($formatLine; String:C10($QtyExcTot; "^^^,^^^,^^0"); ($col14-1))
			$QtyBookGrnd:=$QtyBookGrnd+$QtyBookTot
			$QtyOrdGrnd:=$QtyOrdGrnd+$QtyOrdTot
			$QtyShpGrnd:=$QtyShpGrnd+$QtyShpTot
			$QtyOpenGrnd:=$QtyOpenGrnd+$QtyOpenTot
			$QtyExcGrnd:=$QtyExcGrnd+$QtyExcTot
			tText:=tText+$totals+$formatLine+$cr
			Print form:C5([zz_control:1]; "BigTextAt75")
			PAGE BREAK:C6(>)
			
			If ($j<$numOLs)  //*       Set up for next customer
				$i:=$j-1  //go to the next customer
			Else 
				$i:=$j
			End if 
		End for 
		
		If (tCust="")  //*    Check for inventory on inactive customers 
			If (rReal1=0)  //zero month and up , this algo only works if all the cust orders were included   
				GOTO XY:C161(10; 15)
				MESSAGE:C88("Checking for inventory on inactive customers                                    ")
				tText:=$header+"••• "+"INACTIVE ACCOUNTS"+" •••"+$CR+$titles
				
				For ($i; 1; $numFGs)
					GOTO XY:C161(60; 15)
					MESSAGE:C88(String:C10($numFGs-$i; "^^^,^^^")+" F/G's to go")
					
					If (Not:C34(aPayU2{$i}))  //put it on the report
						aPayU2{$i}:=True:C214  // later we ll look for items of customer not on the report              
						
						If ($lineCounter>$linesPerPag)  //*          page break if required within customer
							Print form:C5([zz_control:1]; "BigTextAt75")
							PAGE BREAK:C6(>)
							tText:=$header+"INACTIVE ACCOUNTS"+"(continued)"+$CR+$titles
							$lineCounter:=1
						End if 
						$lineCounter:=$lineCounter+1
						$formatLine:=$blankLine
						$formatLine:=Change string:C234($formatLine; "INACTIVE"; $col1)
						$formatLine:=Change string:C234($formatLine; Substring:C12(<>aFGKey{$i}; 1; 5); $col2)  //
						$formatLine:=Change string:C234($formatLine; Substring:C12(<>aFGKey{$i}; 7); $col3)
						$formatLine:=Change string:C234($formatLine; ("."*110); $col4)
						$formatLine:=Change string:C234($formatLine; String:C10(aQty{$i}; "^^,^^^,^^0"); $col14)
						tText:=tText+$formatLine+$CR  //*          add that text line to the text block
					End if   //not in report              
				End for 
			Else 
				tText:=$header+"••• "+"INACTIVE ACCOUNTS"+" •••"+$CR+$titles
				$lineCounter:=$lineCounter+1
				$formatLine:=$blankLine
				$formatLine:=Change string:C234($formatLine; "Excess inventory on inactive customers is only"+" shown when the Zero Month & Up report option is choosen."; $col2)
				tText:=tText+$formatLine+$CR
			End if   //this was zero month and up 
			
		Else 
			tText:=$header+"••• "+"INACTIVE ACCOUNTS"+" •••"+$CR+$titles
			$lineCounter:=$lineCounter+1
			$formatLine:=$blankLine
			$formatLine:=Change string:C234($formatLine; "Excess inventory on inactive customers is only"+" shown when the All Customers report option is choosen."; $col2)
			tText:=tText+$formatLine+$CR
		End if   //this was for all customers   
		
		//*    Kick out the last page       `*       Print the totals
		$lineCounter:=$lineCounter+3
		$formatLine:=$blankLine
		$formatLine:=Change string:C234($formatLine; "Report's Totals:"; $col2)
		$formatLine:=Change string:C234($formatLine; String:C10($QtyBookGrnd; "^^^,^^^,^^^,^^0"); ($col5-5))
		$formatLine:=Change string:C234($formatLine; String:C10($QtyShpGrnd; "^^^,^^^,^^^,^^0"); ($col8-5))
		$formatLine:=Change string:C234($formatLine; String:C10($QtyExcGrnd; "^^^,^^^,^^^,^^0"); ($col14-5))
		tText:=tText+$totals+$formatLine+$cr
		$formatLine:=$blankLine
		$formatLine:=Change string:C234($formatLine; String:C10($QtyOrdGrnd; "^^^,^^^,^^^,^^0"); ($col7-5))
		$formatLine:=Change string:C234($formatLine; String:C10($QtyOpenGrnd; "^^^,^^^,^^^,^^0"); ($col9-5))
		tText:=tText+$formatLine+$cr
		tText:=tText+$CR+$CR+$CR+"               ••••••••••• END OF REPORT •••••••••••"
		Print form:C5([zz_control:1]; "BigTextAt75")
		PAGE BREAK:C6
	End if   //any orderlines selected
	CLOSE WINDOW:C154
End if 

REDUCE SELECTION:C351([Customers:16]; 0)
REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
REDUCE SELECTION:C351([Finished_Goods:26]; 0)