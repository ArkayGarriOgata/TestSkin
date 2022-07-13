//%attributes = {"publishedWeb":true}
//Procedure: uChkMissingCost(est num)  010699  MLB
//look for material or machines w/o costs
$MatItems:=""
$MachItems:=""
QUERY:C277([Estimates_Machines:20]; [Estimates_Machines:20]EstimateNo:14=$1)  //find them
ARRAY TEXT:C222($aCC; 0)
SELECTION TO ARRAY:C260([Estimates_Machines:20]CostOOP:28; $aCost; [Estimates_Machines:20]CostCtrID:4; $aCC)
For ($i; 1; Size of array:C274($aCost))
	If ($aCost{$i}=0)
		$MachItems:=$MachItems+(", "*Num:C11($MachItems#"")+$aCC{$i})*Num:C11(Position:C15($aCC{$i}; $MachItems)=0)
	End if 
End for 

ARRAY TEXT:C222($aCC; 0)
QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]EstimateNo:5=$1)  //find them
SELECTION TO ARRAY:C260([Estimates_Materials:29]Cost:11; $aMatCost; [Estimates_Materials:29]CostCtrID:2; $aCC)
For ($i; 1; Size of array:C274($aMatCost))
	If ($aMatCost{$i}=0)
		$MatItems:=$MatItems+(", "*Num:C11($MatItems#"")+$aCC{$i})*Num:C11(Position:C15($aCC{$i}; $MatItems)=0)
	End if 
End for 

Case of 
	: ($MatItems#"") & ($MachItems#"")
		BEEP:C151
		ALERT:C41("The Following Machine Estimates have NO COST : "+$MachItems+<>sCr+"The Following Material Estimates have NO COST : "+$MatItems)
	: ($MachItems#"")
		BEEP:C151
		ALERT:C41("The Following Machine Estimates have NO COST : "+$MachItems)
	: ($MatItems#"")
		BEEP:C151
		ALERT:C41("The Following Material Estimates have NO COST : "+$MatItems)
End case 
//