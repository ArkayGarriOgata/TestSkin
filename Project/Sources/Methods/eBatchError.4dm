//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 12/05/05, 16:15:32
// ----------------------------------------------------
// Method: eBatchError
// Description:
// Installed before each batch session so one error doesnt' kill everything
// ----------------------------------------------------

batchErr:=Error

utl_Logfile("BatchRunner.Log"; "Error "+String:C10(batchErr)+" during "+aCustName{currentBatch})