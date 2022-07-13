//%attributes = {}

// Method: PSG_GlueScheduleUI ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 02/28/14, 08:27:29
// ----------------------------------------------------
// Description
// Start the appropriete glue schedule in its own process
// based on PS_PressScheduleUI, pattern_Singleton
// ----------------------------------------------------
PS_JustInTime  // Modified by: Mel Bohince (6/3/21) 

If (False:C215)
	// Glue Schedule Call Chain- Prefix of PSG_ not shown
	// PSG_ALL
	//   GlueScheduleUI("ALL")
	//     GlueSchedule("ALL")
	//       ServerArrays
	//         ServerArrays ("client-prep") 
	//         ServerArrays ("available?")  //start or get servers pid then release the semaphore
	//           ServerArrays ("init")
	//           MasterArray ("new")
	//             MasterArray ("size")
	//           MasterArray ("load")
	//           MasterArray ("consolidate")
	//           MasterArray ("more_details")
	//         ServerArrays ("exchange")  //suck the arrays from the server
	//           MasterArray ("new")
	//           MasterArray ("get_from_server";server_pid) 
	//         LocalArray ("new")
	//         LocalArray ("size";$num_master_rows) 
	//         LocalArray ("load")  // we be styling ;-)
	//         OpenFormWindow (->[ProductionSchedules];"GlueSchedule";...
End if 

C_TEXT:C284($1)
C_LONGINT:C283($0; $pid)

If (Count parameters:C259=0)  //find the press number
	If (Substring:C12(Current user:C182; 1; 5)="Press")
		//PS_MakeReadyTimer (1)
		$press:=Substring:C12(Current user:C182; 6)
		
	Else 
		$press:="All"
	End if 
	
Else   //use the press number passed
	$press:=$1
End if 

$pid:=PS_pid_mgr("pid"; $press)
If ($pid>-1)
	If ($pid=0)
		$pid:=New process:C317("PSG_GlueSchedule"; <>lMidMemPart; $press+" Schedule"; $press)
		If (False:C215)
			PSG_GlueSchedule
		End if 
		
		$pid:=PS_pid_mgr("setpid"; $press; $pid)
		
	Else 
		SHOW PROCESS:C325($pid)
		BRING TO FRONT:C326($pid)
		WindowPositionMove([WindowSets:185]WindowTitle:3)  // Added by: Mark Zinke (1/10/13)
		POST OUTSIDE CALL:C329($pid)
	End if 
	
Else 
	BEEP:C151
End if 

$0:=$pid