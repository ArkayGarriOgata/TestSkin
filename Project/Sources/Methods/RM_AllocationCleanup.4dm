//%attributes = {"publishedWeb":true}
//PM:  RM_AllocationCleanup  082302  mlb
//get rid of dead wood
//073009 mlb recalc issues as needed
// Modified by: MelvinBohince (2/17/22)  there may have been a substitution for the coldfoil rm_code and RM_getTotalIssued( ) will corrupt
// OBSOLETE OBSOLETE OBSOLETEModified by: MelvinBohince (3/28/22) OBSOLETE date now set by batched RM_AllocationSetDate_eos called by Batch_RM_Allocations

READ WRITE:C146([Raw_Materials_Allocations:58])

ALL RECORDS:C47([Raw_Materials_Allocations:58])
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
	
	CREATE EMPTY SET:C140([Raw_Materials_Allocations:58]; "deleteThese")
	
	
Else 
	
	ARRAY LONGINT:C221($_deleteThese; 0)
	
	
End if   // END 4D Professional Services : January 2019 
uThermoInit(Records in selection:C76([Raw_Materials_Allocations:58]); "Deleting expired Allocations")
//SET QUERY LIMIT(1)
For ($i; 1; Records in selection:C76([Raw_Materials_Allocations:58]))
	
	// Modified by: MelvinBohince (2/17/22)  don't touch if a positive number, there may have been a substitution for the rm_code and RM_getTotalIssued( ) will fail
	If ([Raw_Materials_Allocations:58]Qty_Issued:6=0) & ([Raw_Materials_Allocations:58]commdityKey:13#"09@")  //don't recalc issued on foil
		
		$issues:=RM_getTotalIssued([Raw_Materials_Allocations:58]JobForm:3; [Raw_Materials_Allocations:58]Raw_Matl_Code:1)
		If ($issues#[Raw_Materials_Allocations:58]Qty_Issued:6)
			[Raw_Materials_Allocations:58]Qty_Issued:6:=$issues
			SAVE RECORD:C53([Raw_Materials_Allocations:58])
		End if 
		
	End if   //issued = 0
	
	
	If ([Raw_Materials_Allocations:58]Qty_Issued:6>=[Raw_Materials_Allocations:58]Qty_Allocated:4)
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
			
			ADD TO SET:C119([Raw_Materials_Allocations:58]; "deleteThese")
			
		Else 
			
			APPEND TO ARRAY:C911($_deleteThese; Record number:C243([Raw_Materials_Allocations:58]))
			
			
		End if   // END 4D Professional Services : January 2019 
		
	Else 
		QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Raw_Materials_Allocations:58]Raw_Matl_Code:1)
		If (Records in selection:C76([Raw_Materials:21])=0)  //orphaned
			If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
				
				ADD TO SET:C119([Raw_Materials_Allocations:58]; "deleteThese")
				
			Else 
				
				APPEND TO ARRAY:C911($_deleteThese; Record number:C243([Raw_Materials_Allocations:58]))
				
				
			End if   // END 4D Professional Services : January 2019 
			
		Else 
			QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=[Raw_Materials_Allocations:58]JobForm:3)
			If (Records in selection:C76([Job_Forms:42])=0)  //orphaned
				If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
					
					ADD TO SET:C119([Raw_Materials_Allocations:58]; "deleteThese")
					
				Else 
					
					APPEND TO ARRAY:C911($_deleteThese; Record number:C243([Raw_Materials_Allocations:58]))
					
					
				End if   // END 4D Professional Services : January 2019 
				
			Else 
				If ([Job_Forms:42]ClosedDate:11#!00-00-00!)
					If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
						
						ADD TO SET:C119([Raw_Materials_Allocations:58]; "deleteThese")
						
					Else 
						
						APPEND TO ARRAY:C911($_deleteThese; Record number:C243([Raw_Materials_Allocations:58]))
						
						
					End if   // END 4D Professional Services : January 2019 
					
				Else 
					If ([Job_Forms:42]Completed:18#!00-00-00!)
						If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
							
							ADD TO SET:C119([Raw_Materials_Allocations:58]; "deleteThese")
							
						Else 
							
							APPEND TO ARRAY:C911($_deleteThese; Record number:C243([Raw_Materials_Allocations:58]))
							
							
						End if   // END 4D Professional Services : January 2019 
					Else 
						If ([Raw_Materials_Allocations:58]commdityKey:13="01@")
							QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Raw_Matl_Code:7=[Raw_Materials_Allocations:58]Raw_Matl_Code:1)
							If (Records in selection:C76([Job_Forms_Materials:55])=0)  //allocation changed
								If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
									
									ADD TO SET:C119([Raw_Materials_Allocations:58]; "deleteThese")
									
								Else 
									
									APPEND TO ARRAY:C911($_deleteThese; Record number:C243([Raw_Materials_Allocations:58]))
									
									
								End if   // END 4D Professional Services : January 2019 
							Else 
								QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=[Raw_Materials_Allocations:58]JobForm:3)
								If (Records in selection:C76([Job_Forms_Master_Schedule:67])=1)
									If ([Job_Forms_Master_Schedule:67]Printed:32#!00-00-00!)  //already printed
										If ([Job_Forms_Master_Schedule:67]Printed:32#!2001-01-01!)  //no printed
											If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
												
												ADD TO SET:C119([Raw_Materials_Allocations:58]; "deleteThese")
												
											Else 
												
												APPEND TO ARRAY:C911($_deleteThese; Record number:C243([Raw_Materials_Allocations:58]))
												
												
											End if   // END 4D Professional Services : January 2019 
										End if   //no printing
									End if   //printed
								End if   //in jml
							End if   //matl job
						Else 
							//leave corrugate for now
						End if   //board
					End if   //completed
				End if   //closed
			End if   //orphaned, no job
		End if   //no rm code      
	End if   //already issued
	
	NEXT RECORD:C51([Raw_Materials_Allocations:58])
	uThermoUpdate($i)
End for 
uThermoClose
//SET QUERY LIMIT(0)
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
	
	USE SET:C118("deleteThese")
	CLEAR SET:C117("deleteThese")
	
Else 
	
	CREATE SELECTION FROM ARRAY:C640([Raw_Materials_Allocations:58]; $_deleteThese)
	
End if   // END 4D Professional Services : January 2019 

DELETE SELECTION:C66([Raw_Materials_Allocations:58])
