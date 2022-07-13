//%attributes = {"executedOnServer":true}
// _______
// Method: RM_AllocateColdFoil_eos  ( ) ->
// By: MelvinBohince @ 02/18/22, 07:08:03
// Description
// test all the coldfoil budgeted (jobform_materials) for open and released jobs
//.  ignore if that budget has been issued against
//. create an allocation if necessary
//. then update the qty and date
//. note this is commodity based, not rm_code based
// ----------------------------------------------------



C_TEXT:C284($coldfoil; $jobSequence; $note; $lastJobform)  //commodites that allocate
$coldfoil:="09@"

C_DATE:C307($dateNotSet; $printingStartDate; $suggestedDate)
$dateNotSet:=<>MAGIC_DATE  //so it floats to the future

C_LONGINT:C283($leadTimeFoil)  // Modified by: MelvinBohince (2/27/22) 
$leadTimeFoil:=-1  //days before press 

C_BOOLEAN:C305($save; $useFirstDate)  //only save if changes

C_REAL:C285($_Qty_Issued; $qtyIssued)

C_OBJECT:C1216($jfm_o; $jfm_es; $issueTransactions_es; $allocation_e; $currentAllocations_es; $ps_e; $status_o)

//get all the cold foil budgeted to open  and released jobs
$jfm_es:=ds:C1482.Job_Forms_Materials.query("JOB_FORM.Completed = :1 and JOB_FORM.PlnnerReleased # :2 and Commodity_Key = :3"; !00-00-00!; !00-00-00!; $coldfoil).orderBy("JobForm, Sequence")  //needed until printing is complete

//C_COLLECTION($jf_c)
//$jf_c:=$jfm_es.distinct("JobForm")

utl_LogfileServer("RMCF"; "RM_AllocateColdFoil_eos Starting on "+String:C10($jfm_es.length)+" Job_Forms_Materials"; "rm_allocation.log")
$lastJobform:=""

For each ($jfm_o; $jfm_es)  //test if it has an allocation record
	
	//if($jfm_o.JobForm="18463.01")//this is a job that is using 2 rolls side by side so looks like a duplicate
	//        the estimate enging should make one material record and its qty should be the sum of the rolls
	//End if 
	//If (position($jfm_o.JobForm;"18163.04 18210.02")>0)
	
	//End if
	
	If ($lastJobform#$jfm_o.JobForm)  //job can have more than 1 sequence with coldfoil, only use the earliest date found on the press schedule
		$lastJobform:=$jfm_o.JobForm
		$useFirstDate:=True:C214
	Else 
		$useFirstDate:=False:C215  //use the date of the earlier sequence
	End if 
	
	$save:=False:C215  //only save if changes
	$note:=""
	
	//get all (any) allocations already made for cold foil on this job, need with or without issue transactions
	$currentAllocations_es:=ds:C1482.Raw_Materials_Allocations.query("JobForm = :1 and commdityKey = :2"; $jfm_o.JobForm; $coldfoil)  //test against the current allocation
	
	//get all (any) issues of cold foil to this job
	$issueTransactions_es:=ds:C1482.Raw_Materials_Transactions.query("JobForm = :1 and Sequence = :2 and Commodity_Key = :3 and Xfer_Type = :4"; $jfm_o.JobForm; $jfm_o.Sequence; $coldfoil; "issue")  // not going to chg if already issued
	If ($issueTransactions_es.length=0)  //since it hasn't been issued, see if the allocated qty is suffient
		
		
		Case of 
			: ($currentAllocations_es.length=0)  //create
				$allocation_e:=ds:C1482.Raw_Materials_Allocations.new()
				$allocation_e.JobForm:=$jfm_o.JobForm
				$allocation_e.CustID:=$jfm_o.JOB_FORM.cust_id
				
				$allocation_e.zCount:=1
				$allocation_e.commdityKey:=$jfm_o.Commodity_Key
				If (Length:C16($jfm_o.Raw_Matl_Code)>0)  //rm specified
					$allocation_e.Raw_Matl_Code:=$jfm_o.Raw_Matl_Code
				End if 
				$allocation_e.UOM:=$jfm_o.UOM
				$note:="new "
				
			: ($currentAllocations_es.length=1)  //use existing
				$note:="existing "
				$allocation_e:=$currentAllocations_es.first()
				
			Else   //oh oh, more than one and sequence is not available
				
				$currentAllocations_es:=$currentAllocations_es.query("Raw_Matl_Code = :1"; $jfm_o.Raw_Matl_Code)  //are the r/m code different?
				If ($currentAllocations_es.length=1)  //use existing
					$note:="existing "
					$allocation_e:=$currentAllocations_es.first()
					
				Else   //skip this one
					$allocation_e:=$currentAllocations_es.first()
					$logId:=txt_Pad($allocation_e.JobForm; " "; 1; 10)+txt_Pad($allocation_e.commdityKey; " "; 1; 22)+txt_Pad($allocation_e.Raw_Matl_Code; " "; 1; 22)
					utl_LogfileServer("RMCF"; txt_Pad("FAILED:"; " "; 1; 7)+$logId+"oh oh, more than one allocation"; "rm_allocation.log")
				End if 
				
		End case 
		
		If ($allocation_e#Null:C1517) & ($currentAllocations_es.length<2)  //update the allocation 
			
			//QUANTITY
			If ($allocation_e.Qty_Allocated#$jfm_o.Planned_Qty)  //qty change
				$note:=$note+String:C10($allocation_e.Qty_Allocated)+" chg to "+String:C10($jfm_o.Planned_Qty)+" "
				$allocation_e.Qty_Allocated:=$jfm_o.Planned_Qty
				$save:=True:C214
			End if 
			
			//DATE
			//get a press date from the production sched for this jobsequence if not already printed
			$jobSequence:=$jfm_o.JobForm+"."+String:C10($jfm_o.Sequence; "000")
			$ps_e:=ds:C1482.ProductionSchedules.query("JobSequence = :1 and Completed = :2"; $jobSequence; 0).first()
			
			If ($ps_e#Null:C1517)  //found a press seq in the schedule
				If ($useFirstDate)
					$printingStartDate:=$ps_e.StartDate  //go with the day before
				End if 
				
			Else   //not scheduled, clear the allocation
				$printingStartDate:=$dateNotSet
			End if 
			
			$suggestedDate:=Add to date:C393($printingStartDate; 0; 0; $leadTimeFoil)  // Modified by: MelvinBohince (2/27/22) 
			
			If ($allocation_e.Date_Allocated#$suggestedDate)  //date change
				$allocation_e.Date_Prior:=$allocation_e.Date_Allocated  //backup
				$note:=$note+String:C10($allocation_e.Date_Allocated; Internal date short special:K1:4)+" chg to "+String:C10($suggestedDate; Internal date short special:K1:4)
				$allocation_e.Date_Allocated:=$suggestedDate
				$save:=True:C214
			End if 
			
			If ($save)  //save a change to date or qty
				$allocation_e.ModDate:=Current date:C33
				$allocation_e.ModWho:="RMCF"
				$status_o:=$allocation_e.save(dk auto merge:K85:24)
				
				$logId:=txt_Pad($allocation_e.JobForm; " "; 1; 10)+txt_Pad($allocation_e.commdityKey; " "; 1; 22)+txt_Pad($allocation_e.Raw_Matl_Code; " "; 1; 22)
				If ($status_o.success)
					utl_LogfileServer("RMCF"; txt_Pad("SUCCESS:"; " "; 1; 7)+$logId+$note; "rm_allocation.log")
				Else 
					utl_LogfileServer("RMCF"; txt_Pad("FAILED:"; " "; 1; 7)+$logId+$note; "rm_allocation.log")
				End if 
			End if   //save
			
		End if   //$allocation_e !null
		
	Else   //issues found, test and make the amount issued matches the transactions
		//want the issues on the allocation rec to match the transactions
		$qtyIssued:=$issueTransactions_es.sum("Qty")
		If ($qtyIssued<0)  //issues are negative,
			$qtyIssued:=-1*$qtyIssued  //flip the sign
			//update the Qty_Issued on the allocation record if necessary
			If ($currentAllocations_es.length>0)  //not already deleted
				$_Qty_Issued:=$currentAllocations_es.sum("Qty_Issued")
				If ($qtyIssued#$_Qty_Issued)  //rare but possible more than one coldfoil allocation to the job
					$note:="issue of "+String:C10($_Qty_Issued)+" chg to "+String:C10($qtyIssued)
					$allocation_e:=$currentAllocations_es.first()
					$allocation_e.Qty_Issued:=$qtyIssued
					$allocation_e.ModDate:=Current date:C33
					$allocation_e.ModWho:="RMCF"
					$status_o:=$allocation_e.save(dk auto merge:K85:24)
					
					$logId:=txt_Pad($allocation_e.JobForm; " "; 1; 10)+txt_Pad($allocation_e.commdityKey; " "; 1; 22)+txt_Pad($allocation_e.Raw_Matl_Code; " "; 1; 22)
					If ($status_o.success)
						utl_LogfileServer("RMCF"; txt_Pad("SUCCESS:"; " "; 1; 7)+$logId+$note; "rm_allocation.log")
					Else 
						utl_LogfileServer("RMCF"; txt_Pad("FAILED:"; " "; 1; 7)+$logId+$note; "rm_allocation.log")
					End if 
				End if 
				
			End if 
			
		End if   //qty issued>0
		
	End if   //issued materials
	
End for each   //job matl record

utl_LogfileServer("RMCF"; "RM_AllocateColdFoil_eos Finished"; "rm_allocation.log")