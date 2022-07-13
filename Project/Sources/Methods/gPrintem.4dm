//%attributes = {"publishedWeb":true}
//(P) gPrintem
// Modified by: Mel Bohince (6/9/21) use storage
C_REAL:C285($cc_found)

If (True:C214)  //last_yr_down
	$cc_found:=CostCtrCurrent("desc"; aPrevMach; ->aMachDesc)
	aMach:=String:C10($cc_found)
	rDownBud:=CostCtrCurrent("down"; aMach)
	rCMDown_Bud:=rDownBud
	rLYDown_Bud:=CostCtrCurrent("last_yr_down"; aMach)
	
Else   //old way
	
	QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=aPrevMach)
	aMach:=aPrevMach
	aMachDesc:=[Cost_Centers:27]Description:3
	rDownBud:=[Cost_Centers:27]DownBudget:11
	rCMDown_Bud:=[Cost_Centers:27]DownBudget:11
	rLYDown_Bud:=[Cost_Centers:27]LY_DownBudget:41
End if   //new way


Print form:C5([Job_Forms_Machine_Tickets:61]; "ProdAnalCum_H")
gCalcLY
Print form:C5([Job_Forms_Machine_Tickets:61]; "ProdAnalCum_L")
For (zzi; 1; zzend)
	gCalcCY
	Print form:C5([Job_Forms_Machine_Tickets:61]; "ProdAnalCum_D")
End for 
gZeroLY
gZeroCY

