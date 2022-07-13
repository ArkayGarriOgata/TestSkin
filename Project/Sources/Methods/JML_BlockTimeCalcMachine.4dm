//%attributes = {}
// Method: JML_BlockTimeCalcMachine (ptr to checkbox;quantity) -> 
// ----------------------------------------------------
// by: mel: 01/27/05, 08:44:51
// ----------------------------------------------------
// Description:
// find the c/c, rate, & mr to calc hour required for given qty
// ----------------------------------------------------

C_LONGINT:C283($row; $2)  //$2 is the impressions in sheets or cartons
C_POINTER:C301($1; $ptrCC; $ptrRate; $ptrHrs)

RESOLVE POINTER:C394($1; $rowVar; $table; $field)

$row:=Num:C11(Substring:C12($rowVar; 3; 1))
$ptrCC:=Get pointer:C304("r"+String:C10($row))
$ptrRate:=Get pointer:C304("r1"+String:C10($row))
$ptrHrs:=Get pointer:C304("r2"+String:C10($row))

If ($1->=1)
	$ptrCC->:=aCCid{$row}
	$ptrRate->:=aRate{$row}
	$ptrHrs->:=Round:C94(($2/aRate{$row}+(aMR{$row}*iNumJobs)); 0)
	
Else 
	$ptrCC->:=0
	$ptrRate->:=0
	$ptrHrs->:=0
End if 