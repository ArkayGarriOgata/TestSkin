//%attributes = {"publishedWeb":true}
//PM:  JOB_getFormBudget  2/21/01  mlb
//• mlb - 1/31/03  10:01 preserve [jobform]jobtype
// • mel (12/9/04, 10:51:43) add Job_getDieIdentifier
// Modified by: Mel Bohince (5/31/13) stamp the job.line into the form's line
// Modified by: Mel Bohince (1/23/15) set 1stPRessCount
// Modified by: Mel Bohince (5/27/21) clear PlnnerReleased when jobform is revised

C_BOOLEAN:C305(<>RecordSaved)  //•043096  MLB 

If ($3="Revised")
	[Job_Forms:42]VersionNumber:57:=[Job_Forms:42]VersionNumber:57+1
	[Job_Forms:42]PlnnerReleased:59:=!00-00-00!  // Modified by: Mel Bohince (5/27/21) clear PlnnerReleased when jobform is revised
	If (Length:C16([Estimates:17]JobTypeDescription:69)>0)
		[Job_Forms:42]JobTypeDescription:88:=[Estimates:17]JobTypeDescription:69
	End if 
	//Job_InkNotification ([Job_Forms]JobFormID)
	Job_revisionNoticeSend([Job_Forms:42]JobFormID:5)
	
Else   //Planned
	CREATE RECORD:C68([Job_Forms:42])
	[Job_Forms:42]VersionNumber:57:=0
	[Job_Forms:42]VersionZeroDate:89:=4D_Current_date
	[Job_Forms:42]JobNo:2:=$1
	[Job_Forms:42]FormNumber:3:=[Estimates_DifferentialsForms:47]FormNumber:2
	[Job_Forms:42]JobFormID:5:=String:C10([Job_Forms:42]JobNo:2; "00000")+"."+String:C10([Job_Forms:42]FormNumber:3; "00")
	[Job_Forms:42]zCount:12:=1
	[Job_Forms:42]cust_id:82:=[Jobs:15]CustID:2
	[Job_Forms:42]CustomerLine:62:=[Jobs:15]Line:3  // Modified by: Mel Bohince (5/31/13)
	If (Length:C16([Estimates:17]JobTypeDescription:69)>0)
		[Job_Forms:42]JobTypeDescription:88:=[Estimates:17]JobTypeDescription:69
	End if 
End if 

$jobform:=[Job_Forms:42]JobFormID:5
[Job_Forms:42]CaseFormID:9:=[Estimates_DifferentialsForms:47]DiffFormId:3  //=0-0000.00AZ00
[Job_Forms:42]EstimateNo:47:=$2
[Job_Forms:42]Status:6:=$3
//[JobForm]StartDate:=4D_Current_date
$noteEst:=Replace string:C233([Estimates_DifferentialsForms:47]Notes:33; Char:C90(13); "")
$noteJob:=Replace string:C233([Job_Forms:42]Notes:32; Char:C90(13); "")
Case of 
	: (Length:C16($noteEst)=0)
		// do nothing
	: (Length:C16($noteJob)=0)
		[Job_Forms:42]Notes:32:=[Estimates_DifferentialsForms:47]Notes:33
		
	: (Position:C15($noteEst; $noteJob)=0)  //($noteEst#$noteJob)// Modified by: Mel Bohince (12/3/15) check for existing phrase
		[Job_Forms:42]Notes:32:=[Job_Forms:42]Notes:32+";v"+String:C10([Job_Forms:42]VersionNumber:57)+" "+[Estimates_DifferentialsForms:47]Notes:33  //• mlb - 4/26/01  12:45 don't overrite notes    
End case 

If (Length:C16([Job_Forms:42]JobType:33)=0)  //• mlb - 1/31/03  10:01
	If ([Estimates_DifferentialsForms:47]JobType:9="")
		NewWindow(235; 160; 6; 5; "Pick a job type")
		DIALOG:C40([zz_control:1]; "JobType")
		CLOSE WINDOW:C154
		Case of 
			: (rbPrep=1)
				[Job_Forms:42]JobType:33:="2 Proof"
			: (rbProd=1)
				[Job_Forms:42]JobType:33:="3 Prod"
			: (rbDoOver=1)
				[Job_Forms:42]JobType:33:="4 Do Over"
			: (rbRD=1)
				[Job_Forms:42]JobType:33:="6 R & D"
			: (rbLT=1)
				[Job_Forms:42]JobType:33:="5 Line Trial"
			: (rbPLT=1)
				[Job_Forms:42]JobType:33:="9 Paid P/LT"
		End case 
		If (cbCA=1)  //califorinia
			[Job_Forms:42]JobType:33:=Replace string:C233([Job_Forms:42]JobType:33; " "; "c"; 1)
		End if 
		
	Else 
		[Job_Forms:42]JobType:33:=[Estimates_DifferentialsForms:47]JobType:9
	End if 
End if 

If ([Job_Forms:42]NeedDate:1=!00-00-00!)
	[Job_Forms:42]NeedDate:1:=[Estimates_DifferentialsForms:47]DateCustomerWant:7
Else 
	If ([Job_Forms:42]NeedDate:1#[Estimates_DifferentialsForms:47]DateCustomerWant:7)
		CONFIRM:C162("Job or Estimate's Need Date?"; String:C10([Job_Forms:42]NeedDate:1; System date short:K1:1); String:C10([Estimates_DifferentialsForms:47]DateCustomerWant:7; System date short:K1:1))
		If (OK=0)
			[Job_Forms:42]NeedDate:1:=[Estimates_DifferentialsForms:47]DateCustomerWant:7
		End if 
	End if 
End if 

[Job_Forms:42]ProcessSpec:46:=[Estimates_DifferentialsForms:47]ProcessSpec:23
[Job_Forms:42]ShortGrain:48:=[Estimates_DifferentialsForms:47]ShortGrain:11  //• 5/23/97 cs upr 1870
[Job_Forms:42]Width:23:=[Estimates_DifferentialsForms:47]Width:5
[Job_Forms:42]Lenth:24:=[Estimates_DifferentialsForms:47]Lenth:6
[Job_Forms:42]Pld_CostTtlLabor:20:=[Estimates_DifferentialsForms:47]CostTtlLabor:15
[Job_Forms:42]Pld_CostTtlOH:21:=[Estimates_DifferentialsForms:47]CostTtlOH:16
[Job_Forms:42]Pld_CostTtlMatl:19:=[Estimates_DifferentialsForms:47]CostTtlMatl:17
[Job_Forms:42]Pld_CostTtl:14:=[Estimates_DifferentialsForms:47]CostTtlLabor:15+[Estimates_DifferentialsForms:47]CostTtlOH:16+[Estimates_DifferentialsForms:47]CostTtlMatl:17+[Estimates_DifferentialsForms:47]Cost_Scrap:24
[Job_Forms:42]EstS_ECost:31:=[Estimates_DifferentialsForms:47]Cost_Scrap:24
[Job_Forms:42]EstGrossSheets:27:=[Estimates_DifferentialsForms:47]SheetsQtyGross:19
[Job_Forms:42]1stPressCount:44:=[Job_Forms:42]EstGrossSheets:27  // Modified by: Mel Bohince (1/23/15) 
[Job_Forms:42]EstNetSheets:28:=[Estimates_DifferentialsForms:47]NumberSheets:4
[Job_Forms:42]EstWasteSheets:34:=[Estimates_DifferentialsForms:47]SheetsQtyGross:19-[Estimates_DifferentialsForms:47]NumberSheets:4
[Job_Forms:42]EstCost_M:29:=(([Estimates_DifferentialsForms:47]CostTTL:18/[Estimates_DifferentialsForms:47]SheetsQtyGross:19)*1000)
[Job_Forms:42]ColorStdSheets:60:=[Estimates_DifferentialsForms:47]ColorStdSheets:34
[Job_Forms:42]VersionDate:58:=4D_Current_date
[Job_Forms:42]ModDate:7:=4D_Current_date
[Job_Forms:42]ModWho:8:=<>zResp
[Job_Forms:42]ProjectNumber:56:=pjtId
Job_FormCaliper
If ([Estimates_DifferentialsForms:47]NumberUpOverrid:30#0)
	[Job_Forms:42]NumberUp:26:=[Estimates_DifferentialsForms:47]NumberUpOverrid:30
End if 

[Job_Forms:42]QtyWant:22:=0  // `aka want
[Job_Forms:42]QtyYield:30:=0  //   aka yield
[Job_Forms:42]EstCost_M:29:=0  //  
[Job_Forms:42]SubForms:61:=[Estimates_DifferentialsForms:47]Subforms:31  //• mlb - 6/3/02  12:04
[Job_Forms:42]OutlineNumber:65:=Job_getDieIdentifier  // • mel (12/9/04, 10:51:43)

<>RecordSaved:=True:C214
ON ERR CALL:C155("eSaveRecError")
SAVE RECORD:C53([Job_Forms:42])

$err:=Shuttle_Register("job"; [Job_Forms:42]JobFormID:5)

ON ERR CALL:C155("")
If (Not:C34(<>RecordSaved))
	BEEP:C151
	ALERT:C41("Form "+String:C10($1; "00000")+"."+String:C10([Estimates_DifferentialsForms:47]FormNumber:2; "00")+" was not updated because it was in use. ")
	<>RecordSaved:=True:C214  //just reset this
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$jobform)
End if 