//%attributes = {"publishedWeb":true}
//Estimate Input-- Duplicate Differential Script.     --JML    9/29/93
//•081595  MLB  
//•120695  MLB  UPR 234 chg method of primary keying CartonSpec records

//This procedure will display a list of existing Differentials and allow user
//to choose 1  to be duplciated. The new differential will
//use the Quantity & process Spec specified in the Right most scroll area.

//asDiff will hold source Differential.
//asDiff2 will hold destination differential  QtyBreak.
//Dialog guarantees these to be accurate when OK=1.

//Determine PSpec, Tickler-Tag, Qty break, DiffID...
//duplicate CaseScenario
//Duplciate CartonSpecs(change Want Qty to new QtyBreak)
//Duplicate Forms.
//Duplicate FormCartons.
//Duplicate Machines & Materials

//One problem deals with Recon.  IF user starts creating cartons in Worksheet area
//screwed.  We could eliminate this problem by not trying to adjust WantQuantities
//duplicate these as well.  OTherwise, we either have to hope Qty sceanrio values 
//have not been changed and use the values found in the current Differential,
//or, we double check existence of each CartonSpec in QtyWksht with Cartons
//of current Differential.  I suggest we force user to enter in the new set of
//Quantites.

C_TEXT:C284($estimateNumber; $processSpec; $sourceProcessSpec)
C_TEXT:C284($differentialDesignation)

$winRef:=OpenSheetWindow(->[zz_control:1]; "EstDiff_DupOne")
DIALOG:C40([zz_control:1]; "EstDiff_DupOne")
CLOSE WINDOW:C154
If (OK=1)
	asDiff:=Find in array:C230(ListBox1; True:C214)
	GOTO SELECTED RECORD:C245([Estimates_Differentials:38]; asDiff)
	ONE RECORD SELECT:C189([Estimates_Differentials:38])
	
	$estimateNumber:=[Estimates:17]EstimateNo:1
	$differentialDesignation:=gEstMakeDiffID
	$oldDiffID:=[Estimates_Differentials:38]Id:1  //used to help find and duplciate related records.
	$NewDiffID:=$estimateNumber+$differentialDesignation
	
	//*Dup the cartonspecs
	Estimate_DupCartons($oldDiffID; $NewDiffID)
	
	//creates diff record
	Estimate_DupDiff($NewDiffID; Substring:C12([Estimates_Differentials:38]PSpec_Qty_TAG:25; 1; 26)+"-DUP")
	
	//Duplicate forms
	Estimate_DupForms($oldDiffID; $NewDiffID)
	
	//Duplicate form cartons
	Estimate_DupFormCartons($oldDiffID; $NewDiffID)
	
	//duplicate machines
	Estimate_DupSimple(->[Estimates_Machines:20]DiffFormID:1; $oldDiffID; $NewDiffID)
	
	//duplicate materials
	Estimate_DupSimple(->[Estimates_Materials:29]DiffFormID:1; $oldDiffID; $NewDiffID)
	
	gEstimateLDWkSh("Wksht")
	
End if 

QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]estimateNum:2=[Estimates:17]EstimateNo:1)
ORDER BY:C49([Estimates_Differentials:38]; [Estimates_Differentials:38]Id:1; >)