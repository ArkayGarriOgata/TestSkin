If (Self:C308->="099-Other")
	ALERT:C41("Comment required when 099-Other is picked as a downtime.")
	GOTO OBJECT:C206(*; "eComment")
End if 