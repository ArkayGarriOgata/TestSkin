// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 02/07/13, 11:28:03
// ----------------------------------------------------
// Method: [zz_control].FGEvent.bTHC
// ----------------------------------------------------

<>ThcBatchDat:=!00-00-00!
<>InvCalcDone:=False:C215
<>JobCalcDone:=False:C215
<>JobBatchDat:=!00-00-00!

$id:=uSpawnProcess("BatchTHCcalc"; 64000; "TimeHorizonCalc"; True:C214; False:C215)