//%attributes = {}
// Method: JML_setJobComplete () -> 
// ----------------------------------------------------
// by: mel: 08/25/04, 14:56:41
// ----------------------------------------------------
// Description:
// 
// Updates:
// see also JOB_Completion, JML_OnValidateForm
// ----------------------------------------------------

C_TEXT:C284($1)
C_BOOLEAN:C305($saveRequired)

$audit:="COMPLETED BY "+<>zResp+" "
$saveRequired:=False:C215  //assume validation event

If (Length:C16($1)=8)
	READ WRITE:C146([Job_Forms_Master_Schedule:67])
	READ WRITE:C146([Job_Forms:42])
	READ WRITE:C146([To_Do_Tasks:100])
	READ WRITE:C146([Job_Forms_Items:44])
	
	If ([Job_Forms_Master_Schedule:67]JobForm:4#$1)
		QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=$1)
		$saveRequired:=True:C214
	End if 
	
	If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
		If (fLockNLoad(->[Job_Forms_Master_Schedule:67]))
			QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=[Job_Forms_Master_Schedule:67]JobForm:4)
			If (Records in selection:C76([Job_Forms:42])=1)  //•120998  MLB  more graneular
				If (fLockNLoad(->[Job_Forms:42]))
					
					If ([Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!)
						[Job_Forms_Master_Schedule:67]DateComplete:15:=4D_Current_date
						[Job_Forms_Master_Schedule:67]Comment:22:=$audit+[Job_Forms_Master_Schedule:67]Comment:22
					End if 
					
					If ([Job_Forms_Master_Schedule:67]GoalMetOn:62=!00-00-00!)
						[Job_Forms_Master_Schedule:67]GoalMetOn:62:=[Job_Forms_Master_Schedule:67]DateComplete:15
					End if 
					
					Job_revisionNoticeClear([Job_Forms_Master_Schedule:67]JobForm:4)
					JTB_JobFormComplete([Job_Forms_Master_Schedule:67]JobForm:4)
					
					QUERY:C277([To_Do_Tasks:100]; [To_Do_Tasks:100]Jobform:1=[Job_Forms_Master_Schedule:67]JobForm:4)
					If (Records in selection:C76([To_Do_Tasks:100])>0)
						util_DeleteSelection(->[To_Do_Tasks:100])
					End if 
					
					If ([Job_Forms:42]Status:6#"Closed")
						If ([Job_Forms:42]ClosedDate:11=!00-00-00!)
							[Job_Forms:42]Status:6:="Complete"
						Else 
							[Job_Forms:42]Status:6:="Closed"
						End if 
					End if 
					[Job_Forms:42]Completed:18:=[Job_Forms_Master_Schedule:67]DateComplete:15
					[Job_Forms:42]ModWho:8:=<>zResp
					[Job_Forms:42]ModDate:7:=4D_Current_date
					[Job_Forms:42]Notes:32:=$audit+[Job_Forms:42]Notes:32
					SAVE RECORD:C53([Job_Forms:42])
					UNLOAD RECORD:C212([Job_Forms:42])
					$numAlloc:=RM_AllocationRemove([Job_Forms_Master_Schedule:67]JobForm:4)
					If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
						
						qryJMI([Job_Forms_Master_Schedule:67]JobForm:4+"@")
						CREATE SET:C116([Job_Forms_Items:44]; "jmiGroup")
						QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]Qty_Actual:11=0)
						If (Records in selection:C76([Job_Forms_Items:44])>0)
							APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]Qty_Actual:11:=2)
						End if 
						
						// • mel (8/25/04, 14:40:57)
						USE SET:C118("jmiGroup")
						QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39=!00-00-00!)
						APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39:=[Job_Forms_Master_Schedule:67]DateComplete:15)
						APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]CompletedTimeStamp:56:=TSTimeStamp([Job_Forms_Master_Schedule:67]DateComplete:15; Current time:C178))
						
						USE SET:C118("jmiGroup")
						CLEAR SET:C117("jmiGroup")
						
					Else 
						//the intent is not to have any Qty_Actual=0 or [Job_Forms_Items]Completed=!00-00-00!, but they may not be inclusive of each other
						
						$value:="ALWAYS QUERY JOBIT"  //[Job_Forms_Items]Jobit  // Modified by: Mel Bohince (2/11/19) $value below causes jmi not to be constrained by jobform, so all Qty_Actual=0 get touched
						$critiria:=[Job_Forms_Master_Schedule:67]JobForm:4+"@"
						If ($value#$critiria)
							QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4=$critiria; *)  //find only items belonging to this job
						End if 
						QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Qty_Actual:11=0)
						
						If (Records in selection:C76([Job_Forms_Items:44])>0)
							APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]Qty_Actual:11:=2)
						End if 
						
						If ($value#$critiria)
							QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4=$critiria; *)
						End if 
						QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39=!00-00-00!)
						
						If (Records in selection:C76([Job_Forms_Items:44])>0)
							APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39:=[Job_Forms_Master_Schedule:67]DateComplete:15)
							APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]CompletedTimeStamp:56:=TSTimeStamp([Job_Forms_Master_Schedule:67]DateComplete:15; Current time:C178))
						End if 
						// Modified by: Mel Bohince (2/11/19) 
						If ($value#$critiria)
							QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4=$critiria)  //;*)// Modified by: Mel Bohince (2/11/19) don't leave query open
						End if 
						
					End if   // END 4D Professional Services : January 2019 query selection
					
					<>USE_SUBCOMPONENT:=True:C214
					//assuming only one item on the job so send its qtyActual for backflushing
					//$numBackflushed:=Job_back_flush_components ($1;[Job_Forms_Items]Qty_Actual)
					
					If ($saveRequired)
						SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
					End if 
					
				End if   //jf not locked
			End if 
		End if   //lock and load jml
	End if 
End if 