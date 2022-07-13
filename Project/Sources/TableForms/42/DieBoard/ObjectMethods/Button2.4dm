uConfirm("Do you wish to mark this Die Board as 'Killed'?"; "Kill"; "Cancel")
If (ok=1)
	[Job_DieBoards:152]Bin:4:="Kill"
	[Job_DieBoards:152]DateBinOut:5:=4D_Current_date
End if 