//%attributes = {}
//OBSOLETE, no longer a limit, just be careful with the parameters in text to blob and back

// Method: pattern_BigText ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 03/03/14, 13:18:29
// ----------------------------------------------------
// Description
// store text in an buffer, array, if chance it will exceed text var 32k limit
//
// ----------------------------------------------------
C_TEXT:C284($t; $r)
$t:=Char:C90(9)
$r:=Char:C90(13)

ARRAY TEXT:C222($aText; 0)
C_LONGINT:C283($page; $i; $numRels)
$page:=1
ARRAY TEXT:C222($aText; $page)

For ($i; 1; $numRels)
	If (Length:C16($aText{$page})>30000)  //make new buffer so no overflow
		$page:=$page+1
		ARRAY TEXT:C222($aText; $page)
	End if 
	
	$aText{$page}:=$aText{$page}+"your-content-here"+$r  //now just process as normal
	
End for 