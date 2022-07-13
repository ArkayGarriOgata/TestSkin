//%attributes = {"publishedWeb":true}
//(P) gCalcLY

aSubTitle:="LAST YEAR"
If (rLYSheets=0)
	rLYDown_Bud:=0
End if 
If (rLYAct_MR#0)
	rLYEff_MR:=Round:C94((rLYStd_MR/rLYAct_MR)*100; 1)
Else 
	rLYEff_MR:=0
End if 
If (rLYAct_Run#0)
	rLYEff_Run:=Round:C94((rLYStd_Run/rLYAct_Run)*100; 1)
Else 
	rLYEff_Run:=0
End if 
If (rLYAct_Tot#0)
	rLYEff_Tot:=Round:C94((rLYStd_Tot/rLYAct_Tot)*100; 1)
Else 
	rLYEff_Tot:=0
End if 
If (rLYDown_Hrs#0)
	rLYDown_Pct:=Round:C94((rLYDown_Hrs/(rLYAct_Tot+rLYDown_Hrs))*100; 1)
Else 
	rLYDown_Pct:=0
End if 
If (rLYAct_Run#0)
	rLYAct_Imp:=Round:C94(rLYSheets/rLYAct_Run; 0)
Else 
	rLYAct_Imp:=0
End if 
If (rLYStd_Run#0)
	rLYStd_Imp:=Round:C94(rLYSheets/rLYStd_Run; 0)
Else 
	rLYStd_Imp:=0
End if 