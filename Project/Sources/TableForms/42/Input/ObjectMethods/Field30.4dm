//(s)
uConfirm("You are changing the caliper of this Jobform."+Char:C90(13)+" The original Caliper was: "+String:C10(Old:C35(Self:C308->))+" new value is: "+String:C10(Self:C308->); "Forget"; "Keep")

If (OK=1)
	Self:C308->:=Old:C35(Self:C308->)
	If ([Process_Specs:18]ID:1#[Job_Forms:42]ProcessSpec:46)
		READ ONLY:C145([Process_Specs:18])
		QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=[Job_Forms:42]ProcessSpec:46)
	End if 
	t4:=String:C10([Job_Forms:42]Caliper:49; "0.000#")+" "+[Process_Specs:18]Stock:7
End if 
//