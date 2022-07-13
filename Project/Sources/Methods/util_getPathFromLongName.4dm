//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 01/17/07, 16:54:10
// ----------------------------------------------------
// Method: util_getPathFromLongName()  --> 
// Description
// based on 4D helpfile at http://www.4d.com/docs/CMU/CMU02012.HTM
//
// ----------------------------------------------------

// ----------------------------------------------------
// Long name to path name Project Name
// Long name to path name ( String ) -> String
// Long name to path name ( Long file name ) -> Path name

C_TEXT:C284($1; $0)
C_TEXT:C284($vsDirSymbol)
C_LONGINT:C283($viLen; $viPos; $viChar; $viDirSymbol)

$viDirSymbol:=Character code:C91(<>DELIMITOR)
$viLen:=Length:C16($1)
$viPos:=0
For ($viChar; $viLen; 1; -1)
	If (Character code:C91($1[[$viChar]])=$viDirSymbol)
		$viPos:=$viChar
		$viChar:=0
	End if 
End for 
If ($viPos>0)
	$0:=Substring:C12($1; 1; $viPos)
Else 
	$0:=$1
End if 