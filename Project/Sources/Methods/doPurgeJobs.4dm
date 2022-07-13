//%attributes = {"publishedWeb":true}
//Procedure: doPurgeJobs()  063095  MLB
//•062995  MLB  UPR 1507
//•031596  MLB  additions added
//•050596  MLB  fix Machine&Material_Item search
//• 3/27/98 cs added default path to file creation
//• 6/11/98 cs removed reference to Machine & Material Item table
//• mlb - 7/30/01 fixed problem with JML purge
//• mlb - 9/19/01  10:27 [JobItemCosts] added to export

READ WRITE:C146([Jobs:15])
READ WRITE:C146([Job_Forms:42])
READ WRITE:C146([Job_Forms_Items:44])  //keep if still inventory
READ WRITE:C146([Job_Forms_Items_Costs:92])
READ WRITE:C146([Job_Forms_Materials:55])
READ WRITE:C146([Job_Forms_Machines:43])
READ WRITE:C146([Job_Forms_Machine_Tickets:61])
READ WRITE:C146([Raw_Materials_Transactions:23])
READ WRITE:C146([Finished_Goods_Transactions:33])
READ WRITE:C146([Job_Forms_Master_Schedule:67])

C_LONGINT:C283($i; $recs; $1)  //days old for delete, optional
C_TEXT:C284($CR)
C_DATE:C307($today; $cutoff)
C_TEXT:C284(xTitle; xText; $Path)

$CR:=Char:C90(13)
$today:=4D_Current_date
xTitle:="Job Purge Summary for "+String:C10($today; <>LONGDATE)+"  "+String:C10(4d_Current_time; <>HMMAM)
xText:="____________________________________________"+$CR+"Search includes status: "
$Path:=<>purgeFolderPath

//*Find the candidate Jobs that are Closed, call them "Jobs"
If (Count parameters:C259=0)
	QUERY:C277([Jobs:15]; [Jobs:15]Status:4="Closed")
Else 
	$cutoff:=$today-$1
	QUERY:C277([Jobs:15]; [Jobs:15]CloseDate:17<$cutoff; *)
	QUERY:C277([Jobs:15];  & ; [Jobs:15]CloseDate:17#!00-00-00!)
End if 
xText:=xText+"("+String:C10(Records in selection:C76([Jobs:15]))+") Jobs Closed "
$recs:=Records in selection:C76([Jobs:15])
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	
	FIRST RECORD:C50([Jobs:15])
	
	
Else 
	
	//see  line 38
	
	
End if   // END 4D Professional Services : January 2019 First record
// 4D Professional Services : after Order by , query or any query type you don't need First record  
CREATE SET:C116([Jobs:15]; "Jobs")
//next, find locations related to  these forms, so we can omit
//deleting JMI's with inventory by testing against arrays
//**   exclude jobs that have inventory
ALL RECORDS:C47([Finished_Goods_Locations:35])
ARRAY TEXT:C222($aInvJF; 0)
SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]JobForm:19; $aInvJF)

SET CHANNEL:C77(10; $Path+("JOB_"+String:C10($today; 4)+"_01"))
uThermoInit($recs; "Saving "+String:C10($recs; "###,##0 ")+" Job records.")
C_LONGINT:C283($hit)
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
	
	CREATE EMPTY SET:C140([Jobs:15]; "JobsWithInv")
	For ($i; 1; $recs)
		$hit:=Find in array:C230($aInvJF; (String:C10([Jobs:15]JobNo:1; "00000")+"@"))  //find inventory    
		If ($hit=-1)  //no inventory
			SEND RECORD:C78([Jobs:15])
		Else 
			ADD TO SET:C119([Jobs:15]; "JobsWithInv")
		End if 
		NEXT RECORD:C51([Jobs:15])
		uThermoUpdate($i)
		If (Not:C34(<>fContinue))  //esc pressed
			$i:=$i+$recs
		End if 
	End for 
	
	
Else 
	ARRAY LONGINT:C221($_JobsWithInv; 0)
	
	For ($i; 1; $recs)
		$hit:=Find in array:C230($aInvJF; (String:C10([Jobs:15]JobNo:1; "00000")+"@"))  //find inventory    
		If ($hit=-1)  //no inventory
			SEND RECORD:C78([Jobs:15])
		Else 
			APPEND TO ARRAY:C911($_JobsWithInv; Record number:C243([Jobs:15]))
			
		End if 
		NEXT RECORD:C51([Jobs:15])
		uThermoUpdate($i)
		If (Not:C34(<>fContinue))  //esc pressed
			$i:=$i+$recs
		End if 
	End for 
	
	CREATE SET FROM ARRAY:C641([Jobs:15]; $_JobsWithInv; "JobsWithInv")
	
End if   // END 4D Professional Services : January 2019 

uThermoClose
SET CHANNEL:C77(11)
DIFFERENCE:C122("Jobs"; "JobsWithInv"; "Jobs")  //remove the ones with invnetory
xText:=xText+$CR+"("+String:C10(Records in set:C195("JobsWithInv"))+") Closed jobs still have inventory "
CLEAR SET:C117("JobsWithInv")
ARRAY TEXT:C222($aInvJF; 0)
USE SET:C118("Jobs")

//*Get related jobforms, call them "Jobforms"
RELATE MANY SELECTION:C340([Job_Forms:42]JobNo:2)
$recs:=Records in selection:C76([Job_Forms:42])
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	
	FIRST RECORD:C50([Job_Forms:42])
	
Else 
	
	// see line 88
	
End if   // END 4D Professional Services : January 2019 First record
// 4D Professional Services : after Order by , query or any query type you don't need First record  

CREATE SET:C116([Job_Forms:42]; "Jobforms")
SET CHANNEL:C77(10; ($Path+"JOB_"+String:C10($today; 4)+"_02"))
uThermoInit($recs; "Saving "+String:C10($recs; "###,##0 ")+" Jobform records.")
For ($i; 1; $recs)
	SEND RECORD:C78([Job_Forms:42])
	NEXT RECORD:C51([Job_Forms:42])
	uThermoUpdate($i)
	If (Not:C34(<>fContinue))  //esc pressed
		$i:=$i+$recs
	End if 
End for 
uThermoClose
SET CHANNEL:C77(11)

//*get related JMIs
RELATE MANY SELECTION:C340([Job_Forms_Items:44]JobForm:1)  //all candidate JMI's
CREATE SET:C116([Job_Forms_Items:44]; "JMI")
$recs:=Records in selection:C76([Job_Forms_Items:44])
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	
	FIRST RECORD:C50([Job_Forms_Items:44])
	
	
Else 
	
	// see line 166
	
	
End if   // END 4D Professional Services : January 2019 First record
// 4D Professional Services : after Order by , query or any query type you don't need First record  
SET CHANNEL:C77(10; ($Path+"JOB_"+String:C10($today; 4)+"_03"))
uThermoInit($recs; "Saving "+String:C10($recs; "###,##0 ")+" JobMakesItem records.")
For ($i; 1; $recs)
	SEND RECORD:C78([Job_Forms_Items:44])
	NEXT RECORD:C51([Job_Forms_Items:44])
	uThermoUpdate($i)
	If (Not:C34(<>fContinue))  //esc pressed
		$i:=$i+$recs
	End if 
End for 
uThermoClose
SET CHANNEL:C77(11)

//*get related JICs
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	util_outerJoin(->[Job_Forms_Items_Costs:92]JobForm:1; ->[Job_Forms:42]JobFormID:5)  //all candidate JMI's
	//CREATE SET([JobItemCosts];"JIC")
	$recs:=Records in selection:C76([Job_Forms_Items_Costs:92])
	FIRST RECORD:C50([Job_Forms_Items_Costs:92])
	
Else 
	
	zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Job_Forms_Items_Costs:92])+" file. Please Wait...")
	ARRAY TEXT:C222($_JobFormID; 0)
	DISTINCT VALUES:C339([Job_Forms:42]JobFormID:5; $_JobFormID)
	QUERY WITH ARRAY:C644([Job_Forms_Items_Costs:92]JobForm:1; $_JobFormID)
	$recs:=Records in selection:C76([Job_Forms_Items_Costs:92])
	zwStatusMsg(""; "")
	
	
End if   // END 4D Professional Services : January 2019 query selection

SET CHANNEL:C77(10; ($Path+"JOB_"+String:C10($today; 4)+"_11"))
uThermoInit($recs; "Saving "+String:C10($recs; "###,##0 ")+" [JobItemCosts] records.")
For ($i; 1; $recs)
	SEND RECORD:C78([Job_Forms_Items_Costs:92])
	NEXT RECORD:C51([Job_Forms_Items_Costs:92])
	uThermoUpdate($i)
	If (Not:C34(<>fContinue))  //esc pressed
		$i:=$i+$recs
	End if 
End for 
uThermoClose
SET CHANNEL:C77(11)

//*get related fgx
RELATE MANY SELECTION:C340([Finished_Goods_Transactions:33]JobForm:5)  //all candidate fgx
QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2#"@ship")
CREATE SET:C116([Finished_Goods_Transactions:33]; "fgx")
$recs:=Records in selection:C76([Finished_Goods_Transactions:33])
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	
	FIRST RECORD:C50([Finished_Goods_Transactions:33])
	
	
Else 
	
	// see line 179
	
End if   // END 4D Professional Services : January 2019 First record
// 4D Professional Services : after Order by , query or any query type you don't need First record  
SET CHANNEL:C77(10; ($Path+"JOB_"+String:C10($today; 4)+"_09"))
uThermoInit($recs; "Saving "+String:C10($recs; "###,##0 ")+" FG Trans records.")
For ($i; 1; $recs)
	SEND RECORD:C78([Finished_Goods_Transactions:33])
	NEXT RECORD:C51([Finished_Goods_Transactions:33])
	uThermoUpdate($i)
	If (Not:C34(<>fContinue))  //esc pressed
		$i:=$i+$recs
	End if 
End for 
uThermoClose
SET CHANNEL:C77(11)

//*get related Machines
RELATE MANY SELECTION:C340([Job_Forms_Machines:43]JobForm:1)
$recs:=Records in selection:C76([Job_Forms_Machines:43])
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	
	FIRST RECORD:C50([Job_Forms_Machines:43])
	
	
Else 
	
	// see line 207
	
	
End if   // END 4D Professional Services : January 2019 First record
// 4D Professional Services : after Order by , query or any query type you don't need First record  
SET CHANNEL:C77(10; ($Path+"JOB_"+String:C10($today; 4)+"_04"))
uThermoInit($recs; "Saving "+String:C10($recs; "###,##0 ")+" [Machine_Job] records.")
For ($i; 1; $recs)
	SEND RECORD:C78([Job_Forms_Machines:43])
	NEXT RECORD:C51([Job_Forms_Machines:43])
	uThermoUpdate($i)
	If (Not:C34(<>fContinue))  //esc pressed
		$i:=$i+$recs
	End if 
End for 
uThermoClose
SET CHANNEL:C77(11)

//*get related materials
RELATE MANY SELECTION:C340([Job_Forms_Materials:55]JobForm:1)
$recs:=Records in selection:C76([Job_Forms_Materials:55])
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	
	FIRST RECORD:C50([Job_Forms_Materials:55])
	
	
Else 
	
	// see line 235
	
End if   // END 4D Professional Services : January 2019 First record
// 4D Professional Services : after Order by , query or any query type you don't need First record  
SET CHANNEL:C77(10; ($Path+"JOB_"+String:C10($today; 4)+"_05"))
uThermoInit($recs; "Saving "+String:C10($recs; "###,##0 ")+" [Material_Job] records.")
For ($i; 1; $recs)
	SEND RECORD:C78([Job_Forms_Materials:55])
	NEXT RECORD:C51([Job_Forms_Materials:55])
	uThermoUpdate($i)
	If (Not:C34(<>fContinue))  //esc pressed
		$i:=$i+$recs
	End if 
End for 
uThermoClose
SET CHANNEL:C77(11)

//*get related machine tickets
RELATE MANY SELECTION:C340([Job_Forms_Machine_Tickets:61]JobForm:1)
$recs:=Records in selection:C76([Job_Forms_Machine_Tickets:61])
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	
	FIRST RECORD:C50([Job_Forms_Machine_Tickets:61])
	
	
Else 
	
	//see line 262
	
End if   // END 4D Professional Services : January 2019 First record
// 4D Professional Services : after Order by , query or any query type you don't need First record  
SET CHANNEL:C77(10; ($Path+"JOB_"+String:C10($today; 4)+"_06"))
uThermoInit($recs; "Saving "+String:C10($recs; "###,##0 ")+" [MachineTicket] records.")
For ($i; 1; $recs)
	SEND RECORD:C78([Job_Forms_Machine_Tickets:61])
	NEXT RECORD:C51([Job_Forms_Machine_Tickets:61])
	uThermoUpdate($i)
	If (Not:C34(<>fContinue))  //esc pressed
		$i:=$i+$recs
	End if 
End for 
uThermoClose
SET CHANNEL:C77(11)

//*get related MonthlySummaries
//uRelateSelect (->[MonthlySummary]JobFormID;->[JobForm]JobFormID)
//$recs:=Records in selection([MonthlySummary])
//FIRST RECORD([MonthlySummary])
//SET CHANNEL(10;($Path+"JOB_"+String($today;4)+"_07"))
//uThermoInit ($recs;"Saving "+String($recs;"###,##0 ")+" [MonthlySummary] 
//«records.")
//For ($i;1;$recs)
//SEND RECORD([MonthlySummary])
//NEXT RECORD([MonthlySummary])
//uThermoUpdate ($i)
//If (Not(◊fContinue))  `esc pressed
//$i:=$i+$recs
//End if 
//End for 
//uThermoClose 
//SET CHANNEL(11)

//*get related RMX
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	uRelateSelect(->[Raw_Materials_Transactions:23]JobForm:12; ->[Job_Forms:42]JobFormID:5)
	$recs:=Records in selection:C76([Raw_Materials_Transactions:23])
	FIRST RECORD:C50([Raw_Materials_Transactions:23])
	
	
Else 
	
	zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Raw_Materials_Transactions:23])+" file. Please Wait...")
	RELATE MANY SELECTION:C340([Raw_Materials_Transactions:23]JobForm:12)
	$recs:=Records in selection:C76([Raw_Materials_Transactions:23])
	zwStatusMsg(""; "")
	
End if   // END 4D Professional Services : January 2019 query selection
SET CHANNEL:C77(10; ($Path+"JOB_"+String:C10($today; 4)+"_08"))
uThermoInit($recs; "Saving "+String:C10($recs; "###,##0 ")+" [RM_XFER] records.")
For ($i; 1; $recs)
	SEND RECORD:C78([Raw_Materials_Transactions:23])
	NEXT RECORD:C51([Raw_Materials_Transactions:23])
	uThermoUpdate($i)
	If (Not:C34(<>fContinue))  //esc pressed
		$i:=$i+$recs
	End if 
End for 
uThermoClose
SET CHANNEL:C77(11)

//*Get related JobMasterLogs, call them "deleteJML"
RELATE MANY SELECTION:C340([Job_Forms_Master_Schedule:67]JobForm:4)
CREATE SET:C116([Job_Forms_Master_Schedule:67]; "deleteJML")
//**   add in the orphaned JMLs
ALL RECORDS:C47([Job_Forms_Master_Schedule:67])
CREATE SET:C116([Job_Forms_Master_Schedule:67]; "candidateJML")
DIFFERENCE:C122("candidateJML"; "deleteJML"; "candidateJML")  //don't check ones that are already going to be deleted
USE SET:C118("candidateJML")
FIRST RECORD:C50([Job_Forms_Master_Schedule:67])
CLEAR SET:C117("candidateJML")

ALL RECORDS:C47([Jobs:15])
SELECTION TO ARRAY:C260([Jobs:15]JobNo:1; $aJobRecords)
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
	
	CREATE EMPTY SET:C140([Job_Forms_Master_Schedule:67]; "orphanJML")
	For ($i; 1; Records in selection:C76([Job_Forms_Master_Schedule:67]))
		$hit:=Find in array:C230($aJobRecords; (Num:C11(Substring:C12([Job_Forms_Master_Schedule:67]JobForm:4; 1; 5))))
		If ($hit<0)
			ADD TO SET:C119([Job_Forms_Master_Schedule:67]; "orphanJML")
		End if 
		NEXT RECORD:C51([Job_Forms_Master_Schedule:67])
	End for 
	UNION:C120("deleteJML"; "orphanJML"; "deleteJML")
	CLEAR SET:C117("orphanJML")
	
Else 
	
	ARRAY LONGINT:C221($_orphanJML; 0)
	ARRAY LONGINT:C221($_records_number; 0)
	ARRAY TEXT:C222($_JobForm; 0)
	
	SELECTION TO ARRAY:C260([Job_Forms_Master_Schedule:67]JobForm:4; $_JobForm; \
		[Job_Forms_Master_Schedule:67]; $_records_number)
	
	For ($i; 1; Size of array:C274($_JobForm); 1)
		$hit:=Find in array:C230($aJobRecords; (Num:C11(Substring:C12($_JobForm{$i}; 1; 5))))
		If ($hit<0)
			
			APPEND TO ARRAY:C911($_orphanJML; $_records_number{$i})
			
		End if 
	End for 
	
	CREATE SET FROM ARRAY:C641([Job_Forms_Master_Schedule:67]; $_orphanJML; "orphanJML")
	UNION:C120("deleteJML"; "orphanJML"; "deleteJML")
	CLEAR SET:C117("orphanJML")
	
End if   // END 4D Professional Services : January 2019 

USE SET:C118("deleteJML")
CLEAR SET:C117("deleteJML")
ARRAY LONGINT:C221($aJobRecords; 0)

$recs:=Records in selection:C76([Job_Forms_Master_Schedule:67])
FIRST RECORD:C50([Job_Forms_Master_Schedule:67])
SET CHANNEL:C77(10; ($Path+"JOB_"+String:C10($today; 4)+"_10"))
uThermoInit($recs; "Saving "+String:C10($recs; "###,##0 ")+" [JobMasterLog] records.")

For ($i; 1; $recs)
	SEND RECORD:C78([Job_Forms_Master_Schedule:67])
	NEXT RECORD:C51([Job_Forms_Master_Schedule:67])
	uThermoUpdate($i)
	
	If (Not:C34(<>fContinue))  //esc pressed
		$i:=$i+$recs
	End if 
End for 
uThermoClose
SET CHANNEL:C77(11)

C_LONGINT:C283($Max)
$Max:=255  //maximum built search commands in one grouping

USE SET:C118("Jobs")
USE SET:C118("Jobforms")
USE SET:C118("JMI")
USE SET:C118("fgx")
MESSAGE:C88($CR+"Deleting Jobs")

If (<>fContinue)
	xText:=xText+$CR+String:C10(Records in set:C195("Jobs"); "^^^,^^^,^^0 ")+" Jobs deleted and exported to JOB_"+String:C10($today; 4)+"_1"
	MESSAGE:C88($CR+"Deleting Jobs")
	DELETE SELECTION:C66([Jobs:15])
	FLUSH CACHE:C297
	xText:=xText+$CR+String:C10(Records in set:C195("Jobforms"); "^^^,^^^,^^0 ")+" Jobforms deleted and exported to JOB_"+String:C10($today; 4)+"_2"
	MESSAGE:C88($CR+"Deleting Jobforms")
	DELETE SELECTION:C66([Job_Forms:42])
	FLUSH CACHE:C297
	xText:=xText+$CR+String:C10(Records in set:C195("JMI"); "^^^,^^^,^^0 ")+" JobMakesItem deleted and exported to JOB_"+String:C10($today; 4)+"_3"
	MESSAGE:C88($CR+"Deleting JobMakesItem")
	DELETE SELECTION:C66([Job_Forms_Items:44])
	FLUSH CACHE:C297
	xText:=xText+$CR+String:C10(Records in selection:C76([Job_Forms_Machines:43]); "^^^,^^^,^^0 ")+" Machine_Job deleted and exported to JOB_"+String:C10($today; 4)+"_4"
	MESSAGE:C88($CR+"Deleting [Machine_Job]")
	DELETE SELECTION:C66([Job_Forms_Machines:43])
	FLUSH CACHE:C297
	xText:=xText+$CR+String:C10(Records in selection:C76([Job_Forms_Materials:55]); "^^^,^^^,^^0 ")+" [Material_Job] deleted and exported to JOB_"+String:C10($today; 4)+"_5"
	MESSAGE:C88($CR+"Deleting [Material_Job]")
	DELETE SELECTION:C66([Job_Forms_Materials:55])
	FLUSH CACHE:C297
	xText:=xText+$CR+String:C10(Records in selection:C76([Job_Forms_Machine_Tickets:61]); "^^^,^^^,^^0 ")+" [MachineTicket] deleted and exported to JOB_"+String:C10($today; 4)+"_6"
	MESSAGE:C88($CR+"Deleting [MachineTicket]")
	DELETE SELECTION:C66([Job_Forms_Machine_Tickets:61])
	FLUSH CACHE:C297
	
	FLUSH CACHE:C297
	xText:=xText+$CR+String:C10(Records in selection:C76([Raw_Materials_Transactions:23]); "^^^,^^^,^^0 ")+" [RM_XFER] deleted and exported to JOB_"+String:C10($today; 4)+"_8"
	MESSAGE:C88($CR+"Deleting [RM_XFER]")
	DELETE SELECTION:C66([Raw_Materials_Transactions:23])
	FLUSH CACHE:C297
	xText:=xText+$CR+String:C10(Records in selection:C76([Finished_Goods_Transactions:33]); "^^^,^^^,^^0 ")+" [FG_XFER] deleted and exported to JOB_"+String:C10($today; 4)+"_9"
	MESSAGE:C88($CR+"Deleting [FG_Transactions]")
	DELETE SELECTION:C66([Finished_Goods_Transactions:33])
	FLUSH CACHE:C297
	xText:=xText+$CR+String:C10(Records in selection:C76([Job_Forms_Master_Schedule:67]); "^^^,^^^,^^0 ")+" [JobMasterLog] deleted and exported to JOB_"+String:C10($today; 4)+"_10"
	MESSAGE:C88($CR+"Deleting [JobMasterLog]")
	DELETE SELECTION:C66([Job_Forms_Master_Schedule:67])
	FLUSH CACHE:C297
Else 
	xText:=xText+$CR+"Purge Canceled, no Jobs were deleted."
End if 
CLEAR SET:C117("Jobs")
CLEAR SET:C117("Jobforms")
CLEAR SET:C117("JMI")
CLEAR SET:C117("fgx")
REDUCE SELECTION:C351([Jobs:15]; 0)
REDUCE SELECTION:C351([Job_Forms:42]; 0)
REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)  //keep if still inventory
REDUCE SELECTION:C351([Job_Forms_Materials:55]; 0)
REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
REDUCE SELECTION:C351([Job_Forms_Machine_Tickets:61]; 0)
REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)
REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)

xText:=xText+$CR+"_______________ END OF REPORT ______________"+String:C10(4d_Current_time; <>HMMAM)
//*Print a list of what happened on this run
rPrintText("JOB_PURGE_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".LOG")
xTitle:=""
xText:=""