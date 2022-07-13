//%attributes = {"publishedWeb":true}
//JOB_QuantityControlSheet
//mlb 080900

C_TEXT:C284($jobform; $1)
C_TEXT:C284($t; $cr)
C_LONGINT:C283(iUp; $item; $numitems; $subForms; items; $subForms; $numOfLines; $maxLines)
C_DATE:C307($threeMonths)

If (Count parameters:C259>0)
	$jobform:=$1
Else 
	$jobform:=Request:C163("Jobform number:"; "00000.00")
End if 

zwStatusMsg($jobform; "Printing Job Quantity Control Sheet")
$toDisk:=False:C215
$maxLines:=15
$numOfLines:=30
$threeMonths:=Add to date:C393(4D_Current_date; 0; 3; 0)  //production horizon

$t:=Char:C90(9)
$cr:=Char:C90(13)
sPrintedOn:="As of: "+TS2String(TSTimeStamp)

ARRAY TEXT:C222($aCPN; 0)
ARRAY TEXT:C222($aJobItems; 0)
ARRAY TEXT:C222($aOutline; 0)
ARRAY DATE:C224($aFirstRel; 0)
ARRAY LONGINT:C221($aQtyRel; 0)
ARRAY LONGINT:C221($aQtyYield; 0)
ARRAY LONGINT:C221($aQtyCustWant; 0)
ARRAY TEXT:C222($allCPN; 0)
ARRAY LONGINT:C221($aSF; 0)
ARRAY TEXT:C222($aPeggedOrderline; 0)
ARRAY LONGINT:C221($aYield; 0)
ARRAY LONGINT:C221($aitemNum; 0)

If ([Job_Forms:42]JobFormID:5#$jobform)
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$jobform)
End if 

If ([Jobs:15]JobNo:1#(Num:C11(Substring:C12($jobform; 1; 5))))
	RELATE ONE:C42([Job_Forms:42]JobNo:2)
End if 

sCustName:=[Jobs:15]CustomerName:5
sBrand:=[Jobs:15]Line:3
iUp:=[Job_Forms:42]NumberUp:26
items:=0
$subForms:=1

//get this forms item and subform count
$numitems:=qryJMI($jobform; 0; "@")
SELECTION TO ARRAY:C260([Job_Forms_Items:44]ProductCode:3; $allCPN; [Job_Forms_Items:44]SubFormNumber:32; $aSF; [Job_Forms_Items:44]ItemNumber:7; $aitemNum; [Job_Forms_Items:44]Qty_Yield:9; $aYield; [Job_Forms_Items:44]OrderItem:2; $aPeggedOrderline)

SORT ARRAY:C229($aitemNum; $allCPN; $aSF; $aYield; $aPeggedOrderline; >)
ARRAY TEXT:C222($aCPN; $numitems)
ARRAY TEXT:C222($aJobItems; $numitems)
ARRAY TEXT:C222($aOutline; $numitems)
ARRAY TEXT:C222($aSortKey; $numitems)
ARRAY DATE:C224($aFirstRel; $numitems)
ARRAY LONGINT:C221($aQtyRel; $numitems)
ARRAY LONGINT:C221($aQtyYield; $numitems)
ARRAY LONGINT:C221($aQtyCustWant; $numitems)

For ($item; 1; $numitems)
	$hit:=Find in array:C230($aCPN; $allCPN{$item})
	If ($hit=-1)
		items:=items+1
		$aCPN{items}:=$allCPN{$item}
		$aJobItems{items}:=String:C10($aitemNum{$item}; "00")
		$aQtyYield{items}:=$aYield{$item}
		//fg outline number
		
		qryFinishedGood("#CPN"; $allCPN{$item})
		$aOutline{items}:=[Finished_Goods:26]OutLine_Num:4
		REDUCE SELECTION:C351([Finished_Goods:26]; 0)
		$aSortKey{items}:=$aOutline{items}+$aCPN{items}
		//release info
		
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$allCPN{$item}; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#("<@"); *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5<$threeMonths)
		ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >)
		$aFirstRel{items}:=[Customers_ReleaseSchedules:46]Sched_Date:5
		$aQtyRel{items}:=Sum:C1([Customers_ReleaseSchedules:46]OpenQty:16)
		REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
		//customer want for item
		
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$aPeggedOrderline{$item}; *)
		QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Qty_Open:11>0)
		$aQtyCustWant{items}:=Sum:C1([Customers_Order_Lines:41]Qty_Open:11)
		REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
		
	Else   //already seen this CPN 
		
		$aQtyYield{$hit}:=$aQtyYield{$hit}+$aYield{$item}
		If (Position:C15(String:C10($aitemNum{$item}; "00"); $aJobItems{$hit})=0)
			$aJobItems{$hit}:=$aJobItems{$hit}+", "+String:C10($aitemNum{$item}; "00")
		End if 
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$aPeggedOrderline{$item}; *)
		QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Qty_Open:11>0)
		$aQtyCustWant{$hit}:=$aQtyCustWant{$hit}+Sum:C1([Customers_Order_Lines:41]Qty_Open:11)
		REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
	End if 
	//count number of subforms  
	
	If ($aSF{$item}>$subForms)
		$subForms:=$aSF{$item}
	End if 
End for 
//keepers

ARRAY TEXT:C222($aCPN; items)
ARRAY TEXT:C222($aJobItems; items)
ARRAY TEXT:C222($aOutline; items)
ARRAY TEXT:C222($aSortKey; items)
ARRAY DATE:C224($aFirstRel; items)
ARRAY LONGINT:C221($aQtyRel; items)
ARRAY LONGINT:C221($aQtyYield; items)
ARRAY LONGINT:C221($aQtyCustWant; items)
//done with

ARRAY TEXT:C222($allCPN; 0)
ARRAY LONGINT:C221($aSF; 0)
ARRAY TEXT:C222($aPeggedOrderline; 0)
ARRAY LONGINT:C221($aYield; 0)
ARRAY LONGINT:C221($aitemNum; 0)

SORT ARRAY:C229($aSortKey; $aOutline; $aFirstRel; $aCPN; $aJobItems; $aQtyRel; $aQtyYield; $aQtyCustWant; >)
ARRAY TEXT:C222($aSortKey; 0)
util_PAGE_SETUP(->[Job_Forms:42]; "Job_QtyControlHdr")
PDF_setUp("jobQCS"+$jobform+"_SF.pdf")
N1:=$subForms
sJobNo:=$jobform
If ($numOfLines>$maxLines)
	Print form:C5([Job_Forms:42]; "Job_QtyControlHdr")
	$numOfLines:=0
End if 

If ($toDisk)
	xTitle:="JOB QUANTITY CONTROL SHEET"
	xText:="Customer:"+$t+sCustName+$t+"Line:"+$t+sBrand+$t+"Job#:"+$t+$jobform+$cr
	xText:=xText+String:C10($subForms)+$t+"forms"+$t+String:C10(iUp)+$t+"UP"+$t+String:C10(items)+$t+"diff. items"+$cr+$cr
	$xSubFormTitle:=""  //set up markers
	
	For ($sf; 1; $subForms)
		$xSubFormTitle:=$xSubFormTitle+"FORM "+String:C10($sf)+$t
	End for 
	xText:=xText+"ITEM"+$t+"PRODUCT CODE"+$t+"FILE#"+$t+$xSubFormTitle+"TOTAL YIELD"+$t+"RFQ WANT"+$t+"DIFFERENCE"+$t+"1ST REL"+$t+"3 MONTH REL QTY"+$t+"AMOUNT TO INVENTORY"+$cr
End if 
$totalExcess:=0
$totalYield:=0
$totalRel:=0
$relPct:=0
$totalInventory:=0
$invPct:=0
$f1up:=0
$f2up:=0
$f3up:=0
$f4up:=0
$f1yld:=0
$f2yld:=0
$f3yld:=0
$f4yld:=0
For ($item; 1; items)
	$excess:=$aQtyYield{$item}-$aQtyCustWant{$item}
	If ($excess<0)
		$excess:=0
	End if 
	$totalExcess:=$totalExcess+$excess
	$totalYield:=$totalYield+$aQtyYield{$item}
	$totalRel:=$totalRel+$aQtyRel{$item}
	$inventory:=$aQtyYield{$item}-$aQtyRel{$item}
	If ($inventory<0)
		$inventory:=0
	End if 
	$totalInventory:=$totalInventory+$inventory
	//get the subform stuff
	
	$xSubFormText:=""  //set up markers
	
	For ($sf; 1; $subForms)
		$xSubFormText:=$xSubFormText+"#"+String:C10($sf)+$t
	End for 
	$numitems:=qryJMI($jobform; 0; $aCPN{$item})
	SELECTION TO ARRAY:C260([Job_Forms_Items:44]SubFormNumber:32; $aSF; [Job_Forms_Items:44]NumberUp:8; $aUp; [Job_Forms_Items:44]Qty_Yield:9; $aYield)
	SORT ARRAY:C229($aSF; $aUp; $aYield; >)
	sCol4:=0
	sCol5:=0
	sCol6:=0
	sCol7:=0
	sCol8:=0
	sCol9:=0
	sCol10:=0
	sCol11:=0
	For ($sf; 1; Size of array:C274($aSF))
		$xSubFormText:=Replace string:C233($xSubFormText; "#"+String:C10($aSF{$sf}); String:C10($aUp{$sf})+" / "+String:C10($aYield{$sf}; "###,###,##0"))
		Case of 
			: ($aSF{$sf}=1) | ($aSF{$sf}=0)
				sCol4:=$aUp{$sf}
				sCol5:=$aYield{$sf}
				$f1up:=$f1up+$aUp{$sf}
				$f1yld:=$f1yld+$aYield{$sf}
			: ($aSF{$sf}=2)
				sCol6:=$aUp{$sf}
				sCol7:=$aYield{$sf}
				$f2up:=$f2up+$aUp{$sf}
				$f2yld:=$f2yld+$aYield{$sf}
			: ($aSF{$sf}=3)
				sCol8:=$aUp{$sf}
				sCol9:=$aYield{$sf}
				$f3up:=$f3up+$aUp{$sf}
				$f3yld:=$f3yld+$aYield{$sf}
			: ($aSF{$sf}=4)
				sCol10:=$aUp{$sf}
				sCol11:=$aYield{$sf}
				$f4up:=$f4up+$aUp{$sf}
				$f4yld:=$f4yld+$aYield{$sf}
		End case 
	End for 
	
	If ($toDisk)
		For ($sf; 1; $subForms)  //clear unused markers
			
			If (Position:C15("#"+String:C10($sf); $xSubFormText)>0)
				$xSubFormText:=Replace string:C233($xSubFormText; "#"+String:C10($sf); "")
			End if 
		End for 
		xText:=xText+$aJobItems{$item}+$t+$aCPN{$item}+$t+$aOutline{$item}+$t+$xSubFormText+String:C10($aQtyYield{$item})+$t+String:C10($aQtyCustWant{$item})+$t+String:C10($excess)+$t+String:C10($aFirstRel{$item}; System date short:K1:1)+$t+String:C10($aQtyRel{$item})+$t+String:C10($inventory)+$cr
	End if 
	
	tText:=$aJobItems{$item}
	sCPN:=$aCPN{$item}
	sType:=$aOutline{$item}
	sCol12:=$aQtyYield{$item}
	sCol13:=$aQtyCustWant{$item}
	sCol14:=$excess
	sCol15:=$aQtyRel{$item}
	sCol16:=$inventory
	sDate:=String:C10($aFirstRel{$item}; System date short:K1:1)
	If ($numOfLines>$maxLines)
		PAGE BREAK:C6(>)
		Print form:C5([Job_Forms:42]; "Job_QtyControlHdr")
		$numOfLines:=0
	Else 
		$numOfLines:=$numOfLines+1
	End if 
	Print form:C5([Job_Forms:42]; "Job_QtyControlDetail")
End for 

tText:="§"
sCPN:=" S H E E T S"
sType:="YLD/UP"
sCol4:=0
If ($f1up#0)
	sCol5:=Round:C94($f1yld/$f1up; 0)
Else 
	sCol5:=0
End if 
sCol6:=0

If ($f2up#0)
	sCol7:=Round:C94($f2yld/$f2up; 0)
Else 
	sCol7:=0
End if 
sCol8:=0
If ($f3up#0)
	sCol9:=Round:C94($f3yld/$f3up; 0)
Else 
	sCol9:=0
End if 
sCol10:=0
If ($f4up#0)
	sCol11:=Round:C94($f4yld/$f4up; 0)
Else 
	sCol11:=0
End if 

sCol12:=sCol5+sCol7+sCol9+sCol11
sCol13:=0
sCol14:=0
sCol15:=0
sCol16:=0
sDate:=""
If ($numOfLines>$maxLines)
	PAGE BREAK:C6(>)
	Print form:C5([Job_Forms:42]; "Job_QtyControlHdr")
	$numOfLines:=0
Else 
	$numOfLines:=$numOfLines+1
End if 
Print form:C5([Job_Forms:42]; "Job_QtyControlDetail")

tText:="∑"
sCPN:=" T O T A L S"
sType:=""
sCol4:=$f1up
sCol5:=$f1yld
sCol6:=$f2up
sCol7:=$f2yld
sCol8:=$f3up
sCol9:=$f3yld
sCol10:=$f4up
sCol11:=$f4yld
sCol12:=$totalYield
sCol13:=0
sCol14:=$totalExcess
sCol15:=$totalRel
sCol16:=$totalInventory
sDate:=""
If ($numOfLines>$maxLines)
	PAGE BREAK:C6(>)
	Print form:C5([Job_Forms:42]; "Job_QtyControlHdr")
	$numOfLines:=0
Else 
	$numOfLines:=$numOfLines+1
End if 
Print form:C5([Job_Forms:42]; "Job_QtyControlDetail")

tText:="%"
sCPN:=" P E R C E N T A G E"
sType:="OF YIELD"
sCol4:=0
sCol5:=Round:C94($f1yld/$totalYield*100; 0)
sCol6:=0
sCol7:=Round:C94($f2yld/$totalYield*100; 0)
sCol8:=0
sCol9:=Round:C94($f3yld/$totalYield*100; 0)
sCol10:=0
sCol11:=Round:C94($f4yld/$totalYield*100; 0)
sCol12:=0
sCol13:=0
sCol14:=0
sCol15:=Round:C94($totalRel/$totalYield*100; 0)
sCol16:=Round:C94($totalInventory/$totalYield*100; 0)
If ($numOfLines>$maxLines)
	PAGE BREAK:C6(>)
	Print form:C5([Job_Forms:42]; "Job_QtyControlHdr")
	$numOfLines:=0
Else 
	$numOfLines:=$numOfLines+1
End if 
Print form:C5([Job_Forms:42]; "Job_QtyControlDetail")
PAGE BREAK:C6

If ($toDisk)
	xText:=xText+$cr
	xText:=xText+""+$t+"EXCESS CTNS."+$t+"TOTAL YIELD"+$t+"AMOUNT REL."+$t+"REL %"+$t+"AMOUNT TO INVENTORY"+$t+"% TO INVENTORY"+$cr
	xText:=xText+"TOTALS:"+$t+String:C10($totalExcess)+$t+String:C10($totalYield)+$t+String:C10($totalRel)+$t+String:C10(Round:C94($totalRel/$totalYield*100; 0))+$t+String:C10($totalInventory)+$t+String:C10(Round:C94($totalInventory/$totalYield*100; 0))+$cr
	rPrintText("JobQtyCntrl."+$jobform)
End if 

zwStatusMsg("FINISHED"; "Printed Job Quantity Control Sheet for job "+$jobform)