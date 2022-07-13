C_DATE:C307($PurgeDate)
$PurgeDate:=Date:C102(FiscalYear("start"; 4D_Current_date))
$min:=4D_Current_date-$PurgeDate
If (r37<$min)
	BEEP:C151
	ALERT:C41("You must keep this fiscal year's transactions.")
	r37:=$min
End if 
//