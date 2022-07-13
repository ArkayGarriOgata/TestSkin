//%attributes = {}
// USE uYesNoCancel INSTEAD

// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 11/05/12, 14:20:53
// ----------------------------------------------------
// Method: YesNoCancel(msg;yes_txt;no_txt;title)
// Description:
// Opens a dialog where the developer can specify values for Yes and No.
// $1 = Message to user.
// $2 = Text for Yes button (Optional)
// $3 = Text for No button (Optional)
// $4 = Window Title (Optional)
// $0 = "Yes", "No", or "Cancel"
// ----------------------------------------------------

C_TEXT:C284($1; tMsg; $2; tYes; $3; tNo; $4; tTitle; $0)

tMsg:=$1
If (Count parameters:C259>1)
	tYes:=$2
End if 
If (Count parameters:C259>2)
	tNo:=$3
End if 
If (Count parameters:C259>3)
	tTitle:=$4
Else 
	tTitle:=""
End if 

CenterWindow(400; 150; Movable dialog box:K34:7; tTitle)
DIALOG:C40("YesNoCancel")

Case of 
	: (bYes=1)  //Was Yes or No selected?
		$0:="Yes"
	: (bNo=1)
		$0:="No"
	Else 
		$0:="Cancel"
End case 