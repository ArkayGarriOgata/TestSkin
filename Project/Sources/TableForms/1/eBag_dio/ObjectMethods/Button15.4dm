// ----------------------------------------------------
// User name (OS): mlb
// Date and time: 9/18/02  15:04
// ----------------------------------------------------
// Object Method: [zz_control].eBag_dio.Button15
// SetObjectProperties, Mark Zinke (5/15/13)
// ----------------------------------------------------

$i:=DOC_ShowLinkedDocuments(sCriterion1)

$linkedDocs:=DOC_CountLinkedDocuments(sCriterion1)
Case of 
	: ($linkedDocs=1)
		SetObjectProperties(""; ->bShowLinkedDocs; True:C214; String:C10($linkedDocs)+" Linked Document")
	: ($linkedDocs>0)
		SetObjectProperties(""; ->bShowLinkedDocs; True:C214; String:C10($linkedDocs)+" Linked Documents")
	Else 
		SetObjectProperties(""; ->bShowLinkedDocs; True:C214; "Link Documents to Job")
End case 