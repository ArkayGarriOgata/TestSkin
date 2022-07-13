//(s) Posted

If (Self:C308->>5) | (Self:C308-><0)
	ALERT:C41("Valid 'Posted' status' are 1 thru 5")
	Self:C308->:=Old:C35(Self:C308->)
End if 