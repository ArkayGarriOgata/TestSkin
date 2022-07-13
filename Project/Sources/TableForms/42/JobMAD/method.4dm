//(LP)[jobform]JobMAD
//•070299  mlb  
Case of 
		
	: (Form event code:C388=On Printing Detail:K2:18)
		MESSAGES OFF:C175
		qryJMI([Job_Forms:42]JobFormID:5; 0; "@")  //•010699  MLB 
		// RELATE MANY([JobForm]JobFormID)
		ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]ItemNumber:7; >)
		
End case 
//