//%attributes = {"publishedWeb":true}
//Procedure: qryJobComponent(jobform;sortType)  090898  MLB
//get a jobforms relavent records

C_TEXT:C284($1; $jobForm)

$jobForm:=$1

If (Length:C16($jobForm)>5)
	//*Get the parent
	QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=Num:C11(Substring:C12($jobForm; 1; 5)))
	
	//*Get the MTs, IT, and FGs for the job
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$jobForm)
	QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=$jobForm)
	
	//*Get the MachTicks
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1=$jobForm)
	ORDER BY:C49([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Sequence:3; >)
	
	//*Get the Issues
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue"; *)
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]JobForm:12=$jobForm)
	//SORT SELECTION([RM_XFER];[RM_XFER]XferDate;>)
	
	//Get WIP relief
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]JobForm:5=$jobForm; *)
	QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Receipt")
	//
	Case of 
		: ($2=0)
			//no sort
		: ($2=1)  //cronological sort
			
	End case 
	
Else 
	//REDUCE SELECTION(;0)
	REDUCE SELECTION:C351([Jobs:15]; 0)
	REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
	REDUCE SELECTION:C351([Job_Forms_Machine_Tickets:61]; 0)
	REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
	REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)
End if 