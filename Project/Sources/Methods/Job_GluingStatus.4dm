//%attributes = {"publishedWeb":true}
//PM:  Job_GluingStatus  080302  mlb
//report current status of items being glued
//• mlb - 10/8/02  09:43 treat qty_act different if subforms
// • mel (10/29/03, 12:24:51) warn of excess on promos
// • mel (8/31/05, 11:23:26) search jmi based on completed date
// • mel (9/8/05, 15:56:29) only show excesses, not shortages
// • mel (9/24/05 column totals off and subforms skipped
// Modified by: Mel Bohince (9/16/16) use timestamp for query, add overrun, promo, surplus
// Modified by: Mel Bohince (9/19/16) add Last Price for the wheels, $lastPrice:=string(FG_getLastPrice(fgkey))

C_TIME:C306($docRef)
C_TEXT:C284($t; $cr)
C_LONGINT:C283($item; $numJMI; $totalWant; $totalNet; $totalGlued; $totalExam; $totalScrap; $qtyGlued; $qtyExam; $qtyScrap)
C_TEXT:C284($1; xTitle; xText; $lastPrice)
C_DATE:C307($dateEnd; $2)

$t:=Char:C90(9)
$cr:=Char:C90(13)

If (Count parameters:C259=0)
	$dateBegin:=!00-00-00!  //$2
	$dateEnd:=!00-00-00!  //$3
	QUERY:C277([Job_Forms_Items:44])
Else 
	$dateEnd:=4D_Current_date
	$dateBegin:=$dateEnd-1
	$beginTS:=TSTimeStamp($dateBegin; ?23:00:00?)
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]CompletedTimeStamp:56>$beginTS)  //$dateBegin;*)
End if 
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
	
	CREATE SET:C116([Job_Forms_Items:44]; "candidates")
	USE SET:C118("candidates")
	
Else 
	
	CREATE SET:C116([Job_Forms_Items:44]; "candidates")
	
End if   // END 4D Professional Services : January 2019 query selection

$numJMI:=Records in selection:C76([Job_Forms_Items:44])
If ($numJMI>0)
	DISTINCT VALUES:C339([Job_Forms_Items:44]Jobit:4; $aJobit)
	$numJMI:=Size of array:C274($aJobit)
	
	docName:="DailyJobItemStatus"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
	$docRef:=util_putFileName(->docName)
	If (Count parameters:C259#0)
		xTitle:="Jobits completed after "+TS2String($beginTS)+"; "+String:C10($numJMI)+" Jobits found completed"+$cr+$cr
		
		$body:="Attached is a listing of job items completed after "+TS2String($beginTS)+". "
		$body:=$body+" Open the attachment with Excel."
	Else 
		xTitle:="Job Item Status, Custom Query "+"; "+String:C10($numJMI)+" Jobits tested"+$cr+$cr
	End if 
	xText:="COMPLETED"+$t+"JOB_ITEM"+$t+"WANT"+$t+"NET"+$t+"EXCESS(SHORT)"+$t+"OVERRUN>5"+$t+"GLUED"+$t+"IN_CERT"+$t
	xText:=xText+"SCRAPPED"+$t+"IN_FG"+$t+"SHIPPED"+$t+"NEXT_REL"+$t+"NEXT_QTY"+$t+"TOTAL_RELS"+$t
	xText:=xText+"OTHER_FG"+$t+"SURPLUS(SHORT)"+$t+"PRODUCT_CODE"+$t+"DESCRIPTION"+$t+"CUSTOMER"+$t+"LINE"+$t+"LASTPRICE"+$cr
	$totalWant:=0
	$totalNet:=0
	$totalExcess:=0
	$totalGlued:=0
	$totalCert:=0
	$totalScrap:=0
	$totalInFG:=0
	$totalShip:=0
	$numberShort:=0
	$qtyShort:=0
	
	uThermoInit($numJMI; "Daily Glue Status")
	For ($item; 1; $numJMI)
		
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4=$aJobit{$item})
		$hits:=Records in selection:C76([Job_Forms_Items:44])  //qryJMI ($aJobit{$item})
		If ($hits>0)
			$qtyWant:=Sum:C1([Job_Forms_Items:44]Qty_Want:24)
		Else 
			$qtyWant:=0
		End if 
		uThermoUpdate($item)
		$qtyGlued:=JOB_CalcQtyGlued($aJobit{$item})  //same
		$qtyCC:=0
		$qtyFG:=0
		$qtyOH:=""
		$qtyScrap:=0
		$qtyNet:=0
		$qtyExcess:=0
		$qtyShipped:=0
		
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Jobit:31=$aJobit{$item}; *)
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Scrap")
		If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
			$qtyScrap:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
		End if 
		
		$qtyNet:=$qtyGlued-$qtyScrap
		$qtyExcess:=$qtyNet-$qtyWant
		$overrun:=Round:C94($qtyExcess/$qtyWant*100; 0)
		
		If (Abs:C99($overrun)<=5)
			$overrunStr:=""
		Else 
			$overrunStr:=String:C10($overrun)+"%"
		End if 
		
		If ($qtyExcess>0) | (Count parameters:C259=0) | (True:C214)  // • mel (9/8/05, 15:56:29)
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33=$aJobit{$item}; *)
			QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2="FG@")
			If (Records in selection:C76([Finished_Goods_Locations:35])>0)
				$qtyFG:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
			End if 
			
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="CC@"; *)
			QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="XC@"; *)
			QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="EX@"; *)
			QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Jobit:33=$aJobit{$item})
			If (Records in selection:C76([Finished_Goods_Locations:35])>0)
				$qtyCC:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
			End if 
			
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Job_Forms_Items:44]ProductCode:3; *)
			QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Jobit:33#$aJobit{$item})
			If (Records in selection:C76([Finished_Goods_Locations:35])>0)
				$qtyOH:=String:C10(Sum:C1([Finished_Goods_Locations:35]QtyOH:9))
			End if 
			
			QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Jobit:31=$aJobit{$item}; *)
			QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Ship")
			$qtyShipped:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
			
			$supply:=$qtyNet-$qtyShipped+Num:C11($qtyOH)
			
			$totalWant:=$totalWant+$qtyWant
			$totalNet:=$totalNet+$qtyNet
			$totalExcess:=$totalExcess+$qtyExcess
			$totalGlued:=$totalGlued+$qtyGlued
			$totalCert:=$totalCert+$qtyCC
			$totalScrap:=$totalScrap+$qtyScrap
			$totalInFG:=$totalInFG+$qtyFG
			$totalShip:=$totalShip+$qtyShipped
			
			If (False:C215)  //want forecast, don't care if coverered
				REL_getNextRelease
				JMI_get1stRelease
			End if 
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=[Job_Forms_Items:44]ProductCode:3; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5#!00-00-00!)
			
			If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)  //•070299  mlb  show sales value of release
				ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >)
				$relDate:=String:C10([Customers_ReleaseSchedules:46]Sched_Date:5; System date short:K1:1)
				$relQty:=String:C10([Customers_ReleaseSchedules:46]Sched_Qty:6)
				$totRel:=String:C10(Sum:C1([Customers_ReleaseSchedules:46]Sched_Qty:6))
			Else 
				$relDate:="N/F"
				$relQty:=""
				$totRel:=""
			End if 
			$surplus:=$supply-Num:C11($totRel)
			
			$hit:=qryFinishedGood([Job_Forms_Items:44]CustId:15; [Job_Forms_Items:44]ProductCode:3)
			xText:=xText+String:C10([Job_Forms_Items:44]Completed:39; System date short:K1:1)+$t+[Job_Forms_Items:44]Jobit:4+$t
			xText:=xText+String:C10($qtyWant)+$t+String:C10($qtyNet)+$t+String:C10($qtyExcess)+$t+$overrunStr+$t+String:C10($qtyGlued)+$t+String:C10($qtyCC)+$t
			$lastPrice:=String:C10(FG_getLastPrice([Finished_Goods:26]FG_KEY:47))
			If (Position:C15("promo"; [Finished_Goods:26]OrderType:59)>0)
				xText:=xText+String:C10($qtyScrap)+$t+String:C10($qtyFG)+$t+String:C10($qtyShipped)+$t+$relDate+$t+$relQty+$t+$totRel+$t+$qtyOH+$t+String:C10($surplus)+$t+"PROMO-"+[Job_Forms_Items:44]ProductCode:3+$t+[Finished_Goods:26]CartonDesc:3+$t+CUST_getName([Job_Forms_Items:44]CustId:15; "elc")+$t+[Finished_Goods:26]Line_Brand:15+$t+$lastPrice+$cr
			Else 
				xText:=xText+String:C10($qtyScrap)+$t+String:C10($qtyFG)+$t+String:C10($qtyShipped)+$t+$relDate+$t+$relQty+$t+$totRel+$t+$qtyOH+$t+String:C10($surplus)+$t+[Job_Forms_Items:44]ProductCode:3+$t+[Finished_Goods:26]CartonDesc:3+$t+CUST_getName([Job_Forms_Items:44]CustId:15; "elc")+$t+[Finished_Goods:26]Line_Brand:15+$t+$lastPrice+$cr
			End if 
			
		Else 
			If ($qtyExcess<0)
				$numberShort:=$numberShort+1
				$qtyShort:=$qtyShort+($qtyExcess*-1)
			End if 
		End if   //excess
		
	End for 
	xText:=xText+$cr+$t+"TOTALS"+$t+String:C10($totalWant)+$t+String:C10($totalNet)+$t+String:C10($totalExcess)+$t+$t+String:C10($totalGlued)+$t+String:C10($totalCert)+$t+String:C10($totalScrap)+$t+String:C10($totalInFG)+$t+String:C10($totalShip)+$cr
	
	uThermoClose
	SEND PACKET:C103($docRef; xTitle)
	SEND PACKET:C103($docRef; xText)
	CLOSE DOCUMENT:C267($docRef)
	
	
	If (Count parameters:C259=1)
		EMAIL_Sender("Daily Gluing Status"; ""; $body; distributionList; docName)
		util_deleteDocument(docName)
	Else 
		BEEP:C151
		ALERT:C41("The report has been save to the file named "+$cr+docName)
		$err:=util_Launch_External_App(docName)
	End if 
	xTitle:=""
	xText:=""
	
Else 
	BEEP:C151
End if 