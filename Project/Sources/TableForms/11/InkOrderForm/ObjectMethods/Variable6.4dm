//(s) sJobForm
//• 6/29/98 cs added code for Run location
sJobForm:=[Purchase_Orders:11]DefaultJobId:3

If ([Job_Forms:42]JobFormID:5#[Purchase_Orders:11]DefaultJobId:3)  //• 6/29/98 cs 
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=[Purchase_Orders:11]DefaultJobId:3)
	t3a:=[Job_Forms:42]Run_Location:55
End if 
//
