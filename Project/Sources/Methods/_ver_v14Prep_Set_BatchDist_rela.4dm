//%attributes = {}
// Method: _ver_v14Prep_Set_BatchDist_rela ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 06/13/14, 10:38:52
// ----------------------------------------------------
// Description
// 
//
// ----------------------------------------------------

ALL RECORDS:C47([y_batches:10])
READ WRITE:C146([y_batch_distributions:164])

C_LONGINT:C283($i; $numRecs)

$numRecs:=Records in selection:C76([y_batches:10])
$i:=0
uThermoInit($numRecs; "Updating Records")
While (Not:C34(End selection:C36([y_batches:10])))
	QUERY:C277([y_batch_distributions:164]; [y_batch_distributions:164]future:6=[y_batches:10]_future2:8)
	APPLY TO SELECTION:C70([y_batch_distributions:164]; [y_batch_distributions:164]BatchName:1:=[y_batches:10]BatchName:1)
	
	NEXT RECORD:C51([y_batches:10])
	uThermoUpdate($i)
	$i:=$i+1
End while 

uThermoClose