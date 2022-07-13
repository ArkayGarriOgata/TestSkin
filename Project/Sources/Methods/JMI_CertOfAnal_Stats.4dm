//%attributes = {"publishedWeb":true}
//PM: JMI_CertOfAnal_Stats() -> 
//@author mlb - 3/18/02  14:08

ARRAY REAL:C219(aValue; 0)

SELECTION TO ARRAY:C260([Job_Forms_Items_CertOfAnal:117]Caliper:3; aValue)
rReal1:=util_Stat_Mean(->aValue)
rReal9:=Round:C94(util_Stat_StdDev(->aValue); 4)
$hit:=Find in array:C230(aAttribute; "Board Caliper")
If ($hit>-1)
	aMean{$hit}:=rReal1
	aStdDev{$hit}:=rReal9
End if 

ARRAY REAL:C219(aValue; 0)
SELECTION TO ARRAY:C260([Job_Forms_Items_CertOfAnal:117]CaliperSecondScore:4; aValue)
rReal2:=util_Stat_Mean(->aValue)
rReal10:=Round:C94(util_Stat_StdDev(->aValue); 4)

ARRAY REAL:C219(aValue; 0)
SELECTION TO ARRAY:C260([Job_Forms_Items_CertOfAnal:117]CaliperFourthScore:5; aValue)
rReal3:=util_Stat_Mean(->aValue)
rReal11:=Round:C94(util_Stat_StdDev(->aValue); 4)

ARRAY REAL:C219(aValue; 0)
SELECTION TO ARRAY:C260([Job_Forms_Items_CertOfAnal:117]CaliperDifference:6; aValue)
rReal4:=util_Stat_Mean(->aValue)
rReal12:=Round:C94(util_Stat_StdDev(->aValue); 4)
$hit:=Find in array:C230(aAttribute; "Diff. Btw. 2nd & 4th Scores")
If ($hit>-1)
	aMean{$hit}:=rReal4
	aStdDev{$hit}:=rReal12
End if 

ARRAY REAL:C219(aValue; 0)
SELECTION TO ARRAY:C260([Job_Forms_Items_CertOfAnal:117]ScoreBendRatio:7; aValue)
rReal5:=util_Stat_Mean(->aValue)
rReal13:=Round:C94(util_Stat_StdDev(->aValue); 4)
$hit:=Find in array:C230(aAttribute; "Score Bend Ratio")
If ($hit>-1)
	aMean{$hit}:=rReal5
	aStdDev{$hit}:=rReal13
End if 

ARRAY REAL:C219(aValue; 0)
SELECTION TO ARRAY:C260([Job_Forms_Items_CertOfAnal:117]GlueFlapSkew:8; aValue)
rReal6:=util_Stat_Mean(->aValue)
rReal14:=Round:C94(util_Stat_StdDev(->aValue); 4)
$hit:=Find in array:C230(aAttribute; "Skew")
If ($hit>-1)
	aMean{$hit}:=rReal6
	aStdDev{$hit}:=rReal14
End if 

ARRAY REAL:C219(aValue; 0)
SELECTION TO ARRAY:C260([Job_Forms_Items_CertOfAnal:117]OpeningForceCarton:9; aValue)
rReal7:=util_Stat_Mean(->aValue)
rReal15:=Round:C94(util_Stat_StdDev(->aValue); 4)
$hit:=Find in array:C230(aAttribute; "Opening Force Carton")
If ($hit>-1)
	aMean{$hit}:=rReal7
	aStdDev{$hit}:=rReal15
End if 

ARRAY REAL:C219(aValue; 0)
SELECTION TO ARRAY:C260([Job_Forms_Items_CertOfAnal:117]OpeningForceSleeve:11; aValue)
rReal29:=util_Stat_Mean(->aValue)
rReal30:=Round:C94(util_Stat_StdDev(->aValue); 4)
$hit:=Find in array:C230(aAttribute; "Opening Force Sleeve")
If ($hit>-1)
	aMean{$hit}:=rReal29
	aStdDev{$hit}:=rReal30
End if 

ARRAY REAL:C219(aValue; 0)
SELECTION TO ARRAY:C260([Job_Forms_Items_CertOfAnal:117]CoeffOfFrictionUV:10; aValue)
rReal8:=util_Stat_Mean(->aValue)
rReal16:=Round:C94(util_Stat_StdDev(->aValue); 4)
$hit:=Find in array:C230(aAttribute; "Coeff. of Friction UV")
If ($hit>-1)
	aMean{$hit}:=rReal8
	aStdDev{$hit}:=rReal16
End if 

ARRAY REAL:C219(aValue; 0)
SELECTION TO ARRAY:C260([Job_Forms_Items_CertOfAnal:117]CoeffOfFrictionWB:12; aValue)
rReal33:=util_Stat_Mean(->aValue)
rReal34:=Round:C94(util_Stat_StdDev(->aValue); 4)
$hit:=Find in array:C230(aAttribute; "Coeff. of Friction WB")
If ($hit>-1)
	aMean{$hit}:=rReal33
	aStdDev{$hit}:=rReal34
End if 

ARRAY REAL:C219(aValue; 0)
For ($i; 1; Size of array:C274(aAttribute))
	aCpk{$i}:=util_Stat_Cpk(aLowerLimit{$i}; aUpperLimit{$i}; aMean{$i}; aStdDev{$i})
	If (aCpk{$i}<1) & (aMean{$i}#0) & (aStdDev{$i}#0)
		BEEP:C151
		ALERT:C41(aAttribute{$i}+"'s Cpk is less than 1!")
	End if 
	aPPM{$i}:=util_Stat_PPM(aLowerLimit{$i}; aUpperLimit{$i}; aMean{$i}; aStdDev{$i})
End for 

rReal17:=aCpk{1}
rReal18:=aCpk{8}
rReal19:=aCpk{5}
rReal20:=aCpk{2}
rReal21:=aCpk{3}
rReal31:=aCpk{4}
rReal22:=aCpk{6}
rReal35:=aCpk{7}

rReal23:=aPPM{1}
rReal24:=aPPM{8}
rReal25:=aPPM{5}
rReal26:=aPPM{2}
rReal27:=aPPM{3}
rReal32:=aPPM{4}
rReal28:=aPPM{6}
rReal36:=aPPM{7}

zwStatusMsg("COA"; "Calculation completed at "+TS2String(TSTimeStamp))