// _______
// Method: [Finished_Goods].AskMe.CARbtn   ( ) ->
// By: Mel Bohince @ 09/24/19, 12:09:33
// Description
// 
// ----------------------------------------------------

SET QUERY DESTINATION:C396(Into set:K19:2; "◊PassThroughSet")
QUERY:C277([QA_Corrective_Actions:105]; [QA_Corrective_Actions:105]ProductCode:7=sCPN)
SET QUERY DESTINATION:C396(Into current selection:K19:1)

If (Records in set:C195("◊PassThroughSet")>0)
	$sFile:=sFile  //cover a side effect of Viewsetter
	<>PassThrough:=True:C214
	ViewSetter(3; ->[QA_Corrective_Actions:105])
	sFile:=$sFile  //Table name(->[Request])  `reset this for normal exit 
	If (Records in selection:C76([QA_Corrective_Actions:105])>0)
		REDUCE SELECTION:C351([QA_Corrective_Actions:105]; 0)
	End if 
Else 
	uConfirm("No CAR records found for "+sCPN; "OK"; "Help")
End if 

