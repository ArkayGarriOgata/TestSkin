$caseID:=WMS_CaseId(""; "set"; sJMI; wmsCaseNumber1; wmsCaseQty)
wmsCaseId1:=WMS_CaseId($caseID; "barcode")
wmsHumanReadable1:=WMS_CaseId($caseID; "human")