//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 02/01/07, 13:19:25
// ----------------------------------------------------
// Method: trigger_JobFormMasterSchedule()  --> 
// ----------------------------------------------------
// Modified by: Mel Bohince (12/13/17) add target date for printflow 6 weeks out

Case of 
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		[Job_Forms_Master_Schedule:67]LastUpdate:51:=TSTimeStamp
		$statusChk:=True:C214  //if wip started
		Case of 
			: ([Job_Forms_Master_Schedule:67]StockStaged:66=True:C214)
			: ([Job_Forms_Master_Schedule:67]DateStockSheeted:47#!00-00-00!)
			: ([Job_Forms_Master_Schedule:67]Printed:32#!00-00-00!)
			: ([Job_Forms_Master_Schedule:67]GlueReady:28#!00-00-00!)
			Else 
				$statusChk:=False:C215
		End case 
		
		If ($statusChk)
			$canUnLoad:=True:C214
			If ([Job_Forms:42]JobFormID:5#[Job_Forms_Master_Schedule:67]JobForm:4)
				READ WRITE:C146([Job_Forms:42])
				QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=[Job_Forms_Master_Schedule:67]JobForm:4)
			Else   //on rec
				$canUnLoad:=False:C215
				If (Read only state:C362([Job_Forms:42]))
					UNLOAD RECORD:C212([Job_Forms:42])
					READ WRITE:C146([Job_Forms:42])
					LOAD RECORD:C52([Job_Forms:42])
				End if 
			End if 
			
			
			Case of 
				: ([Job_Forms:42]Status:6="Released")  //mlb 4/29/06 narrow this down
					[Job_Forms:42]Status:6:="WiP"
					SAVE RECORD:C53([Job_Forms:42])
					//: ([JobForm]Status="C@")`closed or cancelled
					//: ([JobForm]Status="Kill@")  `killed
					//: ([JobForm]Status="Wip")  `wip
					//: ([JobForm]Status="Hold")  `hold
					//: ([JobForm]Status="Planned")  `planned
					//: ([JobForm]Status="Revised")  `revised
					//Else   `must be in 
					//[JobForm]Status:="WiP"
					//SAVE RECORD([JobForm])
					
					$err:=Shuttle_Register("milestone"; [Job_Forms_Master_Schedule:67]JobForm:4)
					
			End case 
			
			If ($canUnLoad)
				UNLOAD RECORD:C212([Job_Forms:42])
			End if 
		End if 
		
		
		
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		[Job_Forms_Master_Schedule:67]LastUpdate:51:=TSTimeStamp
		If ([Job_Forms_Master_Schedule:67]TargetDate_PrintFlow:88=!00-00-00!)  // Modified by: Mel Bohince (12/13/17) 
			[Job_Forms_Master_Schedule:67]TargetDate_PrintFlow:88:=Add to date:C393(Current date:C33; 0; 0; (6*7))
		End if 
		If ([Job_Forms:42]Status:6="Released")
			$err:=Shuttle_Register("milestone"; [Job_Forms_Master_Schedule:67]JobForm:4)
		End if 
End case 