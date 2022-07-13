//%attributes = {"publishedWeb":true}
//Procedure: rptNewInventory(mths;title;cust)  030696  MLB
//•022097  MLB  close search
//yet another version of an aged open orders report with
//corresponding inventory. See also gPrintXMonthly (via doFGRptRecords) 
//& rRptMthInvent, both available from palette.popup and rRptMthEndSuite
//and rptNewInventor2
//This report has a reduced number of attributes and is
//intended to be given to the customers in a "Simple" to 
//understand format. Btw, the users specified the last 2 formats as well.
//In in attempt to increase performance, array processing
//will be used instead of record access, and the report layout
//will be a single text object formated with mono spaced font

C_LONGINT:C283($1; $i; $numOLs; $yrs; $j; $hit; $target; $open; $qtyOH)  //if $1 absent, goto interactive mode
C_REAL:C285(rReal1)  //number of months ago
C_TEXT:C284(t2; $2)  //report title
C_TEXT:C284(tCust; $3)  //customer limitor
C_BOOLEAN:C305($continue)
C_DATE:C307(dDateEnd)
C_TIME:C306($now)
C_TEXT:C284($CR)

READ ONLY:C145([Customers:16])
READ ONLY:C145([Customers_Order_Lines:41])
READ ONLY:C145([Job_Forms_Items:44])
READ ONLY:C145([Finished_Goods_Locations:35])

$continue:=True:C214
dDateEnd:=4D_Current_date
$now:=4d_Current_time
$printed:="Printed: "+String:C10(dDateEnd; <>SHORTDATE)+"@"+String:C10($now; <>HHMM)
$CR:=Char:C90(13)

util_PAGE_SETUP(->[zz_control:1]; "BigTextArea")
PDF_setUp(<>pdfFileName)

If (Count parameters:C259=0)  //*Interugate the user for time period and optionally specific customers
	C_LONGINT:C283(rb9Month; rb12Month; rb15Month; rb0thMonth)  //radio buttons to set rReal1
	
	uDialog("NewInvent_dio"; 255; 220)  //•081795  MLB  hk request
	
	If (False:C215)
		FORM SET INPUT:C55([zz_control:1]; "NewInvent_dio")
	End if 
	
	If (OK=1)
		If (tCust="All Customers")
			tCust:=""
		End if 
		PRINT SETTINGS:C106
		If (ok=0)
			$continue:=False:C215
		End if 
	Else 
		$continue:=False:C215
	End if   //select dio accepted
Else   //params sent in
	
	rReal1:=$1
	t2:=$2
	tCust:=$3
End if   //parameters

If ($continue)
	NewWindow(680; 400; 5; -722; "Simple Style Inventory Rpt")
	MESSAGES OFF:C175
	MESSAGE:C88("Gathering orderlines...")
	
	ARRAY TEXT:C222($aCustId; 0)
	ARRAY TEXT:C222($aCPN; 0)
	ARRAY REAL:C219($aPrice; 0)
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
	ARRAY LONGINT:C221($aCustInv; 0)
	ARRAY REAL:C219($aExtPrice; 0)
	ARRAY TEXT:C222($aDesc; 0)
	ARRAY INTEGER:C220($aAge; 0)
	ARRAY TEXT:C222($aFGcpn; 0)
	ARRAY TEXT:C222($aFGdesc; 0)
	ARRAY TEXT:C222($ajmiJF; 0)
	ARRAY TEXT:C222($ajmiOL; 0)
	ARRAY LONGINT:C221($ajmiItem; 0)
	ARRAY TEXT:C222($ainvJF; 0)
	ARRAY LONGINT:C221($ainvQty; 0)
	ARRAY INTEGER:C220($ainvItem; 0)
	ARRAY TEXT:C222($ainvBin; 0)
	
	If (tCust#"")  //limit to one customer
		MESSAGE:C88($CR+"     limiting to "+tCust)
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustomerName:24=tCust)
			qryOpenOrdLines("*"; "*")
			MESSAGE:C88($CR+"     limiting to "+String:C10(rReal1)+" months...")
			QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]DateOpened:13<=(dDateEnd-(365*(rReal1/12))))
			
		Else 
			
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustomerName:24=tCust; *)
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Qty_Open:11>0; *)  //see also same search in doFGRptRecords
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Closed"; *)  //•080195  MLB 1490
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Cancel"; *)  //•080195  MLB 1490
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]SpecialBilling:37=False:C215; *)
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]DateOpened:13<=(dDateEnd-(365*(rReal1/12))))
			MESSAGE:C88($CR+"     limiting to "+String:C10(rReal1)+" months...")
		End if   // END 4D Professional Services : January 2019 query selection
		
	Else 
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			qryOpenOrdLines("*")
			MESSAGE:C88($CR+"     limiting to "+String:C10(rReal1)+" months...")
			QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]DateOpened:13<=(dDateEnd-(365*(rReal1/12))))
			
			
		Else 
			
			
			
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Qty_Open:11>0; *)  //see also same search in doFGRptRecords
			QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Closed"; *)  //•080195  MLB 1490
			QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Cancel"; *)  //•080195  MLB 1490
			QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]SpecialBilling:37=False:C215; *)
			QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]DateOpened:13<=(dDateEnd-(365*(rReal1/12))))
			MESSAGE:C88($CR+"     limiting to "+String:C10(rReal1)+" months...")
			
			
			
		End if   // END 4D Professional Services : January 2019 query selection
	End if 
	
	$numOLs:=Records in selection:C76([Customers_Order_Lines:41])
	If ($numOLs>0)
		MESSAGE:C88($CR+"     loading order data..."+String:C10($numOLs))
		ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustomerName:24; >; [Customers_Order_Lines:41]CustomerLine:42; >; [Customers_Order_Lines:41]ProductCode:5; >; [Customers_Order_Lines:41]PONumber:21; >)
		SELECTION TO ARRAY:C260([Customers_Order_Lines:41]OrderLine:3; $aOL; [Customers_Order_Lines:41]CustID:4; $aCustId; [Customers_Order_Lines:41]ProductCode:5; $aCPN; [Customers_Order_Lines:41]Quantity:6; $aQty; [Customers_Order_Lines:41]Price_Per_M:8; $aPrice; [Customers_Order_Lines:41]Qty_Shipped:10; $aShipped; [Customers_Order_Lines:41]DateOpened:13; $aDateOpen; [Customers_Order_Lines:41]PONumber:21; $aPO; [Customers_Order_Lines:41]CustomerName:24; $aCustName; [Customers_Order_Lines:41]OverRun:25; $aOverRun; [Customers_Order_Lines:41]Qty_Returned:35; $aReturned; [Customers_Order_Lines:41]CustomerLine:42; $aBrand)
		
		ARRAY LONGINT:C221($aAllowable; $numOLs)
		ARRAY LONGINT:C221($aNetShipped; $numOLs)
		ARRAY LONGINT:C221($aExcess; $numOLs)
		ARRAY LONGINT:C221($aCustInv; $numOLs)
		ARRAY REAL:C219($aExtPrice; $numOLs)
		ARRAY TEXT:C222($aDesc; $numOLs)
		ARRAY INTEGER:C220($aAge; $numOLs)
		
		MESSAGE:C88($CR+"     gathering F/G data...")
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			uRelateSelect(->[Finished_Goods:26]ProductCode:1; ->[Customers_Order_Lines:41]ProductCode:5; 0)
			
			
		Else 
			
			RELATE ONE SELECTION:C349([Customers_Order_Lines:41]; [Finished_Goods:26])
			
		End if   // END 4D Professional Services : January 2019 query selection
		MESSAGE:C88($CR+"     loading F/G data..."+String:C10(Records in selection:C76([Finished_Goods:26])))
		SELECTION TO ARRAY:C260([Finished_Goods:26]ProductCode:1; $aFGcpn; [Finished_Goods:26]CartonDesc:3; $aFGdesc)
		
		MESSAGE:C88($CR+"     gathering F/G location data...")
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			uRelateSelect(->[Finished_Goods_Locations:35]ProductCode:1; ->[Customers_Order_Lines:41]ProductCode:5; 0)
			
			
		Else 
			ARRAY TEXT:C222($_ProductCode; 0)
			DISTINCT VALUES:C339([Customers_Order_Lines:41]ProductCode:5; $_ProductCode)
			QUERY WITH ARRAY:C644([Finished_Goods_Locations:35]ProductCode:1; $_ProductCode)
			
		End if   // END 4D Professional Services : January 2019 query selection
		MESSAGE:C88($CR+"     loading F/G location data..."+String:C10(Records in selection:C76([Finished_Goods_Locations:35])))
		SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]JobForm:19; $ainvJF; [Finished_Goods_Locations:35]JobFormItem:32; $ainvItem; [Finished_Goods_Locations:35]QtyOH:9; $ainvQty; [Finished_Goods_Locations:35]Location:2; $ainvBin)
		SORT ARRAY:C229($ainvJF; $ainvItem; $ainvQty; $ainvBin; >)
		//*   JMI
		
		MESSAGE:C88($CR+"     gathering job data...")
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			uRelateSelect(->[Job_Forms_Items:44]ProductCode:3; ->[Finished_Goods_Locations:35]ProductCode:1; 0)
			
		Else 
			ARRAY TEXT:C222($_ProductCode; 0)
			DISTINCT VALUES:C339([Finished_Goods_Locations:35]ProductCode:1; $_ProductCode)
			QUERY WITH ARRAY:C644([Job_Forms_Items:44]ProductCode:3; $_ProductCode)
			
		End if   // END 4D Professional Services : January 2019 query selection
		MESSAGE:C88($CR+"     loading job data..."+String:C10(Records in selection:C76([Job_Forms_Items:44])))
		SELECTION TO ARRAY:C260([Job_Forms_Items:44]OrderItem:2; $ajmiOL; [Job_Forms_Items:44]JobForm:1; $ajmiJF; [Job_Forms_Items:44]ItemNumber:7; $ajmiItem)
		SORT ARRAY:C229($ajmiOL; $ajmiJF; $ajmiItem; >)  //by orderline
		
		MESSAGE:C88($CR+"Processing data...")
		For ($i; 1; $numOLs)
			//*    Orderline stuff     
			GOTO XY:C161(10; 10)
			MESSAGE:C88(String:C10($numOLs-$i; "^^^,^^^"))
			
			$aAllowable{$i}:=$aQty{$i}+($aQty{$i}*($aOverRun{$i}/100))
			$aNetShipped{$i}:=$aShipped{$i}-$aReturned{$i}
			If ($aDateOpen{$i}#!00-00-00!)
				$yrs:=12*(Year of:C25(dDateEnd)-Year of:C25($aDateOpen{$i}))
				$aAge{$i}:=Month of:C24(dDateEnd)-Month of:C24($aDateOpen{$i})+$yrs
			Else 
				$aAge{$i}:=0
			End if 
			//*    fg description
			
			$hit:=Find in array:C230($aFGcpn; $aCPN{$i})
			If ($hit>0)
				$aDesc{$i}:=$aFGdesc{$hit}
			End if 
			$qtyOH:=0  //temporay accumulator
			$hit:=Find in array:C230($ajmiOL; $aOL{$i})  //*          goto the pegged jobs
			
			While ($hit>0)  //make sure this jmi was for this order
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
			
			$open:=$aAllowable{$i}-$aNetShipped{$i}
			If ($qtyOH>$open)
				$aCustInv{$i}:=$open
			Else 
				$aCustInv{$i}:=$qtyOH
			End if 
			//*    Calc the inv value      
			
			$aExtPrice{$i}:=($aCustInv{$i}/1000)*$aPrice{$i}
			//*    Calc the excess
			
			$aExcess{$i}:=$qtyOH-$aCustInv{$i}
			If ($aExcess{$i}<0)
				$aExcess{$i}:=0
			End if 
			
		End for 
		//release some ram    
		
		ARRAY TEXT:C222($aOL; 0)
		ARRAY LONGINT:C221($aQty; 0)
		ARRAY REAL:C219($aOverRun; 0)
		ARRAY DATE:C224($aDateOpen; 0)
		ARRAY LONGINT:C221($aShipped; 0)
		ARRAY LONGINT:C221($aReturned; 0)
		ARRAY TEXT:C222($aFGcpn; 0)
		ARRAY TEXT:C222($aFGdesc; 0)
		ARRAY TEXT:C222($ajmiJF; 0)
		ARRAY TEXT:C222($ajmiOL; 0)
		ARRAY LONGINT:C221($ajmiItem; 0)
		ARRAY TEXT:C222($ainvJF; 0)
		ARRAY LONGINT:C221($ainvQty; 0)
		ARRAY INTEGER:C220($ainvItem; 0)
		ARRAY TEXT:C222($ainvBin; 0)
		
		MESSAGE:C88($CR+"Writing the report...")
		
		C_LONGINT:C283($linesPerPag; $pageNumber)
		$pageNumber:=0
		C_TEXT:C284($blankLine; $formatLine; $titles2; $totals)
		C_TEXT:C284($currCust)
		C_LONGINT:C283($col1; $col2; $col3; $col4; $col5; $col6; $col7; $col8; $col9; $col10; $col11)
		C_LONGINT:C283($lineCounter; $QtyOrdTot; $QtyShpTot; $QtyInvTot; $QtyExcTot)
		C_REAL:C285($QtyDolTot)
		C_TEXT:C284(tText; $titles; $header)
		$col1:=1
		$col2:=14
		$col3:=20
		$col4:=40
		$col5:=55
		$col6:=69
		$col7:=81
		$col8:=93
		$col9:=103
		$col10:=113
		$col11:=123
		$linesPerPag:=40
		$blankLine:=133*" "
		$header:=$blankLine
		//*    header & column titles
		
		$header:=Change string:C234($header; Uppercase:C13(t2); 1)
		$header:=Change string:C234($header; "ARKAY PACKAGING CORPORATION"; 53)
		$header:=Change string:C234($header; "PERIOD ENDING: "+String:C10(dDateEnd; <>SHORTDATE); 110)
		$header:=$header+$CR
		$titles:=$blankLine
		$titles:=Change string:C234($titles; $Printed; 110)
		$header:=$header+$titles+$CR
		$titles:=$blankLine
		$titles:=Change string:C234($titles; "Mths"; $col2)
		$titles:=Change string:C234($titles; "  Order Qty"; $col6)
		$titles:=Change string:C234($titles; "   Quantity"; $col7)
		$titles:=Change string:C234($titles; "  Customer"; $col8)
		$titles:=Change string:C234($titles; "     Sales"; $col10)
		$titles:=Change string:C234($titles; "    Excess"; $col11)
		$titles2:=$blankLine
		$titles2:=Change string:C234($titles2; "P.O. Nº"; $col1)
		$titles2:=Change string:C234($titles2; "Aged"; $col2)
		$titles2:=Change string:C234($titles2; "Product Code"; $col3)
		$titles2:=Change string:C234($titles2; "Line"; $col4)
		$titles2:=Change string:C234($titles2; "Description"; $col5)
		$titles2:=Change string:C234($titles2; " w/ overrun"; $col6)
		$titles2:=Change string:C234($titles2; "    Shipped"; $col7)
		$titles2:=Change string:C234($titles2; " Inventory"; $col8)
		$titles2:=Change string:C234($titles2; "   Price/M"; $col9)
		$titles2:=Change string:C234($titles2; "     Value"; $col10)
		$titles2:=Change string:C234($titles2; "  Quantity"; $col11)
		$titles:=$titles+$CR+$titles2+$CR+(133*"_")+$CR
		//*    totals' underlines
		
		$totals:=$blankLine
		$totals:=Change string:C234($totals; " __________"; $col6)
		$totals:=Change string:C234($totals; " __________"; $col7)
		$totals:=Change string:C234($totals; " _________"; $col8)
		$totals:=Change string:C234($totals; " _________"; $col10)
		$totals:=Change string:C234($totals; " _________"; $col11)
		$totals:=$totals+$CR
		//*    Go through all the orderlines passed
		
		//note that these need to be sorted by customer name, or id
		
		For ($i; 1; $numOLs)
			GOTO XY:C161(10; 12)
			MESSAGE:C88(String:C10($numOLs-$i; "^^^,^^^"))
			GOTO XY:C161(10; 13)
			MESSAGE:C88(" "*60)
			GOTO XY:C161(10; 13)
			MESSAGE:C88($aCustname{$i})
			//*       Process each customer as one block
			
			$currCust:=$aCustId{$i}
			$j:=$i  //*          Set up inner loop
			
			//*          print the header stuff
			
			tText:=$header+"••• "+Uppercase:C13($aCustName{$j})+" •••"+$CR+$titles
			$lineCounter:=1
			//*          init the totals' accumulators
			
			$QtyOrdTot:=0
			$QtyShpTot:=0
			$QtyInvTot:=0
			$QtyDolTot:=0
			$QtyExcTot:=0
			While ($aCustId{$j}=$currCust)  //process all of this customers ordelrines
				If ($lineCounter>$linesPerPag)  //*          page break if required within customer
					Print form:C5([zz_control:1]; "BigTextArea")
					PAGE BREAK:C6(>)
					tText:=$header+$aCustName{$j}+"  (continued)"+$CR+$titles
					$lineCounter:=1
				End if 
				//*          format the array info on one text line
				
				$lineCounter:=$lineCounter+1
				$formatLine:=$blankLine
				$formatLine:=Change string:C234($formatLine; $aPO{$j}; $col1)
				$formatLine:=Change string:C234($formatLine; String:C10($aAge{$j}; "^^"); $col2)
				$formatLine:=Change string:C234($formatLine; $aCPN{$j}; $col3)
				$formatLine:=Change string:C234($formatLine; Substring:C12($aBrand{$j}; 1; 14); $col4)
				$formatLine:=Change string:C234($formatLine; Substring:C12($aDesc{$j}; 1; 14); $col5)
				$formatLine:=Change string:C234($formatLine; String:C10($aAllowable{$j}; "^^^,^^^,^^0"); $col6)
				$formatLine:=Change string:C234($formatLine; String:C10($aNetShipped{$j}; "^^^,^^^,^^0"); $col7)
				$formatLine:=Change string:C234($formatLine; String:C10($aCustInv{$j}; "^^,^^^,^^0"); $col8)
				$formatLine:=Change string:C234($formatLine; String:C10($aPrice{$j}; "^^^,^^0.00"); $col9)
				$formatLine:=Change string:C234($formatLine; String:C10(Round:C94($aExtPrice{$j}; 0); "^^,^^^,^^0"); $col10)
				$formatLine:=Change string:C234($formatLine; String:C10($aExcess{$j}; "^^,^^^,^^0"); $col11)
				//*          add that text line to the text block
				
				tText:=tText+$formatLine+$CR
				//*          accumulate the totals
				
				$QtyOrdTot:=$QtyOrdTot+$aAllowable{$j}
				$QtyShpTot:=$QtyShpTot+$aNetShipped{$j}
				$QtyInvTot:=$QtyInvTot+$aCustInv{$j}
				$QtyDolTot:=$QtyDolTot+$aExtPrice{$j}
				$QtyExcTot:=$QtyExcTot+$aExcess{$j}
				
				If ($j<$numOLs)  //keep it inbounds
					$j:=$j+1
				Else   //you just dit the last element
					$currCust:=""
				End if 
				
			End while 
			//*       Print the totals
			$formatLine:=$blankLine
			$formatLine:=Change string:C234($formatLine; String:C10($QtyOrdTot; "^^^,^^^,^^0"); $col6)
			$formatLine:=Change string:C234($formatLine; String:C10($QtyShpTot; "^^^,^^^,^^0"); $col7)
			$formatLine:=Change string:C234($formatLine; String:C10($QtyInvTot; "^^,^^^,^^0"); $col8)
			$formatLine:=Change string:C234($formatLine; String:C10(Round:C94($QtyDolTot; 0); "^^,^^^,^^0"); $col10)
			$formatLine:=Change string:C234($formatLine; String:C10($QtyExcTot; "^^,^^^,^^0"); $col11)
			tText:=tText+$totals+$formatLine
			Print form:C5([zz_control:1]; "BigTextArea")
			PAGE BREAK:C6(>)
			//*       Set up for next customer
			
			If ($j<$numOLs)
				$i:=$j-1  //go to the next customer
				
			Else 
				$i:=$j
			End if 
		End for 
		//*    Kick out the last page    
		
		tText:=$header+$CR+$CR+$CR+"               ••••••••••• END OF REPORT •••••••••••"
		Print form:C5([zz_control:1]; "BigTextArea")
		PAGE BREAK:C6
		
	End if   //any orderlines selected
	
	CLOSE WINDOW:C154
End if 