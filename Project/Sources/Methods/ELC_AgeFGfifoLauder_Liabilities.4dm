//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 05/07/09, 11:26:52
// ----------------------------------------------------
// Method: ELC_AgeFGfifoLauder_Liabilities
// Description
// find old valued lauder inventory
// based on: rptAgeFGfifo_costed
// Description
// strip away the excess from the qty columns
//`based on rptAgeFGfifo
// Parameters
// ----------------------------------------------------

ARRAY TEXT:C222($a_cpns; 0)  //this is to create a list of cpn's to query the Delfor in edirk
C_TEXT:C284($1)
C_TEXT:C284($CR; $t)
C_DATE:C307($today; $three; $six; $nine; $twelve)

$CR:=Char:C90(13)
$t:=Char:C90(9)
$today:=4D_Current_date
$three:=Add to date:C393($today; 0; -3; 0)  //-(3*30)
$six:=Add to date:C393($today; 0; -6; 0)  //-(6*30)
$nine:=Add to date:C393($today; 0; -9; 0)  //-(9*30)
$twelve:=Add to date:C393($today; 0; -12; 0)  //-(12*30)

READ ONLY:C145([Customers:16])
READ WRITE:C146([Job_Forms_Items:44])  // incase glue date needs reset
READ ONLY:C145([Finished_Goods:26])
READ ONLY:C145([Finished_Goods_Locations:35])
uConfirm("Only show items where Supply is greater than Demand?"; "Yes"; "All")
If (OK=1)
	$limit:=True:C214
Else 
	$limit:=False:C215
End if 
//only look at Lauder items
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
	
	
	$numBins:=ELC_query(->[Finished_Goods_Locations:35]CustID:16)
	
	
Else 
	$criteria:=ELC_getName
	QUERY BY FORMULA:C48([Finished_Goods_Locations:35]; \
		([Finished_Goods_Locations:35]CustID:16=[Customers:16]ID:1)\
		 & ([Customers:16]ParentCorp:19=$criteria)\
		)
	
	
	
End if   // END 4D Professional Services : January 2019 ELC_query
ARRAY TEXT:C222($aEL_FG_Jobits; 0)
DISTINCT VALUES:C339([Finished_Goods_Locations:35]Jobit:33; $aEL_FG_Jobits)

//only look at glued over x months
$cut_off:=Add to date:C393($today; 0; -6; 0)  //6 mths ago
ARRAY TEXT:C222($aOld_EL_Jobits; 0)
For ($jobit; 1; Size of array:C274($aEL_FG_Jobits))
	$glued:=JMI_getGlueDate($aEL_FG_Jobits{$jobit}; "try hard")
	If ($glued#!00-00-00!)
		If ($glued<$cut_off)
			APPEND TO ARRAY:C911($aOld_EL_Jobits; $aEL_FG_Jobits{$jobit})
		End if 
	End if 
End for 

//get all the product codes for the target jobits
QUERY WITH ARRAY:C644([Finished_Goods_Locations:35]Jobit:33; $aOld_EL_Jobits)
ARRAY TEXT:C222($aEL_FG_Inventory; 0)
DISTINCT VALUES:C339([Finished_Goods_Locations:35]FG_Key:34; $aEL_FG_Inventory)

<>FgBatchDat:=!00-00-00!
<>OrdBatchDat:=!00-00-00!
BatchFGinventor(0; ""; 0)  //pre-load all the inventory
BatchOrdcalc(0; "@")
BatchRelCalc(0; "@")

C_TEXT:C284(xTitle; xText)
xTitle:="Aged F/G COSTED Inventory, by Date Glued, using FIFO Valuation "+String:C10($today; <>LONGDATE)+"  "+String:C10(4d_Current_time; <>HMMAM)+" Open Orders includes over-run, Open releases includes forecasts"
xText:=""+$t+""+$t+""+$t+""+$t+$t+""+$t+"≤ 3 Mths"+$t+$t+"3 < Mths ≤ 6"+$t+$t+"6 < Mths ≤ 9"+$t+$t+"9 < Mths ≤ 12"+$t+$t+"12 < Mths"+$t+$t+"Glued=00/00/00"+$t+$cr+$cr
xText:=xText+"SALESMAN"+$t+"CUSTOMER"+$t+"CPN"+$t+"BILL&HOLD"+$t+"OPEN_PO"+$t+"RELEASED"+$t+"Qty3"+$t+"Value3"+$t+"Qty6"+$t+"Value6"+$t+"Qty9"+$t+"Value9"+$t+"Qty12"+$t+"Value12"+$t+"Qty13"+$t+"Value13"+$t+"Qty?"+$t+"Value?"+$t+"LastGlued"+$t+"Line"+$t+"Desc"+$cr
C_TIME:C306($docRef)

docName:="AgeFGfifo_Costed_Lauder"+fYYMMDD($today)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
$docRef:=util_putFileName(->docName)

SEND PACKET:C103($docRef; xTitle+$CR+$CR)
SEND PACKET:C103($docRef; xText)
xText:=""

$numLoc:=Size of array:C274($aEL_FG_Inventory)
ARRAY TEXT:C222($aSalesman; $numLoc)
ARRAY TEXT:C222($aCustName; $numLoc)
ARRAY TEXT:C222($aLine; $numLoc)
ARRAY TEXT:C222($aDesc; $numLoc)
ARRAY LONGINT:C221($aBillHold; $numLoc)
//TRACE
uThermoInit($numLoc; "Aging inventory by glue date")

For ($i; 1; $numLoc)  //for each finishgood that has onhand qtys
	uThermoUpdate($i)
	
	$hit:=Find in array:C230(<>aFGKey; $aEL_FG_Inventory{$i})  //use this so the' based on' code still works
	
	SET QUERY LIMIT:C395(1)
	QUERY:C277([Customers:16]; [Customers:16]ID:1=(Substring:C12(<>aFGKey{$hit}; 1; 5)))
	If (Records in selection:C76([Customers:16])>0)  //get cust info
		$aSalesman{$i}:=[Customers:16]SalesmanID:3
		$aCustName{$i}:=[Customers:16]Name:2
	Else 
		$aSalesman{$i}:="n/a"
		$aCustName{$i}:="N/A"
	End if 
	
	$numRec:=qryFinishedGood("#KEY"; <>aFGKey{$hit})
	If ($numRec>0)  //get description stuff
		$aLine{$i}:=[Finished_Goods:26]Line_Brand:15
		$aDesc{$i}:=[Finished_Goods:26]CartonDesc:3
		$aBillHold{$i}:=[Finished_Goods:26]Bill_and_Hold_Qty:108
	Else 
		$aLine{$i}:="n/a"
		$aDesc{$i}:="N/A"
		$aBillHold{$i}:=0
	End if 
	SET QUERY LIMIT:C395(0)
	
	$onHand:=0
	
	//age it
	ARRAY LONGINT:C221($qtyGroup; 0)
	ARRAY LONGINT:C221($qtyGroup; 6)
	
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]FG_Key:34=<>aFGKey{$hit})
	SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Jobit:33; $aJobit; [Finished_Goods_Locations:35]QtyOH:9; $aQty; [Finished_Goods_Locations:35]Location:2; $aBin)
	SORT ARRAY:C229($aJobit; $aQty; $aBin; >)
	For ($jobit; 1; Size of array:C274($aJobit))  //for each bin location for this f/g code sum the qty and tally it in age group
		$onHand:=$onHand+$aQty{$jobit}
		
		If (qryJMI($aJobit{$jobit})>0)  //get glue date
			$glued:=[Job_Forms_Items:44]Glued:33
			If ($glued=!00-00-00!)
				QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Jobit:31=$aJobit{$jobit}; *)
				QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Receipt")
				If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
					SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]XactionDate:3; $aTransDate)
					SORT ARRAY:C229($aTransDate; >)
					$glued:=$aTransDate{1}
					[Job_Forms_Items:44]Glued:33:=$glued
					SAVE RECORD:C53([Job_Forms_Items:44])
				End if 
			End if 
			
			If ($glued=!00-00-00!)
				$glued:=[Job_Forms_Items:44]Completed:39
				[Job_Forms_Items:44]Glued:33:=$glued
				SAVE RECORD:C53([Job_Forms_Items:44])
			End if 
			
		Else 
			$glued:=!00-00-00!
		End if   //jmi
		
		Case of   //tally it into age catagories
			: ($glued=!00-00-00!)
				$qtyGroup{6}:=$qtyGroup{6}+$aQty{$jobit}  //$qtyZero
			: ($glued>=$three)
				$qtyGroup{1}:=$qtyGroup{1}+$aQty{$jobit}  //$qtyThree
			: ($glued>=$six)
				$qtyGroup{2}:=$qtyGroup{2}+$aQty{$jobit}  //$qtySix
			: ($glued>=$nine)
				$qtyGroup{3}:=$qtyGroup{3}+$aQty{$jobit}  //$qtyNine
			: ($glued>=$twelve)
				$qtyGroup{4}:=$qtyGroup{4}+$aQty{$jobit}  //$qtyTwelve
			Else 
				$qtyGroup{5}:=$qtyGroup{5}+$aQty{$jobit}  //$qtyOver
		End case 
	End for 
	
	//value it
	ARRAY REAL:C219($valueGroup; 0)
	ARRAY REAL:C219($valueGroup; 6)
	
	$numRec:=qryJIC(""; <>aFGKey{$hit})
	If ($numRec>0)  //cost records found
		SELECTION TO ARRAY:C260([Job_Forms_Items_Costs:92]Jobit:3; $aJIC; [Job_Forms_Items_Costs:92]RemainingQuantity:15; $aJICqty; [Job_Forms_Items_Costs:92]RemainingTotal:12; $aJICcost)
		SORT ARRAY:C229($aJIC; $aJICqty; $aJICcost; <)
		ARRAY REAL:C219($aJICunit; $numRec)
		For ($jic; 1; $numRec)  //calc the unit cost of cartons
			If ($aJICqty{$jic}>0)
				$aJICunit{$jic}:=$aJICcost{$jic}/$aJICqty{$jic}
			Else 
				$aJICunit{$jic}:=0
			End if 
		End for 
		
		$costQty:=Sum:C1([Job_Forms_Items_Costs:92]RemainingQuantity:15)
		$excess:=<>aQty_OH{$hit}-$costQty
		If ($excess<0)
			$excess:=0
		End if 
		
		For ($grp; 6; 1; -1)  //remove any excess, from oldest to newest
			If ($excess>0)
				If ($qtyGroup{$grp}>0)
					If ($excess>=$qtyGroup{$grp})
						$excess:=$excess-$qtyGroup{$grp}
						$qtyGroup{$grp}:=0
					Else 
						$qtyGroup{$grp}:=$qtyGroup{$grp}-$excess
						$excess:=0
					End if 
				End if 
			End if 
		End for 
		
		$cursor:=1  //find the first costed qty (latest jobit may not have been calculated yet)
		$keepTrying:=True:C214
		While ($cursor<$numRec) & $keepTrying
			If ($aJICqty{$cursor}=0)
				$cursor:=$cursor+1
			Else 
				$keepTrying:=False:C215
			End if 
		End while 
		$value:=0
		
		For ($grp; 1; 6)  //set the value of each qty in age group
			$qty:=$qtyGroup{$grp}  //get a working copy of the qty
			$value:=0
			While ($qty>0) & ($cursor<=$numRec)
				Case of 
					: ($qty<=$aJICqty{$cursor})
						$value:=$value+($qty*$aJICunit{$cursor})
						$aJICqty{$cursor}:=$aJICqty{$cursor}-$qty
						$qty:=0
						If ($aJICqty{$cursor}<=0)
							$cursor:=$cursor+1
							$keepTrying:=True:C214
							While ($cursor<$numRec) & $keepTrying
								If ($aJICqty{$cursor}=0)
									$cursor:=$cursor+1
								Else 
									$keepTrying:=False:C215
								End if 
							End while 
						End if 
						
					: ($qty>$aJICqty{$cursor})  // more in this group than remaining costed
						$value:=$value+($aJICqty{$cursor}*$aJICunit{$cursor})
						$qty:=$qty-$aJICqty{$cursor}
						$aJICqty{$cursor}:=0
						$cursor:=$cursor+1
						$keepTrying:=True:C214
						While ($cursor<$numRec) & $keepTrying
							If ($aJICqty{$cursor}=0)
								$cursor:=$cursor+1
							Else 
								$keepTrying:=False:C215
							End if 
						End while 
				End case 
			End while 
			$valueGroup{$grp}:=$value
		End for 
		
	Else   //no cost records found
		For ($grp; 1; 6)
			$valueGroup{$grp}:=-1
		End for 
	End if 
	
	$rel:=Find in array:C230(<>aRelKey; <>aFGKey{$hit})  //get total released
	If ($rel>-1)
		$releases:=<>aRel_Open{$rel}
	Else 
		$releases:=0
	End if 
	
	$ord:=Find in array:C230(<>aOrdKey; <>aFGKey{$hit})  //get total on open orders
	If ($ord>-1)
		$orders:=<>aQty_Open{$ord}+<>aQty_ORun{$ord}  // • mel (7/13/05, 10:17:09) add open qty
	Else 
		$orders:=0
	End if 
	
	If ($orders>$releases)  //demand uses greater of orders or releases
		$demand:=$orders
	Else 
		$demand:=$releases
	End if 
	
	If ($limit)
		$supply:=$qtyGroup{1}+$qtyGroup{2}+$qtyGroup{3}+$qtyGroup{4}+$qtyGroup{5}+$qtyGroup{6}-$aBillHold{$i}
		If ($demand<$supply)
			$show:=True:C214
		Else 
			$show:=False:C215
		End if 
	Else 
		$show:=True:C214
	End if 
	
	If ($show)
		If (($valueGroup{3}+$valueGroup{4}+$valueGroup{5}+$valueGroup{6})>0)  //print if valued
			xText:=xText+$aSalesman{$i}+$t+$aCustName{$i}+$t+Substring:C12(<>aFGKey{$hit}; 7)+$t+String:C10($aBillHold{$i})+$t+String:C10($orders)+$t+String:C10($releases)+$t
			For ($grp; 1; 6)
				xText:=xText+String:C10($qtyGroup{$grp})+$t+String:C10($valueGroup{$grp}; "########0.00")+$t
			End for 
			
			xText:=xText+String:C10($glued; System date short:K1:1)+$t+$aLine{$i}+$t+$aDesc{$i}+$cr
			APPEND TO ARRAY:C911($a_cpns; Substring:C12(<>aFGKey{$hit}; 7))
		End if 
	End if 
	
	If (Length:C16(xText)>20000)
		SEND PACKET:C103($docRef; xText)
		xText:=""
	End if 
	
End for 
uThermoClose
SET QUERY LIMIT:C395(0)

SEND PACKET:C103($docRef; xText)
SEND PACKET:C103($docRef; $cr+$cr+"------ END OF FILE ------")
CLOSE DOCUMENT:C267($docRef)
// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
If (Count parameters:C259=0)
	$err:=util_Launch_External_App(docName)
End if 

If (Size of array:C274($a_cpns)>0)
	docName:="CPN-QUERY-"+fYYMMDD($today)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
	$docRef:=util_putFileName(->docName)
	For ($i; 1; Size of array:C274($a_cpns))
		SEND PACKET:C103($docRef; $a_cpns{$i}+Char:C90(13))
	End for 
	CLOSE DOCUMENT:C267($docRef)
End if 

xTitle:=""
xText:=""
REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
REDUCE SELECTION:C351([Customers:16]; 0)
BEEP:C151
BEEP:C151