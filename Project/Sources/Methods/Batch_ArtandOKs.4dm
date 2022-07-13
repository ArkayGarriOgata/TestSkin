//%attributes = {"publishedWeb":true}
//Procedure: Batch_ArtandOks()  012298  MLB
//Keep uptodate with the final art and Ok dates in the JobMasterLog
//•020398  MLB  compare Dropdead date to MAD instead of Want
//•030598  MLB  fix the no change scenario and dropdead date
//•061798  MLB  replace Lena with Charlie
// • mel (8/25/04, 14:36:35) set complet if all items are complete
// • mel (5/26/05, 09:36:19) change the emails
// Modified by: Mel Bohince (6/5/15) only send missed closing once per week
C_TEXT:C284($t; $cr)
C_LONGINT:C283($i; $numRecs; $before; $after; server_pid)
C_BOOLEAN:C305($break)
C_TEXT:C284(xTitle; xText)
C_DATE:C307($dropDead; $warningDate; $1)

$t:=Char:C90(9)
$cr:=Char:C90(13)
If (Count parameters:C259=1)
	$dropDead:=$1+(7*3)  //3 week lead on art
Else 
	$dropDead:=Current date:C33+(7*3)  //3 week lead on art
End if 
READ WRITE:C146([Job_Forms_Master_Schedule:67])

server_pid:=0
C_BOOLEAN:C305(serverMethodDone_local)
serverMethodDone_local:=False:C215  //reset by server

server_pid:=Execute on server:C373("JML_Update"; <>lMinMemPart; "Master Log Update")

C_TIME:C306($timeOutAt)
$timeOutAt:=Current time:C178+?00:05:00?
Repeat   //waiting until server says it ready
	GET PROCESS VARIABLE:C371(server_pid; serverMethodDone; serverMethodDone_local)
	If (Not:C34(serverMethodDone_local))
		zwStatusMsg("SERVER REQUEST"; "Done yet?")
		DELAY PROCESS:C323(Current process:C322; 30)
	End if 
Until (serverMethodDone_local) | (Current time:C178>$timeOutAt)
zwStatusMsg("SERVER REQUEST"; "Done!")

//THE ABOVE REPLACES THIS:
//QUERY([Job_Forms_Master_Schedule];[Job_Forms_Master_Schedule]DateComplete=!00/00/00!)
//$before:=Records in selection([Job_Forms_Master_Schedule])
//If ($before>0)
//zwStatusMsg ("Art&OKs";" Updating Selection…")
//FG_LaunchItem ("Init")
//APPLY TO SELECTION([Job_Forms_Master_Schedule];JML_AutoUpdate ("*"))
//end if

If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	//base query
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateClosingMet:23=!00-00-00!; *)  //not met
	QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!; *)  //not printed
	QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!)  //not complete
	CREATE SET:C116([Job_Forms_Master_Schedule:67]; "baseQuery")
	//for planners and c/s
	$warningDate:=4D_Current_date+7
	QUERY SELECTION:C341([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]GateWayDeadLine:42=$warningDate)  //due in next 7 days
	
Else 
	
	$warningDate:=4D_Current_date+7
	
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateClosingMet:23=!00-00-00!; *)  //not met
	QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!; *)  //not printed
	QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)  //not complete
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]GateWayDeadLine:42=$warningDate)  //due in next 7 days
	
End if   // END 4D Professional Services : January 2019 query selection

//QUERY([JobMasterLog]; & ;[JobMasterLog]GateWayDeadLine#!00/00/00!;*)  `deadline set

$numRecs:=Records in selection:C76([Job_Forms_Master_Schedule:67])
If ($numRecs>0)
	SELECTION TO ARRAY:C260([Job_Forms_Master_Schedule:67]Customer:2; $aCust; [Job_Forms_Master_Schedule:67]JobForm:4; $aJF; [Job_Forms_Master_Schedule:67]MAD:21; $aMAD; [Job_Forms_Master_Schedule:67]Launch:64; $aLaunch; [Job_Forms_Master_Schedule:67]Line:5; $aLine)
	MULTI SORT ARRAY:C718($aCust; >; $aJF; >; $aMAD; $aLaunch; $aLine)
	
	xTitle:="Closing Date Warnings"
	xText:="____________________________________________"+$cr
	xText:=xText+"Final Art and OKs are required for the following jobs by "+String:C10($warningDate; System date short:K1:1)+":"+$cr
	xText:=xText+"CUSTOMER   "+"JOB FORM   "+"HRD "+"LAUNCH  "+"LINE "+$cr
	
	$break:=False:C215
	
	uThermoInit($numRecs; "Reporting Records")
	For ($i; 1; $numRecs)
		If ($break)
			$i:=$i+$numRecs
		End if 
		xText:=xText+$aCust{$i}+"  "+$aJF{$i}+"   "+String:C10($aMAD{$i}; System date short:K1:1)+"   "+$aLaunch{$i}+"   "+$aLine{$i}+$cr
		uThermoUpdate($i)
	End for 
	uThermoClose
	
	distributionList:=Batch_GetDistributionList("Closing Date Warnings")
	//distributionList:="mel.bohince@arkay.com"
	EMAIL_Sender(xTitle; ""; xText; distributionList)
	
	//Else 
	//xTitle:="Closing Dates Met for "
	//xText:="Final Art and OKs are ready for the jobs scheduled to print in the next 7 days."+$cr
End if 

//for frank and kris
If (Day number:C114(Current date:C33)=Friday:K10:17)  // Modified by: Mel Bohince (6/5/15) 
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		USE SET:C118("baseQuery")
		CLEAR SET:C117("baseQuery")
		QUERY SELECTION:C341([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]GateWayDeadLine:42<=4D_Current_date)  //past due 
		
	Else 
		
		QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateClosingMet:23=!00-00-00!; *)  //not met
		QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!; *)  //not printed
		QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)  //not complete
		QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]GateWayDeadLine:42<=4D_Current_date)  //past due 
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	//QUERY([JobMasterLog]; & ;[JobMasterLog]GateWayDeadLine#!00/00/00!;*)  `deadline set
	$numRecs:=Records in selection:C76([Job_Forms_Master_Schedule:67])
	If ($numRecs>0)
		SELECTION TO ARRAY:C260([Job_Forms_Master_Schedule:67]Customer:2; $aCust; [Job_Forms_Master_Schedule:67]JobForm:4; $aJF; [Job_Forms_Master_Schedule:67]MAD:21; $aMAD; [Job_Forms_Master_Schedule:67]Launch:64; $aLaunch; [Job_Forms_Master_Schedule:67]Line:5; $aLine)
		MULTI SORT ARRAY:C718($aCust; >; $aJF; >; $aMAD; $aLaunch; $aLine)
		
		xTitle:="Closing Dates Missed This Week"
		xText:="____________________________________________"+$cr
		xText:=xText+"Final Art and OKs were required for the following jobs on or before "+String:C10(4D_Current_date; System date short:K1:1)+":"+$cr
		xText:=xText+"CUSTOMER   "+"JOB FORM   "+"HRD "+"LAUNCH  "+"LINE "+$cr
		
		$break:=False:C215
		
		uThermoInit($numRecs; "Reporting Records")
		For ($i; 1; $numRecs)
			If ($break)
				$i:=$i+$numRecs
			End if 
			xText:=xText+$aCust{$i}+"  "+$aJF{$i}+"   "+String:C10($aMAD{$i}; System date short:K1:1)+"   "+$aLaunch{$i}+"   "+$aLine{$i}+$cr
			uThermoUpdate($i)
		End for 
		uThermoClose
		
		distributionList:=Batch_GetDistributionList("Closing Dates Missed")
		//distributionList:="mel.bohince@arkay.com"
		EMAIL_Sender(xTitle; ""; xText; distributionList)
		
		//Else 
		//xTitle:="Closing Dates Met for "
		//xText:="Final Art and OKs are ready for the jobs scheduled to print in the next 7 days."+$cr
	End if 
End if   //friday

If (False:C215)
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateFinalArtApproved:12=!00-00-00!; *)
	QUERY:C277([Job_Forms_Master_Schedule:67];  | ; [Job_Forms_Master_Schedule:67]DateFinalToolApproved:18=!00-00-00!; *)
	//QUERY([JobMasterLog];[JobMasterLog]GateWayMet=!00/00/00!;*)
	QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!; *)
	QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!)
	$after:=Records in selection:C76([Job_Forms_Master_Schedule:67])
	CREATE SET:C116([Job_Forms_Master_Schedule:67]; "after")  //•030598  MLB  
	If ($before#$after)  //we got some
		DIFFERENCE:C122("before"; "after"; "changed")
	End if 
	USE SET:C118("changed")
	ARRAY TEXT:C222($aJob; 0)
	ARRAY TEXT:C222($aCust; 0)
	ARRAY TEXT:C222($aLine; 0)
	ARRAY DATE:C224($aArt; 0)
	ARRAY DATE:C224($aOKs; 0)
	ARRAY DATE:C224($aWant; 0)
	SELECTION TO ARRAY:C260([Job_Forms_Master_Schedule:67]JobForm:4; $aJob; [Job_Forms_Master_Schedule:67]Customer:2; $aCust; [Job_Forms_Master_Schedule:67]Line:5; $aLine; [Job_Forms_Master_Schedule:67]DateFinalArtApproved:12; $aArt; [Job_Forms_Master_Schedule:67]DateFinalToolApproved:18; $aOKs; [Job_Forms_Master_Schedule:67]PressDate:25; $aWant)
	SORT ARRAY:C229($aWant; $aJob; $aCust; $aLine; $aArt; $aOKs; >)
	//*Set up for logfile dump
	xTitle:="Art & OKs Update"
	xText:="____________________________________________"+$cr
	
	xText:=xText+"Art and OKs have been Entered for the following jobs:"+$cr+$cr
	xText:=xText+"Jobform "+$t+"Art     "+$t+"OKs     "+$t+"Press   "+$t+"Customer    "+$t+"Line"+$cr
	For ($i; 1; Size of array:C274($aJob))
		xText:=xText+$aJob{$i}+$t+String:C10($aArt{$i}; <>MIDDATE)+$t+String:C10($aOKs{$i}; <>MIDDATE)+$t+String:C10($aWant{$i}; <>MIDDATE)+$t+$aCust{$i}+$t+$aLine{$i}+$cr
		
		If (Length:C16(xText)>31000)  //split it up
			xText:=xText+"*** continued ***"+$cr
			EMAIL_Sender(xTitle; ""; xText; distributionList)
			rPrintText("Art_OKs_Update"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; ""))
			xText:="*** continued ***"+$cr
			xText:=xText+"Art and OKs have been Entered for the following jobs:"+$cr+$cr
			xText:=xText+"Jobform "+$t+"Art     "+$t+"OKs     "+$t+"Press   "+$t+"Customer    "+$t+"Line"+$cr
		End if 
		
	End for 
	
	USE SET:C118("after")
	QUERY SELECTION:C341([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!; *)
	QUERY SELECTION:C341([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateFinalArtApproved:12=!00-00-00!; *)
	QUERY SELECTION:C341([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PressDate:25<$dropDead)
	QUERY SELECTION:C341([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]JobForm:4#"@.**")
	ARRAY TEXT:C222($aJob; 0)
	ARRAY TEXT:C222($aCust; 0)
	ARRAY TEXT:C222($aLine; 0)
	ARRAY DATE:C224($aArt; 0)
	ARRAY DATE:C224($aOKs; 0)
	ARRAY DATE:C224($aWant; 0)
	ARRAY DATE:C224($aMAD; 0)
	SELECTION TO ARRAY:C260([Job_Forms_Master_Schedule:67]JobForm:4; $aJob; [Job_Forms_Master_Schedule:67]Customer:2; $aCust; [Job_Forms_Master_Schedule:67]Line:5; $aLine; [Job_Forms_Master_Schedule:67]MAD:21; $aArt; [Job_Forms_Master_Schedule:67]FirstReleaseDat:13; $aOKs; [Job_Forms_Master_Schedule:67]PressDate:25; $aWant; [Job_Forms_Master_Schedule:67]MAD:21; $aMAD)
	SORT ARRAY:C229($aWant; $aJob; $aCust; $aLine; $aArt; $aOKs; $aMAD; >)
	xText:=xText+$cr+$cr+"___________________"+$cr
	xText:=xText+"Art is still required for the following jobs with a Press Date less than"+String:C10($dropDead; <>MIDDATE)+":"+$cr+$cr
	xText:=xText+"Jobform "+$t+"MAD     "+$t+"1st Rel "+$t+"Press   "+$t+"Customer    "+$t+"Line"+$cr
	For ($i; 1; Size of array:C274($aJob))
		xText:=xText+$aJob{$i}+$t+String:C10($aArt{$i}; <>MIDDATE)+$t+String:C10($aOKs{$i}; <>MIDDATE)+$t+String:C10($aWant{$i}; <>MIDDATE)+$t+$aCust{$i}+$t+$aLine{$i}+$cr
		
		If (Length:C16(xText)>31000)  //split it up
			xText:=xText+"*** continued ***"+$cr
			EMAIL_Sender(xTitle; ""; xText; distributionList)
			//rPrintText ("Art_OKs_Update"+(fYYMMDD (4D_Current_date))+"_"+Replace 
			//«string(String(4d_Current_time;◊HHMM);":";""))
			xText:="*** continued ***"+$cr
			xText:=xText+"Art and OKs are still required for the following jobs with a drop-dead of "+String:C10($dropDead; <>MIDDATE)+":"+$cr+$cr
			xText:=xText+"Jobform "+$t+"MAD     "+$t+"1st Rel "+$t+"Press   "+$t+"Customer    "+$t+"Line"+$cr
		End if 
	End for 
	
	xText:=xText+"_______________ END OF REPORT ______________"
	EMAIL_Sender(xTitle; ""; xText; distributionList)
End if   //false

//*Print a list of what happened on this run
//rPrintText ("Art_OKs_Update"+(fYYMMDD (4D_Current_date))+"_"+Replace 
//«string(String(4d_Current_time;◊HHMM);":";""))  
//rPrintText ("_.LOG")  
//End if 


REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)