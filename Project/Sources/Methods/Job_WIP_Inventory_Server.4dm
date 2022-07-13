//%attributes = {}

// Method: Job_WIP_Inventory_Server ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 04/21/14, 15:11:22
// ----------------------------------------------------
// Description
//   // based on pattern_ServerFileToClient
//  // called by Job_WIP_Inventory
// see also rptWIPinventory

// ----------------------------------------------------

// // // // // // // // // // // // // //
//server-side
// build a docName
C_TEXT:C284($1; $client_call_back; $docShortName; $2; docName; $3)
C_DATE:C307(endDate; $4; beginDate)


C_TEXT:C284($t; $r)
$t:=Char:C90(9)
$r:=Char:C90(13)
C_TEXT:C284(xText)
ARRAY REAL:C219(arResult; 0)  //array to return component values
C_BOOLEAN:C305(prnCostCard)  //not an option here
prnCostCard:=False:C215

READ ONLY:C145([Jobs:15])
READ ONLY:C145([Job_Forms:42])
READ ONLY:C145([Job_Forms_Items:44])
READ ONLY:C145([Job_Forms_Machines:43])
READ ONLY:C145([Job_Forms_Materials:55])
READ ONLY:C145([Job_Forms_Machine_Tickets:61])
READ ONLY:C145([Raw_Materials_Transactions:23])
READ ONLY:C145([Finished_Goods_Transactions:33])

If (Count parameters:C259=4)
	$client_call_back:=$1
	$methodNameOnClient:=$2
	docName:=$3  //************UNCOmMENT when used, just so patter can comple
	endDate:=$4
	
Else   //legacy running on client
	$client_call_back:=""
	$methodNameOnClient:=""
	docName:="WIPinv_"+fYYMMDD($today)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
	endDate:=Date:C102(Request:C163("Enter end date:"; String:C10(Current date:C33)))
End if 
beginDate:=UtilGetDate(endDate; "ThisMonth")  //!00/00/00!

$docShortName:=docName  //capture before path is prepended
C_TIME:C306($docRef)
$docRef:=util_putFileName(->docName)
C_BLOB:C604($blob)
SET BLOB SIZE:C606($blob; 0)
//
utl_Logfile("benchmark.log"; Current method name:C684+": "+$1+", "+$2+", "+$3+", "+String:C10($4; System date short:K1:1))

//
//then do your processing
//
//
xText:="WIP Inventory Report"+$r+"   ending on "+String:C10(endDate; Internal date short:K1:7)+"  by JobFormID "+$r+"   printed: "+TS2String(TSTimeStamp)+$r+$r
qryJobsInWIP(endDate)
If (Records in selection:C76([Job_Forms:42])>0)
	xText:=xText+"JOB FORM"+$t+"STARTED"+$t+"@SEQ"+$t+"BEG BAL"+$t+"MATL"+$t+"LABOR"+$t+"BURDEN"+$t+"MATL+CONV"+$t+"XFERS->FGs"+$t+"END BAL"+$t+"SPOIL(EXCESS)"+$t+"FLAG"+$t+"$PRODUCED"+$t+"$PRIOR FG"+$t+"$HPV"+$t+"Customer"+$t+"Status"+$t+"Completed"+$t+"JobType"+$t+"Location"+$r
	
	ARRAY TEXT:C222($aJobForm; 0)
	ARRAY DATE:C224($aJobStart; 0)
	ARRAY REAL:C219($aWidth; 0)
	ARRAY REAL:C219($aLength; 0)
	ARRAY LONGINT:C221($aNumUp; 0)
	ARRAY LONGINT:C221($aNetShts; 0)
	ARRAY TEXT:C222($aJobStatus; 0)
	ARRAY DATE:C224($aJobCompleted; 0)
	ARRAY TEXT:C222($aJobType; 0)
	SELECTION TO ARRAY:C260([Job_Forms:42]JobFormID:5; $aJobForm; [Job_Forms:42]StartDate:10; $aJobStart; [Job_Forms:42]Width:23; $aWidth; [Job_Forms:42]Lenth:24; $aLength; [Job_Forms:42]NumberUp:26; $aNumUp; [Job_Forms:42]EstNetSheets:28; $aNetShts; [Job_Forms:42]Status:6; $aJobStatus; [Job_Forms:42]Completed:18; $aJobCompleted; [Job_Forms:42]JobType:33; $aJobType)
	SORT ARRAY:C229($aJobForm; $aJobStart; $aWidth; $aLength; $aNumUp; $aNetShts; $aJobStatus; $aJobCompleted; $aJobType; >)
	CostCtrCurrent("init"; "00/00/0000")
	$totMatl:=0
	$totLabor:=0
	$totBurden:=0
	$totCost:=0
	$totBB:=0
	$totEB:=0
	
	For ($i; 1; Size of array:C274($aJobForm))
		//$tickStart:=Tickcount
		$jobForm:=$aJobForm{$i}
		$location:="Roanoke"
		
		jobStartDateStr:=String:C10($aJobStart{$i}; <>MIDDATE)
		firstMach:=!00-00-00!
		firstMatl:=!00-00-00!
		
		$completed:=String:C10($aJobCompleted{$i}; <>MIDDATE)
		QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=Num:C11(Substring:C12($jobForm; 1; 5)))
		$cust:=[Jobs:15]CustomerName:5
		
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
		If (jobStartDateStr#"00/00/00")
			xText:=xText+$jobForm+$t+jobStartDateStr+$t+$lastSeq+$t
			xText:=xText+String:C10($beginBal)+$t+String:C10($matl)+$t+String:C10($labor)+$t+String:C10($burden)+$t+String:C10($inWIP)+$t+String:C10($toFG)+$t+String:C10($endBal)+$t+String:C10($variance)+$t+$flag+$t+String:C10($prodValue)+$t+String:C10($priorFG)+$t+String:C10($HPV)+$t+$cust+$t+$aJobStatus{$i}+$t+$completed+$t+$aJobType{$i}+$t+$location+$r
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
		
		
	End for 
	
	$totCost:=$totMatl+$totLabor+$totBurden
	xText:=xText+$r+$r+"Totals:"+$t+$t+$t+String:C10($totBB)+$t+String:C10($totMatl)+$t+String:C10($totLabor)+$t+String:C10($totBurden)+$t+String:C10($totCost)+$t+$t+String:C10($totEB)+$r
	$percentConv:=Round:C94((($totLabor+$totBurden)/$totCost)*100; 0)
	xText:=xText+$t+$t+$t+"% Conv"+$t+String:C10($percentConv)+$r
	
Else 
	xText:=xText+"No forms found to be in production on that date"+$r
End if 

//save to doc
SEND PACKET:C103($docRef; xText)
SEND PACKET:C103($docRef; $r+$r+"------ END OF FILE ------")
CLOSE DOCUMENT:C267($docRef)

REDUCE SELECTION:C351([Jobs:15]; 0)
REDUCE SELECTION:C351([Job_Forms:42]; 0)
REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
REDUCE SELECTION:C351([Job_Forms_Materials:55]; 0)
REDUCE SELECTION:C351([Job_Forms_Machine_Tickets:61]; 0)
REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)

If (Count parameters:C259>0)  //$client_requesting:=clientRegistered_as
	//utl_Logfile ("benchmark.log";Current method name+": Sending "+docName+" to client0")
	DOCUMENT TO BLOB:C525(docName; $blob)
	//utl_Logfile ("benchmark.log";Current method name+": Sending "+docName+" to client1")
	DELETE DOCUMENT:C159(docName)  // no reason to leave it around
	
	EXECUTE ON CLIENT:C651($client_call_back; $methodNameOnClient; $docShortName; $blob)
	//utl_Logfile ("benchmark.log";Current method name+": Sending "+docName+" to client2")
	SET BLOB SIZE:C606($blob; 0)  //clean up
	//utl_Logfile ("benchmark.log";Current method name+": Sending "+docName+" to client3")
	
	
Else   //legacy running on client
	$err:=util_Launch_External_App(docName)
End if 
//end server-side