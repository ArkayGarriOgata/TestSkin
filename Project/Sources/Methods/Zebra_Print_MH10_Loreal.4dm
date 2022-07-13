//%attributes = {}

// Method: Zebra_Print_MH10_Loreal ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 02/07/14, 14:54:11
// ----------------------------------------------------
// Description
// based on Zebra_Print_MH10_Arkay
//
// ----------------------------------------------------
// Modified by: Mel Bohince (2/4/14) Loreal spl promo requirements, repurpose mh10.8
//*Init vars
C_TEXT:C284($lableDef; $0)
$labelDef:=""
C_TEXT:C284($s; $e; $cr; $startLabel; $endLabel; $printQty)
$cr:=Char:C90(13)+Char:C90(10)  //Linefeed and carriage return
$b:="^FD"  //begin data
$e:="^FS"+$cr  //end data
$startLabel:="^XA"
$endLabel:="^XZ"

$printQty:="^PQ1"  //+String(iCnt)

C_TEXT:C284($labelDef)
$labelDef:=""

$labelDef:=$labelDef+$startLabel+$cr
$labelDef:=$labelDef+"^PR"+sCriterion1+$cr
//$labelDef:=$labelDef+"^PRA"+$cr
$labelDef:=$labelDef+"^XFR:MH10_LL.ZPL"+$cr


$labelDef:=$labelDef+"^FN1^FD"+sCPN+$e
$labelDef:=$labelDef+"^FN2^FD"+sDesc+$e
$labelDef:=$labelDef+"^FN3^FD"+sPO+$e
$labelDef:=$labelDef+"^FN4^FD"+wmsCaseQtyString+$e

If (bAddFSC=0)  //FSC 
	
	$labelDef:=$labelDef+"^FN5^FD"+String:C10(dDate; System date short:K1:1)+$e
	
Else   //Optional FSC location
	
	$labelDef:=$labelDef+"^FN5^FD"+String:C10(dDate; System date short:K1:1)+" FSC# BV-COC-070906"+$e
	
End if   //Done FSC

$labelDef:=$labelDef+"^FN6^FD"+wmsHumanReadable1+$e
$labelDef:=$labelDef+"^FN7^FD"+wmsZebra128+$e

$labelDef:=$labelDef+$printQty
$labelDef:=$labelDef+$endLabel

$0:=$labelDef  //SEND PACKET($labelDef)