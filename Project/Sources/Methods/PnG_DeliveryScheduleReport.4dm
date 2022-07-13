//%attributes = {}
// Method: PnG_DeliveryScheduleReport () -> 
// ----------------------------------------------------
// by: mel: 06/15/05, 13:45:32
// ----------------------------------------------------

C_LONGINT:C283($numElements; $i)
C_TEXT:C284($t; $cr)
C_TEXT:C284(xTitle; xText; docName)

If (Count parameters:C259>0)  //get selection
	ARRAY TEXT:C222(aCPN; 0)
	ARRAY TEXT:C222($relCPN; 0)
	
	QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]Custid:12=COMPARE_CUSTID)
	DISTINCT VALUES:C339([Finished_Goods_DeliveryForcasts:145]ProductCode:2; aCPN)
	$numElements:=Size of array:C274(aCPN)
	
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustID:12=COMPARE_CUSTID; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
	DISTINCT VALUES:C339([Customers_ReleaseSchedules:46]ProductCode:11; $relCPN)
	
	For ($i; 1; Size of array:C274($relCPN))
		If (Length:C16($relCPN{$i})>0)
			$hit:=Find in array:C230(aCPN; $relCPN{$i})
			If ($hit=-1)
				$numElements:=$numElements+1
				ARRAY TEXT:C222(aCPN; $numElements)
				aCPN{$numElements}:=$relCPN{$i}
			End if 
		End if 
	End for 
	SORT ARRAY:C229(aCPN; >)
End if 

$t:=Char:C90(9)
$cr:=Char:C90(13)
If (COMPARE_CUSTID="00199")
	xTitle:="P&G Delivery Schedule Comparison"
Else 
	xTitle:=COMPARE_CUSTID+" Delivery Schedule Comparison"
End if 

xText:="PRODUCT"+$t+"DEST"+$t+"THEIR_TOT"+$t+"OUR_TOT"+$t+"CHANGE"+$t+"THEIR_NUM"+$t+"OUR_NUM"+$t
xText:=xText+"SHIPPED_IN2"+$t+"ON_HAND"+$t+"WIP"+$t
xText:=xText+"THEIR_NEXT"+$t+"OUR_NEXT"+$t+"CASE_CNT"+$t+"SKID_CNT"+$cr

C_TIME:C306($docRef)
docName:="PnG_DelSch"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
$docRef:=util_putFileName(->docName)

If ($docRef#?00:00:00?)
	sCPN:=""
	PnP_DeliveryScheduleQry("sCPN")
	
	$numElements:=Size of array:C274(aCPN)
	
	uThermoInit($numElements; "Processing Array")
	For ($i; 1; $numElements)
		sCPN:=aCPN{$i}
		PnP_DeliveryScheduleQry(sCPN; 0)
		
		xText:=xText+sCPN+$t+[Finished_Goods:26]GSR:79+$t+String:C10(totalDemand)+$t+String:C10(iBB)+$t+String:C10(iiTotal1)+$t+String:C10(i1)+$t+String:C10(i2)+$t
		xText:=xText+String:C10(iiTotal2)+$t+String:C10(iiTotal3)+$t+String:C10(iiTotal4)+$t
		If (i1>0)
			xText:=xText+String:C10(aDateDue{1}; System date short:K1:1)+$t
		Else 
			xText:=xText+"no_date"+$t
		End if 
		If (i2>0)
			xText:=xText+String:C10(aDate{1}; System date short:K1:1)+$t
		Else 
			xText:=xText+"no_date"+$t
		End if 
		xText:=xText+String:C10(caseCount)+$t+String:C10(skidCount)+$cr
		uThermoUpdate($i)
	End for 
	SEND PACKET:C103($docRef; xText)
	uThermoClose
	
	CLOSE DOCUMENT:C267($docRef)
	BEEP:C151
	// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
	$err:=util_Launch_External_App(docName)
	
Else 
	BEEP:C151
End if 