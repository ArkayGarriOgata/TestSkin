//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 02/18/20, 13:49:18
// ----------------------------------------------------
// Method: PK_getCaseDimensions(packing spec#)->obj with length, width, height
// Description
// see also PK_getCaseDimensionsText
//
// Parameters
// ----------------------------------------------------
C_TEXT:C284($1; $dimensionText)
C_LONGINT:C283($xAt)
C_OBJECT:C1216($caseDimensions; $0)
$caseDimensions:=New object:C1471("length"; 12; "width"; 12; "height"; 12)  //default to a cubic foot


Case of 
	: (Count parameters:C259=0)
		$packingSpec:="A060639"
		$dimensionText:=ds:C1482.Finished_Goods_PackingSpecs.query("FileOutlineNum = :1"; $packingSpec).first().CaseSizeLWH
		
	Else 
		$dimensionText:=$1
End case 

If (Length:C16($dimensionText)>0)
	
	$xAt:=Position:C15("x"; $dimensionText)
	$caseDimensions.length:=Num:C11(Substring:C12($dimensionText; 1; $xAt-1))
	
	$dimensionText:=Substring:C12($dimensionText; $xAt+1)  //split
	$xAt:=Position:C15("x"; $dimensionText)
	$caseDimensions.width:=Num:C11(Substring:C12($dimensionText; 1; $xAt-1))
	
	$dimensionText:=Substring:C12($dimensionText; $xAt+1)  //split
	$caseDimensions.height:=Num:C11(Substring:C12($dimensionText; 1))
	
End if 
$0:=$caseDimensions
