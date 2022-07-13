//%attributes = {"publishedWeb":true}
//Procedure: rRptGlueAnalysi()  071495  MLB
//•071495  MLB  UPR 1672
//Investigate parameters which influence the run rate of the gluers

//*Init files and varibles
READ ONLY:C145([Job_Forms_Machine_Tickets:61])
READ ONLY:C145([Job_Forms_Items:44])
READ ONLY:C145([Finished_Goods:26])
READ ONLY:C145([Process_Specs:18])

//*Search & sort machine tickets for all gluing operatioins
If (True:C214)
	BEEP:C151
	ALERT:C41("only gluers 476-487, less 486 and GlueItemNo#0")
End if 

QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2="481"; *)
QUERY:C277([Job_Forms_Machine_Tickets:61];  | ; [Job_Forms_Machine_Tickets:61]CostCenterID:2="482"; *)
QUERY:C277([Job_Forms_Machine_Tickets:61];  | ; [Job_Forms_Machine_Tickets:61]CostCenterID:2="483"; *)
QUERY:C277([Job_Forms_Machine_Tickets:61];  | ; [Job_Forms_Machine_Tickets:61]CostCenterID:2="484"; *)
QUERY:C277([Job_Forms_Machine_Tickets:61];  | ; [Job_Forms_Machine_Tickets:61]CostCenterID:2="485"; *)
QUERY:C277([Job_Forms_Machine_Tickets:61];  | ; [Job_Forms_Machine_Tickets:61]CostCenterID:2="487"; *)
QUERY:C277([Job_Forms_Machine_Tickets:61];  | ; [Job_Forms_Machine_Tickets:61]CostCenterID:2="476"; *)
QUERY:C277([Job_Forms_Machine_Tickets:61];  | ; [Job_Forms_Machine_Tickets:61]CostCenterID:2="477"; *)
QUERY:C277([Job_Forms_Machine_Tickets:61];  | ; [Job_Forms_Machine_Tickets:61]CostCenterID:2="478"; *)
QUERY:C277([Job_Forms_Machine_Tickets:61];  | ; [Job_Forms_Machine_Tickets:61]CostCenterID:2="479"; *)
QUERY:C277([Job_Forms_Machine_Tickets:61];  | ; [Job_Forms_Machine_Tickets:61]CostCenterID:2="480"; *)
QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]GlueMachItemNo:4#0)
// ******* Verified  - 4D PS - January  2019 ********

QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61])

// ******* Verified  - 4D PS - January 2019 (end) *********

util_PAGE_SETUP(->[Job_Forms_Machine_Tickets:61]; "GluerAnalysis")
PRINT SETTINGS:C106

If (OK=1)
	C_BOOLEAN:C305(fSave)
	uConfirm("Would you like to also save this report in Excel format?"; "Save file"; "Don't save")
	If (ok=1)
		vDoc:=Create document:C266("")
		If (ok=1)
			fSave:=True:C214
		Else 
			fSave:=False:C215
		End if 
	End if 
	
	t2:="GLUER ANALYSIS"  //titles
	t2b:="Based on "+String:C10(Records in selection:C76([Job_Forms_Machine_Tickets:61]))+" Machine Ticket Entries"
	dDate:=4D_Current_date
	tTime:=4d_Current_time
	
	If (uNowOrDelay)  //print now?
		$fContinue:=True:C214
	Else 
		$fContinue:=False:C215
	End if 
	
	//*print the report
	If ($fContinue)
		If (fSave)
			SEND PACKET:C103(vDoc; String:C10(dDate; 2)+Char:C90(9)+Char:C90(9)+t2+Char:C90(13))
			SEND PACKET:C103(vDoc; String:C10(tTime; 5)+Char:C90(9)+Char:C90(9)+t2b+Char:C90(13)+Char:C90(13))
			SEND PACKET:C103(vDoc; "C/C"+Char:C90(9)+"Job Form"+Char:C90(9)+"Item"+Char:C90(9))
			SEND PACKET:C103(vDoc; "Good Units"+Char:C90(9)+"Waste Units"+Char:C90(9)+"Act MR"+Char:C90(9))
			SEND PACKET:C103(vDoc; "Adj'd MR"+Char:C90(9)+"Act Run"+Char:C90(9)+"Adj'd Run"+Char:C90(9))
			SEND PACKET:C103(vDoc; "Budget Rate"+Char:C90(9)+"Actual Rate"+Char:C90(9)+"Rate Var"+Char:C90(9))
			SEND PACKET:C103(vDoc; "Glue Type"+Char:C90(9)+"W"+Char:C90(9)+"D"+Char:C90(9)+"H"+Char:C90(9)+"Caliper"+Char:C90(9))
			SEND PACKET:C103(vDoc; "Stock"+Char:C90(9)+"Coat Matl"+Char:C90(9)+"Film Laminate"+Char:C90(9))
			SEND PACKET:C103(vDoc; "PROCESS_SPEC"+Char:C90(13))
		End if 
		SET WINDOW TITLE:C213("Gluer Analysis, "+String:C10(Records in selection:C76([Job_Forms_Machine_Tickets:61]))+" Machine Tickets")
		
		ORDER BY:C49([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2; >; [Job_Forms_Machine_Tickets:61]JobForm:1; >; [Job_Forms_Machine_Tickets:61]GlueMachItemNo:4; >)
		ACCUMULATE:C303([Job_Forms_Machine_Tickets:61]Good_Units:8; [Job_Forms_Machine_Tickets:61]Waste_Units:9; [Job_Forms_Machine_Tickets:61]MR_Act:6; [Job_Forms_Machine_Tickets:61]Run_Act:7; [Job_Forms_Machine_Tickets:61]MR_AdjStd:14; [Job_Forms_Machine_Tickets:61]Run_AdjStd:15)
		BREAK LEVEL:C302(3)
		MESSAGES OFF:C175
		FORM SET OUTPUT:C54([Job_Forms_Machine_Tickets:61]; "GluerAnalysis")
		PRINT SELECTION:C60([Job_Forms_Machine_Tickets:61]; *)
		MESSAGES ON:C181
	End if 
	
	If (fSave)
		CLOSE DOCUMENT:C267(vDoc)
	End if 
End if 

FORM SET OUTPUT:C54([Job_Forms_Machine_Tickets:61]; "List")