//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 10/17/05, 14:01:38
// ----------------------------------------------------
// Method: HR_setDisplayName
// ----------------------------------------------------

C_TEXT:C284(foolName; $0; $1)

Case of 
	: (Count parameters:C259=0)
		foolName:=[Users:5]LastName:2+", "+[Users:5]FirstName:3+" "+[Users:5]MI:4
	: ($1="formal")
		foolName:=[Users:5]FirstName:3+" "+[Users:5]MI:4+" "+[Users:5]LastName:2
End case 
$0:=foolName