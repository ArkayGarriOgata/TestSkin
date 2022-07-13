//%attributes = {"publishedWeb":true}
//JOB_QuantityControlSheet
//mlb 080900
//•090802  mlb  Revision 2
//•9/19/00  mlb  rev 3 add cpn
//•9/29/00  mlb  add yld total
// • mel (10/9/03, 13:35:44) change from 3 to 2 months
// • mel (11/12/03, 15:50:08) change from 2 to 3 months
// • mel (4/13/04, 10:40:30) include columns for all releases

C_TEXT:C284($jobform; $1)
C_TEXT:C284($t; $cr)
C_LONGINT:C283($item; $numitems; $numOfLines; $maxLines)
C_DATE:C307($threeMonths)

MESSAGES OFF:C175

If (Count parameters:C259>0)
	$jobform:=$1
Else 
	$jobform:=Request:C163("Jobform number:"; "00000.00")
End if 

zwStatusMsg($jobform; "Printing Job Quantity Control Sheet")
$toDisk:=False:C215
$maxLines:=20
$numOfLines:=30
$threeMonths:=Add to date:C393(4D_Current_date; 0; 3; 0)  //production horizon

$t:=Char:C90(9)
$cr:=Char:C90(13)
sPrintedOn:="As of: "+TS2String(TSTimeStamp)
READ ONLY:C145([Finished_Goods_Locations:35])
READ ONLY:C145([Customers_ReleaseSchedules:46])

If ([Job_Forms:42]JobFormID:5#$jobform)
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$jobform)
End if 

If ([Jobs:15]JobNo:1#(Num:C11(Substring:C12($jobform; 1; 5))))
	RELATE ONE:C42([Job_Forms:42]JobNo:2)
End if 

sCustName:=[Jobs:15]CustomerName:5
sBrand:=[Jobs:15]Line:3

//get this forms item and subform count

ARRAY TEXT:C222($allCPN; 0)
ARRAY LONGINT:C221($aYield; 0)
ARRAY LONGINT:C221($aitemNum; 0)
$numitems:=qryJMI($jobform; 0; "@")
SELECTION TO ARRAY:C260([Job_Forms_Items:44]ProductCode:3; $allCPN; [Job_Forms_Items:44]ItemNumber:7; $aitemNum; [Job_Forms_Items:44]Qty_Yield:9; $aYield)
SORT ARRAY:C229($allCPN; $aitemNum; $aYield; >)

ARRAY TEXT:C222($aJobItems; $numitems)
ARRAY TEXT:C222($aCPN; $numitems)  //•9/20/00  mlb  

ARRAY LONGINT:C221($aQtyYield; $numitems)

ARRAY LONGINT:C221($onhand; $numitems)
ARRAY LONGINT:C221($wip; $numitems)
ARRAY LONGINT:C221($supply; $numitems)

ARRAY LONGINT:C221($demand; $numitems)
ARRAY LONGINT:C221($want; $numitems)
ARRAY LONGINT:C221($excess; $numitems)

ARRAY LONGINT:C221($demandALL; $numitems)
ARRAY LONGINT:C221($wantALL; $numitems)
ARRAY LONGINT:C221($excessALL; $numitems)

items:=0
For ($item; 1; $numitems)
	$hit:=Find in array:C230($aCPN; $allCPN{$item})
	If ($hit=-1)
		//set up the data for this cpn    
		items:=items+1
		
		$aJobItems{items}:=String:C10($aitemNum{$item}; "00")
		$aCPN{items}:=$allCPN{$item}
		$aQtyYield{items}:=$aYield{$item}
		
		//*get other supply
		
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=$allCPN{$item})
		//QUERY([Finished_Goods_Locations]; & ;[Finished_Goods_Locations]Location#"BH@")
		If (Records in selection:C76([Finished_Goods_Locations:35])>0)
			$onhand{items}:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
		Else 
			$onhand{items}:=0
		End if 
		
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=$allCPN{$item}; *)
		QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]JobForm:1#$jobform; *)
		QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Qty_Actual:11=0)
		If (Records in selection:C76([Job_Forms_Items:44])>0)
			$wip{items}:=Sum:C1([Job_Forms_Items:44]Qty_Yield:9)
		Else 
			$wip{items}:=0
		End if 
		
		$supply{items}:=$wip{items}+$onhand{items}
		
		//*get 3months releases
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$allCPN{$item}; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5<=$threeMonths)
		If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
			$demand{items}:=Sum:C1([Customers_ReleaseSchedules:46]Sched_Qty:6)
		Else 
			$demand{items}:=0
		End if 
		//*calc actual want
		
		$want{items}:=$demand{items}-$supply{items}
		If ($want{items}<0)
			$want{items}:=0
		End if 
		
		//*get all releases
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$allCPN{$item}; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0)
		If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
			$demandALL{items}:=Sum:C1([Customers_ReleaseSchedules:46]Sched_Qty:6)
		Else 
			$demandALL{items}:=0
		End if 
		//*calc actual want
		$wantALL{items}:=$demandALL{items}-$supply{items}
		If ($wantALL{items}<0)
			$wantALL{items}:=0
		End if 
		
	Else 
		$aQtyYield{$hit}:=$aQtyYield{$hit}+$aYield{$item}
		If (Position:C15(String:C10($aitemNum{$item}; "00"); $aJobItems{$hit})=0)
			$aJobItems{$hit}:=$aJobItems{$hit}+", "+String:C10($aitemNum{$item}; "00")
		End if 
	End if 
	
End for 

//keeper
ARRAY TEXT:C222($aJobItems; items)
ARRAY TEXT:C222($aCPN; items)  //•9/20/00  mlb  

ARRAY LONGINT:C221($aQtyYield; items)

ARRAY LONGINT:C221($onhand; items)
ARRAY LONGINT:C221($wip; items)
ARRAY LONGINT:C221($supply; items)

ARRAY LONGINT:C221($demand; items)
ARRAY LONGINT:C221($want; items)
ARRAY LONGINT:C221($excess; items)

ARRAY LONGINT:C221($demandALL; items)
ARRAY LONGINT:C221($wantALL; items)
ARRAY LONGINT:C221($excessALL; items)
//done with

ARRAY TEXT:C222($allCPN; 0)
ARRAY LONGINT:C221($aYield; 0)
ARRAY LONGINT:C221($aitemNum; 0)


$totalYield:=0  //•9/29/00  mlb

$totalSupply:=0
$totalDemand:=0
$totalWant:=0
$totalExcess:=0

$totalDemandALL:=0
$totalWantALL:=0
$totalExcessALL:=0


For ($item; 1; items)  //*calc excess/short
	
	$totalYield:=$totalYield+$aQtyYield{$item}
	$totalSupply:=$totalSupply+$supply{$item}
	$totalDemand:=$totalDemand+$demand{$item}
	$totalWant:=$totalWant+$want{$item}
	$excess{$item}:=$aQtyYield{$item}-$want{$item}
	If ($excess{$item}<0)
		$excess{$item}:=0
	End if 
	If ($excess{$item}>0)
		$totalExcess:=$totalExcess+$excess{$item}
	End if 
	
	$totalDemandALL:=$totalDemandALL+$demandALL{$item}
	$totalWantALL:=$totalWantALL+$wantALL{$item}
	$excessALL{$item}:=$aQtyYield{$item}-$wantALL{$item}
	If ($excessALL{$item}<0)
		$excessALL{$item}:=0
	End if 
	If ($excessALL{$item}>0)
		$totalExcessALL:=$totalExcessALL+$excessALL{$item}
	End if 
	
End for 

If ($totalWant>0)
	$percentToInv:=Round:C94($totalExcess/$totalYield*100; 0)  //•9/29/00  mlb  was /totalWant
	
Else 
	$percentToInv:=100
End if 
iUp:=$percentToInv

If ($totalWantALL>0)
	$percentToInvALL:=Round:C94($totalExcessALL/$totalYield*100; 0)  //•9/29/00  mlb  was /totalWant
	
Else 
	$percentToInvALL:=100
End if 
iWant:=$percentToInvALL

util_PAGE_SETUP(->[Job_Forms:42]; "Job_QtyControlHdr2")
PDF_setUp("jobQCS"+$jobform+".pdf")
sJobNo:=$jobform
If ($numOfLines>$maxLines)
	Print form:C5([Job_Forms:42]; "Job_QtyControlHdr2")
	$numOfLines:=0
End if 

For ($item; 1; items)
	tText:=$aJobItems{$item}
	sCPN:=$aCPN{$item}
	sComp:=String:C10($onhand{$item}; "###,##0")+" + "+String:C10($wip{$item}; "###,##0")+" = "+String:C10($supply{$item}; "^,^^^,^^0")
	sCol5:=$aQtyYield{$item}
	sCol6:=$supply{$item}+$aQtyYield{$item}
	sCol7:=$demand{$item}
	//sCol7:=  $want{$item}
	
	sCol8:=$excess{$item}
	sCol9:=$demandALL{$item}
	sCol10:=$excessALL{$item}  //$wantALL{$item}
	
	//sCol11:=$excessALL{$item}
	
	If ($numOfLines>$maxLines)
		PAGE BREAK:C6(>)
		Print form:C5([Job_Forms:42]; "Job_QtyControlHdr2")
		$numOfLines:=0
	Else 
		$numOfLines:=$numOfLines+1
	End if 
	Print form:C5([Job_Forms:42]; "Job_QtyControlDetail2")
End for 

tText:=""
sCPN:="        TOTALS:"
sComp:="          "+String:C10($totalSupply; "^,^^^,^^0")
sCol5:=$totalYield
sCol6:=$totalDemand+$totalSupply
sCol7:=$totalDemand
//sCol7:= $totalWant

sCol8:=$totalExcess
sCol9:=$totalDemandALL
sCol10:=$totalExcessALL  //$totalWantALL

//sCol11:=$totalExcessALL

Print form:C5([Job_Forms:42]; "Job_QtyControlDetail2")
PAGE BREAK:C6
REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
zwStatusMsg("FINISHED"; "Printed Job Quantity Control Sheet for job "+$jobform)