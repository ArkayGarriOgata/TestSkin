//%attributes = {}
//Method:  Cust_Input_NameColor
//Description:  This method will allow customers names to be colorized

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nBackground; $nForeground)
	
End if   //Done initialize

$nForeground:=Select RGB color:C956(Blue:K11:7; "Select Foreground color")
$nBackground:=Select RGB color:C956(Grey:K11:15; "Select Background color")

[Customers:16]ColorForeground:69:=$nForeground
[Customers:16]ColorBackground:70:=$nBackground

OBJECT SET RGB COLORS:C628([Customers:16]Name:2; $nForeground; $nBackground)
