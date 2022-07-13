//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 03/06/13, 09:40:47
// ----------------------------------------------------
// Method: ClearCreateLists
// Description:
// Clears then creates new lists
// ----------------------------------------------------

C_TEXT:C284($tDoWhat; $1)

$tDoWhat:=$1

If ($tDoWhat="All")
	If (Is a list:C621(xlSublistRef1))  //If this is a list the others are too.
		CLEAR LIST:C377(xlSublistRef1; *)
		CLEAR LIST:C377(xlSublistRef2; *)
		CLEAR LIST:C377(xlSublistRef3; *)
		CLEAR LIST:C377(xlSublistRef4; *)
		CLEAR LIST:C377(xlSublistRef5; *)
		CLEAR LIST:C377(xlSublistRef6; *)
		CLEAR LIST:C377(xlSublistRef7; *)
	End if 
	
	xlSublistRef1:=New list:C375
	xlSublistRef2:=New list:C375
	xlSublistRef3:=New list:C375
	xlSublistRef4:=New list:C375
	xlSublistRef5:=New list:C375
	xlSublistRef6:=New list:C375
	xlSublistRef7:=New list:C375
	
End if 