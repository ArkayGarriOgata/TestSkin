//(s) [user]preference'iminutes
Case of 
	: ((Self:C308-><10) & (Self:C308->#0)) | (Self:C308-><0)
		ALERT:C41("Time interval MUST be a positive number no less than 10 minutes.")
		Self:C308->:=0
	: (Self:C308->>240)
		ALERT:C41("Time interval MUST be a less than or equal to 4 hours.")
		Self:C308->:=240
End case 
//