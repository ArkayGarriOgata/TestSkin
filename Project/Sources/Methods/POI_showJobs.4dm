//%attributes = {"publishedWeb":true}
//POI_showJobs(poItem#) 040202

READ ONLY:C145([Purchase_Orders_Job_forms:59])
QUERY:C277([Purchase_Orders_Job_forms:59]; [Purchase_Orders_Job_forms:59]POItemKey:1=$1)
If (Records in selection:C76([Purchase_Orders_Job_forms:59])>0)
	$msg:=$1+" is a Direct Purchase for: "
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		
		For ($i; 1; Records in selection:C76([Purchase_Orders_Job_forms:59]))
			$msg:=$msg+[Purchase_Orders_Job_forms:59]JobFormID:2+" "
			NEXT RECORD:C51([Purchase_Orders_Job_forms:59])
		End for 
		
		
	Else 
		
		ARRAY TEXT:C222(JobFormID; 0)
		SELECTION TO ARRAY:C260([Purchase_Orders_Job_forms:59]JobFormID:2; $_JobFormID)
		
		For ($i; 1; Size of array:C274(JobFormID); 1)
			$msg:=$msg+JobFormID{$i}+" "
		End for 
		
		
	End if   // END 4D Professional Services : January 2019 First record
	
	zwStatusMsg("DIRECT PURCHASE"; $msg)
	
Else 
	uConfirm("No jobs set up for this direct purchase item! "+" Do not receive "+$1+" until this is corrected."; "OK"; "Help")
End if 