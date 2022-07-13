//[control];"SelecNewDiff   -JML   9/29/93
//used by gEstDiff_NewOne() procedure
C_LONGINT:C283($numberOfCombinations; $numberOfPspecs; $numberOfQtys; $combo; $pspec; $qty)
If (Form event code:C388=On Load:K2:1)
	cb1:=1
	OBJECT SET ENABLED:C1123(bPick; False:C215)
	ARRAY BOOLEAN:C223(ListBox1; 0)
	ARRAY TEXT:C222(aSelected; 0)
	ARRAY TEXT:C222(asDiff; 0)
	
	QUERY:C277([Estimates_PSpecs:57]; [Estimates_PSpecs:57]EstimateNo:1=[Estimates:17]EstimateNo:1)
	
	$numberOfQtys:=gEstCountQtys
	
	$numberOfPspecs:=Records in selection:C76([Estimates_PSpecs:57])
	$numberOfCombinations:=$numberOfPspecs*$numberOfQtys
	ARRAY TEXT:C222(asDiff; $numberOfCombinations)
	$combo:=0
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		
		For ($pspec; 1; $numberOfPspecs)
			For ($qty; 1; $numberOfQtys)
				$combo:=$combo+1
				asDiff{$combo}:="QTY"+Replace string:C233(String:C10($qty); " "; "")+"-"+[Estimates_PSpecs:57]ProcessSpec:2
			End for 
			NEXT RECORD:C51([Estimates_PSpecs:57])
		End for 
		
	Else 
		
		ARRAY TEXT:C222($_ProcessSpec; 0)
		SELECTION TO ARRAY:C260([Estimates_PSpecs:57]ProcessSpec:2; $_ProcessSpec)
		
		For ($pspec; 1; $numberOfPspecs)
			For ($qty; 1; $numberOfQtys)
				$combo:=$combo+1
				asDiff{$combo}:="QTY"+Replace string:C233(String:C10($qty); " "; "")+"-"+$_ProcessSpec{$pspec}
			End for 
			
		End for 
		
	End if   // END 4D Professional Services : January 2019 First record
	
	ARRAY TEXT:C222(aSelected; $numberOfCombinations)
	ARRAY BOOLEAN:C223(ListBox1; $numberOfCombinations)
	asDiff:=0
	aSelected:=0
	ListBox1:=0
End if 
//EOP