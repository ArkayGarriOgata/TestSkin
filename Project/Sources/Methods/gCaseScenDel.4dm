//%attributes = {"publishedWeb":true}
//gCaseScenDel: Deletion of file [CaseScenario]

QUERY:C277([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]DiffId:1=[Estimates_Differentials:38]Id:1)
If (Records in selection:C76([Estimates_DifferentialsForms:47])>0)
	ALERT:C41("Case Form is listed in Case Scenario record.  Form record must be deleted first.")
Else 
	gDeleteRecord(->[Estimates_Differentials:38])
End if 