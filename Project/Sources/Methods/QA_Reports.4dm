//%attributes = {"publishedWeb":true}
//PM: QA_Reports() -> 
//@author mlb - 8/3/01  14:12
// Added by: Garri Ogata (3/10/21) "Receipt and Issued"
C_TEXT:C284($rptAlias; $1)

Case of 
	: (Count parameters:C259=0)  //init the arrays with options    
		ARRAY TEXT:C222(<>aQARptPop; 14)  //•121197  MLB  UPR 1906 resize stringlengtyh
		<>aQARptPop{1}:="(Corrective Action Reports"
		<>aQARptPop{2}:="CAR Report"
		<>aQARptPop{3}:="CAR Listing"
		<>aQARptPop{4}:="Complaint Listing"
		<>aQARptPop{5}:="-"
		<>aQARptPop{6}:="On Time Report"
		<>aQARptPop{7}:="-"
		<>aQARptPop{8}:="Old QA Summary"
		<>aQARptPop{9}:="QA Summary"
		<>aQARptPop{10}:="Shortages Report"
		<>aQARptPop{11}:="QA by Customer"
		<>aQARptPop{12}:="-"
		<>aQARptPop{13}:="Re-Cert Listing"
		<>aQARptPop{14}:="Receipt and Issued"
		
		
		<>aQARptPopMenu:=<>aQARptPop{1}
		For ($i; 2; Size of array:C274(<>aQARptPop))
			If (Substring:C12(<>aQARptPop{$i}; 1; 1)="-")
				<>aQARptPopMenu:=<>aQARptPopMenu+";("+<>aQARptPop{$i}
			Else 
				<>aQARptPopMenu:=<>aQARptPopMenu+";"+<>aQARptPop{$i}
			End if 
		End for 
		
	Else 
		zSetUsageLog(->[QA_Corrective_Actions:105]; "RptPopUp"; $1)
		SET MENU BAR:C67(<>DefaultMenu)
		$rptAlias:=$1
		
		Open window:C153(2; 40; 638; 478; 8; $rptAlias)  //" Reporting")
		filePtr:=->[QA_Corrective_Actions:105]
		fileNum:=Table:C252(filePtr)
		sFile:=Table name:C256(filePtr)
		fromDelete:=False:C215
		
		Case of 
			: ($rptAlias="CAR Report")
				
				QACA_Rprt_Request
				
			: ($rptAlias="CAR Listing")
				util_PAGE_SETUP(->[QA_Corrective_Actions:105]; "CAR Report Listing")
				FORM SET OUTPUT:C54([QA_Corrective_Actions:105]; "CAR Report Listing")
				NumRecs1:=fSelectBy  //generic search equal or range on any four fields 
				If (OK=1)
					tText:=Request:C163("Message in header of report:"; "User defined query and sort")
					SET WINDOW TITLE:C213(fNameWindow(filePtr)+" "+$rptAlias)
					PRINT SELECTION:C60([QA_Corrective_Actions:105]; *)
				End if 
				FORM SET OUTPUT:C54([QA_Corrective_Actions:105]; "List")
				
			: ($rptAlias="Complaint Listing")
				util_PAGE_SETUP(->[QA_Corrective_Actions:105]; "ComplaintListing")
				FORM SET OUTPUT:C54([QA_Corrective_Actions:105]; "ComplaintListing")
				NumRecs1:=fSelectBy  //generic search equal or range on any four fields 
				If (OK=1)
					tText:=Request:C163("Message in header of report:"; "User defined query and sort")
					SET WINDOW TITLE:C213(fNameWindow(filePtr)+" "+$rptAlias)
					PRINT SELECTION:C60([QA_Corrective_Actions:105]; *)
				End if 
				FORM SET OUTPUT:C54([QA_Corrective_Actions:105]; "List")
				
			: ($RptAlias="On Time Report")  //•111798  mlb  UPR 
				REL_OntimeReport
				
			: ($RptAlias="Old QA Summary")  //•111798  mlb  UPR 
				QA_MonthlySummaryA  // 
				
			: ($RptAlias="QA Summary")
				QA_WhereAreTheyNow
				
			: ($RptAlias="Shortages Report")  //•111798  mlb  UPR 
				QA_MonthlySummaryB
				
			: ($RptAlias="QA by Customer")  //•111798  mlb  UPR 
				QA_MonthlySummaryC
				
			: ($RptAlias="Re-Cert Listing")  //•111798  mlb  UPR 
				REL_getRecertificationRequired("local")
				REL_getRecertificationRequired("show"; "")
				FGL_RecertificationCandidate
				
			: ($RptAlias="Receipt and Issued")  // Added by: Garri Ogata (3/10/21) 
				
				RMTr_Quik_Query
				
			Else 
				BEEP:C151
				ALERT:C41("Send me an email. We're continuing our special for the month of October!")
		End case 
		
		CLOSE WINDOW:C154
		
End case 