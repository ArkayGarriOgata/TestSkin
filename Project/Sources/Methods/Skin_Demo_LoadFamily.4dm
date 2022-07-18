//%attributes = {}
/*
Method:  Skin_Demo_LoadFamily
Description:  This method will load family
*/

If (True:C214)  //Initialize
	
	var $tPathNameSkin : Text
	
	Compiler_Skin_Array(Current method name:C684; 0)
	
	$oResourceFolder:=Folder:C1567(fk resources folder:K87:11)
	
	$tPathNameSkin:=$oResourceFolder.platformPath+"Skin"
	
End if   //Done initialize

FOLDER LIST:C473($tPathNameSkin; Skin_Demo_atFamily)
