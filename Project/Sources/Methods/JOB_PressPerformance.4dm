//%attributes = {}
// -------
// Method: JOB_PressPerformance ( ) ->
// By: Mel Bohince @ 09/27/16, 16:17:25
// Description
// only report on printing sequences, must run JOB_ProdPerformance first, hopefully this will become obsolete
// since JOB_ProdPerformance includes these sequences
// ----------------------------------------------------
// Modified by: Mel Bohince (1/25/17) add DT categories
// Modified by: Mel Bohince (10/9/20) remove , from string format arg so csv isn't complicated

C_TEXT:C284($r)
C_LONGINT:C283($i; $numElements; $1; $2)

READ ONLY:C145([Job_Forms_Machine_Tickets:61])
READ ONLY:C145([Job_Forms:42])
READ ONLY:C145([Job_Forms_Machines:43])
READ ONLY:C145([Finished_Goods:26])


utl_Logfile("PressPerf.Log"; "PRINTING: Started...")

//If (Current user="Designer")  //doing some tracing on past date
//$wait_date:=!08/23/2016!
//End if 

//query will use the Machtick's timestamp, find the interval:
If (Count parameters:C259>1)
	$from:=$1
	$to:=$2
Else 
	$from:=TSTimeStamp(!2017-01-18!)
	$to:=TSTimeStamp(!2017-01-19!)
End if 

//machine ticks marked as completed during interval:
QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]TimeStampEntered:17>$from; *)
QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]TimeStampEntered:17<=$to; *)
QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]P_C:10="C"; *)
QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]JobForm:1#"020@")  //plant downtime considered separtely

//only interested in printing:
$press_ids:=txt_Trim(<>PRESSES)  //load all presses in an array for a build query below
$cnt_of_presses:=Num:C11(util_TextParser(16; $press_ids; Character code:C91(" "); 13))

QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2=util_TextParser(1); *)
For ($press; 2; $cnt_of_presses)
	QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61];  | ; [Job_Forms_Machine_Tickets:61]CostCenterID:2=util_TextParser($press); *)
End for 
QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61])


//Here are the completed press sequences:
SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]JobFormSeq:16; $aCompletedSequences)

//now make the report
QUERY WITH ARRAY:C644([Job_Forms_Machines:43]JobSequence:8; $aCompletedSequences)

$body:="<p>Details attached, summary below:</p>  <dl>"

If (Records in selection:C76([Job_Forms_Machines:43])>0)
	
	ORDER BY:C49([Job_Forms_Machines:43]; [Job_Forms_Machines:43]CostCenterID:4; >; [Job_Forms_Machines:43]JobSequence:8; >)
	$t:=","
	$r:="\r"
	//$dateString:=String($dateMeasured;Internal date short special)
	$cc:=""
	$text:=""
	$totalSheets:=0  // Modified by: Mel Bohince (9/1/16) 
	$totalSheetsCC:=0  // Modified by: Mel Bohince (9/1/16) 
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
		
		While (Not:C34(End selection:C36([Job_Forms_Machines:43])))  //these are the machine seqs that were rolled up above
			
			If ([Job_Forms_Machines:43]CostCenterID:4#$cc)  //starting the next press
				$body:=$body+"<dt>"+[Job_Forms_Machines:43]CostCenterID:4+"</dt>"
				
				If (Length:C16($cc)>0)
					$text:=$text+$cc+" TOTAL"+("\t"*12)+String:C10($totalSheetsCC; "######0")+$r+$r
				End if 
				$totalSheetsCC:=0
				$cc:=[Job_Forms_Machines:43]CostCenterID:4
				
				//see if plant charged downtime occurred on this machine in this time period
				QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobFormSeq:16="020@"; *)  //dt charged to the plant
				QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]TimeStampEntered:17>$from; *)
				QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]TimeStampEntered:17<=$to; *)
				QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]CostCenterID:2=[Job_Forms_Machines:43]CostCenterID:4; *)
				QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]Comment:25#"")
				If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
					$dt:=Sum:C1([Job_Forms_Machine_Tickets:61]DownHrs:11)
					$hours:=Time:C179(Time string:C180($dt*60*60))
					$timeStringShort:="   "+String:C10($hours; HH MM:K7:2)+" U"
					SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]Comment:25; $aComments; [Job_Forms_Machine_Tickets:61]DownHrsCat:12; $aCategory)
					$categories:=util_textFromArray_implode(->$aCategory; " // ")
					$comments:=util_textFromArray_implode(->$aComments; " // ")
					DISTINCT VALUES:C339([Job_Forms_Machine_Tickets:61]Operator:27; $aOperators)
					$operators:=util_textFromArray_implode(->$aOperators; "/")
					$text:=$text+[Job_Forms_Machines:43]CostCenterID:4+$t+$operators+$t+"Arkay"+$t+"Factory"+$t+"Downtime"+$t+$timeStringShort+(8*($t+"0"))+String:C10($dt; "##0.00")+$t+$categories+"-->"+$comments+$r
				End if 
				
			End if   //starting next press
			
			QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=[Job_Forms_Machines:43]JobForm:1)
			$cust:=CUST_getName([Job_Forms:42]cust_id:82; "elc")
			$line:=[Job_Forms:42]CustomerLine:62
			
			$ttl_bud:=Round:C94([Job_Forms_Machines:43]Planned_MR_Hrs:15+[Job_Forms_Machines:43]Planned_RunHrs:37; 2)
			$ttl_act:=Round:C94([Job_Forms_Machines:43]Actual_MR_Hrs:24+[Job_Forms_Machines:43]Actual_RunHrs:40+[Job_Forms_Machines:43]Downtime:21; 2)
			$ttl_var:=Round:C94($ttl_bud-$ttl_act; 2)
			$hours:=Time:C179(Time string:C180(Abs:C99($ttl_var)*60*60))
			
			$timeString:=String:C10($hours; Hour min:K7:4)
			$timeStringShort:=String:C10($hours; HH MM:K7:2)
			If ($ttl_var>=0)
				$timeStringShort:="   "+$timeStringShort+" F"
				$varString:=" Favorable"
			Else 
				$timeStringShort:="   "+$timeStringShort+" U"
				$varString:=" Unfavorable"
			End if 
			
			
			$sheetVar:=[Job_Forms_Machines:43]Planned_Qty:10-[Job_Forms_Machines:43]Actual_Qty:19
			$totalSheetsCC:=$totalSheetsCC+[Job_Forms_Machines:43]Actual_Qty:19
			$totalSheets:=$totalSheets+[Job_Forms_Machines:43]Actual_Qty:19
			Case of 
				: ($sheetVar<0)
					$qtyVarString:=String:C10(Abs:C99($sheetVar); "##,##0")+" E"
					$qtyString:=String:C10(Abs:C99($sheetVar); "##,##0")+" Excess sheets "
				: ($sheetVar>0)
					$qtyVarString:=String:C10(Abs:C99($sheetVar); "##,##0")+" S"
					$qtyString:=String:C10(Abs:C99($sheetVar); "##,##0")+" Sheets short "
				Else 
					$qtyVarString:=String:C10(Abs:C99($sheetVar); "##,##0")+"  "
					$qtyString:=""
			End case 
			
			$body:=$body+"<dd>"+[Job_Forms_Machines:43]JobSequence:8+" for "+$cust+"/"+$line  //+" time variance was "+$timeString+$varString+$qtyString+", effective run rate was "+string([Job_Forms_Machines]Actual_RunRate)+"<br />"+"<br />"
			$body:=$body+"<ul>"
			$body:=$body+"<li>"+$timeString+$varString+"</li>"
			If (Length:C16($qtyString)>0)
				$body:=$body+"<li>"+$qtyString+"</li>"
			End if 
			$body:=$body+"<li>"+String:C10([Job_Forms_Machines:43]Actual_RunRate:39)+" effective runrate"+"</li>"
			$body:=$body+"</ul>"
			$body:=$body+"</dd>"
			
			//$text:=$text+[Job_Forms_Machines]CostCenterID+$t+[Job_Forms_Machines]Operators+$t+$dateString+$t+$cust+$t+$line+$t+[Job_Forms_Machines]JobSequence+$t+$timeStringShort+$t+String($ttl_bud;"#,##0.00")+$t+String($ttl_act;"#,##0.00")
			//$text:=$text+$t+String([Job_Forms_Machines]Planned_MR_Hrs-[Job_Forms_Machines]Actual_MR_Hrs;"##,##0.00")+$t+String([Job_Forms_Machines]Planned_MR_Hrs;"##,##0.00")+$t+String([Job_Forms_Machines]Actual_MR_Hrs;"##,##0.00")
			//$text:=$text+$t+String([Job_Forms_Machines]Planned_RunHrs-[Job_Forms_Machines]Actual_RunHrs;"##,##0.00")+$t+String([Job_Forms_Machines]Planned_RunHrs;"##,##0.00")+$t+String([Job_Forms_Machines]Actual_RunHrs;"##,##0.00")
			//$text:=$text+$t+String([Job_Forms_Machines]Actual_RunRate-[Job_Forms_Machines]Planned_RunRate;"##,##0")+$t+String([Job_Forms_Machines]Planned_RunRate;"##,##0")+$t+String([Job_Forms_Machines]Actual_RunRate;"##,##0")
			//$text:=$text+$t+String([Job_Forms_Machines]Actual_Qty-[Job_Forms_Machines]Planned_Qty;"#,###,##0")+$t+String([Job_Forms_Machines]Planned_Qty;"#,###,##0")+$t+String([Job_Forms_Machines]Actual_Qty;"#,###,##0")+$t+String([Job_Forms_Machines]Downtime;"##0.00")
			
			$text:=$text+[Job_Forms_Machines:43]CostCenterID:4+$t+[Job_Forms_Machines:43]Operators:9+$t+$cust+$t+$line+$t+[Job_Forms_Machines:43]JobSequence:8+$t+$timeStringShort+$t+String:C10($ttl_bud; "###0.00")+$t+String:C10($ttl_act; "###0.00")
			$text:=$text+$t+String:C10([Job_Forms_Machines:43]Planned_MR_Hrs:15; "####0.00")+$t+String:C10([Job_Forms_Machines:43]Actual_MR_Hrs:24; "####0.00")
			$text:=$text+$t+String:C10([Job_Forms_Machines:43]Planned_RunHrs:37; "####0.00")+$t+String:C10([Job_Forms_Machines:43]Actual_RunHrs:40; "####0.00")
			$text:=$text+$t+String:C10([Job_Forms_Machines:43]Actual_Qty:19; "######0")+$t+String:C10([Job_Forms_Machines:43]Downtime:21; "##0.00")
			
			
			If ([Job_Forms_Machines:43]Downtime:21>0)  //look for comments
				QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobFormSeq:16=[Job_Forms_Machines:43]JobSequence:8; *)
				QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]Comment:25#"")
				SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]Comment:25; $aComments; [Job_Forms_Machine_Tickets:61]DownHrsCat:12; $aCategory)
				$categories:=util_textFromArray_implode(->$aCategory; " // ")
				$comments:=util_textFromArray_implode(->$aComments; " // ")
				$text:=$text+(1*$t)+$categories+"-->"+$comments+$r
			Else 
				$text:=$text+$r
			End if 
			
			NEXT RECORD:C51([Job_Forms_Machines:43])
		End while 
		
	Else 
		
		SELECTION TO ARRAY:C260([Job_Forms_Machines:43]CostCenterID:4; $_CostCenterID; \
			[Job_Forms_Machines:43]JobForm:1; $_JobForm; \
			[Job_Forms_Machines:43]Planned_MR_Hrs:15; $_Planned_MR_Hrs; \
			[Job_Forms_Machines:43]Planned_RunHrs:37; $_Planned_RunHrs; \
			[Job_Forms_Machines:43]Actual_MR_Hrs:24; $_Actual_MR_Hrs; \
			[Job_Forms_Machines:43]Actual_RunHrs:40; $_Actual_RunHrs; \
			[Job_Forms_Machines:43]Actual_RunRate:39; $_Actual_RunRate; \
			[Job_Forms_Machines:43]Downtime:21; $_Downtime; \
			[Job_Forms_Machines:43]Planned_Qty:10; $_Planned_Qty; \
			[Job_Forms_Machines:43]Actual_Qty:19; $_Actual_Qty; \
			[Job_Forms_Machines:43]JobSequence:8; $_JobSequence; \
			[Job_Forms_Machines:43]Operators:9; $_Operators)
		
		$i:=1
		$n:=Size of array:C274($_Operators)+1
		While ($i<$n)  //these are the machine seqs that were rolled up above
			
			If ($_CostCenterID{$i}#$cc)  //starting the next press
				$body:=$body+"<dt>"+$_CostCenterID{$i}+"</dt>"
				
				If (Length:C16($cc)>0)
					$text:=$text+$cc+" TOTAL"+("\t"*12)+String:C10($totalSheetsCC; "######0")+$r+$r
				End if 
				$totalSheetsCC:=0
				$cc:=$_CostCenterID{$i}
				
				//see if plant charged downtime occurred on this machine in this time period
				QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobFormSeq:16="020@"; *)  //dt charged to the plant
				QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]TimeStampEntered:17>$from; *)
				QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]TimeStampEntered:17<=$to; *)
				QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]CostCenterID:2=$_CostCenterID{$i}; *)
				QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]Comment:25#"")
				If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
					$dt:=Sum:C1([Job_Forms_Machine_Tickets:61]DownHrs:11)
					$hours:=Time:C179(Time string:C180($dt*60*60))
					$timeStringShort:="   "+String:C10($hours; HH MM:K7:2)+" U"
					SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]Comment:25; $aComments; [Job_Forms_Machine_Tickets:61]DownHrsCat:12; $aCategory)
					$categories:=util_textFromArray_implode(->$aCategory; " // ")
					$comments:=util_textFromArray_implode(->$aComments; " // ")
					DISTINCT VALUES:C339([Job_Forms_Machine_Tickets:61]Operator:27; $aOperators)
					$operators:=util_textFromArray_implode(->$aOperators; "/")
					$text:=$text+$_CostCenterID{$i}+$t+$operators+$t+"Arkay"+$t+"Factory"+$t+"Downtime"+$t+$timeStringShort+(8*($t+"0"))+String:C10($dt; "##0.00")+$t+$categories+"-->"+$comments+$r
				End if 
				
			End if   //starting next press
			
			QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$_JobForm{$i})
			$cust:=CUST_getName([Job_Forms:42]cust_id:82; "elc")
			$line:=[Job_Forms:42]CustomerLine:62
			
			$ttl_bud:=Round:C94($_Planned_MR_Hrs{$i}+$_Planned_RunHrs{$i}; 2)
			$ttl_act:=Round:C94($_Actual_MR_Hrs{$i}+$_Actual_RunHrs{$i}+$_Downtime{$i}; 2)
			$ttl_var:=Round:C94($ttl_bud-$ttl_act; 2)
			$hours:=Time:C179(Time string:C180(Abs:C99($ttl_var)*60*60))
			
			$timeString:=String:C10($hours; Hour min:K7:4)
			$timeStringShort:=String:C10($hours; HH MM:K7:2)
			If ($ttl_var>=0)
				$timeStringShort:="   "+$timeStringShort+" F"
				$varString:=" Favorable"
			Else 
				$timeStringShort:="   "+$timeStringShort+" U"
				$varString:=" Unfavorable"
			End if 
			
			
			$sheetVar:=$_Planned_Qty{$i}-$_Actual_Qty{$i}
			$totalSheetsCC:=$totalSheetsCC+$_Actual_Qty{$i}
			$totalSheets:=$totalSheets+$_Actual_Qty{$i}
			Case of 
				: ($sheetVar<0)
					$qtyVarString:=String:C10(Abs:C99($sheetVar); "##,##0")+" E"
					$qtyString:=String:C10(Abs:C99($sheetVar); "##,##0")+" Excess sheets "
				: ($sheetVar>0)
					$qtyVarString:=String:C10(Abs:C99($sheetVar); "##,##0")+" S"
					$qtyString:=String:C10(Abs:C99($sheetVar); "##,##0")+" Sheets short "
				Else 
					$qtyVarString:=String:C10(Abs:C99($sheetVar); "##,##0")+"  "
					$qtyString:=""
			End case 
			
			$body:=$body+"<dd>"+$_JobSequence{$i}+" for "+$cust+"/"+$line  //+" time variance was "+$timeString+$varString+$qtyString+", effective run rate was "+string([Job_Forms_Machines]Actual_RunRate)+"<br />"+"<br />"
			$body:=$body+"<ul>"
			$body:=$body+"<li>"+$timeString+$varString+"</li>"
			If (Length:C16($qtyString)>0)
				$body:=$body+"<li>"+$qtyString+"</li>"
			End if 
			$body:=$body+"<li>"+String:C10($_Actual_RunRate{$i})+" effective runrate"+"</li>"
			$body:=$body+"</ul>"
			$body:=$body+"</dd>"
			$text:=$text+$_CostCenterID{$i}+$t+$_Operators{$i}+$t+$cust+$t+$line+$t+$_JobSequence{$i}+$t+$timeStringShort+$t+String:C10($ttl_bud; "###0.00")+$t+String:C10($ttl_act; "###0.00")
			$text:=$text+$t+String:C10($_Planned_MR_Hrs{$i}; "####0.00")+$t+String:C10($_Actual_MR_Hrs{$i}; "####0.00")
			$text:=$text+$t+String:C10($_Planned_RunHrs{$i}; "####0.00")+$t+String:C10($_Actual_RunHrs{$i}; "####0.00")
			$text:=$text+$t+String:C10($_Actual_Qty{$i}; "######0")+$t+String:C10($_Downtime{$i}; "##0.00")
			
			
			If ($_Downtime{$i}>0)  //look for comments
				QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobFormSeq:16=$_JobSequence{$i}; *)
				QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]Comment:25#"")
				SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]Comment:25; $aComments; [Job_Forms_Machine_Tickets:61]DownHrsCat:12; $aCategory)
				$categories:=util_textFromArray_implode(->$aCategory; " // ")
				$comments:=util_textFromArray_implode(->$aComments; " // ")
				$text:=$text+(1*$t)+$categories+"-->"+$comments+$r
			Else 
				$text:=$text+$r
			End if 
			
			$i:=$i+1
			
		End while 
		
	End if   // END 4D Professional Services : January 2019 
	
	$text:=$text+$cc+" TOTAL"+("\t"*12)+String:C10($totalSheetsCC; "######0")+$r+$r
	$text:=$text+"REPORT TOTAL"+("\t"*12)+String:C10($totalSheets; "######0")+$r
	$body:=$body+"</dl>"
	
	C_TEXT:C284($title; $text; $docName)
	C_TIME:C306($docRef)
	$subject:="Press Performance "+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")
	$title:=$subject
	//If (Length($text)>0)
	//$headings:="PRESS"+$t+"OPERATOR"+$t+"DATE"+$t+"CUSTOMER"+$t+"LINE"+$t+"JOB SEQUENCE"+$t+"TTL TIME VAR"+$t+"TTL BUD"+$t+"TTL ACT"
	//$headings:=$headings+$t+"MR VAR"+$t+"BUD MR"+$t+"ACT MR"
	//$headings:=$headings+$t+"RUN VAR"+$t+"BUD RUN"+$t+"ACT RUN"
	//$headings:=$headings+$t+"RATE VAR"+$t+"BUD RATE"+$t+"ACT RATE"
	//$headings:=$headings+$t+"SHEET VAR"+$t+"BUD SHEET"+$t+"ACT SHEET"
	//$headings:=$headings+$t+"DOWNTIME"+$t+"COMMENTS"+$r
	//$text:=$headings+$text
	//End if 
	
	If (Length:C16($text)>0)
		$headings:="PRESS"+$t+"OPERATOR"+$t+"CUSTOMER"+$t+"LINE"+$t+"JOB SEQUENCE"+$t+"VARIANCE"+$t+"HRS BUD"+$t+"HRS ACT"
		$headings:=$headings+$t+"BUD MR"+$t+"ACT MR"
		$headings:=$headings+$t+"BUD RUN"+$t+"ACT RUN"
		$headings:=$headings+$t+"SHEETS"
		$headings:=$headings+$t+"DT"+$t+"COMMENTS"+$r
		$text:=$headings+$text
	End if 
	$docName:="Press_Perf_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
	$subject:="Press Performance "+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")
	$docRef:=util_putFileName(->$docName)
	
	If ($docRef#?00:00:00?)
		SEND PACKET:C103($docRef; $title+"\r\r")
		
		If (Length:C16($text)>25000)
			SEND PACKET:C103($docRef; $text)
			$text:=""
		End if 
		
		SEND PACKET:C103($docRef; $text)
		SEND PACKET:C103($docRef; "\r\r------ END OF FILE ------")
		CLOSE DOCUMENT:C267($docRef)
		
		//$err:=util_Launch_External_App ($docName)
	End if 
	
	$preheader:="Budget vs. Actual for printing sequences completed in the past 24 hours."
	
	$distributionList:=Batch_GetDistributionList("PressPerf")
	//$distributionList:="jill.cook@arkay.com"+$t+"mel.bohince@arkay.com"+$t+"paul.Ladino@arkay.com"+$t
	
	//Email_html_body ($subject;$preheader;$body;500;$distributionList;$docName)//far too confusing to mgmt to summarize data
	
	EMAIL_Sender($subject; ""; "Open attached with Excel"; $distributionList; $docName)
	util_deleteDocument($docName)
	
	REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
	REDUCE SELECTION:C351([Job_Forms_Machine_Tickets:61]; 0)
	REDUCE SELECTION:C351([Job_Forms:42]; 0)
	
	
End if   //something to report








