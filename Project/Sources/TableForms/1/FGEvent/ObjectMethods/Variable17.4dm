//Script: bPU()  092795  MLB
//•092795  MLB  UPR 1729
C_TEXT:C284(<>POnum)
C_LONGINT:C283(BillingId)
<>POnum:=""
BillingId:=uSpawnProcess("doBillPayU"; 0; "Bill a Pay-U"; True:C214; False:C215)
If (False:C215)
	doBillPayU
End if 