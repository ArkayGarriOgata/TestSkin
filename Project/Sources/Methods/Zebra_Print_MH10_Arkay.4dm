//%attributes = {}
//PM: Zebra_Print_MH10() -> 
//@author mlb - 11/14/01  14:26
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
$labelDef:=$labelDef+"^XFR:MH10_8.ZPL"+$cr

$line1:=""
$line2:=""
$line3:=""

$temp:=Uppercase:C13(Replace string:C233(tFrom; "Corporation"; ""))

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
$labelDef:=$labelDef+"^FN2^FD"+$line2+$e
$labelDef:=$labelDef+"^FN3^FD"+$line3+$e

$line1:=""
$line2:=""
$line3:=""
// Modified by: Mel Bohince (2/4/14) Loreal spl promo requirements, repurpose mh10.8
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
$labelDef:=$labelDef+"^FN4^FD"+$line1+$e
$labelDef:=$labelDef+"^FN5^FD"+$line2+$e
$labelDef:=$labelDef+"^FN6^FD"+$line3+$e

$labelDef:=$labelDef+"^FN7^FD"+sPO+$e
$labelDef:=$labelDef+"^FN8^FD"+sPO+$e

$labelDef:=$labelDef+"^FN9^FD"+sCPN+$e
$labelDef:=$labelDef+"^FN10^FD"+sCPN+$e

$line1:=""
$line2:=""
$line3:=""
$temp:=sDesc
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
$labelDef:=$labelDef+"^FN11^FD"+$line1+$e
//$labelDef:=$labelDef+"^FN10^FD"+$line2+$e
//$labelDef:=$labelDef+"^FN11^FD"+$line3+$e

$labelDef:=$labelDef+"^FN12^FD"+wmsCaseQtyString+$e
$labelDef:=$labelDef+"^FN13^FD"+wmsCaseQtyString+$e

//$labelDef:=$labelDef+"^FN14^FD"+sJMI+$e
//$labelDef:=$labelDef+"^FN15^FD"+sJMI+$e
$labelDef:=$labelDef+"^FN14^FD"+wmsHumanReadable1+$e
$labelDef:=$labelDef+"^FN15^FD"+wmsZebra128+$e

$labelDef:=$labelDef+"^FN16^FD"+String:C10(dDate; System date short:K1:1)+$e

If (wmsCaseNumber1>0)
	$labelDef:=$labelDef+"^FN17"+"^FD"+String:C10(wmsCaseNumber1; "####;Partial;0")+$e
Else 
	$labelDef:=$labelDef+"^FN17"+"^FD"+" "+$e
End if 

$labelDef:=$labelDef+$printQty
$labelDef:=$labelDef+$endLabel

$0:=$labelDef  //SEND PACKET($labelDef)