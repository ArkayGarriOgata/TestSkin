//%attributes = {"publishedWeb":true}
C_TEXT:C284($rptAlias)  // doRptOneRec
C_POINTER:C301($rptFilePtr)
C_LONGINT:C283($recNum)

$rptAlias:=<>whichRpt
$rptFilePtr:=<>rptFilePtr
$recNum:=<>recNum

GOTO RECORD:C242($rptFilePtr->; $recNum)
ONE RECORD SELECT:C189($rptFilePtr->)
FORM SET OUTPUT:C54($rptFilePtr->; $rptAlias)
PRINT SELECTION:C60($rptFilePtr->; *)
FORM SET OUTPUT:C54($rptFilePtr->; "Output")
UNLOAD RECORD:C212($rptFilePtr->)