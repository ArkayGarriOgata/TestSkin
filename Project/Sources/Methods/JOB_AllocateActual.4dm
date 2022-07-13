//%attributes = {"publishedWeb":true}
//PM:  JOB_AllocateActual  2/14/00  mlb
//formerly  `(P) gAllocateActual  see also gAllocate
//-------------------------------------
//11/15/94 make material costs positive in wip
//upr 160 1/9/95
//1/24/95 remove modal window
// drop the field upr 1449 3/10/95
//4/19/95 [jmi]qty_machticket added to be compared to [jmi]qty_actual
//•112296    skip the machine_item level stuff
//• 4/10/97 cs stop creation of MI records - request from Jim
//• 9/5/97 cs remove creation of Machine Item records - request of Jim
//• 4/10/98 cs Nan Checking
//• 6/11/98 cs rem oved reference to Machine & MAterial  Item tables
//• 8/10/98 cs nan checking
//•030599  MLB  use contract price and want qty for ave selling price if orderline
//•102799   mlb  chg to using Job_CalcAllocPercent()   mlb
//•2/04/00  mlb  always allocate
//•2/14/00  mlb  comment out MthSummary allocation by item
//• mlb - 4/25/01  12:28treat contract items special
// • mel (5/5/04, 15:52:50) don't close if just allocation

//zwStatusMsg ("Allocating";"Allocating actual for "+[Job_Forms]JobFormID)
//utl_Logfile ("rollup.log";"Allocating actual for "+[Job_Forms]JobFormID)

MESSAGES OFF:C175

C_LONGINT:C283($i)
C_REAL:C285($TotalSqIn; $alloc; $perM)  //to calc avg selling price
C_BOOLEAN:C305(canHaveExcess)

canHaveExcess:=True:C214  //see also JIC_Regenerate
//JMS_MthlySummary("init") `•2/14/00  mlb  comment out MthSummary allocation b

If (Count parameters:C259>0)
	RELATE MANY:C262([Job_Forms:42]JobFormID:5)
End if 

FIRST RECORD:C50([Job_Forms_Items:44])
If (<>AllocateGoodQty)
	//zwStatusMsg ("Allocating";"  Look for contract items")
	$i:=Job_FindContractItems  //• mlb - 4/25/01  12:28treat contract items special
End if 
//zwStatusMsg ("Allocating";"  Calculating total square inches on the job...")
$TotalSqIn:=Job_CalcAllocPercent(->[Job_Forms_Items:44]Qty_Good:10)

$jic:=qryJIC(([Job_Forms:42]JobFormID:5+"@"))
If ($jic>0)
	DELETE SELECTION:C66([Job_Forms_Items_Costs:92])  //because of the additive nature req'd for subforms
End if 

FIRST RECORD:C50([Job_Forms_Items:44])
//uThermoInit (Records in selection([Job_Forms_Items]);"Allocating actual costs")
For ($i; 1; Records in selection:C76([Job_Forms_Items:44]))
	$alloc:=[Job_Forms_Items:44]AllocationPercent:23/100
	If ([Job_Forms_Items:44]Qty_Good:10>[Job_Forms_Items:44]Qty_Want:24)
		$perM:=[Job_Forms_Items:44]Qty_Want:24/1000
	Else 
		$perM:=[Job_Forms_Items:44]Qty_Good:10/1000
	End if 
	If ($perM#0)
		[Job_Forms_Items:44]Cost_LAB:13:=([Job_Forms:42]ActLabCost:37*$alloc)/$perM
		[Job_Forms_Items:44]Cost_Burd:14:=([Job_Forms:42]ActOvhdCost:38*$alloc)/$perM
		[Job_Forms_Items:44]Cost_SE:16:=([Job_Forms:42]ActS_ECost:39*$alloc)/$perM
		[Job_Forms_Items:44]Cost_Mat:12:=([Job_Forms:42]ActMatlCost:40*$alloc)/$perM
		[Job_Forms_Items:44]ActCost_M:27:=[Job_Forms_Items:44]Cost_LAB:13+[Job_Forms_Items:44]Cost_Burd:14+[Job_Forms_Items:44]Cost_SE:16+[Job_Forms_Items:44]Cost_Mat:12
	Else 
		[Job_Forms_Items:44]Cost_LAB:13:=0
		[Job_Forms_Items:44]Cost_Burd:14:=0
		[Job_Forms_Items:44]Cost_SE:16:=0
		[Job_Forms_Items:44]Cost_Mat:12:=0
		[Job_Forms_Items:44]ActCost_M:27:=0
	End if 
	
	If (isClosing)  // • mel (5/5/04, 15:52:50) don't close if just allocation
		[Job_Forms_Items:44]FormClosed:5:=True:C214  //•120798  MLB  streamline this
	End if 
	uUpdateTrail(->[Job_Forms_Items:44]ModDate:29; ->[Job_Forms_Items:44]ModWho:30)
	//JMS_MthlySummary  `•2/14/00  mlb  comment out MthSummary allocation by item 
	//-------------------------------------  `
	SAVE RECORD:C53([Job_Forms_Items:44])
	$recNo:=JIC_Create([Job_Forms_Items:44]Jobit:4)  //convert cost record to actual
	
	NEXT RECORD:C51([Job_Forms_Items:44])
End for 

[Job_Forms:42]AvgSellPrice:42:=JOB_SellingPrice
SAVE RECORD:C53([Job_Forms:42])
//-------------------------------------
RELATE MANY:C262([Job_Forms:42]JobFormID:5)
fCalcAlloc:=True:C214