//%attributes = {"publishedWeb":true}
//Procedure: uChkHighOOP()  `•070198  MLB  warn if high OOP costs 
//check for high OOP costs
ARRAY REAL:C219($aTotalCost; 0)
SELECTION TO ARRAY:C260([Estimates_Differentials:38]CostTTL:14; $aTotalCost)
C_BOOLEAN:C305($highCost)
C_LONGINT:C283($j)
$highCost:=False:C215
For ($j; 1; Size of array:C274($aTotalCost))
	If ($aTotalCost{$j}>100000)
		$highCost:=True:C214
	End if 
End for 
ARRAY REAL:C219($aTotalCost; 0)
If ($highCost)
	BEEP:C151
	ALERT:C41("WARNING: Out-Of-Pocket costs exceed $100,000, contact Pricing Commitee.")
End if 
//•070198  MLB  end