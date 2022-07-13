//%attributes = {}
//Method:  Util_GetPlatformN=>nPlatform
//Desctipition:  This method will return the numeric value of the platform
//.  based on the constants provided by 4D

If (True:C214)  //Initialize
	
	C_LONGINT:C283($0; $nPlatform)
	
	$nPlatform:=0
	
End if   //Done initilialize

Case of   //Choose platform
		
	: (Is macOS:C1572)
		
		$nPlatform:=Mac OS:K25:2
		
	: (Is Windows:C1573)
		
		$nPlatform:=Windows:K25:3
		
	Else   //
		
		$nPlatform:=0
		
End case   //Done choose platform

$0:=$nPlatform