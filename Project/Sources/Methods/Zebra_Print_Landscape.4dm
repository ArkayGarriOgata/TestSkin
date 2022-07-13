//%attributes = {"publishedWeb":true}
//PM: Zebra_Print_Landscape() -> 
//@author mlb - 11/14/01  14:26

C_TEXT:C284($e; $cr; $printQty)
$cr:=Char:C90(13)+Char:C90(10)
$e:="^FS"+$cr  //end data

$printQty:="^PQ"+String:C10(iCnt)
$serialNumber:=wmsCaseNumber1

C_TEXT:C284($labelDef; $0)
$labelDef:=""

$labelDef:=$labelDef+"^XA"+$cr
//$labelDef:=$labelDef+"^PRA"+$cr
$labelDef:=$labelDef+"^PR"+sCriterion1+$cr
$labelDef:=$labelDef+"^XFR:SIDEWAYS.ZPL"+$cr

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
$labelDef:=$labelDef+"^FN1^FD"+$line1+$e
//$labelDef:=$labelDef+"^FN2^FD"+$line2+$e
//$labelDef:=$labelDef+"^FN3^FD"+$line3+$e

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
$labelDef:=$labelDef+"^FN2^FD"+$line1+$e
//$labelDef:=$labelDef+"^FN5^FD"+$line2+$e
//$labelDef:=$labelDef+"^FN6^FD"+$line3+$e

$labelDef:=$labelDef+"^FN3^FD"+sCPN+$e
$labelDef:=$labelDef+"^FN4^FD"+sCPN+$e

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
$labelDef:=$labelDef+"^FN5^FD"+$line1+$e
//$labelDef:=$labelDef+"^FN10^FD"+$line2+$e
//$labelDef:=$labelDef+"^FN11^FD"+$line3+$e

$labelDef:=$labelDef+"^FN6^FD"+wmsCaseQtyString+$e
$labelDef:=$labelDef+"^FN7^FD"+wmsCaseQtyString+$e

$labelDef:=$labelDef+"^FN8^FD"+sPO+$e
//$labelDef:=$labelDef+"^FN15^FD"+sPO+$e

$labelDef:=$labelDef+"^FN9^FD"+sJMI+$e
$labelDef:=$labelDef+"^FN10^FD"+sJMI+$e


Case of 
	: ($serialNumber>0)
		$serialNumber:=$serialNumber+iCnt-1  //print back to front
		$labelDef:=$labelDef+"^FN11"+"^SN"+String:C10($serialNumber; "####;Partial;0")+",-1,Y"+$e
	: ($serialNumber<0)
		$labelDef:=$labelDef+"^FN11"+"^FD"+"Partial"+$e
	Else 
		$labelDef:=$labelDef+"^FN11"+"^FD"+""+$e
End case 

If (Length:C16(sOF)=0)
	sOF:="N/A"
End if 
$labelDef:=$labelDef+"^FN12^FD"+sOF+$e

$labelDef:=$labelDef+"^FN13^FD"+String:C10(dDate; System date short:K1:1)+$e

$labelDef:=$labelDef+$printQty
$labelDef:=$labelDef+"^XZ"
$0:=$labelDef  //SEND PACKET($labelDef)