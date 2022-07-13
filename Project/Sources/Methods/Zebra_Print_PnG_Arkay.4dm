//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 02/19/08, 16:55:12
// ----------------------------------------------------
// Method: Zebra_Print_PnG_Arkay
// Description
// 


C_TEXT:C284($e; $cr; $printQty)
$cr:=Char:C90(13)+Char:C90(10)
$e:="^FS"+$cr  //end data

$printQty:="^PQ1"  //+String(iCnt)

C_TEXT:C284($labelDef; $0)
$labelDef:=""

$labelDef:=$labelDef+"^XA"+$cr
//$labelDef:=$labelDef+"^PRA"+$cr
$labelDef:=$labelDef+"^PR"+sCriterion1+$cr
$labelDef:=$labelDef+"^XFR:PnG.ZPL"+$cr

$line1:=""
$line2:=""
$line3:=""
$temp:=Uppercase:C13(tTo)
$delim:=Position:C15(Char:C90(13); $temp)
If ($delim>0)
	$line1:=Substring:C12($temp; 1; $delim-1)
	$temp:=Substring:C12($temp; $delim+1)
	
	$delim:=Position:C15(Char:C90(13); $temp)
	If ($delim>0)
		$line2:=Substring:C12($temp; 1; $delim-1)
		$line3:=Substring:C12($temp; $delim+1)
	Else 
		$line2:=$temp
	End if 
Else 
	$line1:=$temp
End if 
$labelDef:=$labelDef+"^FN1^FD"+$line1+$e

$labelDef:=$labelDef+"^FN2^FD"+sCPN+$e
$labelDef:=$labelDef+"^FN3^FD"+sCPN+$e



$labelDef:=$labelDef+"^FN4^FD"+wmsCaseQtyString+$e
$labelDef:=$labelDef+"^FN5^FD"+wmsCaseQtyString+$e

$labelDef:=$labelDef+"^FN6^FD"+wmsHumanReadable1+$e
$labelDef:=$labelDef+"^FN7^FD"+wmsZebra128+$e

$line1:=""
$line2:=""
$line3:=""
$temp:=Uppercase:C13(sDesc)
$delim:=Position:C15(Char:C90(13); $temp)
If ($delim>0)
	$line1:=Substring:C12($temp; 1; $delim-1)
	$temp:=Substring:C12($temp; $delim+1)
	
	$delim:=Position:C15(Char:C90(13); $temp)
	If ($delim>0)
		$line2:=Substring:C12($temp; 1; $delim-1)
		$line3:=Substring:C12($temp; $delim+1)
	Else 
		$line2:=$temp
	End if 
Else 
	$line1:=$temp
End if 
$labelDef:=$labelDef+"^FN8^FD"+$line1+$e

$line1:=""
$line2:=""
$line3:=""
$temp:=Uppercase:C13(tFrom)
$delim:=Position:C15(Char:C90(13); $temp)
If ($delim>0)
	$line1:=Substring:C12($temp; 1; $delim-1)
	$temp:=Substring:C12($temp; $delim+1)
	
	$delim:=Position:C15(Char:C90(13); $temp)
	If ($delim>0)
		$line2:=Substring:C12($temp; 1; $delim-1)
		$line3:=Substring:C12($temp; $delim+1)
	Else 
		$line2:=$temp
	End if 
Else 
	$line1:=$temp
End if 
$labelDef:=$labelDef+"^FN9^FD"+$line1+$e

$labelDef:=$labelDef+"^FN10^FD"+String:C10(dDate; System date short:K1:1)+$e
$labelDef:=$labelDef+"^FN11^FD"+sPO+$e
If (wmsCaseNumber1>0)
	$labelDef:=$labelDef+"^FN12"+"^FD"+String:C10(wmsCaseNumber1; "####;Partial;0")+$e
Else 
	$labelDef:=$labelDef+"^FN12"+"^FD"+" "+$e
End if 

sOF:=""  //"N/A"

$labelDef:=$labelDef+"^FN13^FD"+sOF+$e

//sCriterion4:=""  `old code
$labelDef:=$labelDef+"^FN14^FD"+sCriterion4+$e
$labelDef:=$labelDef+"^FN15^FD"+sCriterion5+$e

$labelDef:=$labelDef+$printQty
$labelDef:=$labelDef+"^XZ"
$0:=$labelDef  //SEND PACKET($labelDef)