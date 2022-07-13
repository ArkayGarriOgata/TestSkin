If (Form event code:C388=On Clicked:K2:4)
	vl_currentMonth:=Month of:C24(Current date:C33)
	vl_currentYear:=Year of:C25(Current date:C33)
	Cal_draw
End if 