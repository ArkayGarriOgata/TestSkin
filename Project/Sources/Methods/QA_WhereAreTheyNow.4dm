//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 04/11/06, 13:36:21
//mlb 04/17/06 combine xc with ex, since both represent failure, and add fx to fg
//mlb 5/11/06 add err msg is fg>glued, chg score to EX/glued
// ----------------------------------------------------
// Method: QA_WhereAreTheyNow
// Description
// replacment for report QA_MonthlySummaryA
// ----------------------------------------------------

//get a range of fg transactions
C_DATE:C307($1; $2; dDateEnd; dDateBegin)
C_TEXT:C284($3)
C_LONGINT:C283($i; $numFGX)
C_TEXT:C284($t; $cr)
C_TEXT:C284(xTitle; xText)
C_TIME:C306($docRef)

zwStatusMsg("QA SUM"; "QA Summary")

$t:=Char:C90(9)
$cr:=Char:C90(13)
xText:=""

MESSAGES OFF:C175
//*Find the transactions to report
REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)

If (Count parameters:C259>=2)
	dDateBegin:=$1
	dDateEnd:=$2
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Receipt")
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3>=dDateBegin; *)
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<=dDateEnd)
		If (Count parameters:C259=3)
			QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]CustID:12=$3)
		End if 
		
	Else 
		
		If (Count parameters:C259=3)
			QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]CustID:12=$3; *)
		End if 
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Receipt"; *)
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3>=dDateBegin; *)
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<=dDateEnd)
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	OK:=1
	$numFGX:=Records in selection:C76([Finished_Goods_Transactions:33])
Else 
	$numFGX:=qryByDateRange(->[Finished_Goods_Transactions:33]XactionDate:3; "Date Range of FG Receipts")
	QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Receipt")
	$numFGX:=Records in selection:C76([Finished_Goods_Transactions:33])
	If ($numFGX>-1)
		OK:=1
	Else 
		OK:=0
	End if 
End if   //params

If (OK=1)
	xTitle:="Quality Summary for Jobitems glued from "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1)+$cr
	
	ARRAY TEXT:C222($aJobit; 0)
	DISTINCT VALUES:C339([Finished_Goods_Transactions:33]Jobit:31; $aJobit)
	$ttl_produced:=0
	$ttl_scrapped:=0
	$ttl_good:=0
	$ttl_to_FG:=0
	$ttl_to_EX:=0
	$ttl_score:=0
	
	xText:="Customer"+$t+"Jobit"+$t+"ProductCode"+$t+"Qty_Wanted"+$t+"Qty_Glued"+$t+"Qty_Scrapped"+$t+"Qty_Stocked"+$t+"Qty_Shipped"+$t+"Adjustments"+$t+"To_FGorFX"+$t+"To_EXorXC"+$t+"Completed"+$t+"Closed"+$cr
	For ($jobit; 1; Size of array:C274($aJobit))
		SET QUERY LIMIT:C395(1)
		QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=(Num:C11(Substring:C12($aJobit{$jobit}; 1; 5))))
		SET QUERY LIMIT:C395(0)
		
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4=$aJobit{$jobit})
		
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Jobit:31=$aJobit{$jobit})
			CREATE SET:C116([Finished_Goods_Transactions:33]; "XforThisJobit")
			QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Receipt")
			$glued:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
			
			USE SET:C118("XforThisJobit")
			QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Scrap")
			QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ReasonNotes:28#"OBSOLETE")
			QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ReasonNotes:28#"EXCESS")
			$scrapped:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
			
			USE SET:C118("XforThisJobit")
			QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Ship")
			$shipped:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
			
			USE SET:C118("XforThisJobit")
			QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Adjust")
			$adjustments:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
			
			USE SET:C118("XforThisJobit")
			QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9="FG:@"; *)
			QUERY SELECTION:C341([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]Location:9="FX:@"; *)  //mlb 04/17/06
			QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & [Finished_Goods_Transactions:33]XactionType:2="Move"; *)
			QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]viaLocation:11="CC:@")
			$toFG:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
			
			USE SET:C118("XforThisJobit")
			QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9="EX:@"; *)
			QUERY SELECTION:C341([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]Location:9="XC:@"; *)  //mlb 04/17/06 combine xc with ex, since both represent failure
			QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Move"; *)
			QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]viaLocation:11="CC:@")
			$toEX:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
			
		Else 
			
			QUERY BY FORMULA:C48([Finished_Goods_Transactions:33]; \
				([Finished_Goods_Transactions:33]Jobit:31=$aJobit{$jobit})\
				 & ([Finished_Goods_Transactions:33]XactionType:2="Receipt")\
				)
			
			$glued:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
			
			QUERY BY FORMULA:C48([Finished_Goods_Transactions:33]; \
				([Finished_Goods_Transactions:33]Jobit:31=$aJobit{$jobit})\
				 & ([Finished_Goods_Transactions:33]XactionType:2="Scrap")\
				 & ([Finished_Goods_Transactions:33]ReasonNotes:28#"OBSOLETE")\
				 & ([Finished_Goods_Transactions:33]ReasonNotes:28#"EXCESS")\
				)
			
			$scrapped:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
			
			QUERY BY FORMULA:C48([Finished_Goods_Transactions:33]; \
				([Finished_Goods_Transactions:33]Jobit:31=$aJobit{$jobit})\
				 & ([Finished_Goods_Transactions:33]XactionType:2="Ship")\
				)
			
			
			$shipped:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
			
			QUERY BY FORMULA:C48([Finished_Goods_Transactions:33]; \
				([Finished_Goods_Transactions:33]Jobit:31=$aJobit{$jobit})\
				 & ([Finished_Goods_Transactions:33]XactionType:2="Adjust")\
				)
			
			
			$adjustments:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
			
			QUERY BY FORMULA:C48([Finished_Goods_Transactions:33]; \
				([Finished_Goods_Transactions:33]Jobit:31=$aJobit{$jobit})\
				 & (([Finished_Goods_Transactions:33]Location:9="FG:@") | ([Finished_Goods_Transactions:33]Location:9="FX:@"))\
				 & ([Finished_Goods_Transactions:33]XactionType:2="Move")\
				 & ([Finished_Goods_Transactions:33]viaLocation:11="CC:@")\
				)
			
			$toFG:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
			
			QUERY BY FORMULA:C48([Finished_Goods_Transactions:33]; \
				([Finished_Goods_Transactions:33]Jobit:31=$aJobit{$jobit})\
				 & (([Finished_Goods_Transactions:33]Location:9="EX:@") | ([Finished_Goods_Transactions:33]Location:9="XC:@"))\
				 & ([Finished_Goods_Transactions:33]XactionType:2="Move")\
				 & ([Finished_Goods_Transactions:33]viaLocation:11="CC:@")\
				)
			
			$toEX:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33=$aJobit{$jobit})
		$stocked:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
		
		xText:=xText+[Jobs:15]CustomerName:5+$t+$aJobit{$jobit}+$t+[Job_Forms_Items:44]ProductCode:3+$t+String:C10(Sum:C1([Job_Forms_Items:44]Qty_Want:24))+$t+String:C10($glued)+$t+String:C10($scrapped)+$t+String:C10($stocked)+$t+String:C10($shipped)+$t+String:C10($adjustments)+$t+String:C10($toFG)+$t+String:C10($toEX)+$t+String:C10([Job_Forms_Items:44]Completed:39; System date short:K1:1)+$t
		xText:=xText+(Num:C11([Job_Forms_Items:44]FormClosed:5)*"YES")
		If ($toFG>$glued)
			xText:=xText+" ERROR, LOOK FOR ADJUSTMENTS"
		End if 
		xText:=xText+$cr
		
		$ttl_produced:=$ttl_produced+$glued
		$ttl_scrapped:=$ttl_scrapped+$scrapped
		$ttl_to_FG:=$ttl_to_FG+$toFG
		$ttl_to_EX:=$ttl_to_EX+$toEX
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			CLEAR SET:C117("XforThisJobit")
			
			
		Else 
			
			
		End if   // END 4D Professional Services : January 2019 query selection
	End for 
	
	xText:=xText+(3*$cr)
	xText:=xText+"SUMMARY"+$cr
	xText:=xText+String:C10($ttl_produced)+$t+"Total Cartons Produced"+$cr
	xText:=xText+String:C10($ttl_scrapped)+$t+"Total Cartons Scrapped (not OBSOLETE or EXCESS)"+$cr
	xText:=xText+String:C10($ttl_produced-$ttl_scrapped)+$t+"Total Good"+$cr
	xText:=xText+String:C10($ttl_to_FG)+$t+"Total To FG from CC"+$cr
	xText:=xText+String:C10($ttl_to_EX)+$t+"Total To EX from CC"+$cr
	xText:=xText+String:C10(Round:C94($ttl_to_EX/$ttl_produced*100; 2))+$t+"QA Score for "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1)+$cr
	docName:="QA_MonthlySummary"+fYYMMDD(dDateEnd)
	$docRef:=util_putFileName(->docName)
	SEND PACKET:C103($docRef; xTitle+$cr+$cr)
	SEND PACKET:C103($docRef; xText)
	CLOSE DOCUMENT:C267($docRef)
	BEEP:C151
	// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
	$err:=util_Launch_External_App(docName)
	
	xText:=""
	
End if   //ok
zwStatusMsg("QA SUM"; "Monthly Summary A Fini")