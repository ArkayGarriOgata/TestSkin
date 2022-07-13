//%attributes = {}
//Method:  RMLc_Pick_Initialize(tPhase)
//Description:  This method handles initializing the RMLc_Pick form

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPhase)
	
	$tPhase:=$1
	
End if   //Done initialize

Case of   //Phase
		
	: ($tPhase=CorektPhaseInitialize)
		
		Form:C1466.nColdFoil:=0
		Form:C1466.nRollStock:=0
		Form:C1466.nSheeted:=0
		Form:C1466.nPlastic:=0
		
		Form:C1466.nAll:=0
		
End case   //Done phase
