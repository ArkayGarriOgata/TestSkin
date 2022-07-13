//%attributes = {"publishedWeb":true}
// _______
// Method: fCalcComm09   ($LFgross;$estFtPerRoll;$splCostPerRoll;$stdFtPerRoll;$stdCost;$wasteFactor) -> $matlError  (0=no err)
// By: MelvinBohince @ 03/08/22, 09:07:51
// Description
// rewrite, change arguments, calc to number of rolls as 
//.   rolls:= $LFgross*waste) then round up to nearest half rolls
//.   keeping Est-material flex field unchanged
// "Special" in the commodity key uses estimates values, otherwise use rm-groups values
// ----------------------------------------------------


C_REAL:C285($feetNeeded; $rollLengthFt; $2; $costPerRoll; $3; $4; $5; $wasteFactor; $6)
C_LONGINT:C283($0; $1)  //error#
C_TEXT:C284($note)

$feetNeeded:=$1  //from estimate's :  $LFgross:=uNANCheck ($grossSheets*$Length/12), going to assume that foiler will not be indexing, that would be a mfg positive variance

If (Position:C15("Special"; [Estimates_Materials:29]Commodity_Key:6)#0)  //allow for overrides and unusual foils, special should also mention color in the flex fields
	$note:="••SPL••: "
	$rollLengthFt:=$2  //set in est
	If ($rollLengthFt<=1)  //dont #div0, mayhave been left blank
		$rollLengthFt:=30000  //common length
	End if 
	
	$costPerRoll:=$3  //set in est
	If ($costPerRoll<=1)
		$costPerRoll:=$5  //set in rm_groups
	End if 
	
Else   //use standards from the Commodity record
	$note:=""
	$rollLengthFt:=$4  //set in rm_groups
	If ($rollLengthFt<=1)  //dont #div0, mayhave been left blank
		$rollLengthFt:=30000  //common length
	End if 
	
	$costPerRoll:=$5  //set in est
	
End if 

$wasteFactor:=$6  //set in rm_groups
If ($wasteFactor<1)  //no 0 or %reduction permitted
	$wasteFactor:=1
End if 

[Estimates_Materials:29]Comments:13:=$note+" GrossLF="+String:C10($feetNeeded)+" ft/roll="+String:C10($rollLengthFt)+" waste="+String:C10($wasteFactor)+" $/roll="+String:C10($costPerRoll)

If ([Estimates_Materials:29]UOM:8="ROLL")
	$feetNeeded:=$feetNeeded*$wasteFactor
	//fractions ok, issues can be in roll, 1/4roll, 1/2roll or butt
	$rollsNeeded:=Round:C94($feetNeeded/$rollLengthFt; 2)
	//round up to  1/2, or whole
	$wholeRolls:=Int:C8($rollsNeeded)
	$fractionRolls:=$rollsNeeded-$wholeRolls
	
	Case of   //round up to issuing units
		: ($fractionRolls>0.5)
			$fractionRolls:=1
		: ($fractionRolls>0.25)
			$fractionRolls:=0.5
		: ($fractionRolls>0)
			$fractionRolls:=0.5
		Else 
			//pass
	End case 
	$rollsNeeded:=$wholeRolls+$fractionRolls
	
	[Estimates_Materials:29]Qty:9:=uNANCheck($rollsNeeded)
	
	[Estimates_Materials:29]Cost:11:=[Estimates_Materials:29]Qty:9*$costPerRoll
	$0:=0
	
Else   //wrong UOM
	$matlError:=-901
	$0:=$matlError
End if 
