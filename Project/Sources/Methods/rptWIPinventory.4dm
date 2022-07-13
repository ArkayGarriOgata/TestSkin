//%attributes = {"publishedWeb":true}
//rptWIPinventory(begin;end;jobform;CostCard;WipInv) 090298, see alsorWipinventory
//•090898  MLB  incorporate the Cost Card rpt
//•092398  MLB  add status of job
// • mel (5/12/05, 11:53:20) set startdate if missing, don't report if no startdate
// Modified by: Garri Ogata (9/23/21) added $tEmailTo
// Modified by: MelvinBohince (4/4/22) chg to CSV

C_DATE:C307($1; $2; beginDate; endDate; firstMatl; firstMach)
C_LONGINT:C283($i; $4; $5)
C_TEXT:C284($begin; $end; $3; $jobForm; $6; jobStartDateStr)
C_TEXT:C284($7; $tEmailTo)
C_TEXT:C284(sEffective)

C_TIME:C306($docRef; $CCdocRef)
C_BOOLEAN:C305(prnCostCard; $doWIPINV)
C_TEXT:C284($t; $cr; $savedCostCard)
C_TEXT:C284(xText)
C_BOOLEAN:C305($sublaunch)
ARRAY REAL:C219(arResult; 0)  //array to return component values

MESSAGES OFF:C175

$t:=","  //Char(9)  // Modified by: MelvinBohince (4/4/22) chg to CSV
$cr:=Char:C90(13)

xText:=""

sEffective:="00/00/00"

$sublaunch:=True:C214
$tEmailTo:=CorektBlank
//$wiPath:=uCreateFolder ("WIP_Inventory")

READ ONLY:C145([Jobs:15])
READ ONLY:C145([Job_Forms:42])
READ ONLY:C145([Job_Forms_Master_Schedule:67])
READ ONLY:C145([Job_Forms_Machines:43])
READ ONLY:C145([Job_Forms_Materials:55])
READ ONLY:C145([Job_Forms_Machine_Tickets:61])

If (Count parameters:C259=0)  //make requests
	$jobForm:=Request:C163("Enter jobform# or Cancel for dates"; "00000.00")
	If (OK=1) & ($jobForm#"00000.00") & (Length:C16($jobForm)=8)
		$begin:=""
		$end:=""
		beginDate:=!00-00-00!
		endDate:=!00-00-00!
		prnCostCard:=True:C214
		$doWIPINV:=False:C215
	Else 
		$jobForm:=""
		$begin:=Request:C163("Enter beginning date"; "mm/dd/yy")
		$end:=Request:C163("Enter ending date"; "mm/dd/yy")
		beginDate:=Date:C102($begin)
		endDate:=Date:C102($end)
		prnCostCard:=False:C215
		$doWIPINV:=True:C214
	End if 
	// sEffective:=Request("Enter Std effectivity date:";sEffective)
	
Else   //values passed in
	beginDate:=$1
	endDate:=$2
	$begin:=String:C10(beginDate; <>MIDDATE)
	$end:=String:C10(endDate; <>MIDDATE)
	$jobForm:=$3
	prnCostCard:=($4=1)
	$doWIPINV:=($5=1)
	OK:=1
	If (Count parameters:C259>=6)
		$sublaunch:=False:C215
	End if 
	If (Count parameters:C259>=7)
		$tEmailTo:=$7
	End if 
End if 

If ($doWIPINV)
	wipDoc:="WIPinv_"+Replace string:C233($end; "/"; "-")+"_"+String:C10(TSTimeStamp)+".csv"  // Modified by: MelvinBohince (4/4/22) chg to CSV
	$docRef:=util_putFileName(->wipDoc)
Else 
	$docRef:=?00:00:00?
	wipDoc:=""
End if 

If ($jobForm#"")  //by job
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$jobForm)
	If ($doWIPINV)
		uSendPacket($docRef; "WIP Inventory Report"+$cr+"   for JobFormID:"+$jobForm+$cr)
	End if 
Else   //by date range
	qryJobsInWIP(endDate)  //get jobs that were open in the period
	If ($doWIPINV)
		uSendPacket($docRef; "WIP Inventory Report"+$cr+"   from "+$begin+" to "+$end+"  by JobFormID"+$cr)
	End if 
End if 

ARRAY LONGINT:C221($_wip_jobs; 0)
If (prnCostCard)
	LONGINT ARRAY FROM SELECTION:C647([Job_Forms:42]; $_wip_jobs)  //size of $_wip_jobs is now the flag for cost cards
	prnCostCard:=False:C215  // don't want the called methods doing their extra thing in the first pass
End if 

If ($doWIPINV)
	uSendPacket($docRef; "   Printed: "+TS2String(TSTimeStamp)+$cr+$cr)
	uSendPacket($docRef; rCostCardHdrs(1))
End if 

ARRAY TEXT:C222($aJobForm; 0)
ARRAY DATE:C224($aJobStart; 0)
ARRAY DATE:C224($aJobCompleted; 0)
ARRAY REAL:C219($aWidth; 0)
ARRAY REAL:C219($aLength; 0)
ARRAY LONGINT:C221($aNumUp; 0)
ARRAY LONGINT:C221($aNetShts; 0)
ARRAY TEXT:C222($aJobStatus; 0)
SELECTION TO ARRAY:C260([Job_Forms:42]JobFormID:5; $aJobForm; [Job_Forms:42]StartDate:10; $aJobStart; [Job_Forms:42]Width:23; $aWidth; [Job_Forms:42]Lenth:24; $aLength; [Job_Forms:42]NumberUp:26; $aNumUp; [Job_Forms:42]EstNetSheets:28; $aNetShts; [Job_Forms:42]Status:6; $aJobStatus; [Job_Forms:42]Completed:18; $aJobCompleted; [Job_Forms:42]JobType:33; $aJobType)
SORT ARRAY:C229($aJobForm; $aJobStart; $aWidth; $aLength; $aNumUp; $aNetShts; $aJobStatus; $aJobCompleted; $aJobType; >)
CostCtrCurrent("init"; sEffective)

uThermoInit(Records in selection:C76([Job_Forms:42]); "Calc WIP INV")
MESSAGES OFF:C175
$totMatl:=0
$totLabor:=0
$totBurden:=0
$totCost:=0
$totBB:=0
$totEB:=0

//$tickMsg:=""

For ($i; 1; Size of array:C274($aJobForm))
	//$tickStart:=Tickcount
	$jobForm:=$aJobForm{$i}
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=$jobForm)
	If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
		$location:=[Job_Forms_Master_Schedule:67]LocationOfMfg:30
	Else 
		$location:="?"
	End if 
	
	jobStartDateStr:=String:C10($aJobStart{$i}; <>MIDDATE)
	firstMach:=!00-00-00!
	firstMatl:=!00-00-00!
	
	$completed:=String:C10($aJobCompleted{$i}; <>MIDDATE)
	QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=Num:C11(Substring:C12($jobForm; 1; 5)))
	$cust:=CUST_getName([Jobs:15]CustID:2; "elc")
	
	REDUCE SELECTION:C351([Jobs:15]; 0)
	
	$beginBal:=0
	$matl:=0  //doesn't included BB
	$ccMatl:=0  //all material, for cost card
	$labor:=0
	$cclabor:=0
	$burden:=0
	$ccburden:=0
	$toFG:=0
	$inWIP:=0
	$endBal:=0
	$variance:=0
	$HPV:=0
	$prodValue:=0
	$lastSeq:=""
	$priorFG:=0
	$HPV:=0
	$flag:=""
	
	//*Get the Job Items
	rptWIPjmi($jobForm; ->arResult)
	$HPV:=arResult{1}
	
	//*Get the MachTicks
	rptWIPmachHrs($jobForm; ->arResult; endDate)
	$beginBal:=$beginBal+arResult{1}
	$labor:=arResult{2}
	$burden:=arResult{3}
	$lastSeq:=String:C10(arResult{4}; "000")
	$cclabor:=arResult{5}
	$ccburden:=arResult{6}
	
	//*Get the Issues
	rptWIPmatl($jobForm; ->arResult; endDate)
	$ccMatl:=arResult{1}
	$beginBal:=$beginBal+arResult{2}
	$matl:=arResult{3}
	
	//*Get the FG transactions to relieve WIP
	rptWIPfgXfer($jobForm; ->arResult; endDate)
	$prodValue:=arResult{1}
	$priorFG:=arResult{2}
	$toFG:=arResult{3}
	
	$HPV:=$HPV-$prodValue  //what more can be xfer'ed out
	If ($HPV<0)
		$HPV:=0
	End if 
	
	$beginBal:=$beginBal-$priorFG
	$inWIP:=$matl+$labor+$burden
	$endBal:=($beginBal+$inWIP)-$toFG
	
	If ($endBal<0)
		$variance:=$endBal
		$endBal:=0
		$flag:="EB<0"
	End if 
	
	If ($endBal>0)  //what value is left in the job
		If ($HPV<$endBal)
			$variance:=$endBal-$HPV
			$endBal:=$HPV
			$flag:="HPV<EB"
		End if 
	End if 
	
	$beginBal:=Round:C94($beginBal; 0)
	$matl:=Round:C94($matl; 0)
	$labor:=Round:C94($labor; 0)
	$burden:=Round:C94($burden; 0)
	$ccmatl:=Round:C94($ccmatl; 0)
	$cclabor:=Round:C94($cclabor; 0)
	$ccburden:=Round:C94($ccburden; 0)
	$inWIP:=Round:C94($inWIP; 0)
	$toFG:=Round:C94($toFG; 0)
	$endBal:=Round:C94($endBal; 0)
	$variance:=Round:C94($variance; 0)
	$prodValue:=Round:C94($prodValue; 0)
	$priorFG:=Round:C94($priorFG; 0)
	$HPV:=Round:C94($HPV; 0)
	
	If (jobStartDateStr="00/00/00")  // • mel (5/12/05, 11:02:32) try to set start date if required
		If (firstMach=!00-00-00!) & (firstMatl=!00-00-00!)
			//didn't start
		Else 
			Case of 
				: (firstMach=!00-00-00!)
					jobStartDateStr:=String:C10(firstMatl; <>MIDDATE)
				: (firstMatl=!00-00-00!)
					jobStartDateStr:=String:C10(firstMach; <>MIDDATE)
				: (firstMatl<firstMach)
					jobStartDateStr:=String:C10(firstMatl; <>MIDDATE)
				Else 
					jobStartDateStr:=String:C10(firstMach; <>MIDDATE)
			End case 
		End if 
	End if 
	//*Write the WIP Inventory row to disk
	If ($doWIPINV) & (jobStartDateStr#"00/00/00")  //($endBal>0)|($variance#0)
		uSendPacket($docRef; $jobForm+$t+jobStartDateStr+$t+$lastSeq+$t)
		uSendPacket($docRef; String:C10($beginBal)+$t+String:C10($matl)+$t+String:C10($labor)+$t+String:C10($burden)+$t+String:C10($inWIP)+$t+String:C10($toFG)+$t+String:C10($endBal)+$t+String:C10($variance)+$t+$flag+$t+String:C10($prodValue)+$t+String:C10($priorFG)+$t+String:C10($HPV)+$t+$cust+$t+$aJobStatus{$i}+$t+$completed+$t+$aJobType{$i}+$t+$location+$cr)
		If (Length:C16(xText)>20000)
			SEND PACKET:C103($docRef; xText)
			xText:=""
		End if 
	End if 
	
	//*Accumulate totals
	$totMatl:=$totMatl+$matl
	$totLabor:=$totLabor+$labor
	$totBurden:=$totBurden+$burden
	$totBB:=$totBB+$beginBal
	$totEB:=$totEB+$endBal
	$HPV:=arResult{1}
	
	uThermoUpdate($i; 2)
End for 

//*Write Totals to disk
If ($doWIPINV)
	$totCost:=$totMatl+$totLabor+$totBurden
	uSendPacket($docRef; $cr+$cr+"Totals:"+$t+$t+$t+String:C10($totBB)+$t+String:C10($totMatl)+$t+String:C10($totLabor)+$t+String:C10($totBurden)+$t+String:C10($totCost)+$t+$t+String:C10($totEB)+$cr)
	$percentConv:=Round:C94((($totLabor+$totBurden)/$totCost)*100; 0)
	uSendPacket($docRef; $t+$t+$t+"% Conv"+$t+String:C10($percentConv)+$cr)
	SEND PACKET:C103($docRef; xText)
	CLOSE DOCUMENT:C267($docRef)
	
	If ($sublaunch)
		$err:=util_Launch_External_App(wipDoc)
	End if 
	
	If ($tEmailTo#CorektBlank)
		
		EMAIL_Sender("WIPinv_"+Replace string:C233($end; "/"; "-")+"_"+String:C10(TSTimeStamp); ""; "Copy attached"; $tEmailTo; wipDoc)
		
	End if 
	
End if 

// Modified by: Mel Bohince (12/21/17) 
If (Size of array:C274($_wip_jobs)>0)  //printing cost cards
	
	For ($job; 1; Size of array:C274($_wip_jobs); 1)
		GOTO RECORD:C242([Job_Forms:42]; $_wip_jobs{$job})
		$savedCostCard:=Job_WIP_CostCard([Job_Forms:42]JobFormID:5)
	End for 
	
End if 

xText:=""
//CostCtrCurrent ("kill")

uThermoClose
ARRAY TEXT:C222($aJobForm; 0)
ARRAY DATE:C224($aJobStart; 0)
qryJobComponent("kill"; 0)

BEEP:C151