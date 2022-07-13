//%attributes = {}
//Method:  FGLc_Adjust_Location(tPhase{;pOption1})
//Description:  This method handles initializing values

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPhase)
	C_POINTER:C301($2; $pOption1)
	
	C_LONGINT:C283($nNumberOfParameters)
	C_LONGINT:C283($nColumn; $nRow)
	C_TEXT:C284($tCase)
	
	$tPhase:=$1
	
	$nNumberOfParameters:=Count parameters:C259
	
	If ($nNumberOfParameters>=2)
		$pOption1:=$2
	End if 
	
	$nColumn:=0
	$nRow:=0
	
	$tCase:="Case"
	
End if   //Done Initialize

Case of   //Phase
		
	: ($tPhase=CorektPhaseAssignVariable)
		
		If (Form event code:C388=On Clicked:K2:4)  //Entry
			
			Core_ListBox_EnterNow(OBJECT Get pointer:C1124)
			
		End if   //Done entry
		
		FGLc_Adjust_Manager
		
		LISTBOX GET CELL POSITION:C971(FGLc_abAdjust_Location; $nColumn; $nRow)
		
		Case of   //Skid is case
				
			: ($nRow<=0)  //Ignore
				
			: ($nRow>Size of array:C274(FGLc_atLoc_Skid))  //Ignore
				
			: (FGLc_atLoc_Skid{$nRow}#"CASE")  //Not case 
				
			: (FGLc_abLoc_Delete{$nRow})  //Delete it
				
				FGLc_Adjust_Reason(Current method name:C684; ->$tCase)
				
			: (FGLc_anLoc_OriginalQty{$nRow}=FGLc_anLoc_Qty{$nRow})  //No change 
				
				If (Not:C34(FGLc_Adjust_LocationCaseB))  //No skids with case are selected
					
					FGLc_Adjust_Reason("FGLc_Adjust_Negative")
					
				End if   //Done no skids with case are selected
				
			Else 
				
				FGLc_Adjust_Reason(Current method name:C684; ->$tCase)
				
		End case   //Done skid is case
		
	: ($tPhase=CorektPhaseInitialize)
		
		FGLc_Adjust_LoadLocation($pOption1->)
		
End case   //Done phase