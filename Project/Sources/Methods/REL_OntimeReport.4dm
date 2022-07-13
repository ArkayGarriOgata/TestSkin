//%attributes = {"publishedWeb":true}
//PM: REL_OntimeReport({dDateBegin;dDateEnd;custid{;outputstyle;cc list}}) -> 
//@author mlb - 8/2/01  15:31
//see also REL_OntimeReportCustomerView
//• mlb - 1/12/03  14:30 remove weekends
//• mlb - 1/30/03  14:29 put in estee lauder rule
// • mel (4/2/04, 11:55:39) put in a 5 biz day grace
// • mel (6/10/04, 09:38:39) put in a 3 day grace
// • mel (8/12/04, 12:39:56) put in a 0 day grace
// Modified by: Mel Bohince (3/26/15) html'ize the mailing


C_DATE:C307($1; $2; dDateBegin; dDateEnd; $allowedEarly; $allowedLate)
C_TEXT:C284($3; sCust)
C_TEXT:C284($subject; xText; distributionList; $distributionList)
C_LONGINT:C283($4; $outputStyle; $i; $numCust; $relCursor; $totalNumReleases; $totalNumOnTime; $hit; $percent; $early; $tolerance; $lateCursor; $days)
C_TEXT:C284($cr)
C_BOOLEAN:C305($continue)
ARRAY LONGINT:C221($aReleaseNumber; 0)
ARRAY LONGINT:C221($aLateRelease; 0)

READ ONLY:C145([Customers:16])
READ ONLY:C145([Customers_ReleaseSchedules:46])

$cr:=Char:C90(13)
$continue:=False:C215
$tolerance:=0  //was 5 bizness days
$outputStyle:=0  //report, 1=dialog, 2=email
$lateCursor:=0

If (Count parameters:C259=0)
	//Open form window([CONTROL];"DateRange2";1)  `;"wCloseOption")
	dDateBegin:=!00-00-00!
	dDateEnd:=4D_Current_date  //-3
	$distributionList:=Email_WhoAmI
	$outputStyle:=2
	DIALOG:C40([zz_control:1]; "DateRange2")
	If (OK=1)
		$continue:=True:C214
		If (bSearch=1)
			zwStatusMsg("ON TIME"; "Ad hoc")
			QUERY:C277([Customers_ReleaseSchedules:46])
		Else 
			zwStatusMsg("ON TIME"; "From "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1))
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5>=dDateBegin; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<F@"; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5<=dDateEnd)
		End if 
	End if 
	
Else 
	dDateBegin:=$1
	dDateEnd:=$2
	sCust:=$3
	zwStatusMsg("ON TIME"; "From "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1)+" for Customer Id= "+sCust)
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5>=dDateBegin; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5<=dDateEnd; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<F@"; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustID:12=sCust)
	$continue:=True:C214
	If (Count parameters:C259>3)
		$outputStyle:=$4
	End if 
	
	If (Count parameters:C259>4)
		$distributionList:=$5
	Else 
		$distributionList:=distributionList
	End if 
End if 

If ($continue)
	If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
		ARRAY TEXT:C222($aEsteeCompany; 0)
		//QUERY([CUSTOMER];[CUSTOMER]ParentCorp="Estée Lauder Companies")
		//SELECTION TO ARRAY([CUSTOMER]ID;$aEsteeCompany)
		//REDUCE SELECTION([CUSTOMER];0)
		
		DISTINCT VALUES:C339([Customers_ReleaseSchedules:46]CustID:12; $aCustomer)
		$numCust:=Size of array:C274($aCustomer)
		ARRAY TEXT:C222($aCustomerName; $numCust)
		ARRAY LONGINT:C221($aCustomerTotal; $numCust)
		ARRAY LONGINT:C221($aCustomerOntime; $numCust)
		
		SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]CustID:12; $aCust; [Customers_ReleaseSchedules:46]Sched_Date:5; $aDateSch; [Customers_ReleaseSchedules:46]Actual_Date:7; $aDateAct; [Customers_ReleaseSchedules:46]Sched_Qty:6; $aQtySch; [Customers_ReleaseSchedules:46]Actual_Qty:8; $aQtyAct; [Customers_ReleaseSchedules:46]ReleaseNumber:1; $aReleaseNumber)
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
						: (Find in array:C230($aEsteeCompany; $aCustomer{$i})>-1) & (False:C215)  //• mlb - 1/30/03  14:17
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
								//If ($aQtyAct{$hit}>=$aQtySch{$hit})
								$totalNumOnTime:=$totalNumOnTime+1
								$aCustomerOntime{$i}:=$aCustomerOntime{$i}+1
								//End if 
							End if 
							
							//      *****            
						: ($aCustomer{$i}="00045") & (False:C215)  //special rules for Chanel
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
								: (True:C214)  // • mel (6/10/04, 09:40:23) 08/12/04 zero tol
									$tolerance:=0  //3
								: ($dayOfWeek=Sunday:K10:19)
									$tolerance:=5
								: ($dayOfWeek=Saturday:K10:18)
									$tolerance:=6
								Else 
									$tolerance:=7  //to give 5 bizness days
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
		
		// ////
		// / BUILD THE TABLE 
		// ///
		//$platwhite:="background-color:#e5e4e2"  `too dark
		//
		//
		$tableData:=""
		$b:="<tr style=\"background-color:#fefcff\"> <td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
		$t:="</td><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
		$e:="</td></tr>"+$cr
		$tableData:=$tableData+$b+"PCT"+$t+"CUSTOMER"+$t+"#OT : TOT"+$e
		xText:="PCT  "+txt_Pad("CUSTOMER"; " "; 1; 41)+" ("+"#OT"+" of "+"TOT"+")"+" "+"END_DATE"+$cr
		
		$t:="</td><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"  //use heavier font weight
		$days:=dDateEnd-dDateBegin
		For ($i; 1; $numCust)
			If (($i%2)#0)  //alternate row color
				$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"  //start white $normwhite:="background-color:#ffffff"
			Else 
				$b:="<tr style=\"background-color:#fefcff\"><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"  //`milk white, slightly darker white $milkwhite:="background-color:#fefcff"
			End if 
			$percent:=Round:C94($aCustomerOntime{$i}/$aCustomerTotal{$i}*100; 0)
			$tableData:=$tableData+$b+String:C10($percent; "##0%")+$t+$aCustomerName{$i}+$t+String:C10($aCustomerOntime{$i}; "##,##0")+" : "+String:C10($aCustomerTotal{$i}; "##,##0")+$e
			xText:=xText+txt_Pad(String:C10($percent; "##0%"); " "; -1; 4)+" "+txt_Pad($aCustomerName{$i}; " "; 1; 41)+" ("+txt_Pad(String:C10($aCustomerOntime{$i}; "##,##0"); " "; -1; 3)+" of "+txt_Pad(String:C10($aCustomerTotal{$i}; "##,##0"); " "; -1; 3)+")"+" "+String:C10(dDateEnd; System date short:K1:1)+$cr
			OnTime_setRecent($days; String:C10($percent; "^^0%")+" ("+String:C10($aCustomerOntime{$i}; "^^0")+"/"+String:C10($aCustomerTotal{$i}; "^^0")+")"; $aCustomer{$i}; $aCustomerName{$i})
		End for 
		xText:=xText+$cr
		$percent:=Round:C94($totalNumOnTime/$totalNumReleases*100; 0)
		OnTime_setRecent($days; String:C10($percent; "^^0%")+" ("+String:C10($totalNumOnTime; "^^0")+"/"+String:C10($totalNumReleases; "^^0")+")")
		
		$b:="<tr style=\"background-color:#fff\"><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
		$t:="</td><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
		$tableData:=$tableData+$b+String:C10($percent; "##0%")+$t+"Overall"+$t+String:C10($totalNumOnTime; "##,##0")+" : "+String:C10($totalNumReleases; "##,##0")+$e
		
		xText:=xText+txt_Pad(String:C10($percent; "##0%"); " "; -1; 4)+" "+txt_Pad("Overall"; " "; 1; 41)+" ("+String:C10($totalNumOnTime; "##,##0")+" of "+String:C10($totalNumReleases; "##,##0")+")"+" "+String:C10(dDateEnd; System date short:K1:1)+$cr
		xText:=xText+$cr+$cr+$cr+"On-Time is defined as shipped on or before"+$cr
		xText:=xText+"the scheduled date."  //, plus a 3 day grace."  `plus 5 days, weekends excluded. "
		//" A '*' indicates customer specific rules; otherwise, "
		//Weekends are excluded from tolerence (2 days - EL,"+" +3/-4 days, not short - Chanel)
		$subject:="On Time Period from "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1)
		$prehead:=String:C10($percent)+"% On-time overall for the period from "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1)+". On-Time is defined as shipped on or before the scheduled date. "+String:C10($totalNumOnTime; "##,##0")+" out of "+String:C10($totalNumReleases; "##,##0")+" shipments made on time for the "+String:C10($days)+" day period."
		
		
		Case of 
			: ($outputStyle=1)  // | (True)
				utl_LogIt("init")
				utl_LogIt(xTitle+$cr+$cr+xText; 0)
				utl_LogIt("show")
				utl_LogIt("init")
				
			: ($outputStyle=2)
				//QM_Sender ($subject;"";xText;$distributionList)
				Email_html_table($subject; $prehead; $tableData; 550; $distributionList)
				
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
		zwStatusMsg(""; "No releases scheduled with that criterion.")
	End if 
	
End if 