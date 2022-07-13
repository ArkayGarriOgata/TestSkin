READ WRITE:C146([Job_Forms_Items:44])
QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=[Finished_Goods:26]ProductCode:1; *)
QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Glued:33=!00-00-00!)
If (Records in selection:C76([Job_Forms_Items:44])>0)
	APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]Category:31:=[Finished_Goods:26]OriginalOrRepeat:71)
End if 
REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)