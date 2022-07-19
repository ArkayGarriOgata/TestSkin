//%attributes = {}
/*
 Method:  Skin_Entr_Source()
 Description:  Prompts for file selection and stores it to the Form
*/

If (True:C214)  // Initialize
	
	C_COLLECTION:C1488($cFormFamily; $cFormPathnames)
	
	C_LONGINT:C283($nPathname; $nPathParts)
	
	ARRAY TEXT:C222($atDocuments; 0)
	
	$cFormPathnames:=New collection:C1472()
	
	$cFormFamily:=New collection:C1472()
	
End if   // Done initialize

Select document:C905(""; ".png"; "Select Files"; Multiple files:K24:7; $atDocuments)

If (Size of array:C274($atDocuments)#0)
	
	Form:C1466.tSource:=Convert path POSIX to system:C1107($atDocuments{1})
	
	$tSplitPath:=Split string:C1554(Form:C1466.tSource; "/")
	
	$nPathParts:=$tSplitPath.count()
	
End if 

ARRAY TO COLLECTION:C1563($cFormPathnames; $atDocuments; "pathName")

For ($nPathname; 0; $cFormPathnames.count()-1; 1)
	
	OB SET:C1220($cFormPathnames[$nPathname]; "FamilyName"; $tSplitPath[$nPathParts-2])
	
End for 

Form:C1466.cSources:=$cFormPathnames

Skin_Entr_Manager


