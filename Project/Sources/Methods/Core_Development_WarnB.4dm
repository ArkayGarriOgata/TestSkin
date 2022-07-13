//%attributes = {}
//Method:  Core_Development_WarnB({oWarning})=>bDevelopmentWarning
//Description:  This method will warn if you are in Development
//. Use this around code that you want to warn will have consequences outside of intentions.

If (True:C214)  //Initialize 
	
	C_BOOLEAN:C305($0; $bDevelopmentWarning)
	C_OBJECT:C1216($1; $oWarning)
	
	C_LONGINT:C283($nNumberOfParameters)
	$nNumberOfParameters:=Count parameters:C259
	
	$oWarning:=New object:C1471()
	
	If ($nNumberOfParameters>=1)
		$oWarning:=$1
	End if 
	
	$bDevelopmentWarning:=True:C214
	
	$nApplicationType:=Application type:C494
	
	$bCompiled:=Is compiled mode:C492
	$bInterpretted:=Not:C34(Is compiled mode:C492)
	
	$tDeveloper:=Current user:C182
	
	Case of   //Application type
			
		: (Application type:C494=4D Desktop:K5:4)
			
			
		: (Application type:C494=4D Local mode:K5:1)
			
			
		: (Application type:C494=4D Remote mode:K5:5)
			
			
		: (Application type:C494=4D Server:K5:6)
			
			
		: (Application type:C494=4D Volume desktop:K5:2)
			
	End case   //Done application type
	
End if   //Done Initialize

Case of   //Warn
		
		//: ()  //Always warn if in interrpreted
		
		//Running on server and compiled and not developer it is ok
		//Running on server and interpretted and not developer it is ok
		
		//Running on standalone and compiled and not developer it is ok
		
	Else 
		
		$bDevelopmentWarning:=False:C215
		
End case   //Done warn

$0:=$bDevelopmentWarning

