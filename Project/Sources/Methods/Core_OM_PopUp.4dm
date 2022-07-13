//%attributes = {}
//Method:  Core_OM_PopUp (patPopUp)
//Description:  This will handle popups

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $patPopUp)
	C_LONGINT:C283($nTable; $nField)
	
	$patPopUp:=$1
	
	RESOLVE POINTER:C394($patPopUp; $tPopUp; $nTable; $nField)
	
End if   //Done initialize

Case of 
		
		
End case 
