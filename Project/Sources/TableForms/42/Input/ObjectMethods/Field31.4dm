//(p) [jobform]input run_Location
//if the run location is either strictly hauppauge or Roanaoke
//verify that the machines specified are for the specified location
//• 6/29/98 cs created
Case of 
	: ([Job_Forms:42]Run_Location:55="")
		//do nothing = accept button will handle    
	: ([Job_Forms:42]Run_Location:55="Roanoke") | ([Job_Forms:42]Run_Location:55="Hauppauge")
		zwStatusMsg("RUN LOC"; "Checking budgeted machines...")
		If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
			
			COPY NAMED SELECTION:C331([Job_Forms_Machines:43]; "Hold")
			
		Else 
			
			ARRAY LONGINT:C221($_Hold; 0)
			LONGINT ARRAY FROM SELECTION:C647([Job_Forms_Machines:43]; $_Hold)
			
			
		End if   // END 4D Professional Services : January 2019 
		
		FIRST RECORD:C50([Job_Forms_Machines:43])
		
		If (<>Roanoke_CCs="")  //this routine has not yet been run, do so
			uSetupCCDivisio  //setup text of CCs, & Sets of CCs for each division
		End if 
		
		If ([Job_Forms:42]Run_Location:55="Hauppauge")
			$Compare:=<>NY_CCs
		Else 
			$Compare:=<>Roanoke_CCs
		End if 
		$Wrong:=""
		
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			For ($i; 1; Records in selection:C76([Job_Forms_Machines:43]))
				
				If (Position:C15([Job_Forms_Machines:43]CostCenterID:4; $Compare)=0)
					$Wrong:=[Job_Forms_Machines:43]CostCenterID:4+("; "*(Num:C11(Not:C34($Wrong=""))))+$Wrong
				End if 
				NEXT RECORD:C51([Job_Forms_Machines:43])
			End for 
			
		Else 
			
			ARRAY TEXT:C222($_CostCenterID; 0)
			SELECTION TO ARRAY:C260([Job_Forms_Machines:43]CostCenterID:4; $_CostCenterID)
			
			For ($i; 1; Size of array:C274($_CostCenterID); 1)
				
				If (Position:C15($_CostCenterID{$i}; $Compare)=0)
					$Wrong:=$_CostCenterID{$i}+("; "*(Num:C11(Not:C34($Wrong=""))))+$Wrong
				End if 
				
			End for 
			
		End if   // END 4D Professional Services : January 2019 First record
		If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
			
			USE NAMED SELECTION:C332("Hold")
			CLEAR NAMED SELECTION:C333("Hold")
			
		Else 
			
			CREATE SELECTION FROM ARRAY:C640([Job_Forms_Machines:43]; $_Hold)
			
		End if   // END 4D Professional Services : January 2019 
		
		If ($Wrong#"")
			ALERT:C41("There were machines budgeted for this Jobform, which are NOT located in "+Self:C308->+Char:C90(13)+"These Machines are:"+Char:C90(13)+$Wrong+Char:C90(13)+"Please insure that you have the correct machines budgeted.")
		End if 
		
		If ([Job_Forms_Master_Schedule:67]JobForm:4#[Job_Forms:42]JobFormID:5)
			READ WRITE:C146([Job_Forms_Master_Schedule:67])
			QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=[Job_Forms:42]JobFormID:5)  //1/26/95
		End if 
		If (Records in selection:C76([Job_Forms_Master_Schedule:67])=1)
			[Job_Forms_Master_Schedule:67]LocationOfMfg:30:=[Job_Forms:42]Run_Location:55
			SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
		End if 
	Else 
		ALERT:C41("Please be sure that the machines specifed on this budget are correct.")
End case 
//