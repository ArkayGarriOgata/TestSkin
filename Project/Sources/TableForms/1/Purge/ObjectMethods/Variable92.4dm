C_DATE:C307($PurgeDate)
$PurgeDate:=Date:C102(FiscalYear("start"; 4D_Current_date))
If (dEndDate>$PurgeDate)
	BEEP:C151
	ALERT:C41("You must keep this fiscal year's transactions.")
	dEndDate:=$PurgeDate
End if 
//
//If (Self->>4D_Current_date)
//ALERT("Invalid Date Entry")
//Self->:=4D_Current_date-365
//End if 