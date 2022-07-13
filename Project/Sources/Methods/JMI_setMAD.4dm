//%attributes = {"publishedWeb":true}
//PM: JMI_setMAD() -> 
//@author mlb - 2/6/03  11:15

QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=[Job_Forms_Items:44]JobForm:1)
If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
	[Job_Forms_Items:44]MAD:37:=[Job_Forms_Master_Schedule:67]MAD:21
End if 