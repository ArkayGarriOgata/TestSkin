//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 03/12/09, 10:43:39
// ----------------------------------------------------
// Method: rptAgeFGfifo_costed
// Description
// strip away the excess from the qty columns
// based on rptAgeFGfifo
// Parameters
// ----------------------------------------------------

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

If (Count parameters:C259=0)
	SET AUTOMATIC RELATIONS:C310(True:C214; False:C215)
	QUERY:C277([Finished_Goods_Locations:35])
	SET AUTOMATIC RELATIONS:C310(False:C215; False:C215)
	
Else 
	ALL RECORDS:C47([Finished_Goods_Locations:35])
End if 

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

docName:="AgeFGinvenFIFO_Costed"+fYYMMDD($today)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")
$docRef:=util_putFileName(->docName)

SEND PACKET:C103($docRef; xTitle+$CR+$CR)
SEND PACKET:C103($docRef; xText)
xText:=""
$numLoc:=Size of array:C274(<>aFGKey)
ARRAY TEXT:C222($aSalesman; $numLoc)
ARRAY TEXT:C222($aCustName; $numLoc)
ARRAY TEXT:C222($aLine; $numLoc)
ARRAY TEXT:C222($aDesc; $numLoc)
ARRAY LONGINT:C221($aBillHold; $numLoc)
//TRACE
uThermoInit(Size of array:C274(<>aFGKey); "Aging inventory by glue date")

For ($i; 1; Size of array:C274(<>aFGKey))  //for each finishgood that has onhand qtys
	uThermoUpdate($i)
	SET QUERY LIMIT:C395(1)
	QUERY:C277([Customers:16]; [Customers:16]ID:1=(Substring:C12(<>aFGKey{$i}; 1; 5)))
	If (Records in selection:C76([Customers:16])>0)
		$aSalesman{$i}:=[Customers:16]SalesmanID:3
		$aCustName{$i}:=[Customers:16]Name:2
	Else 
		$aSalesman{$i}:="n/a"
		$aCustName{$i}:="N/A"
	End if 
	
	$numRec:=qryFinishedGood("#KEY"; <>aFGKey{$i})
	If ($numRec>0)
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
	$billedAlready:=$aBillHold{$i}  //get a working copy of b&h qty
	//age it
	ARRAY LONGINT:C221($qtyGroup; 0)
	ARRAY LONGINT:C221($qtyGroup; 6)
	
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]FG_Key:34=<>aFGKey{$i})
	SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Jobit:33; $aJobit; [Finished_Goods_Locations:35]QtyOH:9; $aQty; [Finished_Goods_Locations:35]Location:2; $aBin)
	SORT ARRAY:C229($aJobit; $aQty; $aBin; >)
	For ($jobit; 1; Size of array:C274($aJobit))  //for each bin location for this f/g code sum the qty and tally it in age group
		If ($billedAlready>0)  // & (False)  `remove what we can from this jobit's qty
			If ($aQty{$jobit}<=$billedAlready)  //none should be valued
				$billedAlready:=$billedAlready-$aQty{$jobit}  //consume some of the b&h copy
				$aQty{$jobit}:=0
				
			Else 
				$aQty{$jobit}:=$aQty{$jobit}-$billedAlready  //some may be valued
				$billedAlready:=0  //consume the b&h totally
			End if 
		End if 
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
	
	$numRec:=qryJIC(""; <>aFGKey{$i})
	If ($numRec>0)
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
		$excess:=<>aQty_OH{$i}-$costQty
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
	
	$hit:=Find in array:C230(<>aRelKey; <>aFGKey{$i})  //get total released
	If ($hit>-1)
		$releases:=<>aRel_Open{$hit}
	Else 
		$releases:=0
	End if 
	
	$hit:=Find in array:C230(<>aOrdKey; <>aFGKey{$i})  //get total on open orders
	If ($hit>-1)
		$orders:=<>aQty_Open{$hit}+<>aQty_ORun{$hit}  // • mel (7/13/05, 10:17:09) add open qty
	Else 
		$orders:=0
	End if 
	
	If ($orders>$releases)  //demand uses greater of orders or releases
		$demand:=$orders
	Else 
		$demand:=$releases
	End if 
	
	If (($qtyGroup{1}+$qtyGroup{2}+$qtyGroup{3}+$qtyGroup{4}+$qtyGroup{5}+$qtyGroup{6})>0)
		xText:=xText+$aSalesman{$i}+$t+$aCustName{$i}+$t+Substring:C12(<>aFGKey{$i}; 7)+$t+String:C10($aBillHold{$i})+$t+String:C10($orders)+$t+String:C10($releases)+$t
		For ($grp; 1; 6)
			xText:=xText+String:C10($qtyGroup{$grp})+$t+String:C10($valueGroup{$grp}; "########0.00")+$t
		End for 
		
		xText:=xText+String:C10($glued; System date short:K1:1)+$t+$aLine{$i}+$t+$aDesc{$i}+$cr
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

xTitle:=""
xText:=""

REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
REDUCE SELECTION:C351([Customers:16]; 0)

BEEP:C151
BEEP:C151