//%attributes = {"publishedWeb":true}
//gCaseFormDel: Deletion of file [CaseForm]

QUERY:C277([Estimates_FormCartons:48]; [Estimates_FormCartons:48]DiffFormID:2=[Estimates_DifferentialsForms:47]DiffFormId:3)
If (Records in selection:C76([Estimates_FormCartons:48])>0)
	DELETE SELECTION:C66([Estimates_FormCartons:48])
End if 
QUERY:C277([Estimates_Machines:20]; [Estimates_Machines:20]DiffFormID:1=[Estimates_DifferentialsForms:47]DiffFormId:3)
If (Records in selection:C76([Estimates_Machines:20])>0)
	DELETE SELECTION:C66([Estimates_Machines:20])
End if 
gDeleteRecord(->[Estimates_DifferentialsForms:47])