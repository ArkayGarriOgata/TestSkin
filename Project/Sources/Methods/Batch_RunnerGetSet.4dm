//%attributes = {}
// Method: Batch_RunnerGetSet (->[BatchEmailDistributions]Daily;"√") -> 
// ----------------------------------------------------
// by: mel: 12/14/04, 16:24:20
// ----------------------------------------------------
// Description:
// check mark all in a set
// • mel (12/21/04, 11:17:20) remove dependency on id of batchname, use it only as execution order
// ----------------------------------------------------

C_LONGINT:C283($i; $id)
C_POINTER:C301($1)
C_TEXT:C284($2)

READ ONLY:C145([y_batches:10])
QUERY:C277([y_batches:10]; $1->=True:C214)
SELECTION TO ARRAY:C260([y_batches:10]BatchName:1; $aName)  //[BatchEmailDistributions]id;$aFamily;
REDUCE SELECTION:C351([y_batches:10]; 0)

For ($i; 1; Size of array:C274($aName))
	$hit:=Find in array:C230(aCustName; $aName{$i})
	If ($hit>-1)
		//$id:=$aFamily{$i}
		asBull{$hit}:=$2
	End if 
End for 