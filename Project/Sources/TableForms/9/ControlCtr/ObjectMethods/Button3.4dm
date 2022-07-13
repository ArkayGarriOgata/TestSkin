ARRAY LONGINT:C221(axlRecordNums; 0)

Pjt_setReferId(pjtId)

CtlCtrGetArrays(->abArtLB; ->axlRecNums; ->axlRecordNums)
CREATE SET FROM ARRAY:C641([Finished_Goods_Specifications:98]; axlRecordNums; "clickedIncludeRecord")

$tablePtr:=->[Finished_Goods_Specifications:98]
If (Records in set:C195("clickedIncludeRecord")=1)
	USE SET:C118("clickedIncludeRecord")
	FG_copyControlLikeOtherFG
	ControlCtrManageLB("ArtFillLB")
	
Else 
	uConfirm("Please select only one "+Table name:C256($tablePtr)+" record to duplicate."; "OK"; "Help")
End if 