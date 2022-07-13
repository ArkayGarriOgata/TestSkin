//%attributes = {"executedOnServer":true}
// _______
// Method: RM_AllocateBoard_eos   ( ) ->
// By: MelvinBohince @ 02/25/22, 15:09:54
// Description
// test all the board (01 & 20) budgeted (jobform_materials) for open and plnnr released jobs
//.  if issued against, update the issue qty if necessary, but don't do anything else
//. create an allocation if necessary
//. then update the qty and date
// ----------------------------------------------------
// Modified by: MelvinBohince (3/15/22) 
// -> use commodity not rmCode when looking for issues and allocations, see lines 38, 48, and 51
// -> only assign the pressdate-7 if a new allocation is created, let RM_AllocationSetDate_eos do it otherwise
// Modified by: MelvinBohince (3/24/22) test and correct allocation r/m code against hte budget
// Modified by: MelvinBohince (3/28/22) log was missing job# when more than 1 allocation

C_TEXT:C284($note)  //commodites that allocate

C_COLLECTION:C1488($board)
$board:=New collection:C1472("01@"; "20@")

C_DATE:C307($dateNotSet; $suggestedDate)
$dateNotSet:=<>MAGIC_DATE  //so it floats to the future

C_LONGINT:C283($leadTimeBoard)
$leadTimeBoard:=-7  //days before printing

C_BOOLEAN:C305($save)  //only save if changes

C_REAL:C285($qtyIssuedOnAllocation; $qtyIssuedOnTransactions)

C_OBJECT:C1216($jfm_o; $jfm_es; $issueTransactions_es; $allocation_e; $currentAllocations_es; $jobMasterSchedule_es; $jobMasterSchedule_e; $status_o)

$jobMasterSchedule_es:=ds:C1482.Job_Forms_Master_Schedule.query("DateComplete = :1"; !00-00-00!)  //used to get the Press date

//get all the board budgeted to open and released jobs
$jfm_es:=ds:C1482.Job_Forms_Materials.query("JOB_FORM.Completed = :1 and JOB_FORM.PlnnerReleased # :2 and Commodity_Key in :3"; !00-00-00!; !00-00-00!; $board).orderBy("JobForm")  //needed until printing is complete

utl_LogfileServer("RMBD"; "RM_AllocateBoard_eos Starting on "+String:C10($jfm_es.length)+" Job_Forms_Materials"; "rm_allocation.log")

For each ($jfm_o; $jfm_es)  //test if it has an allocation record
	
	$save:=False:C215  //only save if changes
	$note:=""
	
	//get all (any) allocations already made for this r/m on this job, need with or without issue transactions
	$currentAllocations_es:=ds:C1482.Raw_Materials_Allocations.query("JobForm = :1 and commdityKey in :2"; $jfm_o.JobForm; $board)  //test against the current allocation// Modified by: MelvinBohince (3/15/22)  use commodity not rmCode
	
	//get all (any) issues of board to this job
	$issueTransactions_es:=ds:C1482.Raw_Materials_Transactions.query("JobForm = :1 and Commodity_Key in :2  and Xfer_Type = :3"; $jfm_o.JobForm; $board; "issue")  // Modified by: MelvinBohince (3/15/22)  use commodity not rmCode
	
	If ($issueTransactions_es.length=0)  //since it hasn't been issued, see if the allocated qty is suffient
		
		$jobMasterSchedule_e:=$jobMasterSchedule_es.query("JobForm = :1"; $jfm_o.JobForm).first()
		
		Case of 
				// first check if needed based on JML's printed date
			: ($jobMasterSchedule_e=Null:C1517)  // Modified by: MelvinBohince (3/15/22) shouldn't happen
				$allocation_e:=Null:C1517
				$note:=$note+" NO JML RECORD "
				$logId:=txt_Pad($jfm_o.JobForm; " "; 1; 10)+txt_Pad($jfm_o.commdityKey; " "; 1; 22)+txt_Pad($jfm_o.Raw_Matl_Code; " "; 1; 22)
				utl_LogfileServer("RMBD"; txt_Pad("ERROR:"; " "; 1; 7)+$logId+$note; "rm_allocation.log")
				
			: ($jobMasterSchedule_e.Printed#!00-00-00!)  //already printed, don't make an allocation
				$allocation_e:=Null:C1517
				$note:=$note+"already printed, "
				If ($currentAllocations_es.length>0)
					$note:=$note+String:C10($currentAllocations_es.sum("Qty_Allocated"))+" should be removed"
				End if 
				$logId:=txt_Pad($jfm_o.JobForm; " "; 1; 10)+txt_Pad($jfm_o.commdityKey; " "; 1; 22)+txt_Pad($jfm_o.Raw_Matl_Code; " "; 1; 22)
				utl_LogfileServer("RMBD"; txt_Pad("WARNING:"; " "; 1; 7)+$logId+$note; "rm_allocation.log")
				
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
				
				//base the date needed to be a week before the jml's Press date, or float it out to xmas
				If ($jobMasterSchedule_e.PressDate#!00-00-00!)
					$allocation_e.Date_Allocated:=Add to date:C393($jobMasterSchedule_e.PressDate; 0; 0; $leadTimeBoard)
				Else 
					$allocation_e.Date_Allocated:=$dateNotSet
				End if 
				
				$allocation_e.Qty_Allocated:=0  //start fresh, get it below
				
				$note:="new "
				
				$save:=True:C214
				
			: ($currentAllocations_es.length=1)  //use existing
				$note:="existing "
				$allocation_e:=$currentAllocations_es.first()
				
			Else   //oh oh, more than one and sequence is not available
				
				$allocation_e:=$currentAllocations_es.first()  // Modified by: MelvinBohince (3/28/22) log was missing job#. //just to get the jobform
				$logId:=txt_Pad($allocation_e.JobForm; " "; 1; 10)+txt_Pad($allocation_e.commdityKey; " "; 1; 22)+txt_Pad($allocation_e.Raw_Matl_Code; " "; 1; 22)
				$note:=$note+"more than one allocation for this r/m budget"
				utl_LogfileServer("RMBD"; txt_Pad("ERROR:"; " "; 1; 7)+$logId+$note; "rm_allocation.log")
				$allocation_e:=Null:C1517  //don't continue
				
		End case 
		
		If ($allocation_e#Null:C1517)  //& ($currentAllocations_es.length<2)  //update the allocation 
			
			//QUANTITY
			If ($allocation_e.Qty_Allocated#$jfm_o.Planned_Qty)  //qty change
				$note:=$note+String:C10($allocation_e.Qty_Allocated)+" chg to "+String:C10($jfm_o.Planned_Qty)+" "
				$allocation_e.Qty_Allocated:=$jfm_o.Planned_Qty
				$save:=True:C214
			End if 
			
			//R/M Code // added Modified by: MelvinBohince (3/24/22) someone changing on jobform without rev'g the job
			If ($allocation_e.Raw_Matl_Code#$jfm_o.Raw_Matl_Code)  //rm code change
				$note:=$note+$allocation_e.Raw_Matl_Code+" chg to "+$jfm_o.Raw_Matl_Code+" "
				$allocation_e.Raw_Matl_Code:=$jfm_o.Raw_Matl_Code
				$save:=True:C214
			End if 
			
			If (False:C215)  // Removed by: MelvinBohince (3/15/22) let RM_AllocationSetDate_eos deal with dates
				//DATE, see version 2022-03-07 or earlier
			End if 
			
			
			If ($save)  //save a change to date or qty
				$allocation_e.ModDate:=Current date:C33
				$allocation_e.ModWho:="RMBD"
				$status_o:=$allocation_e.save(dk auto merge:K85:24)
				
				$logId:=txt_Pad($allocation_e.JobForm; " "; 1; 10)+txt_Pad($allocation_e.commdityKey; " "; 1; 22)+txt_Pad($allocation_e.Raw_Matl_Code; " "; 1; 22)
				If ($status_o.success)
					utl_LogfileServer("RMBD"; txt_Pad("SUCCESS:"; " "; 1; 7)+$logId+$note; "rm_allocation.log")
				Else 
					utl_LogfileServer("RMBD"; txt_Pad("FAILED:"; " "; 1; 7)+$logId+$note; "rm_allocation.log")
				End if 
			End if   //save
			
		End if   //$allocation_e !null
		
	Else   //. ISSUES found, test and make the amount issued matches the transactions
		
		//want the issues on the allocation rec to match the transactions
		$qtyIssuedOnTransactions:=$issueTransactions_es.sum("Qty")
		If ($qtyIssuedOnTransactions<0)  //issues are negative,
			$qtyIssuedOnTransactions:=-1*$qtyIssuedOnTransactions  //flip the sign
			
			//update the Qty_Issued on the allocation record if necessary
			If ($currentAllocations_es.length>0)  //not already deleted
				$qtyIssuedOnAllocation:=$currentAllocations_es.sum("Qty_Issued")
				
				If ($qtyIssuedOnTransactions#$qtyIssuedOnAllocation)  //rare but possible more than one coldfoil allocation to the job
					$note:="issue of "+String:C10($qtyIssuedOnAllocation)+" chg to "+String:C10($qtyIssuedOnTransactions)
					$allocation_e:=$currentAllocations_es.first()
					$allocation_e.Qty_Issued:=$qtyIssuedOnTransactions
					$allocation_e.ModDate:=Current date:C33
					$allocation_e.ModWho:="RMBD"
					$status_o:=$allocation_e.save(dk auto merge:K85:24)
					
					$logId:=txt_Pad($allocation_e.JobForm; " "; 1; 10)+txt_Pad($allocation_e.commdityKey; " "; 1; 22)+txt_Pad($allocation_e.Raw_Matl_Code; " "; 1; 22)
					If ($status_o.success)
						utl_LogfileServer("RMBD"; txt_Pad("SUCCESS:"; " "; 1; 7)+$logId+$note; "rm_allocation.log")
					Else 
						utl_LogfileServer("RMBD"; txt_Pad("FAILED:"; " "; 1; 7)+$logId+$note; "rm_allocation.log")
					End if 
				End if 
				
			End if 
			
		End if   //qty issued>0
		
	End if   //issued materials
	
End for each   //job matl record

utl_LogfileServer("RMBD"; "RM_AllocateBoard_eos Finished"; "rm_allocation.log")