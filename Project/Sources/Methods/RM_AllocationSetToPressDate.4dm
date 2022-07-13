//%attributes = {"publishedWeb":true,"executedOnServer":true}
// -------
// Method: RM_AllocationSetToPressDate   ( ) ->
// By: Mel Bohince 
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (3/9/18) use 2 weeks before earlier of Press or HRD, add a backup field
// Modified by: Mel Bohince (3/10/18) use 1 week, exclude com's other than paper and plactic
// OBSOLETE OBSOLETE OBSOLETEModified by: MelvinBohince (3/28/22) OBSOLETE date now set by batched RM_AllocationSetDate_eos called by Batch_RM_Allocations


C_LONGINT:C283($leadtime)
$leadtime:=-7  //days
C_DATE:C307($dateToUse)
READ WRITE:C146([Raw_Materials_Allocations:58])
ALL RECORDS:C47([Raw_Materials_Allocations:58])

//uThermoInit (Records in selection([Raw_Materials_Allocations]);"Setting Allocation to Press date")

For ($i; 1; Records in selection:C76([Raw_Materials_Allocations:58]))
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=[Raw_Materials_Allocations:58]JobForm:3)
	If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)  //not orphaned
		$com:=Substring:C12([Raw_Materials_Allocations:58]commdityKey:13; 1; 2)
		[Raw_Materials_Allocations:58]Date_Prior:16:=[Raw_Materials_Allocations:58]Date_Allocated:5  //backup
		
		If (Position:C15($com; " 01 20 ")>0)  //board or plastic
			Case of 
				: ([Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!) & ([Job_Forms_Master_Schedule:67]MAD:21#!00-00-00!)
					If ([Job_Forms_Master_Schedule:67]PressDate:25<[Job_Forms_Master_Schedule:67]MAD:21)  //earlier of HRD or Print date
						$dateToUse:=[Job_Forms_Master_Schedule:67]PressDate:25
					Else 
						$dateToUse:=[Job_Forms_Master_Schedule:67]MAD:21
					End if 
					
				: ([Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!)
					$dateToUse:=[Job_Forms_Master_Schedule:67]PressDate:25
					
				: ([Job_Forms_Master_Schedule:67]MAD:21#!00-00-00!)
					$dateToUse:=[Job_Forms_Master_Schedule:67]MAD:21
					
				Else 
					$dateToUse:=<>MAGIC_DATE
			End case 
			
			[Raw_Materials_Allocations:58]Date_Allocated:5:=Add to date:C393($dateToUse; 0; 0; $leadtime)
			
		Else   //original method, for foil and sensors
			If ([Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!)
				[Raw_Materials_Allocations:58]Date_Allocated:5:=[Job_Forms_Master_Schedule:67]PressDate:25
			Else 
				[Raw_Materials_Allocations:58]Date_Allocated:5:=<>MAGIC_DATE
			End if 
		End if   //board/apet
		
		SAVE RECORD:C53([Raw_Materials_Allocations:58])
		
	End if   //jml record
	
	NEXT RECORD:C51([Raw_Materials_Allocations:58])
	//uThermoUpdate ($i)
End for 

//uThermoClose 