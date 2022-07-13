uConfirm("Have you printed the current Requisition?"; "Yes, make new"; "Go Back")
If (ok=1)
	$r:=Char:C90(13)
	
	tText:="__________________"+$r
	tText:=tText+"["+[Job_DieBoards:152]PO:16+"]"+$r
	tText:=tText+String:C10([Job_DieBoards:152]DateRequired:17)+" "
	tText:=tText+[Job_DieBoards:152]Contact:18+$r
	tText:=tText+("Order Blanker"*Num:C11([Job_DieBoards:152]OrderBlanker:9))+", "
	tText:=tText+("Order FSB"*Num:C11([Job_DieBoards:152]OrderFSB:10))+", "
	tText:=tText+("Order Die"*Num:C11([Job_DieBoards:152]OrderDie:11))+$r
	tText:=tText+[Job_DieBoards:152]HowTrans:12+", "
	tText:=tText+[Job_DieBoards:152]Knifed:13+", "
	tText:=tText+[Job_DieBoards:152]Counters:14+$r
	tText:=tText+[Job_DieBoards:152]SpecialRequirements:15+$r
	tText:=tText+"•••"+$r
	[Job_DieBoards:152]PriorPOs:26:=tText+[Job_DieBoards:152]PriorPOs:26
	
	[Job_DieBoards:152]PO:16:=""
	[Job_DieBoards:152]DateRequired:17:=!00-00-00!
	[Job_DieBoards:152]Contact:18:=""
	[Job_DieBoards:152]OrderBlanker:9:=False:C215
	[Job_DieBoards:152]OrderFSB:10:=False:C215
	[Job_DieBoards:152]OrderDie:11:=False:C215
	[Job_DieBoards:152]HowTrans:12:=""
	[Job_DieBoards:152]Knifed:13:=""
	[Job_DieBoards:152]Counters:14:=""
	[Job_DieBoards:152]SpecialRequirements:15:=""
	
	
	aProvided{0}:=[Job_DieBoards:152]HowTrans:12
	aStandard{0}:=[Job_DieBoards:152]Knifed:13
	aStyle{0}:=[Job_DieBoards:152]Counters:14
	
	util_FloatingAlert("Prior PO's:"+$r+[Job_DieBoards:152]PriorPOs:26)
	
	GOTO OBJECT:C206([Job_DieBoards:152]PO:16)
End if 