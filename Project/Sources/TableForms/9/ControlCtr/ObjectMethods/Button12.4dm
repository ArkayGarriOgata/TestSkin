//app_OpenSelectedIncludeRecords (->[Job_Forms]JobFormID)

Pjt_setReferId(pjtId)
$tablePtr:=->[Finished_Goods_SizeAndStyles:132]
If (Records in set:C195("clickedIncludeRecord")>0)
	UNLOAD RECORD:C212($tablePtr->)
	CUT NAMED SELECTION:C334($tablePtr->; "hold")
	USE SET:C118("clickedIncludeRecord")
	
	
	FG_PrepServiceJobSummary([Job_Forms:42]JobFormID:5)
	USE NAMED SELECTION:C332("hold")
	
Else 
	uConfirm("Please select a "+"Finished_Goods_SizeAndStyles"+" record(s) to update."; "OK"; "Help")
End if 