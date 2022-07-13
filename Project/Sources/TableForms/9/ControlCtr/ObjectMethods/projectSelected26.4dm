Pjt_setReferId(pjtId)
$tablePtr:=->[Finished_Goods_SizeAndStyles:132]
If (Records in set:C195("clickedIncludeRecord")>0)
	
	UNLOAD RECORD:C212($tablePtr->)
	CUT NAMED SELECTION:C334($tablePtr->; "hold")
	USE SET:C118("clickedIncludeRecord")
	
	
	rfc_MakeLiner([Finished_Goods_SizeAndStyles:132]FileOutlineNum:1)
	FORM GOTO PAGE:C247(ppHome)
	SELECT LIST ITEMS BY POSITION:C381(tc_PjtControlCtr; 1)
	
	USE NAMED SELECTION:C332("hold")
	
Else 
	uConfirm("Please select a "+"Finished_Goods_SizeAndStyles"+" record(s) to update."; "OK"; "Help")
End if 