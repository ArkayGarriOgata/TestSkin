//%attributes = {"publishedWeb":true}
//PM:  JOB_getMachineBudgetob;diff)  2/21/01  mlb
//set the MachineJob records to the Machine_Est records
// Modified by: Mel Bohince (2/12/16) suddenly these were getting set to read only

C_DATE:C307($today)

READ ONLY:C145([ProductionSchedules:110])  //• mlb - 6/18/02  15:28 update schedule
READ WRITE:C146([Job_Forms_Machines:43])  // Modified by: Mel Bohince (2/12/16) 


$today:=4D_Current_date

If (Count parameters:C259>2)  //revising, so blank out existing data
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=$3)
		CREATE SET:C116([Job_Forms_Machines:43]; "currentSeqs")
		
		
	Else 
		
		QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=$3)
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	ARRAY TEXT:C222($aCC; 0)
	SELECTION TO ARRAY:C260([Job_Forms_Machines:43]CostCenterID:4; $aCC)
	For ($i; 1; Size of array:C274($aCC))
		$aCC{$i}:="DEL"
	End for 
	ARRAY TO SELECTION:C261($aCC; [Job_Forms_Machines:43]CostCenterID:4)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		QUERY:C277([To_Do_Tasks:100]; [To_Do_Tasks:100]Jobform:1=($3+"@"); *)
		QUERY:C277([To_Do_Tasks:100];  & ; [To_Do_Tasks:100]Category:2="Production Approval")
		CREATE SET:C116([To_Do_Tasks:100]; "currentToDos")
		
	Else 
		
		QUERY:C277([To_Do_Tasks:100]; [To_Do_Tasks:100]Jobform:1=($3+"@"); *)
		QUERY:C277([To_Do_Tasks:100];  & ; [To_Do_Tasks:100]Category:2="Production Approval")
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	SELECTION TO ARRAY:C260([To_Do_Tasks:100]AssignedTo:9; $aCC)
	ARRAY TEXT:C222($aCC; 0)
	For ($i; 1; Size of array:C274($aCC))
		$aCC{$i}:="DEL"
	End for 
	ARRAY TO SELECTION:C261($aCC; [To_Do_Tasks:100]AssignedTo:9)
End if 

QUERY:C277([Estimates_Machines:20]; [Estimates_Machines:20]DiffFormID:1=$2+"@")
$numRecs:=Records in selection:C76([Estimates_Machines:20])
For ($i; 1; $numRecs)
	If (Count parameters:C259<=2)
		CREATE RECORD:C68([Job_Forms_Machines:43])
		[Job_Forms_Machines:43]JobForm:1:=String:C10($1; "00000")+"."+Substring:C12([Estimates_Machines:20]DiffFormID:1; 12; 2)
		[Job_Forms_Machines:43]Sequence:5:=[Estimates_Machines:20]Sequence:5
	Else 
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			USE SET:C118("currentSeqs")
			QUERY SELECTION:C341([Job_Forms_Machines:43]; [Job_Forms_Machines:43]Sequence:5=[Estimates_Machines:20]Sequence:5)
			
			
		Else 
			
			QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=$3; *)
			QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]Sequence:5=[Estimates_Machines:20]Sequence:5)
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		If (Records in selection:C76([Job_Forms_Machines:43])=0)  // new sequence added
			CREATE RECORD:C68([Job_Forms_Machines:43])
			[Job_Forms_Machines:43]JobForm:1:=String:C10($1; "00000")+"."+Substring:C12([Estimates_Machines:20]DiffFormID:1; 12; 2)
			[Job_Forms_Machines:43]Sequence:5:=[Estimates_Machines:20]Sequence:5
		End if 
	End if 
	[Job_Forms_Machines:43]ModDate:32:=$today
	[Job_Forms_Machines:43]ModWho:33:=<>zResp
	[Job_Forms_Machines:43]Comment:2:=[Estimates_Machines:20]Comment:29
	[Job_Forms_Machines:43]CostCenterID:4:=[Estimates_Machines:20]CostCtrID:4
	[Job_Forms_Machines:43]Effectivity:3:=[Estimates_Machines:20]Effectivity:6  //•5.10.95
	[Job_Forms_Machines:43]Planned_Qty:10:=[Estimates_Machines:20]Qty_Net:24
	[Job_Forms_Machines:43]Planned_Waste:11:=[Estimates_Machines:20]Qty_Waste:23
	[Job_Forms_Machines:43]Planned_Labor:13:=[Estimates_Machines:20]CostLabor:13
	[Job_Forms_Machines:43]Planned_OH:14:=[Estimates_Machines:20]CostOverhead:15
	[Job_Forms_Machines:43]Planned_MR_Hrs:15:=[Estimates_Machines:20]MakeReadyHrs:30
	[Job_Forms_Machines:43]Planned_RunRate:36:=[Estimates_Machines:20]RunningRate:31
	[Job_Forms_Machines:43]MachJobID:18:=[Estimates_Machines:20]SequenceID:3
	[Job_Forms_Machines:43]FormChangeHere:38:=[Estimates_Machines:20]FormChangeHere:9
	[Job_Forms_Machines:43]Flex_field1:6:=[Estimates_Machines:20]Flex_field1:18
	[Job_Forms_Machines:43]Flex_field2:7:=[Estimates_Machines:20]Flex_Field2:19
	[Job_Forms_Machines:43]Flex_field3:17:=[Estimates_Machines:20]Flex_Field3:20
	[Job_Forms_Machines:43]Flex_field4:26:=[Estimates_Machines:20]Flex_Field4:21
	[Job_Forms_Machines:43]Flex_Field5:27:=[Estimates_Machines:20]Flex_Field5:25
	[Job_Forms_Machines:43]Flex_field6:34:=[Estimates_Machines:20]Flex_field6:37
	[Job_Forms_Machines:43]Flex_field7:35:=[Estimates_Machines:20]Flex_Field7:38
	[Job_Forms_Machines:43]Planned_RunHrs:37:=[Estimates_Machines:20]RunningHrs:32
	[Job_Forms_Machines:43]Planned_RunRate:36:=[Estimates_Machines:20]RunningRate:31  //
	[Job_Forms_Machines:43]OutsideService:41:=[Estimates_Machines:20]OutSideService:33  //•082295  MLB  UPR 1702
	SAVE RECORD:C53([Job_Forms_Machines:43])
	
	//PS_RevisionLog ([Machine_Job]JobForm;[Machine_Job]Sequence;[Machine_Job]CostCenterID;[Machine_Job]Pld_RunHrs;[Machine_Job]Planned_MR_Hrs)  `• mlb - 6/18/02  15:41
	If (Position:C15([Job_Forms_Machines:43]CostCenterID:4; <>SHEETERS)>0) & (False:C215)  //only Keith uses this
		ToDo_ProcessOK
	End if 
	
	NEXT RECORD:C51([Estimates_Machines:20])
End for 

If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	//clean up unused sequences
	If (Count parameters:C259>2)  //revising, so blank out existing data
		USE SET:C118("currentSeqs")
		CLEAR SET:C117("currentSeqs")
		QUERY SELECTION:C341([Job_Forms_Machines:43]; [Job_Forms_Machines:43]CostCenterID:4="DEL")
		If (Records in selection:C76([Job_Forms_Machines:43])>0)
			DELETE SELECTION:C66([Job_Forms_Machines:43])
		End if 
		
		USE SET:C118("currentToDos")
		CLEAR SET:C117("currentToDos")
		QUERY SELECTION:C341([To_Do_Tasks:100]; [To_Do_Tasks:100]AssignedTo:9="DEL")
		If (Records in selection:C76([To_Do_Tasks:100])>0)
			DELETE SELECTION:C66([To_Do_Tasks:100])
		End if 
	End if 
Else 
	
	//clean up unused sequences
	If (Count parameters:C259>2)  //revising, so blank out existing data
		
		QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=$3; *)
		QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]CostCenterID:4="DEL")
		If (Records in selection:C76([Job_Forms_Machines:43])>0)
			DELETE SELECTION:C66([Job_Forms_Machines:43])
		End if 
		
		QUERY:C277([To_Do_Tasks:100]; [To_Do_Tasks:100]Jobform:1=($3+"@"); *)
		QUERY:C277([To_Do_Tasks:100]; [To_Do_Tasks:100]Category:2="Production Approval"; *)
		QUERY:C277([To_Do_Tasks:100]; [To_Do_Tasks:100]AssignedTo:9="DEL")
		If (Records in selection:C76([To_Do_Tasks:100])>0)
			DELETE SELECTION:C66([To_Do_Tasks:100])
		End if 
	End if 
End if   // END 4D Professional Services : January 2019 query selection
