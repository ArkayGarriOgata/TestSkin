//%attributes = {"publishedWeb":true}
//gCCDel: Deletion for file [COST_CENTER]

QUERY:C277([Estimates_Machines:20]; [Estimates_Machines:20]CostCtrID:4=[Cost_Centers:27]ID:1)
If (Records in selection:C76([Estimates_Machines:20])>0)
	ALERT:C41("Cost Center is listed in Route and Materials record.  R&M record must be deleted")
Else 
	gDeleteRecord(->[Cost_Centers:27])  //•092895  MLB 
End if 