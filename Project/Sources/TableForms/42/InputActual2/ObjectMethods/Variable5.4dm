//bzSort: Sort Items
If (Records in selection:C76([Job_Forms_Items:44])>0)
	ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3; >)
End if 
//EOP