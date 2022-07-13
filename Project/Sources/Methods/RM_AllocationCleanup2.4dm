//%attributes = {}
// _______
// Method: RM_AllocationCleanup2   ( ) ->
// By: MelvinBohince @ 02/17/22, 15:52:21
// Description
//search for each condition below, if allocations found, concatenate to a selection
//   and drop at the end. Do some logging as you go

//remove  allocations that have been fulfilled
//remove  allocations that the jml has completed, or orphaned
//remove allocation if the jobform is Closed
//remove board /plastic allocation if the job has printed or is a no-print
//remove duplicates (coldfoil) that point back to a r/m that isn't budgeted
// ----------------------------------------------------
// Modified by: MelvinBohince (3/24/22) with cold foil, forget r/m code, remove if no coldfoil in budget, duplicates must be allowed for multi row and multi pass

utl_LogfileServer("RMCU"; "RM_AllocationCleanup2"; "rm_allocation.log")

C_TEXT:C284($noteWhy)  //hint added to logfile

//remove  allocations that have been fulfilled
C_OBJECT:C1216($rma_e; $rmaToRemove; $formula_o; $notDropped_e; $fullyIssued; $completedJobs; $closedJobs; $noPrinting; $coldfoilAllocations_es; $jfm_es)

$rmaToRemove:=ds:C1482.Raw_Materials_Allocations.newSelection()  //build this as we go in a for/each loop of allocations that are not needed

$formula_o:=Formula:C1597(This:C1470.Qty_Issued>=This:C1470.Qty_Allocated)
$fullyIssued:=ds:C1482.Raw_Materials_Allocations.query(":1"; $formula_o)
If ($fullyIssued.length>0)
	
	$noteWhy:=txt_Pad("Removing fully issued:"; " "; 1; 23)
	For each ($rma_e; $fullyIssued)
		$rmaToRemove.add($rma_e)
		utl_LogfileServer("RMCU"; $noteWhy+txt_Pad($rma_e.commdityKey; " "; 1; 23)+txt_Pad($rma_e.Raw_Matl_Code; " "; 1; 23)+$rma_e.JobForm; "rm_allocation.log")
	End for each 
	
End if 

//remove  allocations that the jml has completed, or orphaned
//when a jml is dated as complete, it should have already deleted the allocations

C_COLLECTION:C1488($jobsStillOpen_c; $substrate_c)
$jobsStillOpen_c:=ds:C1482.Job_Forms_Master_Schedule.query("DateComplete = :1"; !00-00-00!).toCollection("JobForm").extract("JobForm")

$completedJobs:=ds:C1482.Raw_Materials_Allocations.query("not(JobForm in :1)"; $jobsStillOpen_c)  //.orderBy("JobForm")
If ($completedJobs.length>0)
	
	$noteWhy:=txt_Pad("Removing completed:"; " "; 1; 23)
	For each ($rma_e; $completedJobs)
		$rmaToRemove.add($rma_e)
		utl_LogfileServer("RMCU"; $noteWhy+txt_Pad($rma_e.commdityKey; " "; 1; 23)+txt_Pad($rma_e.Raw_Matl_Code; " "; 1; 23)+$rma_e.JobForm; "rm_allocation.log")
	End for each 
	
End if 

//remove allocation if the jobform is Closed, should not happen as completing deletes allocations
$jobsStillOpen_c:=ds:C1482.Job_Forms.query("ClosedDate = :1"; !00-00-00!).toCollection("JobFormID").extract("JobFormID")

$closedJobs:=ds:C1482.Raw_Materials_Allocations.query("not(JobForm in :1)"; $jobsStillOpen_c)  //.orderBy("JobForm")
If ($closedJobs.length>0)
	
	$noteWhy:=txt_Pad("Removing closed:"; " "; 1; 23)
	For each ($rma_e; $closedJobs)
		$rmaToRemove.add($rma_e)
		utl_LogfileServer("RMCU"; $noteWhy+txt_Pad($rma_e.commdityKey; " "; 1; 23)+txt_Pad($rma_e.Raw_Matl_Code; " "; 1; 23)+$rma_e.JobForm; "rm_allocation.log")
	End for each 
	
End if 

//remove board /plastic allocation if the job has printed or is a no-print
$substrate_c:=New collection:C1472("01@"; "20@")

$jobsStillOpen_c:=ds:C1482.Job_Forms_Master_Schedule.query("(Printed = :1 or Printed = :2) and DateComplete = :3"; !00-00-00!; !2001-01-01!; !00-00-00!).toCollection("JobForm").extract("JobForm")

$noPrinting:=ds:C1482.Raw_Materials_Allocations.query("commdityKey in :1 and not(JobForm in :2)"; $substrate_c; $jobsStillOpen_c)  //.orderBy("JobForm")
If ($noPrinting.length>0)
	
	$noteWhy:=txt_Pad("Removing printed:"; " "; 1; 23)
	For each ($rma_e; $noPrinting)
		$rmaToRemove.add($rma_e)
		utl_LogfileServer("RMCU"; $noteWhy+txt_Pad($rma_e.commdityKey; " "; 1; 23)+txt_Pad($rma_e.Raw_Matl_Code; " "; 1; 23)+$rma_e.JobForm; "rm_allocation.log")
	End for each 
	
End if 

//look for duplicates that point back to a r/m that isn't budgeted
// Modified by: MelvinBohince (3/24/22) forget r/m code, remove if no coldfoil in budget, duplicates must be allowed for multi row and multi pass
$noteWhy:=txt_Pad("Removing duplicate:"; " "; 1; 23)
$coldfoilAllocations_es:=ds:C1482.Raw_Materials_Allocations.query("commdityKey = :1"; "09@").orderBy("JobForm")
For each ($rma_e; $coldfoilAllocations_es)
	//$jfm_es:=ds.Job_Forms_Materials.query("JobForm = :1 and Raw_Matl_Code = :2";$rma_e.JobForm;$rma_e.Raw_Matl_Code) // Modified by: MelvinBohince (3/24/22)
	$jfm_es:=ds:C1482.Job_Forms_Materials.query("JobForm = :1 and Commodity_Key = :2"; $rma_e.JobForm; "09@")  // Modified by: MelvinBohince (3/24/22)
	If ($jfm_es.length=0)  //not cool
		$rmaToRemove.add($rma_e)
		utl_LogfileServer("RMCU"; $noteWhy+txt_Pad($rma_e.commdityKey; " "; 1; 23)+txt_Pad($rma_e.Raw_Matl_Code; " "; 1; 23)+$rma_e.JobForm; "rm_allocation.log")
	End if 
End for each 


If ($rmaToRemove.length>0)
	utl_LogfileServer("RMCU"; "Removed: "+String:C10($rmaToRemove.length)+" allocations"; "rm_allocation.log")
	$notDropped_e:=$rmaToRemove.drop()  //get then next time if locked
	If ($notDropped_e.length>0)
		utl_LogfileServer("RMCU"; "FAIL: "+String:C10($notDropped_e.length)+" not dropped"; "rm_allocation.log")
	End if 
	
Else 
	utl_LogfileServer("RMCU"; "None removed."; "rm_allocation.log")
End if 
