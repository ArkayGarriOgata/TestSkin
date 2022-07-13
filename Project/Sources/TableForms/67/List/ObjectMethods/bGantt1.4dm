//bGantt 12/13/01 Systems G4

<>jobform:=util_getKeyFromListing(->[Job_Forms_Master_Schedule:67]JobForm:4)
If (Length:C16(<>jobform)=8)
	PS_showScheduleForJob(<>jobform)
End if 