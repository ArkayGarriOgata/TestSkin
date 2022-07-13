//%attributes = {"publishedWeb":true}
//(p) doPurgeIssTick(ets)
//• 11/6/97 cs created
//• 3/27/98 cs added default path to file creation

C_DATE:C307($PurgeDate)
C_TEXT:C284(xTitle; xText; $Path)
C_TEXT:C284($CR)

$Path:=<>purgeFolderPath
$Cr:=Char:C90(13)
$PurgeDate:=4D_Current_date-90
QUERY:C277([Job_Forms_Issue_Tickets:90]; [Job_Forms_Issue_Tickets:90]Posted:4#0; *)  //not yet posted
QUERY:C277([Job_Forms_Issue_Tickets:90];  & ; [Job_Forms_Issue_Tickets:90]PostDate:8<$Purgedate)
xTitle:="Issue Tickets Purge Summary for "+String:C10(4D_Current_date; <>LONGDATE)+"  "+String:C10(4d_Current_time; <>HMMAM)
xText:="____________________________________________"
xText:=$CR+"Search was for Issue Tickets before "+String:C10($Purgedate; <>SHORTDATE)

If (Records in selection:C76([Job_Forms_Issue_Tickets:90])>0)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		FIRST RECORD:C50([Job_Forms_Issue_Tickets:90])
		
		
	Else 
		//see line 13
		
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	SET CHANNEL:C77(10; $Path+"IssueTickets "+String:C10(4D_Current_date))
	uThermoInit(Records in selection:C76([Job_Forms_Issue_Tickets:90]); "Purging "+String:C10(Records in selection:C76([Job_Forms_Issue_Tickets:90]); "###,##0")+" Issue Tickets, press Esc to stop.")
	
	For ($i; 1; Records in selection:C76([Job_Forms_Issue_Tickets:90]))
		SEND RECORD:C78([Job_Forms_Issue_Tickets:90])
		NEXT RECORD:C51([Job_Forms_Issue_Tickets:90])
		uThermoUpdate($i)
	End for 
	SET CHANNEL:C77(11)
	xText:=xText+$CR+String:C10(Records in selection:C76([Job_Forms_Issue_Tickets:90]); "^^^,^^^,^^0 ")+" Issue Tickets deleted and exported to: IssueTickets"+String:C10(4D_Current_date; 4)
	xText:=xText+$CR+"_______________ END OF REPORT ______________"+String:C10(4d_Current_time; <>HMMAM)
	//*Print a list of what happened on this run
	rPrintText("Issue Tickets Purge"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; ""))
	xTitle:=""
	xText:=""
	MESSAGE:C88(Char:C90(13)+"Deleting Issue Tickets ...")
	DELETE SELECTION:C66([Job_Forms_Issue_Tickets:90])
	FLUSH CACHE:C297
	CLOSE WINDOW:C154
End if 