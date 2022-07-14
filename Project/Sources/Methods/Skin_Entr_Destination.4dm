//%attributes = {}
//  Method:  Skin_Entr_Destiniation()
//  Description:  Prompts for a folder selection and stores it to the Form

If (True:C214)  // start initialize
	
	ARRAY TEXT:C222($atDocuments; 0)
	
	$cFormPathnames:=New collection:C1472()
	
	var $tDestinationFolder : Text
	
End if   // done initialize

$tDestinationFolder:=Select folder:C670()
Form:C1466.tDestination:=$tDestinationFolder


