//%attributes = {}
// _______
// Method: PK_getVolumePerCase   ( ) ->
// By: Mel Bohince @ 02/05/20, 16:39:04
// Description
// try to estimate the cubic volume in in^3
// ----------------------------------------------------

C_REAL:C285($0; $a; $b; $c)
C_TEXT:C284($1; $dimensionText)
C_LONGINT:C283($xAt)
C_OBJECT:C1216($entSel)

$entSel:=ds:C1482.Finished_Goods_PackingSpecs.query("FileOutlineNum = :1"; $1)

If ($entSel.length>0)
	$dimensionText:=$entSel.first().CaseSizeLWH
	$xAt:=Position:C15("x"; $dimensionText)
	$a:=Num:C11(Substring:C12($dimensionText; 1; $xAt-1))
	
	$dimensionText:=Substring:C12($dimensionText; $xAt+1)  //split
	$xAt:=Position:C15("x"; $dimensionText)
	$b:=Num:C11(Substring:C12($dimensionText; 1; $xAt-1))
	
	$dimensionText:=Substring:C12($dimensionText; $xAt+1)  //split
	$c:=Num:C11(Substring:C12($dimensionText; 1; $xAt-1))
	
	$0:=$a*$b*$c
	
Else 
	$0:=0
End if 