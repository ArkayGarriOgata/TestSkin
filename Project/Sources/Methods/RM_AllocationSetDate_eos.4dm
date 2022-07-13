//%attributes = {"executedOnServer":true}
// _______
// Method: RM_AllocationSetDate_eos   ( ) ->
// By: MelvinBohince @ 02/24/22, 09:24:56
// Description
// based on RM_AllocationSetToPressDate
//     board or plastic , based on  earlier of mutually agreed date (mad) a.k.a. have ready date (hrd) or press date
//     cold foil, check the pressSchedule
//     sensors, based on mutually agreed date (mad) a.k.a. have ready date (hrd)
// only save if changed, Date_Prior saves original date
// if no JobMaster record open, then clear date and qty
// ----------------------------------------------------
// History
// Modified by: Mel Bohince (3/9/18) use 2 weeks before earlier of Press or HRD, add a backup field
// Modified by: Mel Bohince (3/10/18) use 1 week, exclude com's other than paper and plactic
// Modified by: MelvinBohince (2/14/22) better control over cold foil allocations
// Modified by: MelvinBohince (2/15/22) change to ORDA

C_LONGINT:C283($leadTimeBoard; $leadTimeFoil; $leadTimeSensors)
$leadTimeBoard:=-7  //days before printing
$leadTimeFoil:=-1  //days before press 
$leadTimeSensors:=-4  //days before HRD

C_DATE:C307($dateToUse; $dateNotSet; $jmlPressDate; $jmlMAD)
$dateNotSet:=!00-00-00!  //null date query

C_TEXT:C284($commodity; $daysChg)  //expect 01,20,09, or 12

C_OBJECT:C1216($ps_e; $ps_es)  // Modified by: MelvinBohince (2/14/22) better control over cold foil
C_OBJECT:C1216($jfm_e; $jfm_es)
C_OBJECT:C1216($rma_e; $rma_es; $jobMasterSchedule_es; $jobMasterSchedule_e; $status_o)  // Modified by: MelvinBohince (2/15/22) 

C_COLLECTION:C1488($pressIDs_c)  //for use in .query()
$pressIDs_c:=New collection:C1472
ARRAY TO COLLECTION:C1563($pressIDs_c; <>aPRESSES)
//[Job_Forms_Master_Schedule]DateComplete
$jobMasterSchedule_es:=ds:C1482.Job_Forms_Master_Schedule.query("DateComplete = :1"; $dateNotSet)

$rma_es:=ds:C1482.Raw_Materials_Allocations.all().orderBy("JobForm")
utl_LogfileServer("RMSD"; "RM_AllocationSetToPressDate_eos for "+String:C10($rma_es.length)+" allocation records"; "rm_allocation.log")

For each ($rma_e; $rma_es)
	//If ($rma_e.JobForm="18163.04")
	
	//End if 
	$commodity:=Substring:C12($rma_e.commdityKey; 1; 2)
	$save:=False:C215
	$dateToUse:=<>MAGIC_DATE  //float out in the future if $dateToUse can't be set
	$suggestedDate:=$dateToUse
	
	$logId:=txt_Pad($rma_e.JobForm; " "; 1; 10)+txt_Pad($rma_e.commdityKey; " "; 1; 22)+txt_Pad($rma_e.Raw_Matl_Code; " "; 1; 22)  // for logging
	
	$jobMasterSchedule_e:=$jobMasterSchedule_es.query("JobForm = :1"; $rma_e.JobForm).first()
	If ($jobMasterSchedule_e#Null:C1517)
		
		Case of 
			: (Position:C15($commodity; " 01 20 ")>0)  //board or plastic , based on  earlier of mutually agreed date (mad) a.k.a. have ready date (hrd) or press date
				
				Case of 
					: ((Not:C34(util_isDateNull(->$jmlPressDate))) & (Not:C34(util_isDateNull(->$jmlMAD))))
						If ($jobMasterSchedule_e.PressDate<$jobMasterSchedule_e.MAD)  //earlier of HRD or Print date
							$dateToUse:=$jobMasterSchedule_e.PressDate
						Else 
							$dateToUse:=$jobMasterSchedule_e.MAD
						End if 
						
					: ($jobMasterSchedule_e.PressDate#$dateNotSet)
						$dateToUse:=$jobMasterSchedule_e.PressDate
						
					: ($jobMasterSchedule_e.MAD#$dateNotSet)
						$dateToUse:=$jobMasterSchedule_e.MAD
						
				End case 
				
				If ($dateToUse#$dateNotSet)
					$suggestedDate:=Add to date:C393($dateToUse; 0; 0; $leadTimeBoard)
				End if 
				
			: (Position:C15($commodity; " 09 ")>0)  //cold foil, check the pressSchedule
				
				$ps_es:=ds:C1482.ProductionSchedules.query("JobSequence = :1 and CostCenter in :2 and Completed = :3"; ($rma_e.JobForm+"@"); $pressIDs_c; 0).orderBy("JobSequence")  // Modified by: MelvinBohince (2/27/22) 
				
				Case of   //look for a date to use
					: ($ps_es.length=1)
						$dateToUse:=$ps_es.first().StartDate
						
					: ($ps_es.length>1)
						//make sure the sequence calls for coldfoil, take the earliest
						//$dateToUse:=$dateNotSet
						//$suggestedDate:=$dateNotSet
						
						For each ($ps_e; $ps_es) While ($dateToUse=<>MAGIC_DATE)
							$jfm_es:=ds:C1482.Job_Forms_Materials.query("JobForm = :1 and Sequence = :2 "; Substring:C12($ps_e.JobSequence; 1; 8); Num:C11(Substring:C12($ps_e.JobSequence; 10)))
							
							For each ($jfm_e; $jfm_es)  //test if foil is used
								If ($jfm_e.Commodity_Key=("09@"))
									$dateToUse:=$ps_e.StartDate
								End if 
							End for each   //job material
							
						End for each   //sequence scheduled
						
						//Else   //not scheduled, clear the allocation
						//$dateToUse:=<>MAGIC_DATE
				End case 
				
				$suggestedDate:=Add to date:C393($dateToUse; 0; 0; $leadTimeFoil)
				
			: (Position:C15($commodity; " 12 ")>0)  //sensors, based on mutually agreed date (mad) a.k.a. have ready date (hrd)
				
				If ($jobMasterSchedule_e.MAD#!00-00-00!)
					$suggestedDate:=Add to date:C393($jobMasterSchedule_e.MAD; 0; 0; $leadTimeSensors)
				End if 
				
		End case   //commodity type
		
		If ($rma_e.Date_Allocated#$suggestedDate)  //save
			$rma_e.Date_Prior:=$rma_e.Date_Allocated  //backup
			$rma_e.Date_Allocated:=$suggestedDate
			$rma_e.ModWho:="RM_A"
			$rma_e.ModDate:=Current date:C33
			
			$status_o:=$rma_e.save(dk auto merge:K85:24)
			
			$daysChg:=String:C10($suggestedDate-$rma_e.Date_Prior)
			
			$note:=String:C10($rma_e.Date_Prior; Internal date short special:K1:4)+" to "+String:C10($rma_e.Date_Allocated; Internal date short special:K1:4)+" "+$daysChg
			If ($status_o.success)
				utl_LogfileServer("RMSD"; txt_Pad("SUCCESS:"; " "; 1; 7)+$logId+$note; "rm_allocation.log")
				
			Else 
				utl_LogfileServer("RMSD"; txt_Pad("FAILED:"; " "; 1; 7)+$logId+$note; "rm_allocation.log")
			End if 
		End if 
		
	Else   //no jml, cleanup
		$rma_e.Qty_Allocated:=0
		$rma_e.Date_Prior:=$rma_e.Date_Allocated  //backup
		$rma_e.Date_Allocated:=$suggestedDate
		$rma_e.ModWho:="RM_A"
		$rma_e.ModDate:=Current date:C33
		
		$status_o:=$rma_e.save(dk auto merge:K85:24)
		
		$note:=String:C10($rma_e.Date_Prior; Internal date short special:K1:4)+" to "+String:C10($rma_e.Date_Allocated; Internal date short special:K1:4)+" and qty set to 0"
		If ($status_o.success)
			utl_LogfileServer("RMSD"; txt_Pad("NO JML:"; " "; 1; 7)+$logId+$note; "rm_allocation.log")
		Else 
			utl_LogfileServer("RMSD"; txt_Pad("NO JML-FAILED:"; " "; 1; 7)+$logId+$note; "rm_allocation.log")
		End if 
		
		
	End if   //jml
	
End for each 

utl_LogfileServer("RMSD"; "RM_AllocationSetToPressDate_eos Finished"; "rm_allocation.log")

