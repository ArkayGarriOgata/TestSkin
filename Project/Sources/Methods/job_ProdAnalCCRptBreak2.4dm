//%attributes = {}
//job_ProdAnalCCRptBreak
// Modified by: Mel Bohince (6/9/21) use Storage
C_REAL:C285($cc_found)
aGroupDesc:=""
aMachDesc:=""

aMach:=[Job_Forms_Machine_Tickets:61]CostCenterID:2
//QUERY([COST_CENTER];[COST_CENTER]ID=[MachineTicket]CostCenterID)

//mlb 08/12/03 use cache
If (True:C214)  // Modified by: Mel Bohince (6/9/21) 
	$cc_found:=CostCtrCurrent("desc"; aMach; ->aMachDesc)
	$cc_found:=CostCtrCurrent("group"; aMach; ->aGroupDesc)
	rDown_Bud:=CostCtrCurrent("down"; aMach)
	
Else   //old way
	$element:=CostCtrCurrent("Desc"; aMach)
	aGroupDesc:=aCostCtrGroup{$element}
	aMachDesc:=aCostCtrDes{$element}
	rDown_Bud:=CostCtrCurrent("Down"; aMach)
End if 

rDown_Hrs:=Subtotal:C97(rDown_Hrs)
rSheets:=Subtotal:C97(rSheets)
rAct_MR:=Subtotal:C97(rAct_MR)
rStd_MR:=Subtotal:C97(rStd_MR)
If (rAct_MR#0)
	rEff_MR:=Round:C94((rStd_MR/rAct_MR)*100; 1)
Else 
	rEff_MR:=0
End if 
rAct_Run:=Subtotal:C97(rAct_Run)
rStd_Run:=Subtotal:C97(rStd_Run)
If (rAct_Run#0)
	rEff_Run:=Round:C94((rStd_Run/rAct_Run)*100; 1)
Else 
	rEff_Run:=0
End if 
rAct_Tot:=Subtotal:C97(rAct_Tot)
rStd_Tot:=Subtotal:C97(rStd_Tot)
If (rAct_Tot#0)
	rEff_Tot:=Round:C94((rStd_Tot/rAct_Tot)*100; 1)
Else 
	rEff_Tot:=0
End if 
//rDown_Hrs:=Subtotal(rDown_Hrs)

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