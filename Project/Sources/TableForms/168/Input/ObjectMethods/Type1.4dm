If (Form event code:C388=On Data Change:K2:15)
	xlImpRemaining:=DieBoardGetImpressions(->xlImpressions)
	REDRAW WINDOW:C456
End if 