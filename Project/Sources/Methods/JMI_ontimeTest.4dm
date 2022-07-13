//%attributes = {}
// Method: JMI_ontimeTest () -> 
// ----------------------------------------------------
// by: mel: 08/16/04, 12:01:24
// ----------------------------------------------------
// Description:
// see if what was glued appears to be needed within a horizon
// ----------------------------------------------------

C_LONGINT:C283($numRecs; $i; $outputStyle)
C_TEXT:C284($1; $jf)
C_DATE:C307($2; $date; $horizon)

If (Count parameters:C259=0)
	$jf:="@"
	$date:=4D_Current_date
	$outputStyle:=2
Else 
	$jf:=$1
	$date:=$2
	If ($date>4D_Current_date)
		BEEP:C151
		ALERT:C41("Cant look at gluing in the future, using today instead.")
		$date:=4D_Current_date
	End if 
	$outputStyle:=1
End if 
$horizon:=Add to date:C393($date; 0; 0; 7)  //give a 1 week horizon

QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Glued:33=$date; *)
QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]JobForm:1=$jf)
$numRecs:=Records in selection:C76([Job_Forms_Items:44])

If ($numRecs>0)
	SELECTION TO ARRAY:C260([Job_Forms_Items:44]ProductCode:3; $aCPNmulti; [Job_Forms_Items:44]Qty_Actual:11; $aQtyMade; [Job_Forms_Items:44]MAD:37; $aMAD)
	SORT ARRAY:C229($aCPNmulti; $aQtyMade; $aMAD; >)
	DISTINCT VALUES:C339([Job_Forms_Items:44]ProductCode:3; $aCPN)
	$numRecs:=Size of array:C274($aCPN)
	ARRAY LONGINT:C221($aQtyThisWeek; $numRecs)
	ARRAY LONGINT:C221($aQtyLate; $numRecs)
	ARRAY LONGINT:C221($aQtyMfg; $numRecs)
	ARRAY TEXT:C222($aHRD; $numRecs)
	
	For ($i; 1; Size of array:C274($aCPNmulti))
		$hit:=Find in array:C230($aCPN; $aCPNmulti{$i})
		If ($hit>-1)
			$aQtyMfg{$hit}:=$aQtyMfg{$hit}+$aQtyMade{$i}
			If ($aMAD{$i}#!00-00-00!)
				$aHRD{$hit}:=String:C10($aMAD{$i}; System date short:K1:1)
			End if 
		End if 
	End for 
	
	C_BOOLEAN:C305($break)
	$break:=False:C215
	$totalDemand:=0
	$totalMfg:=0
	$totalCPN:=$numRecs
	$totalOT:=0
	uThermoInit($numRecs; "Checking Releases")
	For ($i; 1; $numRecs)
		If ($break)
			$i:=$i+$numRecs
		End if 
		$horizonsDemand:=0
		$shippedToday:=0
		$lateDemand:=0
		$shippedBefore:=0
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$aCPN{$i}; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<@"; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5<=$horizon; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5#!00-00-00!)
			CREATE SET:C116([Customers_ReleaseSchedules:46]; "demandZone")
			//look for what was already filled
			
			USE SET:C118("demandZone")
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7<$date; *)
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7#!00-00-00!)
			CREATE SET:C116([Customers_ReleaseSchedules:46]; "shippedBefore")
			DIFFERENCE:C122("demandZone"; "shippedBefore"; "demandZone")
			
			USE SET:C118("demandZone")
			If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
				$horizonsDemand:=Sum:C1([Customers_ReleaseSchedules:46]Sched_Qty:6)
			End if 
			
			USE SET:C118("demandZone")
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5<=$date; *)
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
			If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
				$lateDemand:=Sum:C1([Customers_ReleaseSchedules:46]Sched_Qty:6)
			End if 
			
			$totalDemand:=$totalDemand+$horizonsDemand
			$totalMfg:=$totalMfg+$aQtyMfg{$i}
			If (Length:C16($aHRD{$i})>0)  //if there was a date promised
				
				If ((Date:C102($aHRD{$i}))>=$date)
					$totalOT:=$totalOT+1
				End if 
			Else 
				$totalCPN:=$totalCPN-1
			End if 
			
			$aQtyThisWeek{$i}:=$horizonsDemand-$lateDemand
			$aQtyLate{$i}:=$lateDemand
			
			CLEAR SET:C117("demandZone")
			
		Else 
			
			
			
			QUERY BY FORMULA:C48([Customers_ReleaseSchedules:46]; \
				(\
				([Customers_ReleaseSchedules:46]ProductCode:11=$aCPN{$i})\
				 & ([Customers_ReleaseSchedules:46]CustomerRefer:3#"<@")\
				 & ([Customers_ReleaseSchedules:46]Sched_Date:5<=$horizon)\
				 & ([Customers_ReleaseSchedules:46]Sched_Date:5#!00-00-00!)\
				)\
				#\
				(\
				([Customers_ReleaseSchedules:46]Actual_Date:7<$date)\
				 & ([Customers_ReleaseSchedules:46]Actual_Date:7#!00-00-00!)\
				)\
				)
			
			If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
				$horizonsDemand:=Sum:C1([Customers_ReleaseSchedules:46]Sched_Qty:6)
			End if 
			
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5<=$date; *)
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
			If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
				$lateDemand:=Sum:C1([Customers_ReleaseSchedules:46]Sched_Qty:6)
			End if 
			
			$totalDemand:=$totalDemand+$horizonsDemand
			$totalMfg:=$totalMfg+$aQtyMfg{$i}
			If (Length:C16($aHRD{$i})>0)  //if there was a date promised
				
				If ((Date:C102($aHRD{$i}))>=$date)
					$totalOT:=$totalOT+1
				End if 
			Else 
				$totalCPN:=$totalCPN-1
			End if 
			
			$aQtyThisWeek{$i}:=$horizonsDemand-$lateDemand
			$aQtyLate{$i}:=$lateDemand
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		
		uThermoUpdate($i)
	End for 
	uThermoClose
	
	xText:=txt_Pad("Product_Code"; " "; 1; 21)+txt_Pad("Glued"; " "; -1; 10)+txt_Pad("RelsInWeek"; " "; -1; 12)+txt_Pad("RelsLate"; " "; -1; 10)+txt_Pad("Item_HRD"; " "; -1; 10)+<>CR
	For ($i; 1; $numRecs)
		xText:=xText+txt_Pad($aCPN{$i}; " "; 1; 21)+txt_Pad(String:C10($aQtyMfg{$i}); " "; -1; 10)+txt_Pad(String:C10($aQtyThisWeek{$i}); " "; -1; 12)+txt_Pad(String:C10($aQtyLate{$i}); " "; -1; 10)+txt_Pad($aHRD{$i}; " "; -1; 10)+<>CR
	End for 
	xText:=xText+<>CR
	If ($totalMfg>=$totalDemand) & ($totalMfg#0)
		xText:=xText+"Percentage of Make-To-Ship (demand/mfg): "+String:C10($totalDemand)+"/"+String:C10($totalMfg)+" = "+String:C10(Round:C94($totalDemand/$totalMfg*100; 0))+"%"+<>CR
	Else 
		xText:=xText+"Percentage of Make-To-Ship (mfg < demand): "+String:C10(100)+"%"+<>CR
	End if 
	xText:=xText+<>CR
	$totalMfg:=Round:C94($totalOT/$totalCPN*100; 0)
	xText:=xText+String:C10($totalMfg)+"% Glued on or before Item's HRD"+<>CR
	xText:=xText+<>CR
	xTitle:="Mfg'd Ontime for "+String:C10($date; System date short:K1:1)+" "+String:C10($totalMfg)+"%"
	
	Case of 
		: ($outputStyle=1)
			utl_LogIt("init")
			utl_LogIt(xTitle+<>CR+<>CR+xText; 0)
			utl_LogIt("show")
			utl_LogIt("init")
			
		: ($outputStyle=2)
			$distributionList:=distributionList
			//$distributionList:="mel.bohince@arkay.com"+Char(9)
			
			EMAIL_Sender(xTitle; ""; xText; $distributionList)
			
		Else 
			rPrintText
	End case 
	
	xTitle:=""
	xText:=""
	
End if 