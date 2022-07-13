If (Length:C16(<>aPrinterNames{0})=0)
	uConfirm("Pick a printer name or cancel."; "OK"; "Help")
	REJECT:C38
End if 