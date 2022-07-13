//Partial Case btn
//@author mlb - 11/21/01  15:49

//wmsCaseNumber1:=-100
uConfirm("Enter the actual quantity or zero to leave blank."; "Acutal"; "Blank")
If (ok=1)
	GOTO OBJECT:C206(wmsCaseQty)
	
Else 
	wmsCaseQty:=0
	$caseID:=WMS_CaseId(""; "set"; sJMI; wmsCaseNumber1; wmsCaseQty)
	wmsCaseId1:=WMS_CaseId($caseID; "barcode")
	wmsHumanReadable1:=WMS_CaseId($caseID; "human")
End if 