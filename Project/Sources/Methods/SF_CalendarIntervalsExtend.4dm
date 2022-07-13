//%attributes = {}
// _______
// Method: SF_CalendarIntervalsExtend   ("c/c" ; ->calendarCollection) ->
// By: Mel Bohince @ 02/28/20, 10:54:00
// Description
// set the start dates of scheduled sequences based on the priority
// ----------------------------------------------------

C_OBJECT:C1216($jobEntSel; $jobSequence)
C_TEXT:C284($dept; $1)
C_POINTER:C301($deptCalendar; $2)
$dept:=$1
$deptCalendar:=$2

C_LONGINT:C283($intervalInSeconds; $startFrom; $index)
$intervalInSeconds:=SF_CalendarIntervalsSettings("intervalInSeconds")

//[ProductionSchedules]JobSequence
//[ProductionSchedules]Completed
//[ProductionSchedules]StartDate
//[ProductionSchedules]FixedStart

//set the fixed jobs
$jobEntSel:=ds:C1482.ProductionSchedules.query("CostCenter = :1 and Priority > :2 and Completed = :3 and FixedStart = :4"; $dept; 0; 0; True:C214).orderBy("Priority")
//note that for fixed the start date is inside the each loop cause they were manually set

For each ($jobSequence; $jobEntSel)
	//base the start on the date FIXED on the schedule, this is different than teh floating start loop below
	$startFrom:=TSTimeStamp($jobSequence.StartDate; $jobSequence.StartTime)
	$startFrom:=Int:C8(Round:C94(($startFrom/$intervalInSeconds); 0))*$intervalInSeconds  //get to the nearest interval, else the first interval will be skipped
	//adjust startFrom to nearest interval
	
	//find first interval starting at $startFrom
	$index:=$deptCalendar->findIndex(0; "SF_CalendarIntervalsFindTime"; $startFrom)  // -> Function result
	//or
	//For ($i;0;$deptCalendar->length)  //brute force to the matching timeslot
	//If ($deptCalendar->[$i].timeStampSeconds>=$startFrom)
	//$index:=$i
	//$i:=$i+$deptCalendar->length  //break
	//End if 
	//End for 
	
	$intervalsNeeded:=$jobSequence.DurationInIntervals  //this is how many we need
	$intervalsScheduled:=0
	$setStartTimeForThisSequence:=True:C214
	
	Repeat 
		If ($deptCalendar->[$index].available)  // not already taken used grab it
			//mark the job on the calendar
			$deptCalendar->[$index].task:=$jobSequence.JobSequence
			$deptCalendar->[$index].available:=False:C215
			//keep track of slots scheduled
			$intervalsScheduled:=$intervalsScheduled+1
			$deptCalendar->[$index].interval:=$intervalsScheduled
			
			If ($setStartTimeForThisSequence)
				//set the startdate on the prod sche
				$jobSequence.StartDateISO:=$deptCalendar->[$index].startTime
				$jobSequence.save()
				$setStartTimeForThisSequence:=False:C215
			End if 
			
		End if 
		
		//go to the next block in the calendar
		$index:=$index+1
		
	Until ($intervalsScheduled=$intervalsNeeded)
	
	
End for each 

//now set the floating starters
$jobEntSel:=ds:C1482.ProductionSchedules.query("CostCenter = :1 and Priority > :2 and Completed = :3 and FixedStart = :4"; $dept; 0; 0; False:C215).orderBy("Priority")
If ($jobEntSel.length>0)
	$startFrom:=TSTimeStamp($jobEntSel.first().StartDate; $jobEntSel.first().StartTime)  //optimistically start at the begining
	$startFrom:=Int:C8(Round:C94(($startFrom/$intervalInSeconds); 0))*$intervalInSeconds  //get to the nearest interval, else the first interval will be skipped
End if 

For each ($jobSequence; $jobEntSel)
	
	
	//find first interval starting at $startFrom
	$index:=$deptCalendar->findIndex(0; "SF_CalendarIntervalsFindTime"; $startFrom)  // -> Function result
	
	//For ($i;0;$deptCalendar->length)  //brute force to the matching timeslot
	//If ($deptCalendar->[$i].timeStampSeconds>=$startFrom)
	//$index:=$i
	//$i:=$i+$deptCalendar->length  //break
	//End if 
	//End for 
	
	$intervalsNeeded:=$jobSequence.DurationInIntervals  //this is how many we need
	$intervalsScheduled:=0
	$setStartTimeForThisSequence:=True:C214
	
	Repeat 
		If ($deptCalendar->[$index].available)  // not already taken used grab it
			//mark the job on the calendar
			$deptCalendar->[$index].task:=$jobSequence.JobSequence
			$deptCalendar->[$index].available:=False:C215
			//keep track of slots scheduled
			$intervalsScheduled:=$intervalsScheduled+1
			$deptCalendar->[$index].interval:=$intervalsScheduled
			
			If ($setStartTimeForThisSequence)
				//set the startdate on the prod sche
				$jobSequence.StartDateISO:=$deptCalendar->[$index].startTime
				$jobSequence.save()
				$setStartTimeForThisSequence:=False:C215
			End if 
			
		End if 
		
		//go to the next block
		$index:=$index+1
		
	Until ($intervalsScheduled=$intervalsNeeded)
	
	$startFrom:=$deptCalendar->[$index].timeStampSeconds  //reset the cursor to the next time block
	
End for each 
