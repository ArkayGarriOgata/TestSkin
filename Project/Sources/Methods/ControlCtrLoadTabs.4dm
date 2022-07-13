//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 04/15/13, 14:24:42
// ----------------------------------------------------
// Method: ControlCtrLoadTabs
// Description:
// Loads the proper tab items.
// ----------------------------------------------------

C_BOOLEAN:C305($1; bLarge)

If ($1)  //ProjectComponents
	bLarge:=True:C214
	ARRAY TEXT:C222(atPjtControlCtr; 10)
	atPjtControlCtr{1}:="Home"
	atPjtControlCtr{2}:="Size & Style"
	atPjtControlCtr{3}:="Color"
	atPjtControlCtr{4}:="Art"
	atPjtControlCtr{5}:="Estimate"
	atPjtControlCtr{6}:="F/G"
	atPjtControlCtr{7}:="Order"
	atPjtControlCtr{8}:="Supt Item"
	atPjtControlCtr{9}:="Job"
	atPjtControlCtr{10}:="Customer"
	atPjtControlCtr:=1
	
Else   //ProjectComponSmall
	bLarge:=False:C215
	ARRAY TEXT:C222(atPjtControlCtr; 2)
	atPjtControlCtr{1}:="Home"
	atPjtControlCtr{2}:="Customer"
	atPjtControlCtr:=2
	
End if 