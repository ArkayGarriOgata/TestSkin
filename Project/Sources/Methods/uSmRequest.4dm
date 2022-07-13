//%attributes = {"publishedWeb":true}
//gp: uSmRequest
//$1 - string - information request (question)
//$2 - string - default response or format
//$3 - string - Accept button text
//$4 - string - cancel button text
//$0 -> returns user entered reponse
//6/19/97 cs created - based on uRequest - smaller window
//• 1/14/98 cs changed variables to X instead of V
C_TEXT:C284(xText; xTitle)
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
uDialog("SmRequest"; 380; 145)

If (False:C215)  //insider
	FORM SET OUTPUT:C54([zz_control:1]; "SmRequest")
End if 
$0:=xText
//