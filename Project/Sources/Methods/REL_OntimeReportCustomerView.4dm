//%attributes = {"publishedWeb":true}
//PM: REL_OntimeReportCustomerView() -> 
//@author mlb - 2/6/03  12:31
//mlb 6/17/03 relax tolerance to 5 buz days for all customers
//based on:REL_OntimeReport({dDateBegin;dDateEnd;custid{;outputstyle;cc list}}) ->
//see also REL_shippedLateRpt 

C_DATE:C307($1; $2; dDateBegin; dDateEnd; $allowedEarly; $allowedLate)
C_TEXT:C284($3; sCust)
C_TEXT:C284(xTitle; xText; distributionList)
C_TEXT:C284($cr)
C_BOOLEAN:C305($continue)
C_LONGINT:C283($4; $outputStyle; $i; $numCust; $relCursor; $totalNumReleases; $totalNumOnTime; $hit; $percent; $dayOfWeek; $lateCursor)
ARRAY LONGINT:C221($aReleaseNumber; 0)
ARRAY LONGINT:C221($aLateRelease; 0)

READ ONLY:C145([Customers:16])
READ ONLY:C145([Customers_ReleaseSchedules:46])

$cr:=Char:C90(13)
$continue:=False:C215
$outputStyle:=0  //report, 1=dialog, 2=email
$lateCursor:=0

If (Count parameters:C259=0)
	//Open form window([CONTROL];"DateRange2";1)  `;"wCloseOption")
	dDateBegin:=!00-00-00!
	dDateEnd:=4D_Current_date  //-5
	DIALOG:C40([zz_control:1]; "DateRange2")
	If (OK=1)
		$continue:=True:C214
		If (bSearch=1)
			zwStatusMsg("ON TIME"; "Ad hoc")
			QUERY:C277([Customers_ReleaseSchedules:46])
		Else 
			zwStatusMsg("ON TIME"; "From "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1))
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Promise_Date:32>=dDateBegin; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<F@"; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Promise_Date:32<=dDateEnd)
		End if 
	End if 
	
Else 
	dDateBegin:=$1
	dDateEnd:=$2
	sCust:=$3
	zwStatusMsg("ON TIME"; "From "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1)+" for Customer Id= "+sCust)
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Promise_Date:32>=dDateBegin; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Promise_Date:32<=dDateEnd; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<F@"; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustID:12=sCust)
	$continue:=True:C214
	If (Count parameters:C259>3)
		$outputStyle:=$4
	End if 
End if 

If ($continue)
	If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
		ARRAY TEXT:C222($aEsteeCompany; 0)
		QUERY:C277([Customers:16]; [Customers:16]ParentCorp:19="Estée Lauder Companies")
		SELECTION TO ARRAY:C260([Customers:16]ID:1; $aEsteeCompany)
		REDUCE SELECTION:C351([Customers:16]; 0)
		
		DISTINCT VALUES:C339([Customers_ReleaseSchedules:46]CustID:12; $aCustomer)
		$numCust:=Size of array:C274($aCustomer)
		ARRAY TEXT:C222($aCustomerName; $numCust)
		ARRAY LONGINT:C221($aCustomerTotal; $numCust)
		ARRAY LONGINT:C221($aCustomerOntime; $numCust)
		
		SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]CustID:12; $aCust; [Customers_ReleaseSchedules:46]Promise_Date:32; $aDateSch; [Customers_ReleaseSchedules:46]Actual_Date:7; $aDateAct; [Customers_ReleaseSchedules:46]Sched_Qty:6; $aQtySch; [Customers_ReleaseSchedules:46]Actual_Qty:8; $aQtyAct; [Customers_ReleaseSchedules:46]ReleaseNumber:1; $aReleaseNumber)
		SORT ARRAY:C229($aCust; $aDateSch; $aDateAct; $aQtySch; $aQtyAct; $aReleaseNumber; >)
		$relCursor:=1
		$totalNumReleases:=Size of array:C274($aCust)
		$totalNumOnTime:=0
		ARRAY LONGINT:C221($aLateRelease; $totalNumReleases)
		
		For ($i; 1; $numCust)
			QUERY:C277([Customers:16]; [Customers:16]ID:1=$aCustomer{$i})
			$aCustomerName{$i}:=[Customers:16]Name:2
			$hit:=Find in array:C230($aCust; $aCustomer{$i}; $relCursor)
			
			While ($hit>-1)
				$aCustomerTotal{$i}:=$aCustomerTotal{$i}+1
				$relCursor:=$hit+1
				
				If ($aDateAct{$hit}#!00-00-00!)
					$dayOfWeek:=Day number:C114($aDateSch{$hit})
					Case of 
						: (False:C215) & (Find in array:C230($aEsteeCompany; $aCustomer{$i})>-1)  //• mlb - 1/30/03  14:17
							
							Case of 
								: ($dayOfWeek=Thursday:K10:16)
									$tolerance:=4
								: ($dayOfWeek=Friday:K10:17)
									$tolerance:=4
								: ($dayOfWeek=Saturday:K10:18)
									$tolerance:=3
								Else 
									$tolerance:=2
							End case 
							
							If ($aCustomerName{$i}[[1]]#"*")
								$aCustomerName{$i}:="*"+$aCustomerName{$i}
							End if 
							
							If ($aDateAct{$hit}<=($aDateSch{$hit}+$tolerance))
								$totalNumOnTime:=$totalNumOnTime+1
								$aCustomerOntime{$i}:=$aCustomerOntime{$i}+1
								
							End if 
							
						: (False:C215) & ($aCustomer{$i}="00045")  //special rules for Chanel
							Case of 
								: ($dayOfWeek=Wednesday:K10:15)
									$tolerance:=5
								: ($dayOfWeek=Thursday:K10:16)
									$tolerance:=5
								: ($dayOfWeek=Friday:K10:17)
									$tolerance:=5
								: ($dayOfWeek=Saturday:K10:18)
									$tolerance:=4
								Else 
									$tolerance:=3
							End case 
							
							Case of 
								: ($dayOfWeek=Monday:K10:13)
									$early:=6
								: ($dayOfWeek=Tuesday:K10:14)
									$early:=6
								: ($dayOfWeek=Wednesday:K10:15)
									$early:=6
								: ($dayOfWeek=Thursday:K10:16)
									$early:=6
								: ($dayOfWeek=Saturday:K10:18)
									$early:=5
								: ($dayOfWeek=Sunday:K10:19)
									$early:=6
								Else 
									$early:=4
							End case 
							
							If ($aCustomerName{$i}[[1]]#"*")
								$aCustomerName{$i}:="*"+$aCustomerName{$i}
							End if 
							
							If ($aQtyAct{$hit}>=$aQtySch{$hit})
								$allowedEarly:=$aDateSch{$hit}-$early
								$allowedLate:=$aDateSch{$hit}+$tolerance
								If ($aDateAct{$hit}>=$allowedEarly) & ($aDateAct{$hit}<=$allowedLate)
									$totalNumOnTime:=$totalNumOnTime+1
									$aCustomerOntime{$i}:=$aCustomerOntime{$i}+1
								End if 
							End if 
							//      *****
							
						Else   //***** default rule
							Case of 
								: ($dayOfWeek=Saturday:K10:18)
									$tolerance:=0  //6  `7
									
								: ($dayOfWeek=Sunday:K10:19)
									$tolerance:=0  //5  `6
									
								Else 
									$tolerance:=0  //7  `5
									
							End case 
							
							If ($aDateAct{$hit}<=($aDateSch{$hit}+$tolerance))
								//If ($aQtyAct{$hit}>=$aQtySch{$hit})
								
								$totalNumOnTime:=$totalNumOnTime+1
								$aCustomerOntime{$i}:=$aCustomerOntime{$i}+1
								//End if 
								
							Else 
								$lateCursor:=$lateCursor+1
								$aLateRelease{$lateCursor}:=$aReleaseNumber{$hit}
							End if 
					End case 
					
				Else 
					$lateCursor:=$lateCursor+1
					$aLateRelease{$lateCursor}:=$aReleaseNumber{$hit}
				End if   //not 00/00/00
				
				$hit:=Find in array:C230($aCust; $aCustomer{$i}; $relCursor)
			End while 
		End for 
		
		SORT ARRAY:C229($aCustomerName; $aCustomerOntime; $aCustomerTotal; $aCustomer; >)
		C_LONGINT:C283($days)
		$days:=dDateEnd-dDateBegin
		xTitle:="On Time (CUSTOMER VIEW) Period from "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1)
		xText:="PCT  "+txt_Pad("CUSTOMER"; " "; 1; 41)+" ("+"#OT"+" of "+"TOT"+")"+" "+"END_DATE"+$cr
		For ($i; 1; $numCust)
			$percent:=Round:C94($aCustomerOntime{$i}/$aCustomerTotal{$i}*100; 0)
			xText:=xText+txt_Pad(String:C10($percent; "##0%"); " "; -1; 4)+" "+txt_Pad($aCustomerName{$i}; " "; 1; 41)+" ("+txt_Pad(String:C10($aCustomerOntime{$i}; "##0"); " "; -1; 3)+" of "+txt_Pad(String:C10($aCustomerTotal{$i}; "##0"); " "; -1; 3)+")"+" "+String:C10(dDateEnd; System date short:K1:1)+$cr
			OnTime_setRecent($days; String:C10($percent; "##0%")+" ("+String:C10($aCustomerOntime{$i}; "##0")+"/"+String:C10($aCustomerTotal{$i}; "##0")+")"; $aCustomer{$i}; $aCustomerName{$i})
		End for 
		xText:=xText+$cr
		$percent:=Round:C94($totalNumOnTime/$totalNumReleases*100; 0)
		OnTime_setRecent($days; String:C10($percent; "^^0")+" ("+String:C10($totalNumOnTime; "^^0")+" of "+String:C10($totalNumReleases; "^^0")+")")
		xText:=xText+txt_Pad(String:C10($percent; "##0%"); " "; -1; 4)+" "+txt_Pad("Overall"; " "; 1; 41)+" ("+txt_Pad(String:C10($totalNumOnTime; "##0"); " "; -1; 3)+" of "+txt_Pad(String:C10($totalNumReleases; "##0"); " "; -1; 3)+")"+" "+String:C10(dDateEnd; System date short:K1:1)+$cr
		xText:=xText+$cr+$cr+$cr+"On-Time is defined as shipped on or before "
		xText:=xText+"the promised date."  // (plus grace period). Weekends are excluded from the 5day grace"
		
		Case of 
			: ($outputStyle=1)
				utl_LogIt("init")
				utl_LogIt(xTitle+$cr+$cr+xText; 0)
				utl_LogIt("show")
				utl_LogIt("init")
				
			: ($outputStyle=2)
				$distributionList:=$5
				QM_Sender(xTitle; ""; xText; $distributionList)
				
			: ($outputStyle=3)
				utl_LogIt("init")
				utl_LogIt(xTitle+$cr+$cr+xText; 0)
				utl_LogIt("show")
				utl_LogIt("init")
				ARRAY LONGINT:C221($aLateRelease; $lateCursor)
				READ WRITE:C146([Customers_ReleaseSchedules:46])
				QUERY WITH ARRAY:C644([Customers_ReleaseSchedules:46]ReleaseNumber:1; $aLateRelease)
				
			Else 
				rPrintText
		End case 
		
		xTitle:=""
		xText:=""
		
	Else 
		BEEP:C151
		zwStatusMsg(""; "No releases scheduled with that criterian.")
	End if 
	
End if 