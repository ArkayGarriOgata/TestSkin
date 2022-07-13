//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 01/23/07, 14:08:28
// ----------------------------------------------------
// Method: JobSeq_setAdjHours()  --> 
// Description
// tidy up the machine ticket before saving
// ----------------------------------------------------

READ ONLY:C145([Job_Forms_Machines:43])
READ ONLY:C145([Job_Forms:42])
READ ONLY:C145([Jobs:15])

SET QUERY LIMIT:C395(1)

QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=(Substring:C12($1; 1; 8)); *)  //validate the budget
QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]Sequence:5=(Num:C11(Substring:C12($1; 10; 3))))
If (Records in selection:C76([Job_Forms_Machines:43])>0)
	If ([Job_Forms_Machines:43]Planned_RunRate:36>0)
		If ([Job_Forms_Machine_Tickets:61]Good_Units:8#0)
			If (Position:C15($2; <>SHEETERS)>0)
				QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=(Substring:C12($1; 1; 8)))
				If ([Job_Forms:42]ShortGrain:48)
					$length:=[Job_Forms:42]Width:23
				Else 
					$length:=[Job_Forms:42]Lenth:24
				End if 
				[Job_Forms_Machine_Tickets:61]Run_AdjStd:15:=Round:C94([Job_Forms_Machine_Tickets:61]Good_Units:8*$length/[Job_Forms_Machines:43]Planned_RunRate:36; 2)
			Else 
				[Job_Forms_Machine_Tickets:61]Run_AdjStd:15:=Round:C94([Job_Forms_Machine_Tickets:61]Good_Units:8/[Job_Forms_Machines:43]Planned_RunRate:36; 2)
			End if 
		End if   //good#0
	End if 
End if 

SET QUERY LIMIT:C395(0)