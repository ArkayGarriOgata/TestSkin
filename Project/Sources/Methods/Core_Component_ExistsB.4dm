//%attributes = {}
//Method:  Core_Component_ExistsB(tComponent)=>bExists
//Description:  This method 

If (True:C214)  //Initialize 
	
	C_BOOLEAN:C305($0; $bExists)
	C_TEXT:C284($1; $tComponent)
	
	ARRAY TEXT:C222($atComponentList; 0)
	
	$tComponent:=$1
	
	$bExists:=False:C215
	
End if   //Done Initialize

COMPONENT LIST:C1001($atComponentList)

$bExists:=(Find in array:C230($atComponentList; $tComponent)#CoreknNoMatchFound)

$0:=$bExists
