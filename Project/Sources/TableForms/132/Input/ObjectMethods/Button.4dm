If (Current user:C182="Brian Hopkins") | (Current user:C182="Designer")
	If ([Finished_Goods_SizeAndStyles:132]Brian_Approval:60=!00-00-00!)
		[Finished_Goods_SizeAndStyles:132]Brian_Approval:60:=4D_Current_date
	Else 
		uConfirm("Remove the 'Brian Approval'?"; "Remove"; "Cancel")
		If (ok=1)
			[Finished_Goods_SizeAndStyles:132]Brian_Approval:60:=!00-00-00!
		End if 
	End if 
	
Else 
	uConfirm("You don't click like Mr. Hopkins, no date for you!"; "Sorry"; "Nice Try")
End if 