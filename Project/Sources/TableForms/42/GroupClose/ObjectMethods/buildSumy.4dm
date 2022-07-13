// _______
// Method: [Job_Forms].GroupClose.buildSumy   ( ) ->
// Description get a selection of jobform which have been closed with no budgeted qty, why? idk

QUERY:C277([Job_Forms:42]; [Job_Forms_CloseoutSummaries:87]QtyBudgeted:24=0; *)  // BEGIN 4D Professional Services : January 2019 query selection
QUERY:C277([Job_Forms:42]; [Job_Forms:42]Status:6="Closed")

SELECTION TO ARRAY:C260([Job_Forms:42]JobFormID:5; aJFID; [Jobs:15]CustomerName:5; aCustName; [Jobs:15]Line:3; aLine)  //*dump into an array for user selection
SORT ARRAY:C229(aJFID; aCustName; aLine)
ARRAY TEXT:C222(aRpt; Size of array:C274(aJFID))
vSel:=0
For ($i; 1; Size of array:C274(aRpt))
	aRpt{$i}:="√"
	vSel:=vSel+1
End for 
vTotRec:=vSel