//%attributes = {"publishedWeb":true}
//gp: uRequest
//$1 - string - information request (question)
//$2 - string - default response or format
//$3 - string - Accept button text
//$4 - string - cancel button text
//$0 -> returns user entered reponse
If (Count parameters:C259>0)
	xTitle:=$1
Else 
	xTitle:=""
End if 

If (Count parameters:C259>=2)
	xText:=$2
Else 
	xText:=""
End if 

If (Count parameters:C259>=3)
	sOKText:=$3
Else 
	sOKText:=""
End if 

If (Count parameters:C259=4)
	sCancelText:=$4
Else 
	sCancelText:=""
End if 
uDialog("Request"; 380; 262)

If (False:C215)  //insider
	FORM SET OUTPUT:C54([zz_control:1]; "Request")
End if 
$0:=xText
//