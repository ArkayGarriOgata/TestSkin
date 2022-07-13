//%attributes = {}
// -------
// Method: PF_Queue_Listener   ({send_xml|publish_schedule|both} ) ->
// By: Mel Bohince @ 02/26/18, 11:36:33
// Description
// send waiting xml from pf queue and check for new published schedules
// ----------------------------------------------------
//see wms_api_Get_Process
// Modified by: Mel Bohince (3/22/18) don't send DC if job han't been sent and glue sched switch

C_TEXT:C284($1; $r; $2; $option; $mode)
$r:=Char:C90(13)
C_LONGINT:C283($interval; <>PF_PID; $minutes)
$minutes:=2
$interval:=60*60*$minutes

C_BOOLEAN:C305(<>run_PF; <>PF_SAVE_GLUE_SCHEDULE)
Case of 
	: (Count parameters:C259=0)  //menu call
		If (Current user:C182="Administrator") | (Current user:C182="Designer")
			
			<>PF_PID:=Process number:C372("PF_Queue_Listener")
			If (<>PF_PID=0)
				
				$mode:=Request:C163("send_xml|publish_schedule|both"; "send_xml"; "Go"; "Cancel")
				CONFIRM:C162("Save glue schedule?"; "Save"; "Ignore")  // Modified by: Mel Bohince (3/22/18) glue sched switch
				If (ok=1)
					<>PF_SAVE_GLUE_SCHEDULE:=True:C214
				Else 
					<>PF_SAVE_GLUE_SCHEDULE:=False:C215
				End if 
				
				$option:=Request:C163("Send JML's w/ HRD's?"; "send_jml"; "Go"; "Cancel")
				If (Ok=0)
					$option:=""
				End if 
				
				$msg:="Poling for PrintFlow Transactions"+$r
				$msg:=$msg+"Mode = "+$mode+$r
				$msg:=$msg+"Option = "+$option+$r
				$msg:=$msg+"Interval = "+String:C10(2)+String:C10($interval)+" seconds"+$r
				$msg:=$msg+"Transactions = "+" All "+$r
				//util_FloatingAlert ($msg)
				<>run_PF:=True:C214
				zwStatusMsg("PrintFlow"; $mode+" transactions, every "+String:C10(2)+" minutes at "+String:C10(Current time:C178; HH MM SS:K7:1))
				<>PF_PID:=New process:C317("PF_Queue_Listener"; <>lMidMemPart; "PF_Queue_Listener"; $mode; $option)
				If (False:C215)
					PF_Queue_Listener
				End if 
				
			Else 
				uConfirm("PF_Queue_Listener is already running on this client."; "Just Checking"; "Kill")
				If (ok=0)
					<>run_PF:=False:C215
				End if 
			End if 
			
		Else 
			BEEP:C151
			uConfirm("Not Administrator, ehh?"; "Ohh"; "Well then")
		End if 
		
	: (Count parameters:C259>0)
		READ WRITE:C146([PrintFlow_Msg_Queue:169])
		Repeat 
			If ($1="send_xml") | ($1="both")
				QUERY:C277([PrintFlow_Msg_Queue:169]; [PrintFlow_Msg_Queue:169]Sent:5=0)
				For ($i; 1; Records in selection:C76([PrintFlow_Msg_Queue:169]))
					$jobform:=Substring:C12([PrintFlow_Msg_Queue:169]JobRef:7; 1; 8)  // Modified by: Mel Bohince (3/22/18) don't send DC if job han't been sent
					SET QUERY DESTINATION:C396(Into variable:K19:4; $sentToPF)
					QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=$jobform; *)
					QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Exported_PrintFlow:89#!00-00-00!)
					SET QUERY DESTINATION:C396(Into current selection:K19:1)
					If ($sentToPF>0)
						PF_SendDataCollection
					Else 
						[PrintFlow_Msg_Queue:169]Sent:5:=-1
						SAVE RECORD:C53([PrintFlow_Msg_Queue:169])
					End if 
					NEXT RECORD:C51([PrintFlow_Msg_Queue:169])
				End for 
			End if 
			
			If ($1="publish_schedule") | ($1="both")
				PF_GetSchedule
			End if 
			
			If ($2="send_jml")
				PF_JobsCreateNoUI
				PF_JobsRemoveFromPF
			End if 
			
			zwStatusMsg("PrintFlow"; "Paused for "+String:C10($minutes)+" minutes")
			DELAY PROCESS:C323(Current process:C322; $interval)
		Until (Not:C34(<>run_PF))
		
		
		
		
		<>PF_PID:=0
		
End case 

