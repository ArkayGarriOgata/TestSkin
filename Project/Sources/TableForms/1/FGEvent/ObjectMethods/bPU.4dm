// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 02/07/13, 11:23:12
// ----------------------------------------------------
// Method: [zz_control].FGEvent.bPU
// ----------------------------------------------------

C_TEXT:C284(<>POnum)
C_LONGINT:C283(BillingId)

<>POnum:=""
BillingId:=uSpawnProcess("doBillPayU"; 0; "Bill a Pay-U"; True:C214; False:C215)