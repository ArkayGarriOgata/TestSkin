//COPY NAMED SELECTION([Job_Forms_Items];"holdJMI")
sLink_Js_to_Os("FromJobs")
If (ok=1)
	ARRAY TO SELECTION:C261(asJOrderID; [Job_Forms_Items:44]OrderItem:2)
	//$numrec:=Records in selection([Job_Forms_Items])
	//For ($i;1;$numrec)
	//USE NAMED SELECTION("holdJMI")
	//QUERY SELECTION([Job_Forms_Items];[Job_Forms_Items]ItemNumber=aJobItem{$i})
	//If (Records in selection([Job_Forms_Items])>0)
	//If (asJOrderID{$i}#[Job_Forms_Items]OrderItem)  `then we need to save this change
	//[Job_Forms_Items]OrderItem:=asJOrderID{$i}
	//SAVE RECORD([Job_Forms_Items])
	//End if 
	//End if 
	//End for 
End if 

//USE NAMED SELECTION("holdJMI")
//CLEAR NAMED SELECTION("holdJMI")


//eos