//%attributes = {}
// Method: Batch_RunnerGetOptions () -> 
// ----------------------------------------------------
// by: mel: 12/14/04, 16:39:07
// ----------------------------------------------------
// Description:
// load the arrays, based on Batch_RunnerOptions
// ----------------------------------------------------

ARRAY TEXT:C222(aCustName; 0)
ARRAY TEXT:C222(asBull; 0)

READ ONLY:C145([y_batches:10])
QUERY:C277([y_batches:10]; [y_batches:10]sort_order:3>0)
//control order of execution by id
ORDER BY:C49([y_batches:10]; [y_batches:10]sort_order:3; >)
SELECTION TO ARRAY:C260([y_batches:10]BatchName:1; aCustName)
ARRAY TEXT:C222(asBull; Size of array:C274(aCustName))
REDUCE SELECTION:C351([y_batches:10]; 0)