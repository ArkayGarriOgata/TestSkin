//%attributes = {"publishedWeb":true}
//PM:  JobCloseOut3rdPage  1/24/00  mlb
//item detail info to accomply job close out

C_TEXT:C284($1)  //jobform
C_TIME:C306($2)

util_PAGE_SETUP(->[zz_control:1]; "BigTextAt75")

If (Count parameters:C259=1)
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$1)
	RELATE ONE:C42([Job_Forms:42]JobNo:2)
	qryJMI($1+"@")
	PRINT SETTINGS:C106
Else 
	OK:=1
End if 

If (OK=1)
	PDF_setUp(" jobclose3rd"+[Job_Forms:42]JobFormID:5+".pdf")
	C_TEXT:C284(tText; $header)
	tText:=""  //this is the printed variable
	C_TEXT:C284($t; $cr)
	$t:="  "
	$cr:=Char:C90(13)
	C_LONGINT:C283($lineCounter; $maxLines; $item; $numItems; $qtyWant; $qtyAct; $qtyExc; $page)
	C_REAL:C285($allocationPct; r1)
	$maxLines:=75
	$page:=1
	$header:="JobItem Closeout Details for JobForm: "+[Job_Forms:42]JobFormID:5+" Customer: "+[Jobs:15]CustID:2+"  "+[Jobs:15]CustomerName:5+"  Line: "+[Jobs:15]Line:3
	$header:=$header+"  Nº Sheets(gross): "+String:C10([Job_Forms:42]EstGrossSheets:27; "###,###,###")+"  WxL: "+String:C10([Job_Forms:42]Width:23)+" x "+String:C10([Job_Forms:42]Lenth:24)
	$header:=$header+(" "*1)+" Printed: "+TS2String(TSTimeStamp)+"   Page: "
	
	tText:=$header+String:C10($page)+$cr
	tText:=tText+"ITM"+$t
	tText:=tText+"#UP"+$t
	tText:=tText+"SQ IN"+$t
	tText:=tText+"ALLO%"+$t
	tText:=tText+" WANT QTY"+$t
	tText:=tText+" GOOD QTY"+$t
	tText:=tText+"QTY VAR"+$t
	tText:=tText+"EXCSS QTY"+$t
	tText:=tText+"PLD MATL"+$t
	tText:=tText+"PLD LABR"+$t
	tText:=tText+"PLD V OH"+$t
	tText:=tText+"PLD TOTL"+$t
	tText:=tText+"ACT MATL"+$t
	tText:=tText+"ACT LABR"+$t
	tText:=tText+"ACT V OH"+$t
	tText:=tText+"ACT TOTL"+$t
	tText:=tText+"ORDER PEG "+$t
	tText:=tText+"SELLING$"+$t
	tText:=tText+"CUST PRODUCT CODE   "+$t
	tText:=tText+$cr
	$lineCounter:=2
	
	ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]ItemNumber:7; >)
	$numItems:=Records in selection:C76([Job_Forms_Items:44])
	$allocationPct:=0
	$qtyWant:=0
	$qtyAct:=0
	$qtyExc:=0
	$plnMatl:=0
	$plnLabor:=0
	$plnBurden:=0
	$plnTotal:=0
	
	$actMatl:=0
	$actLabor:=0
	$actBurden:=0
	$actTotal:=0
	
	$revTotal:=0
	
	For ($item; 1; $numItems)
		$lineCounter:=$lineCounter+1
		If ($lineCounter>$maxLines)
			If (Count parameters:C259=2)  //(docRef # †00:00:00†)
				SEND PACKET:C103($2; tText)
			Else 
				Print form:C5([zz_control:1]; "BigTextAt75")
				PAGE BREAK:C6(>)
			End if 
			$page:=$page+1
			tText:=$header+String:C10($page)+$cr
			$lineCounter:=1
			tText:=""
		End if 
		
		$allocationPct:=$allocationPct+[Job_Forms_Items:44]AllocationPercent:23
		$qtyWant:=$qtyWant+[Job_Forms_Items:44]Qty_Want:24
		$plnMatl:=$plnMatl+([Job_Forms_Items:44]PldCostMatl:17*[Job_Forms_Items:44]Qty_Want:24/1000)
		$plnLabor:=$plnLabor+([Job_Forms_Items:44]PldCostLab:18*[Job_Forms_Items:44]Qty_Want:24/1000)
		$plnBurden:=$plnBurden+([Job_Forms_Items:44]PldCostOvhd:19*[Job_Forms_Items:44]Qty_Want:24/1000)
		$plnTotal:=$plnTotal+([Job_Forms_Items:44]PldCostTotal:21*[Job_Forms_Items:44]Qty_Want:24/1000)
		//TRACE
		If ([Job_Forms_Items:44]Qty_Good:10>[Job_Forms_Items:44]Qty_Want:24)
			$qtyExc:=$qtyExc+([Job_Forms_Items:44]Qty_Good:10-[Job_Forms_Items:44]Qty_Want:24)
			$qtyAct:=$qtyAct+[Job_Forms_Items:44]Qty_Want:24
			$actMatl:=$actMatl+([Job_Forms_Items:44]Cost_Mat:12*[Job_Forms_Items:44]Qty_Want:24/1000)
			$actLabor:=$actLabor+([Job_Forms_Items:44]Cost_LAB:13*[Job_Forms_Items:44]Qty_Want:24/1000)
			$actBurden:=$actBurden+([Job_Forms_Items:44]Cost_Burd:14*[Job_Forms_Items:44]Qty_Want:24/1000)
			$actTotal:=$actTotal+([Job_Forms_Items:44]ActCost_M:27*[Job_Forms_Items:44]Qty_Want:24/1000)
		Else 
			$qtyExc:=$qtyExc+0
			$qtyAct:=$qtyAct+[Job_Forms_Items:44]Qty_Good:10
			$actMatl:=$actMatl+([Job_Forms_Items:44]Cost_Mat:12*[Job_Forms_Items:44]Qty_Good:10/1000)
			$actLabor:=$actLabor+([Job_Forms_Items:44]Cost_LAB:13*[Job_Forms_Items:44]Qty_Good:10/1000)
			$actBurden:=$actBurden+([Job_Forms_Items:44]Cost_Burd:14*[Job_Forms_Items:44]Qty_Good:10/1000)
			$actTotal:=$actTotal+([Job_Forms_Items:44]ActCost_M:27*[Job_Forms_Items:44]Qty_Good:10/1000)
		End if 
		
		tText:=tText+txt_Format(->[Job_Forms_Items:44]ItemNumber:7; "Right"; 3; "00")+$t
		tText:=tText+txt_Format(->[Job_Forms_Items:44]NumberUp:8; "Right"; 3; "###")+$t
		tText:=tText+txt_Format(->[Job_Forms_Items:44]SqInches:22; "Right"; 5; "##0.0")+$t
		tText:=tText+txt_Format(->[Job_Forms_Items:44]AllocationPercent:23; "Right"; 5; "##0.0")+$t
		tText:=tText+txt_Format(->[Job_Forms_Items:44]Qty_Want:24; "Right"; 9)+$t
		tText:=tText+txt_Format(->[Job_Forms_Items:44]Qty_Good:10; "Right"; 9)+$t
		r1:=Round:C94((([Job_Forms_Items:44]Qty_Good:10-[Job_Forms_Items:44]Qty_Want:24)/[Job_Forms_Items:44]Qty_Want:24)*100; 0)
		tText:=tText+txt_Format(->r1; "Right"; 7; "####0%")+$t
		If ([Job_Forms_Items:44]Qty_Good:10>[Job_Forms_Items:44]Qty_Want:24)
			r1:=[Job_Forms_Items:44]Qty_Good:10-[Job_Forms_Items:44]Qty_Want:24
		Else 
			r1:=0
		End if 
		tText:=tText+txt_Format(->r1; "Right"; 9)+$t
		tText:=tText+txt_Format(->[Job_Forms_Items:44]PldCostMatl:17; "Right"; 8; "####0.00")+$t
		tText:=tText+txt_Format(->[Job_Forms_Items:44]PldCostLab:18; "Right"; 8; "####0.00")+$t
		tText:=tText+txt_Format(->[Job_Forms_Items:44]PldCostOvhd:19; "Right"; 8; "####0.00")+$t
		tText:=tText+txt_Format(->[Job_Forms_Items:44]PldCostTotal:21; "Right"; 8; "####0.00")+$t
		tText:=tText+txt_Format(->[Job_Forms_Items:44]Cost_Mat:12; "Right"; 8; "####0.00")+$t
		tText:=tText+txt_Format(->[Job_Forms_Items:44]Cost_LAB:13; "Right"; 8; "####0.00")+$t
		tText:=tText+txt_Format(->[Job_Forms_Items:44]Cost_Burd:14; "Right"; 8; "####0.00")+$t
		tText:=tText+txt_Format(->[Job_Forms_Items:44]ActCost_M:27; "Right"; 8; "####0.00")+$t
		tText:=tText+txt_Format(->[Job_Forms_Items:44]OrderItem:2; "Left"; 9)
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=[Job_Forms_Items:44]OrderItem:2)
		If (Records in selection:C76([Customers_Order_Lines:41])>0)
			If ([Customers_Order_Lines:41]Quantity:6#[Job_Forms_Items:44]Qty_Want:24)
				tText:=tText+"†"+$t
				If ([Customers_Order_Lines:41]Quantity:6>[Job_Forms_Items:44]Qty_Want:24)
					$revTotal:=$revTotal+([Job_Forms_Items:44]SellPrice_M:25*[Job_Forms_Items:44]Qty_Want:24/1000)
				Else 
					$revTotal:=$revTotal+([Job_Forms_Items:44]SellPrice_M:25*[Customers_Order_Lines:41]Quantity:6/1000)
				End if 
			Else 
				tText:=tText+" "+$t
				$revTotal:=$revTotal+([Job_Forms_Items:44]SellPrice_M:25*[Job_Forms_Items:44]Qty_Want:24/1000)
			End if 
			
		Else 
			If (Substring:C12([Job_Forms_Items:44]OrderItem:2; 1; 2)="DF")  //assume want qty is golden
				tText:=tText+"∂"+$t
				$revTotal:=$revTotal+([Job_Forms_Items:44]SellPrice_M:25*[Job_Forms_Items:44]Qty_Want:24/1000)
			Else 
				tText:=tText+"x"+$t
				$revTotal:=$revTotal+([Job_Forms_Items:44]SellPrice_M:25*[Job_Forms_Items:44]Qty_Want:24/1000)
			End if 
		End if 
		tText:=tText+txt_Format(->[Job_Forms_Items:44]SellPrice_M:25; "Right"; 8; "####0.00")+$t
		tText:=tText+txt_Format(->[Job_Forms_Items:44]ProductCode:3; "Left"; 20)+$t
		tText:=tText+$cr
		If (Length:C16(tText)>20000)
			If (Count parameters:C259=2)  //(docRef # †00:00:00†)
				SEND PACKET:C103($2; tText)
			Else 
				Print form:C5([zz_control:1]; "BigTextAt75")
				PAGE BREAK:C6(>)
			End if 
			$page:=$page+1
			tText:=$header+String:C10($page)+$cr
			$lineCounter:=2
		End if 
		
		NEXT RECORD:C51([Job_Forms_Items:44])
	End for 
	
	tText:=tText+"TOTALS:"+$t
	tText:=tText+(" "*6)+$t
	r1:=$allocationPct
	tText:=tText+txt_Format(->r1; "Right"; 5; "##0.0")+$t
	r1:=$qtyWant
	tText:=tText+txt_Format(->r1; "Right"; 9)+$t
	r1:=$qtyAct
	tText:=tText+txt_Format(->r1; "Right"; 9)+$t
	r1:=Round:C94((($qtyAct-$qtyWant)/$qtyWant)*100; 0)
	tText:=tText+txt_Format(->r1; "Right"; 7; "####0%")+$t
	r1:=$qtyExc
	tText:=tText+txt_Format(->r1; "Right"; 9)+$t
	
	r1:=Round:C94(($plnMatl/$plnTotal)*100; 1)
	tText:=tText+txt_Format(->r1; "Right"; 8; "###0.0%")+$t
	r1:=Round:C94(($plnLabor/$plnTotal)*100; 1)
	tText:=tText+txt_Format(->r1; "Right"; 8; "###0.0%")+$t
	r1:=Round:C94(($plnBurden/$plnTotal)*100; 1)
	tText:=tText+txt_Format(->r1; "Right"; 8; "###0.0%")+$t
	r1:=$plnTotal
	tText:=tText+txt_Format(->r1; "Right"; 8; "#######0")+$t
	
	r1:=Round:C94(($actMatl/$actTotal)*100; 1)
	tText:=tText+txt_Format(->r1; "Right"; 8; "###0.0%")+$t
	r1:=Round:C94(($actLabor/$actTotal)*100; 1)
	tText:=tText+txt_Format(->r1; "Right"; 8; "###0.0%")+$t
	r1:=Round:C94(($actBurden/$actTotal)*100; 1)
	tText:=tText+txt_Format(->r1; "Right"; 8; "###0.0%")+$t
	r1:=Round:C94($actTotal; 0)
	tText:=tText+txt_Format(->r1; "Right"; 8; "#######0")+$t
	
	tText:=tText+"          "+$t
	
	r1:=Round:C94($revTotal; 0)
	tText:=tText+txt_Format(->r1; "Right"; 8; "#######0")+$t
	
	tText:=tText+$cr+(" "*100)+"Backtest:"+$cr
	tText:=tText+(" "*106)+"[JobForm]ActFormCost = "
	tText:=tText+txt_Format(->[Job_Forms:42]ActFormCost:13; "Right"; 15; "##,###,##0")+$t
	tText:=tText+$cr
	tText:=tText+(" "*106)+"[JobForm]ActCost/M   = "
	tText:=tText+txt_Format(->[Job_Forms:42]ActCost_M:41; "Right"; 15; "##,###,##0.00")+$t
	tText:=tText+$cr
	tText:=tText+(" "*106)+"[JobForm]AvgPrice/M  = "
	tText:=tText+txt_Format(->[Job_Forms:42]AvgSellPrice:42; "Right"; 15; "##,###,##0.00")+$t
	
	tText:=tText+$cr+$cr
	tText:=tText+"† Order line's quantity does not match job"+" item's want quantity.  Avg. Sell"+"/M uses former if less than the want."+$cr
	tText:=tText+$cr
	If (Count parameters:C259=2)  //(docRef # †00:00:00†)
		SEND PACKET:C103($2; tText)
	Else 
		Print form:C5([zz_control:1]; "BigTextAt75")
		PAGE BREAK:C6
	End if 
	
	FIRST RECORD:C50([Job_Forms_Items:44])
	tText:=""
End if 