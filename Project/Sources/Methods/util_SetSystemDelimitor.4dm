//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 02/08/07, 11:39:29
// ----------------------------------------------------
// Method: util_SetSystemDelimitor()  --> 
// Description
// 
//
// ----------------------------------------------------

// ----------------------------------------------------
//C_LONGINT($vlPlatform;$vlSystem;$vlMachine)
//_O_PLATFORM_PROPERTIES($vlPlatform;$vlSystem;$vlMachine)
Case of 
	: (Is macOS:C1572)
		<>DELIMITOR:=":"
		
	: (Is Windows:C1573)
		<>DELIMITOR:="\\"
		
	Else 
		<>DELIMITOR:=":"
End case 