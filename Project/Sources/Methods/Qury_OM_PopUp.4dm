//%attributes = {}
//Method:  Qury_OM_PopUp (patPopUp)
//Description:  This will handle popups

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $patPopUp)
	C_LONGINT:C283($nTable; $nField)
	
	$patPopUp:=$1
	
	RESOLVE POINTER:C394($patPopUp; $tPopUp; $nTable; $nField)
	
End if   //Done initialize

Case of 
		
	: (Position:C15("Qury_View_atConjunction"; $tPopUp)>0)
		
		Qury_View_Conjunction($patPopUp)
		
End case 
