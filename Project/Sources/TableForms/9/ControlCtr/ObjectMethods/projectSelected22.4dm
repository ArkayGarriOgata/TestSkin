ARRAY LONGINT:C221(axlRecordNums; 0)

Pjt_setReferId(pjtId)

CtlCtrGetArrays(->abSandS; ->axlRecNums; ->axlRecordNums)
CREATE SET FROM ARRAY:C641([Finished_Goods_SizeAndStyles:132]; axlRecordNums; "clickedIncludeRecord")

If (Records in set:C195("clickedIncludeRecord")=1)
	USE SET:C118("clickedIncludeRecord")
	rfc_duplicate([Finished_Goods_SizeAndStyles:132]FileOutlineNum:1)
	ControlCtrManageLB("SSFillLB")
Else 
	uConfirm("Please select only one Finished_Goods_SizeAndStyles record to update."; "OK"; "Help")
End if 