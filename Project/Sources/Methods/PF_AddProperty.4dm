//%attributes = {}
// -------
// Method: PF_AddProperty   (nodeRef;name;value ) ->
// By: Mel Bohince @ 10/10/17, 15:32:33
// Description
// 
// ----------------------------------------------------
If (False:C215)  // Modified by: Mel Bohince (7/9/21) disable
	$propref:=$1
	$name:=$2
	$value:=$3
	
	$ccRef:=DOM Append XML child node:C1080($propref; XML ELEMENT:K45:20; "<Property />")
	ARRAY TEXT:C222($AttrName; 0)
	ARRAY TEXT:C222($AttrVal; 0)
	APPEND TO ARRAY:C911($AttrName; "Name")
	APPEND TO ARRAY:C911($AttrVal; $name)
	APPEND TO ARRAY:C911($AttrName; "Value")
	APPEND TO ARRAY:C911($AttrVal; $value)
	DOM SET XML ATTRIBUTE:C866($ccRef; $AttrName{1}; $AttrVal{1}; $AttrName{2}; $AttrVal{2})
End if 
