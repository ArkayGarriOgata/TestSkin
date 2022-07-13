If ([Finished_Goods:26]Status:14="Final")
	If (User in group:C338(Current user:C182; "Planners"))
		FG_LockDown(True:C214)
	Else 
		BEEP:C151
		ALERT:C41("Only planners can change the status to 'Final'.")
		[Finished_Goods:26]Status:14:=Old:C35([Finished_Goods:26]Status:14)
	End if 
End if 
//