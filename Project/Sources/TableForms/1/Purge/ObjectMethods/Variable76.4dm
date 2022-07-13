C_DATE:C307($PurgeDate)
$PurgeDate:=Date:C102(FiscalYear("start"; 4D_Current_date))
$min:=4D_Current_date-$PurgeDate+1
If (rFG62<$min)
	BEEP:C151
	ALERT:C41("You must keep this fiscal year's transactions.")
	rFG62:=$min
End if 
//