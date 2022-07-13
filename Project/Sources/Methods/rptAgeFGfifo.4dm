//%attributes = {}
// Method: rptAgeFGfifo () -> 
// ----------------------------------------------------
// by: mel: 06/01/05, 09:03:53
// ----------------------------------------------------
// Description:
//based on rptAgeFGdetail()  111398  MLB
//but do it by item, not location and value by fifo
// • mel (7/13/05, 10:17:09) add open qty for po qty, not just the overrun
//021709 added gluedate to report, remove fxqty
// Modified by: Mel Bohince (4/4/14) Retrofit server execution and pass back to client
// Modified by: Mel Bohince (12/2/15) undo the server execution
// Modified by: MelvinBohince (1/10/22) remove confirm about kill excess or all; change to csv

C_BLOB:C604($blob)
SET BLOB SIZE:C606($blob; 0)
C_DATE:C307($today; $three; $six; $nine; $twelve)
C_TEXT:C284(xTitle; xText; $r; $t)

$r:="\r"  //Char(Carriage return)
$t:=","  //Char(Tab)
$today:=Current date:C33
$three:=Add to date:C393($today; 0; -3; 0)  //-(3*30)
$six:=Add to date:C393($today; 0; -6; 0)  //-(6*30)
$nine:=Add to date:C393($today; 0; -9; 0)  //-(9*30)
$twelve:=Add to date:C393($today; 0; -12; 0)  //-(12*30)

C_TEXT:C284($1; $client_call_back; $docShortName; docName; $distributionList)

Case of 
	: (Count parameters:C259=2)  //FiFo_Aged_Inventory
		$client_call_back:=$1
		docName:=$2
		
	: (Count parameters:C259=1)
		$distributionList:=$1
		docName:="AgeFGinvenFIFO_"+fYYMMDD($today)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
		
	Else 
		$client_call_back:=""
		docName:="AgeFGinvenFIFO_"+fYYMMDD($today)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
End case 

$docShortName:=docName  //capture before path is prepended
C_TIME:C306($docRef)
$docRef:=util_putFileName(->docName)


READ ONLY:C145([Customers:16])
READ WRITE:C146([Job_Forms_Items:44])  // incase glue date needs reset
READ ONLY:C145([Finished_Goods:26])
READ ONLY:C145([Finished_Goods_Locations:35])

If (Count parameters:C259=0)
	//CONFIRM("Only calc OK2Kill based on Excess?";"Excess";"All Qty over 3mth")
	$killOnlyExcess:=True:C214  //(ok=1)
	
	SET AUTOMATIC RELATIONS:C310(True:C214; False:C215)
	QUERY:C277([Finished_Goods_Locations:35])
	SET AUTOMATIC RELATIONS:C310(False:C215; False:C215)
	
Else 
	utl_Logfile("AgedFifo.log"; "Running for all FG locations")
	ALL RECORDS:C47([Finished_Goods_Locations:35])
	$killOnlyExcess:=True:C214
End if 

//QUERY SELECTION([Finished_Goods_Locations];[Finished_Goods_Locations]Location#"BH@")`obsolete, bh kept in f/g record, see [Finished_Goods]Bill_and_Hold_Qty below,  11/13/08
<>FgBatchDat:=!00-00-00!
<>OrdBatchDat:=!00-00-00!
BatchFGinventor(0; ""; 0)
BatchOrdcalc(0; "@")
BatchRelCalc(0; "@")

If (<>IgnorObsoleteAndOld)  // Modified by: Mel Bohince (3/21/14) 
	$spl_note:=", >9 MTHS Devalued "
Else 
	$spl_note:=", Any Age Valued "
End if 

xTitle:="Aged F/G Inventory, by Date Glued, using FIFO Valuation "+String:C10($today; <>LONGDATE)+"  "+String:C10(4d_Current_time; <>HMMAM)+"; Open Orders includes over-run, Open releases includes forecasts"+$spl_note
xText:=""+$t+""+$t+""+$t+""+$t+""+$t+$t+""+$t+"≤ 3 Mths"+$t+$t+"3 < Mths ≤ 6"+$t+$t+"6 < Mths ≤ 9"+$t+$t+"9 < Mths ≤ 12"+$t+$t+"12 < Mths"+$t+$t+"Glued=00/00/00"+$t+$r+$r
xText:=xText+"SALESMAN"+$t+"CUSTOMER"+$t+"CPN"+$t+"INVESTMENT"+$t+"BILL&HOLD"+$t+"OPEN_PO"+$t+"RELEASED"+$t+"Qty3"+$t+"Value3"+$t+"Qty6"+$t+"Value6"+$t+"Qty9"+$t+"Value9"+$t+"Qty12"+$t+"Value12"+$t+"Qty13"+$t+"Value13"+$t+"Qty?"+$t+"Value?"+$t+"LastGlued"+$t+"OK2KILL?"+$t+"CaseQty"+$t+"Line"+$t+"Desc"+$t+"Liability"+$r

SEND PACKET:C103($docRef; xTitle+$r+$r)
SEND PACKET:C103($docRef; xText)
xText:=""


$numLoc:=Size of array:C274(<>aFGKey)
ARRAY TEXT:C222($aSalesman; $numLoc)
ARRAY TEXT:C222($aCustName; $numLoc)
ARRAY TEXT:C222($aLine; $numLoc)
ARRAY TEXT:C222($aDesc; $numLoc)
ARRAY LONGINT:C221($aBillHold; $numLoc)
ARRAY LONGINT:C221($aLiability; $numLoc)
ARRAY LONGINT:C221($aCaseQty; $numLoc)
//TRACE
uThermoInit(Size of array:C274(<>aFGKey); "Aging inventory by glue date")

For ($i; 1; Size of array:C274(<>aFGKey))
	uThermoUpdate($i)
	SET QUERY LIMIT:C395(1)
	QUERY:C277([Customers:16]; [Customers:16]ID:1=(Substring:C12(<>aFGKey{$i}; 1; 5)))
	If (Records in selection:C76([Customers:16])>0)
		$aSalesman{$i}:=[Customers:16]SalesmanID:3
		$aCustName{$i}:=txt_quote([Customers:16]Name:2)
		
	Else 
		$aSalesman{$i}:="n/a"
		$aCustName{$i}:="N/A"
	End if 
	
	$numRec:=qryFinishedGood("#KEY"; <>aFGKey{$i})
	If ($numRec>0)
		$aLine{$i}:=txt_quote([Finished_Goods:26]Line_Brand:15)
		$aDesc{$i}:=txt_quote([Finished_Goods:26]CartonDesc:3)
		$aBillHold{$i}:=[Finished_Goods:26]Bill_and_Hold_Qty:108
		$aLiability{$i}:=[Finished_Goods:26]InventoryLiability:111
		$aCaseQty{$i}:=PK_getCaseCount([Finished_Goods:26]OutLine_Num:4)
	Else 
		$aLine{$i}:="n/a"
		$aDesc{$i}:="N/A"
		$aBillHold{$i}:=0
		$aLiability{$i}:=0
		$aCaseQty{$i}:=0
	End if 
	SET QUERY LIMIT:C395(0)
	$kill:=0
	$onHand:=0
	$billedAlready:=$aBillHold{$i}  //get a working copy of b&h qty
	$newStuff:=0
	$ours:=0
	//age it
	ARRAY LONGINT:C221($qtyGroup; 0)
	ARRAY LONGINT:C221($qtyGroup; 6)
	
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]FG_Key:34=<>aFGKey{$i})
	SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Jobit:33; $aJobit; [Finished_Goods_Locations:35]QtyOH:9; $aQty; [Finished_Goods_Locations:35]Location:2; $aBin)
	SORT ARRAY:C229($aJobit; $aQty; $aBin; >)
	For ($jobit; 1; Size of array:C274($aJobit))
		
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
		
		Case of 
			: ($glued=!00-00-00!)
				$qtyGroup{6}:=$qtyGroup{6}+$aQty{$jobit}  //$qtyZero
				$newStuff:=$newStuff+$aQty{$jobit}
			: ($glued>=$three)
				$qtyGroup{1}:=$qtyGroup{1}+$aQty{$jobit}  //$qtyThree
				$newStuff:=$newStuff+$aQty{$jobit}
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
		For ($jic; 1; $numRec)
			If ($aJICqty{$jic}>0)
				$aJICunit{$jic}:=$aJICcost{$jic}/$aJICqty{$jic}
				//$costQty:=$costQty+$aJICqty{$jic}
			Else 
				$aJICunit{$jic}:=0
			End if 
		End for 
		
		$costQty:=Sum:C1([Job_Forms_Items_Costs:92]RemainingQuantity:15)
		$excess:=<>aQty_OH{$i}-$costQty
		If ($excess<0)
			$excess:=0
		End if 
		
		$cursor:=1
		$keepTrying:=True:C214
		While ($cursor<$numRec) & $keepTrying
			If ($aJICqty{$cursor}=0)
				$cursor:=$cursor+1
			Else 
				$keepTrying:=False:C215
			End if 
		End while 
		$value:=0
		
		For ($grp; 1; 6)
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
		
	Else   // Modified by: Mel Bohince (4/3/14) was setting them all to -1, 0 is less disruptive now that >9mths ignored 
		$excess:=<>aQty_OH{$i}
		For ($grp; 1; 6)
			$valueGroup{$grp}:=0
		End for 
	End if 
	
	$hit:=Find in array:C230(<>aRelKey; <>aFGKey{$i})
	If ($hit>-1)
		$releases:=<>aRel_Open{$hit}
	Else 
		$releases:=0
	End if 
	
	$hit:=Find in array:C230(<>aOrdKey; <>aFGKey{$i})
	If ($hit>-1)
		$orders:=<>aQty_Open{$hit}+<>aQty_ORun{$hit}  // • mel (7/13/05, 10:17:09) add open qty
	Else 
		$orders:=0
	End if 
	
	If ($orders>$releases)  //use whichever is greater
		$demand:=$orders
	Else 
		$demand:=$releases
	End if 
	
	$ours:=$onHand-$aBillHold{$i}  //-$aLiability{$i}
	$kill:=$ours-$newStuff
	$kill:=$kill-$demand
	If ($killOnlyExcess)  //limit kills to no-cost inventory
		If ($kill>$excess)
			$kill:=$excess
		End if 
	End if 
	//don't kill partial cases, NOT
	//If ($kill<$aCaseQty{$i})
	//$kill:=0
	//End if 
	//don't show negatives
	If ($kill<0)
		$kill:=0
	End if 
	
	xText:=xText+$aSalesman{$i}+$t+$aCustName{$i}+$t+Substring:C12(<>aFGKey{$i}; 7)+$t+String:C10($excess)+$t+String:C10($aBillHold{$i})+$t+String:C10($orders)+$t+String:C10($releases)+$t
	For ($grp; 1; 6)
		xText:=xText+String:C10($qtyGroup{$grp})+$t+String:C10($valueGroup{$grp}; "########0.00")+$t
	End for 
	
	xText:=xText+String:C10($glued; System date short:K1:1)+$t+String:C10($kill)+$t+String:C10($aCaseQty{$i})+$t+$aLine{$i}+$t+$aDesc{$i}+$t+String:C10($aLiability{$i})+$r
	
	//If (Length(xText)>20000)
	//SEND PACKET($docRef;xText)
	//xText:=""
	//End if 
	
End for 
uThermoClose
SET QUERY LIMIT:C395(0)

SEND PACKET:C103($docRef; xText)
SEND PACKET:C103($docRef; $r+$r+"------ END OF FILE ------")
CLOSE DOCUMENT:C267($docRef)
xTitle:=""
xText:=""

REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
REDUCE SELECTION:C351([Customers:16]; 0)

Case of 
	: (Count parameters:C259=2)  //$client_requesting:=clientRegistered_as
		DOCUMENT TO BLOB:C525(docName; $blob)
		DELETE DOCUMENT:C159(docName)  // no reason to leave it around
		EXECUTE ON CLIENT:C651($client_call_back; "FiFo_Aged_Inventory"; $docShortName; $blob)
		SET BLOB SIZE:C606($blob; 0)  //clean up
		
	: (Count parameters:C259=1)
		EMAIL_Sender("FIFO Aged Monthly "+fYYMMDD(Current date:C33); ""; "Advance copy attached"; $distributionList; docName)
		
	Else 
		$err:=util_Launch_External_App(docName)
End case 



