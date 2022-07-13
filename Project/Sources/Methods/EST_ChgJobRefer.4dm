//%attributes = {"publishedWeb":true}
//PM:  EST_ChgJobRefer  
//set a family of estimates to a common job number
//110899  mlb chg to array to select and test locked set
//formerly  `Procedure: uChgEstJob()  082295  MLB
//•091495
//•031297  mBohince  reduce the selection

C_TEXT:C284($est)  //1/25/95
C_LONGINT:C283($job; $numEst; $i)

$est:=<>EstNo
$job:=<>JobNo
<>EstNo:=""
<>JobNo:=0

If (Length:C16($est)>=6) & ($job#0)  //•091495
	READ WRITE:C146([Estimates:17])
	QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=Substring:C12($est; 1; 6)+"@")  //;*)
	$numEst:=Records in selection:C76([Estimates:17])
	ARRAY LONGINT:C221($aJobNum; $numEst)
	For ($i; 1; $numEst)
		$aJobNum{$i}:=$job
	End for 
	
	Repeat 
		zwStatusMsg("ESTIMATE"; "Changing job number of estimates "+$est+" to "+String:C10($job))
		ARRAY TO SELECTION:C261($aJobNum; [Estimates:17]JobNo:50)
		DELAY PROCESS:C323(Current process:C322; 60)
	Until (Records in set:C195("LockedSet")=0)
	
	REDUCE SELECTION:C351([Estimates:17]; 0)
End if 