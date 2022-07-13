//(s) [process_spec]id
If (Self:C308->#Old:C35(Self:C308->)) & (Old:C35(Self:C308->)#"")
	ALERT:C41("To Change the ID of this Process Spec You MUST Use the 'Rename' Button.")
	Self:C308->:=Old:C35(Self:C308->)
End if 