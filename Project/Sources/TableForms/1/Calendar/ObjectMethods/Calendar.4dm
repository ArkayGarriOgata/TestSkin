C_LONGINT:C283($vl_selectedCell; $vl_lastDayOfThisMonth)
If (Form event code:C388=On Clicked:K2:4)
	$vl_selectedCell:=(Self:C308->)-vl_firstDayOfThisMonth+1
	$vl_lastDayOfThisMonth:=Day of:C23(vd_endOfMonthFlag-1)
	If (($vl_selectedCell>0) & ($vl_selectedCell<=$vl_lastDayOfThisMonth))
		vp_recieverDateVar->:=Cal_getFormatedDate(vl_currentYear; vl_currentMonth; $vl_selectedCell)
		ACCEPT:C269
	Else 
		BEEP:C151
		Self:C308->:=0
		CANCEL:C270
	End if 
End if 