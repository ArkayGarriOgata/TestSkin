//%attributes = {"publishedWeb":true}
//JML_checkForPreFlight
//*Init files and vars

MESSAGES OFF:C175

READ WRITE:C146([Job_Forms_Master_Schedule:67])
READ ONLY:C145([Job_Forms_Items:44])

//*   Load Job Items  
zwStatusMsg("JobMaster Update"; " Getting the Job items...on "+[Job_Forms_Master_Schedule:67]JobForm:4)
qryJMI([Job_Forms_Master_Schedule:67]JobForm:4; 0; "@")
If (Records in selection:C76([Job_Forms_Items:44])=0)  //this job has no items (still from estimate)
	REDUCE SELECTION:C351([Finished_Goods:26]; 0)
Else 
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		$custid:=[Job_Forms_Items:44]CustId:15
		uRelateSelect(->[Finished_Goods:26]ProductCode:1; ->[Job_Forms_Items:44]ProductCode:3; 0)
		QUERY SELECTION:C341([Finished_Goods:26]; [Finished_Goods:26]CustID:2=$custid)
		
	Else 
		
		//you need to see line 11 before validate this
		
		$custid:=[Job_Forms_Items:44]CustId:15
		
		QUERY:C277([Finished_Goods:26]; [Job_Forms_Items:44]JobForm:1=[Job_Forms_Master_Schedule:67]JobForm:4; *)
		QUERY:C277([Finished_Goods:26]; [Job_Forms_Items:44]ProductCode:3="@"; *)  //5/4/95
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]CustID:2=$custid)
	End if   // END 4D Professional Services : January 2019 query selection
	
End if 

//*   Check if all have been preflighted
If (Records in selection:C76([Finished_Goods:26])>0)  //if there are records found
	zwStatusMsg("JobMaster Update"; " Checking for Preflight..."+[Job_Forms_Master_Schedule:67]JobForm:4)
	QUERY SELECTION:C341([Finished_Goods:26]; [Finished_Goods:26]Preflight:66=False:C215)
	[Job_Forms_Master_Schedule:67]Preflighed:43:=(Records in selection:C76([Finished_Goods:26])=0)  //if there are records then data is incomplete  
End if 
