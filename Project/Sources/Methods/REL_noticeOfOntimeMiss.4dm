//%attributes = {}
// Method: REL_noticeOfOntimeMiss (distributionlist;{date to check}) -> 
// ----------------------------------------------------
// by: mel: 01/06/04, 12:54:45
// • mel (4/2/04, 12:03:40)change to internal view using [ReleaseSchedule]Sched_Date
// • mel (6/10/04, 09:31:14) change to 3 day grace
// • mel (8/16/04, 18:19:02) zero tolerance
// ----------------------------------------------------
// Description:
//daily email warning of rels that will be defined as late
// ----------------------------------------------------

C_TEXT:C284($1)
C_LONGINT:C283($outputStyle; $i; $numCust; $relCursor; $totalNumReleases; $totalNumOnTime; $hit; $percent; $dayOfWeek; $goBack)
C_DATE:C307($2; dDateEnd)
C_TEXT:C284($cr)

$outputStyle:=2  //0=report, 1=dialog, 2=email
$cr:=Char:C90(13)

If (Count parameters:C259>=2)  //use the date provided
	dDateEnd:=$2
Else   //backup to the date that should have shipped by now
	dDateEnd:=4D_Current_date  //was -3  ` was 7
End if 

READ ONLY:C145([Customers:16])
READ ONLY:C145([Customers_ReleaseSchedules:46])
//QUERY([ReleaseSchedule];[ReleaseSchedule]Promise_Date=dDateEnd;*)

QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5=dDateEnd; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<@")

If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
	DISTINCT VALUES:C339([Customers_ReleaseSchedules:46]CustID:12; $aCustomer)
	$numCust:=Size of array:C274($aCustomer)
	ARRAY TEXT:C222($aCustomerName; $numCust)
	ARRAY LONGINT:C221($aCustomerTotal; $numCust)
	ARRAY LONGINT:C221($aCustomerOntime; $numCust)
	ARRAY LONGINT:C221($aCustomerINV; $numCust)
	
	SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]CustID:12; $aCust; [Customers_ReleaseSchedules:46]Sched_Date:5; $aDateSch; [Customers_ReleaseSchedules:46]Actual_Date:7; $aDateAct; [Customers_ReleaseSchedules:46]Sched_Qty:6; $aQtySch; [Customers_ReleaseSchedules:46]Actual_Qty:8; $aQtyAct; [Customers_ReleaseSchedules:46]THC_State:39; $aTHC)
	SORT ARRAY:C229($aCust; $aDateSch; $aDateAct; $aQtySch; $aQtyAct; >)
	$relCursor:=1
	$totalNumReleases:=Size of array:C274($aCust)
	$totalNumOnTime:=0
	
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
					: (False:C215)  //& (Find in array($aEsteeCompany;$aCustomer{$i})>-1)  `• mlb - 1/30/03  14:17       
					: (False:C215)  //& ($aCustomer{$i}="00045")  `special rules for Chanel
					Else   //***** default rule
						
						Case of 
							: (True:C214)  // • mel (6/10/04, 09:34:59)
								// • mel (8/16/04, 18:19:02) zero tolerance
								$tolerance:=0  //3
								
							: ($dayOfWeek=Saturday:K10:18)
								$tolerance:=6
							: ($dayOfWeek=Sunday:K10:19)
								$tolerance:=5
							Else 
								$tolerance:=7
						End case 
						
						If ($aDateAct{$hit}<=($aDateSch{$hit}+$tolerance))
							$totalNumOnTime:=$totalNumOnTime+1
							$aCustomerOntime{$i}:=$aCustomerOntime{$i}+1
						Else 
							If ($aTHC{$hit}=0)  //had inventory
								$aCustomerINV{$i}:=$aCustomerINV{$i}+1
							End if 
						End if 
				End case 
			End if   //not shipped, therefore late
			
			$hit:=Find in array:C230($aCust; $aCustomer{$i}; $relCursor)
		End while 
	End for 
	
	SORT ARRAY:C229($aCustomerName; $aCustomerOntime; $aCustomerTotal; $aCustomer; >)
	
	xTitle:="On Time Notice for Rels on "+String:C10(dDateEnd; System date short:K1:1)
	xText:="PCT  "+txt_Pad("CUSTOMER"; " "; 1; 41)+" ("+"#OT"+" of "+"TOT"+")"+" "+"HAD_INVENTORY"+$cr
	For ($i; 1; $numCust)
		$percent:=Round:C94($aCustomerOntime{$i}/$aCustomerTotal{$i}*100; 0)
		xText:=xText+txt_Pad(String:C10($percent; "##0%"); " "; -1; 4)+" "+txt_Pad($aCustomerName{$i}; " "; 1; 41)+" ("+txt_Pad(String:C10($aCustomerOntime{$i}; "##0"); " "; -1; 3)+" of "+txt_Pad(String:C10($aCustomerTotal{$i}; "##0"); " "; -1; 3)+")"+"   "+String:C10($aCustomerINV{$i})+$cr
	End for 
	xText:=xText+$cr
	
	$percent:=Round:C94($totalNumOnTime/$totalNumReleases*100; 0)
	xText:=xText+txt_Pad(String:C10($percent; "##0%"); " "; -1; 4)+" "+txt_Pad("Overall"; " "; 1; 41)+" ("+txt_Pad(String:C10($totalNumOnTime; "##0"); " "; -1; 3)+" of "+txt_Pad(String:C10($totalNumReleases; "##0"); " "; -1; 3)+")"+" "+$cr  //String(dDateEnd;Short )+
	xText:=xText+$cr+$cr+$cr+"On-Time is defined as shipped on or before "
	xText:=xText+"the scheduled date."  // (plus 3 day grace period)."  `Weekends are excluded from the 5 d"+"ay grac"+"e"
	
	Case of 
		: ($outputStyle=1)
			utl_LogIt("init")
			utl_LogIt(xTitle+$cr+$cr+xText; 0)
			utl_LogIt("show")
			utl_LogIt("init")
			
		: ($outputStyle=2)
			$distributionList:=$1
			//$distributionList:="mel.bohince@arkay.com"+Char(9)
			EMAIL_Sender(xTitle; ""; xText; $distributionList)
			
		Else 
			rPrintText
	End case 
	
	xTitle:=""
	xText:=""
	
Else 
	BEEP:C151
	zwStatusMsg(""; "No releases scheduled with that criterian.")
End if   //some promised releases on that date

REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
REDUCE SELECTION:C351([Customers:16]; 0)