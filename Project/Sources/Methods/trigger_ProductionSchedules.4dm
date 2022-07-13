//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 02/01/07, 13:42:22
// ----------------------------------------------------
// Method: trigger_ProductionSchedules()  --> 
// ----------------------------------------------------

Case of 
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		//PS_CreateTargetMRrecord 
		$sendToFlex:=True:C214
		[ProductionSchedules:110]JOB_FORM:74:=Substring:C12([ProductionSchedules:110]JobSequence:8; 1; 8)
		[ProductionSchedules:110]JOB_MASTER_LOG:71:=[ProductionSchedules:110]JOB_FORM:74
		
		[ProductionSchedules:110]DurationInIntervals:83:=SF_ConvertSecondsToIntervals([ProductionSchedules:110]DurationSeconds:9*1)
		
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		[ProductionSchedules:110]JOB_FORM:74:=Substring:C12([ProductionSchedules:110]JobSequence:8; 1; 8)
		[ProductionSchedules:110]JOB_MASTER_LOG:71:=[ProductionSchedules:110]JOB_FORM:74
		[ProductionSchedules:110]DurationInIntervals:83:=SF_ConvertSecondsToIntervals([ProductionSchedules:110]DurationSeconds:9*1)
		
		Case of 
			: (Old:C35([ProductionSchedules:110]CostCenter:1)#[ProductionSchedules:110]CostCenter:1)
				$sendToFlex:=True:C214
			: (Old:C35([ProductionSchedules:110]Planned_MR:52)#[ProductionSchedules:110]Planned_MR:52)
				$sendToFlex:=True:C214
			: (Old:C35([ProductionSchedules:110]Planned_Run:53)#[ProductionSchedules:110]Planned_Run:53)
				$sendToFlex:=True:C214
			: (Old:C35([ProductionSchedules:110]Planned_QtyGood:56)#[ProductionSchedules:110]Planned_QtyGood:56)
				$sendToFlex:=True:C214
			: (Old:C35([ProductionSchedules:110]Planned_QtyWaste:55)#[ProductionSchedules:110]Planned_QtyWaste:55)
				$sendToFlex:=True:C214
				//: (Old([ProductionSchedules]Priority)#[ProductionSchedules]Priority)
				//$sendToFlex:=True
			: (Old:C35([ProductionSchedules:110]Planned_QtyWaste:55)#[ProductionSchedules:110]Planned_QtyWaste:55)
				$sendToFlex:=True:C214
			Else 
				$sendToFlex:=False:C215
		End case 
		
	: (Trigger event:C369=On Deleting Record Event:K3:3)
		$sendToFlex:=True:C214
End case 

If ($sendToFlex)  // ----------------------------------------------------
	// User name: Mel Bohince
	// Created: 02/01/07, 13:42:22
	// ----------------------------------------------------
	// Method: trigger_ProductionSchedules()  --> 
	// ----------------------------------------------------
	// Modified by: Mel Bohince (3/2/20) convert duration to intervals
	
	Case of 
		: (Trigger event:C369=On Saving New Record Event:K3:1)
			//PS_CreateTargetMRrecord 
			$sendToFlex:=True:C214
			[ProductionSchedules:110]JOB_FORM:74:=Substring:C12([ProductionSchedules:110]JobSequence:8; 1; 8)
			[ProductionSchedules:110]JOB_MASTER_LOG:71:=[ProductionSchedules:110]JOB_FORM:74
			
			[ProductionSchedules:110]DurationInIntervals:83:=SF_ConvertSecondsToIntervals([ProductionSchedules:110]DurationSeconds:9*1)  // Modified by: Mel Bohince (3/2/20) convert duration to intervals
			
		: (Trigger event:C369=On Saving Existing Record Event:K3:2)
			[ProductionSchedules:110]JOB_FORM:74:=Substring:C12([ProductionSchedules:110]JobSequence:8; 1; 8)
			[ProductionSchedules:110]JOB_MASTER_LOG:71:=[ProductionSchedules:110]JOB_FORM:74
			
			[ProductionSchedules:110]DurationInIntervals:83:=SF_ConvertSecondsToIntervals([ProductionSchedules:110]DurationSeconds:9*1)  // Modified by: Mel Bohince (3/2/20) convert duration to intervals
			
			Case of 
				: (Old:C35([ProductionSchedules:110]CostCenter:1)#[ProductionSchedules:110]CostCenter:1)
					$sendToFlex:=True:C214
				: (Old:C35([ProductionSchedules:110]Planned_MR:52)#[ProductionSchedules:110]Planned_MR:52)
					$sendToFlex:=True:C214
				: (Old:C35([ProductionSchedules:110]Planned_Run:53)#[ProductionSchedules:110]Planned_Run:53)
					$sendToFlex:=True:C214
				: (Old:C35([ProductionSchedules:110]Planned_QtyGood:56)#[ProductionSchedules:110]Planned_QtyGood:56)
					$sendToFlex:=True:C214
				: (Old:C35([ProductionSchedules:110]Planned_QtyWaste:55)#[ProductionSchedules:110]Planned_QtyWaste:55)
					$sendToFlex:=True:C214
					//: (Old([ProductionSchedules]Priority)#[ProductionSchedules]Priority)
					//$sendToFlex:=True
				: (Old:C35([ProductionSchedules:110]Planned_QtyWaste:55)#[ProductionSchedules:110]Planned_QtyWaste:55)
					$sendToFlex:=True:C214
				Else 
					$sendToFlex:=False:C215
			End case 
			
		: (Trigger event:C369=On Deleting Record Event:K3:3)
			$sendToFlex:=True:C214
	End case 
	
	If ($sendToFlex)
		//$attempts:=10
		//Repeat 
		//IDLE
		//DELAY PROCESS(Current process;30)  `may not work in a trigger
		$success:=Batch_RunDate("Mark"; "Flex-Work-to")
		//If ($success>0)  `we're done
		//$attempts:=0
		//Else 
		//$attempts:=$attempts-1
		//End if 
		//Until ($attempts=0)
	End if 
	//$attempts:=10
	//Repeat 
	//IDLE
	//DELAY PROCESS(Current process;30)  `may not work in a trigger
	$success:=Batch_RunDate("Mark"; "Flex-Work-to")
	//If ($success>0)  `we're done
	//$attempts:=0
	//Else 
	//$attempts:=$attempts-1
	//End if 
	//Until ($attempts=0)
End if 