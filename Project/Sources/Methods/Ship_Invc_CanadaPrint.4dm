//%attributes = {}
//Method:  Ship_Invc_RprtCanada
//Description:  This method will print the Canadian Invoice to attach
// to shipping.

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nPixels)
	
	$nPixels:=0
	
End if   //Done initialize

$nPixels:=Print form:C5("Ship_Invc_Canada")

PAGE BREAK:C6
