//%attributes = {}
//Method:  Core_Convert_NumberB(rNumber)=>Boolean
//Description:  This method takes a number and converts it to 
//  true or false

If (True:C214)  //Initialize
	
	C_REAL:C285($1; $rNumber)
	C_BOOLEAN:C305($0; $bValue)
	
	$rNumber:=$1
	$bValue:=True:C214
	
End if   //Done Initialize

$bValue:=Choose:C955($rNumber=0; False:C215; True:C214)

$0:=$bValue