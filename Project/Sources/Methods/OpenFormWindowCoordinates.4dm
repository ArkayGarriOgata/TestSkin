//%attributes = {}
// _______
// Method: OpenFormWindowCoordinates   ( ) ->
// By: Mel Bohince @ 04/16/20, 11:19:04
// Description
// increment the x and y with some limits
// ----------------------------------------------------

C_TEXT:C284($1)
C_OBJECT:C1216($0)
C_LONGINT:C283(<>winX; <>winY; $max_Y)

Case of 
	: ($1="get")
		<>winX:=<>winX+40
		<>winY:=<>winY+40
		$max_Y:=Screen height:C188/4
		If (<>winY>$max_Y)
			<>winX:=200
			<>winY:=60
		End if 
		
	: ($1="set")
		<>winX:=40  // used by NewWindow for stacking
		<>winY:=80
End case 

$0:=New object:C1471("x"; <>winX; "y"; <>winY)