//%attributes = {"publishedWeb":true}
//JIC_Remove(jobit)->recnº 111599  mlb
//delete a JobItemCost record

READ WRITE:C146([Job_Forms_Items_Costs:92])

QUERY:C277([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]Jobit:3=$1)
If (Records in selection:C76([Job_Forms_Items_Costs:92])=1)  //subform situation may have already created
	DELETE RECORD:C58([Job_Forms_Items_Costs:92])
End if 

If (Records in selection:C76([Job_Forms_Items_Costs:92])=0)
	$0:=0
Else 
	$0:=Record number:C243([Job_Forms_Items_Costs:92])
End if 