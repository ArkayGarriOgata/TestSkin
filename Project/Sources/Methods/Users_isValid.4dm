//%attributes = {}

// Method: Users_isValid ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 07/29/14, 10:13:05
// ----------------------------------------------------
// Description
// make sure everyone listed in log in dialog has not been terminated
//
// ----------------------------------------------------

ARRAY TEXT:C222($sUserNames; 0)
ARRAY LONGINT:C221($aUserNumbers; 0)
GET USER LIST:C609($sUserNames; $aUserNumbers)
SET QUERY DESTINATION:C396(Into variable:K19:4; $valid)

$numElements:=Size of array:C274($sUserNames)

uThermoInit($numElements; "Checking Users")
For ($i; 1; Size of array:C274($sUserNames))
	If (Position:C15($sUserNames{$i}; "Web EDI VirtualFactory")=0)
		QUERY:C277([Users:5]; [Users:5]UserName:11=$sUserNames{$i}; *)
		QUERY:C277([Users:5];  & ; [Users:5]DOT:30=!00-00-00!)
		If ($valid<1)
			BEEP:C151
			ALERT:C41($sUserNames{$i})
		End if 
	End if 
	uThermoUpdate($i)
End for 
uThermoClose

SET QUERY DESTINATION:C396(Into current selection:K19:1)
