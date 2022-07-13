//%attributes = {"publishedWeb":true}
//gp: uYesNoCancel
//$1 - text string to disaplay
//$2,$3;$4 Yes & No& Cancel button text (optional)
//bCancel = "cancel", bAccept = "Yes", bNo = "No"
//the three buttons above are set to the indicated text, ONLY 'yes' and 'No' 
//text can be changed
//both bCancel & bNo set OK=0, bAccept sets OK=1

C_TEXT:C284($1; MyText; $2; sOKText; $3; sNoText; $4; sCancelText; tTitle; $0)

If (Count parameters:C259>=1)
	MyText:=$1
End if 
If (Count parameters:C259>=2)
	sOKText:=$2
Else 
	sOKText:=""
End if 
If (Count parameters:C259>=3)
	sNoText:=$3
Else 
	sNoText:=""
End if 
If (Count parameters:C259=4)
	sCancelText:=$4
Else 
	sCancelText:=""
End if 




$winRef:=NewWindow(380; 135; 6; 5; "Hmmm...")
DIALOG:C40([zz_control:1]; "YesNoCancel")

Case of 
	: (bAccept=1)
		$0:=sOKText
	: (bNo=1)
		$0:=sNoText
	Else 
		$0:=sCancelText
End case 

CLOSE WINDOW:C154($winRef)
