//%attributes = {"publishedWeb":true}
//Procedure: qryJobsInWIP($end)  090898  MLB
//find the open jobs in wip given an end date
//beginning date is not relavent, it is controlled by carring a Begining bal in WI
// • mel (5/12/05, 10:26:04) don' t include blocked time
// Modified by: Mel Bohince (7/13/15) only include production jobs
// Modified by: Mel Bohince (4/14/16) show non production, exclude null start date
If (Count parameters:C259=1)
	$endDate:=$1
Else 
	$endDate:=Date:C102(Request:C163("End date:"))
End if 

QUERY:C277([Job_Forms:42]; [Job_Forms:42]Completed:18>$endDate; *)  //was open in period of interest
QUERY:C277([Job_Forms:42];  | ; [Job_Forms:42]Completed:18=!00-00-00!; *)  //still in production
QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]StartDate:10<=$endDate; *)  //didn't start after period of interest
QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]StartDate:10#!00-00-00!; *)
//QUERY([Job_Forms]; & ;[Job_Forms]JobType="3@";*)  // Modified by: Mel Bohince (7/13/15) 
QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]Status:6#"Closed")
//QUERY([JobForm]; & ;[JobForm]Status # "Complete";*)
//QUERY([JobForm]; & ;[JobForm]Status # "Kill";*)
//QUERY([JobForm]; & ;[JobForm]Status # "Cancel")
//SEARCH([JobForm]; & ;[JobForm]NeedDate>!11/01/97!)  `looks to old, data problem