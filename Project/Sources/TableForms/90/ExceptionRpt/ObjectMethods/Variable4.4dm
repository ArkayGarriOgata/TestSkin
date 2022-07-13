//(s) xText
//set and display the type of exception 
//• 11/5/97 cs created
//• 6/26/98 cs new exception  - not enough qty on hand
//• 7/31/98 cs new exception  - no jobform
Case of 
	: ([Job_Forms_Issue_Tickets:90]Posted:4=2)
		Self:C308->:="Invalid PO Item - No Material adjustment done"
	: ([Job_Forms_Issue_Tickets:90]Posted:4=3)
		Self:C308->:="No Material bin found, issue posted, bin created with negative inventory"
	: ([Job_Forms_Issue_Tickets:90]Posted:4=4)  //• 6/26/98 cs new exception  - not enough qty on hand
		Self:C308->:="Not enough material on hand to cover requested issue amount.  "+"No material adjustment done"
	: ([Job_Forms_Issue_Tickets:90]Posted:4=5)  //• 7/31/98 cs new exception  - no jobform
		Self:C308->:="No JOBFORM found - Invalid Job Form ID.  "+"No material adjustment done"
End case 
//