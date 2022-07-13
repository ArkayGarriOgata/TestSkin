//(S) bCalc
//If (Not(◊fRev))

zwStatusMsg("Get Actuals"; "Please Wait...")


wWindowTitle("Push"; "Jobform {actuals} Calculating "+[Job_Forms:42]JobFormID:5+" Please Wait...")

jobform:=[Job_Forms:42]JobFormID:5
zwStatusMsg("SERVER REQUEST"; "Allocate "+jobform)
Job_ExecuteOnServer("client-prep"; "get-actuals"; jobform)
zwStatusMsg("SERVER REQUEST"; "Waiting for "+jobform)
fCalcAlloc:=Job_ExecuteOnServer("exchange")

wWindowTitle("Pop")

BEEP:C151
zwStatusMsg("Allocate Actuals"; "Finished.")