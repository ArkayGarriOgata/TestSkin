//%attributes = {"publishedWeb":true}
//Estimate Input-- Duplicate Group of Differentials.     --JML    9/29/93
//•081595  MLB  
//•111495  MLB  UPR ralph
//•120695  MLB  UPR 234 chg method of primary keying CartonSpec records

//This procedure will display a list of all existing Differential Groups and allow
//user to choose 1  to be duplciated.  A group is all Qty Scenarios for a given
//process spec.

//The computer will do a distinct values to obtain a process Specs that have at
//least one differntial created.  This will become the available "Process Spec"
//differential groups which can be duplicated.  The computer will assume that
//each process Spec group is complete with one differential for each Qty Scenario.
//It is up to the user to make sure this is the case.

C_TEXT:C284($estimateNumber; $processSpec; $sourceProcessSpec)
C_TEXT:C284($differentialDesignation)
C_LONGINT:C283($item; $collectionSize; $numDifferentials; $group; $differential)

$winRef:=OpenSheetWindow(->[zz_control:1]; "EstDiff_DupGrp")
DIALOG:C40([zz_control:1]; "EstDiff_DupGrp")
CLOSE WINDOW:C154
If (OK=1)
	zwStatusMsg("Please Wait"; "Duplicating Differentials...")
	
	$estimateNumber:=[Estimates:17]EstimateNo:1
	$sourceProcessSpec:=asDiff2{asDiff2}  //the source Group
	QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]estimateNum:2=$estimateNumber; *)
	QUERY:C277([Estimates_Differentials:38];  & ; [Estimates_Differentials:38]ProcessSpec:5=$sourceProcessSpec)
	ORDER BY:C49([Estimates_Differentials:38]; [Estimates_Differentials:38]diffNum:3; >)
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 GOTO SELECTED RECORD
		
		COPY NAMED SELECTION:C331([Estimates_Differentials:38]; "srcDiffGroup")
		
		
	Else 
		
		ARRAY LONGINT:C221($_srcDiffGroup; 0)
		LONGINT ARRAY FROM SELECTION:C647([Estimates_Differentials:38]; $_srcDiffGroup)
		
	End if   // END 4D Professional Services : January 2019 query selection
	$numDifferentials:=Records in selection:C76([Estimates_Differentials:38])
	uThermoInit($numDifferentials; "Duplicating Differentials")
	For ($differential; 1; Size of array:C274(asDiff))  //find all destination Groups
		If (aSelected{$differential}#"")  //this PRocess Spec is marked to have a new Group of differentials    
			$processSpec:=asDiff{$differential}  //get name of new process
			For ($group; 1; $numDifferentials)  //loop thru each diff of source group & duplicate it
				If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 GOTO SELECTED RECORD
					
					USE NAMED SELECTION:C332("SrcDIFFGroup")
					GOTO SELECTED RECORD:C245([Estimates_Differentials:38]; $group)
					ONE RECORD SELECT:C189([Estimates_Differentials:38])  //get source differential
					
				Else 
					
					GOTO RECORD:C242([Estimates_Differentials:38]; $_srcDiffGroup{$group})
					
				End if   // END 4D Professional Services : January 2019 query selection
				
				$differentialDesignation:=gEstMakeDiffID
				$oldDiffID:=[Estimates_Differentials:38]Id:1  //used to help find and duplciate related records.
				$NewDiffID:=$estimateNumber+$differentialDesignation
				
				//*Dup the cartonspecs
				Estimate_DupCartons($oldDiffID; $NewDiffID; $processSpec)
				
				//*creates diff record
				Estimate_DupDiff($NewDiffID; Substring:C12([Estimates_Differentials:38]PSpec_Qty_TAG:25; 1; 5)+$processSpec; $processSpec)
				
				//*Duplicate forms
				Estimate_DupForms($oldDiffID; $NewDiffID; $processSpec)
				
				//*Duplicate form cartons
				Estimate_DupFormCartons($oldDiffID; $NewDiffID)
				
				//*duplicate machines
				Estimate_DupSimple(->[Estimates_Machines:20]DiffFormID:1; $oldDiffID; $NewDiffID)
				
				
				//*duplicate materials
				Estimate_DupSimple(->[Estimates_Materials:29]DiffFormID:1; $oldDiffID; $NewDiffID)
				
				
			End for   //looping thru each diff of source group-& duplicating it.
		End if   //if AsBull#""
		uThermoUpdate($differential)
	End for 
	
	uThermoClose
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 GOTO SELECTED RECORD
		
		CLEAR NAMED SELECTION:C333("SrcDIFFGroup")
		
	Else 
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	gEstimateLDWkSh
	
End if   //OK=1
QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]estimateNum:2=[Estimates:17]EstimateNo:1)
ORDER BY:C49([Estimates_Differentials:38]; [Estimates_Differentials:38]Id:1; >)
