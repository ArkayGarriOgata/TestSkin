//%attributes = {"publishedWeb":true}
//(P) gCalcCY
//-----------------------------

If (zzi<10)
	zziMth:=zzi+3
Else 
	zziMth:=zzi-9
End if 
aSubTitle:=<>ayMonth{zziMth}
//-----------------------------
rSheets:=aySheets{zziMth}
rAct_MR:=ayAct_MR{zziMth}
rStd_MR:=ayStd_MR{zziMth}
rAct_Run:=ayAct_Run{zziMth}
rStd_Run:=ayStd_Run{zziMth}
rAct_Tot:=ayAct_Tot{zziMth}
rStd_Tot:=ayStd_Tot{zziMth}
rDown_Hrs:=ayDown_Hrs{zziMth}
//-----------------------------
//Melissa: every month must have a Down Budget even if there are no sheets budget
//If (rSheets=0)
//rDown_Bud:=0
//Else 
rDown_Bud:=rDownBud
//End if 

If (rAct_MR#0)
	rEff_MR:=Round:C94((rStd_MR/rAct_MR)*100; 1)
Else 
	rEff_MR:=0
End if 
If (rAct_Run#0)
	rEff_Run:=Round:C94((rStd_Run/rAct_Run)*100; 1)
Else 
	rEff_Run:=0
End if 
If (rAct_Tot#0)
	rEff_Tot:=Round:C94((rStd_Tot/rAct_Tot)*100; 1)
Else 
	rEff_Tot:=0
End if 
If (rDown_Hrs#0)
	rDown_Pct:=Round:C94((rDown_Hrs/(rAct_Tot+rDown_Hrs))*100; 1)
Else 
	rDown_Pct:=0
End if 
If (rAct_Run#0)
	rAct_Imp:=Round:C94(rSheets/rAct_Run; 0)
Else 
	rAct_Imp:=0
End if 
If (rStd_Run#0)
	rStd_Imp:=Round:C94(rSheets/rStd_Run; 0)
Else 
	rStd_Imp:=0
End if 
//---------------------------------------
rCMSheets:=rCMSheets+rSheets
rCMAct_MR:=rCMAct_MR+rAct_MR
rCMStd_MR:=rCMStd_MR+rStd_MR
rCMAct_Run:=rCMAct_Run+rAct_Run
rCMStd_Run:=rCMStd_Run+rStd_Run
rCMAct_Tot:=rCMAct_Tot+rAct_Tot
rCMStd_Tot:=rCMStd_Tot+rStd_Tot
rCMDown_Hrs:=rCMDown_Hrs+rDown_Hrs
//---------------------------------------
If (rCMAct_MR#0)
	rCMEff_MR:=Round:C94((rCMStd_MR/rCMAct_MR)*100; 1)
Else 
	rCMEff_MR:=0
End if 
If (rCMAct_Run#0)
	rCMEff_Run:=Round:C94((rCMStd_Run/rCMAct_Run)*100; 1)
Else 
	rCMEff_Run:=0
End if 
If (rCMAct_Tot#0)
	rCMEff_Tot:=Round:C94((rCMStd_Tot/rCMAct_Tot)*100; 1)
Else 
	rCMEff_Tot:=0
End if 
If (rCMDown_Hrs#0)
	rCMDown_Pct:=Round:C94((rCMDown_Hrs/(rCMAct_Tot+rCMDown_Hrs))*100; 1)
Else 
	rCMDown_Pct:=0
End if 
If (rCMAct_Run#0)
	rCMAct_Imp:=Round:C94(rCMSheets/rCMAct_Run; 0)
Else 
	rCMAct_Imp:=0
End if 
If (rCMStd_Run#0)
	rCMStd_Imp:=Round:C94(rCMSheets/rCMStd_Run; 0)
Else 
	rCMStd_Imp:=0
End if 