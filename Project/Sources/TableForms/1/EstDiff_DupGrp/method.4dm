//[control];"EstDiff_DupGrp"   -JML   9/29/93
//used by gEstDiff_DupGrp() procedure

C_LONGINT:C283($numEstPspecs; $differencial; $estPspec)
If (Form event code:C388=On Load:K2:1)
	OBJECT SET ENABLED:C1123(bPick; False:C215)
	ARRAY TEXT:C222(asDiff; 0)
	ARRAY TEXT:C222(asDiff2; 0)
	//chug thru the Process specs-search for them within the Differential List.
	//if found, add to list asDiff2
	//if not found, add to List AsDiff
	QUERY:C277([Estimates_PSpecs:57]; [Estimates_PSpecs:57]EstimateNo:1=[Estimates:17]EstimateNo:1)  //get existing differentials
	$numEstPspecs:=Records in selection:C76([Estimates_PSpecs:57])
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		
		For ($estPspec; 1; $numEstPspecs)
			QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]estimateNum:2=[Estimates:17]EstimateNo:1; *)
			QUERY:C277([Estimates_Differentials:38];  & ; [Estimates_Differentials:38]ProcessSpec:5=[Estimates_PSpecs:57]ProcessSpec:2)
			If (Records in selection:C76([Estimates_Differentials:38])=0)  //list of Process_Specs without any Differentials
				$differencial:=Size of array:C274(asDiff)+1
				ARRAY TEXT:C222(asDiff; $differencial)
				asDiff{$differencial}:=[Estimates_PSpecs:57]ProcessSpec:2
			Else 
				$differencial:=Size of array:C274(asDiff2)+1  //list of Process_Specs with Diff's already created
				ARRAY TEXT:C222(asDiff2; $differencial)
				asDiff2{$differencial}:=[Estimates_PSpecs:57]ProcessSpec:2
			End if 
			NEXT RECORD:C51([Estimates_PSpecs:57])
		End for 
		
	Else 
		
		ARRAY TEXT:C222($_ProcessSpec; 0)
		SELECTION TO ARRAY:C260([Estimates_PSpecs:57]ProcessSpec:2; $_ProcessSpec)
		
		
		For ($estPspec; 1; $numEstPspecs)
			QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]estimateNum:2=[Estimates:17]EstimateNo:1; *)
			QUERY:C277([Estimates_Differentials:38];  & ; [Estimates_Differentials:38]ProcessSpec:5=$_ProcessSpec{$estPspec})
			If (Records in selection:C76([Estimates_Differentials:38])=0)
				$differencial:=Size of array:C274(asDiff)+1
				ARRAY TEXT:C222(asDiff; $differencial)
				asDiff{$differencial}:=$_ProcessSpec{$estPspec}
			Else 
				$differencial:=Size of array:C274(asDiff2)+1  //list of Process_Specs with Diff's already created
				ARRAY TEXT:C222(asDiff2; $differencial)
				asDiff2{$differencial}:=$_ProcessSpec{$estPspec}
			End if 
		End for 
		
	End if   // END 4D Professional Services : January 2019 First record
	
	ARRAY TEXT:C222(aSelected; 0)
	$numEstPspecs:=Size of array:C274(asDiff)
	ARRAY TEXT:C222(aSelected; $numEstPspecs)
	asDiff:=0
	asDiff2:=0
	aSelected:=0
End if 
//EOP