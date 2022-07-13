//%attributes = {"publishedWeb":true}
//PM:  JML_newViaJobobform;pressdate;madDate;comment;{[ESTIMATE]Sales_Rep;[ESTI
//create a jml JobTracking Record when job is created
//•2/26/01  mlb  don't init the MAD date

QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=$1)  //1/26/95
If (Records in selection:C76([Job_Forms_Master_Schedule:67])=0)
	CREATE RECORD:C68([Job_Forms_Master_Schedule:67])
	[Job_Forms_Master_Schedule:67]JobForm:4:=$1
	[Job_Forms_Master_Schedule:67]Customer:2:=[Jobs:15]CustomerName:5
	[Job_Forms_Master_Schedule:67]Salesman:1:=[Customers:16]SalesmanID:3
	[Job_Forms_Master_Schedule:67]Line:5:=[Jobs:15]Line:3
	[Job_Forms_Master_Schedule:67]Comment:22:=""  //"Created when planning form "+[JobForm]JobFormID
	If (Length:C16([Estimates:17]ProjectNumber:63)=5)
		[Job_Forms_Master_Schedule:67]ProjectNumber:26:=[Estimates:17]ProjectNumber:63
	Else 
		[Job_Forms_Master_Schedule:67]ProjectNumber:26:=Substring:C12([Jobs:15]EstimateNo:6; 1; 6)
	End if 
	[Job_Forms_Master_Schedule:67]PressDate:25:=$2
	
	//[JobMasterLog]MAD:=$3
	//If ([JobMasterLog]MAD=!00/00/00!)
	//[JobMasterLog]MAD:=[JobForm]NeedDate
	//End if 
	[Job_Forms_Master_Schedule:67]Comment:22:=$4
	
	If (Count parameters:C259>4)
		[Job_Forms_Master_Schedule:67]Salesman:1:=$5
		[Job_Forms_Master_Schedule:67]Line:5:=$6
	End if 
	
	If (Count parameters:C259>7)  //•083002  mlb  
		[Job_Forms_Master_Schedule:67]LocationOfMfg:30:=$8
	End if 
	[Job_Forms_Master_Schedule:67]JobType:31:=[Job_Forms:42]JobType:33
	
	If (Count parameters:C259>8)  // Modified by: Mel Bohince (10/2/18) 
		[Job_Forms_Master_Schedule:67]EarliestStart_PrintFlow:90:=Add to date:C393($9; 0; 0; 14)
	End if 
	
	If (Length:C16([Job_Forms_Master_Schedule:67]Salesman:1)=0)
		READ ONLY:C145([Customers:16])
		QUERY:C277([Customers:16]; [Customers:16]ID:1=[Jobs:15]CustID:2)
		[Job_Forms_Master_Schedule:67]Salesman:1:=[Customers:16]SalesmanID:3
		REDUCE SELECTION:C351([Customers:16]; 0)
	End if 
	
	SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
End if 
zwStatusMsg("Job Track"; [Job_Forms_Master_Schedule:67]ProjectNumber:26+" was entered in the the JobMasterLog")

//REDUCE SELECTION([JobMasterLog];0)
UNLOAD RECORD:C212([Job_Forms_Master_Schedule:67])  //• mlb - 7/30/02  15:45