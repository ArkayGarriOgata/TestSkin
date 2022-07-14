//%attributes = {}



If (True:C214)  // start initialize
	
	ARRAY TEXT:C222($atDocuments; 0)
	
	$cFormPathnames:=New collection:C1472()
	
End if   // done initialize


Select document:C905(""; ".png"; "Select Files"; Multiple files:K24:7; $atDocuments)
Form:C1466.tSource:=Convert path POSIX to system:C1107($atDocuments{1})

ARRAY TO COLLECTION:C1563($cFormPathnames; $atDocuments)
Form:C1466.cSources:=$cFormPathnames


