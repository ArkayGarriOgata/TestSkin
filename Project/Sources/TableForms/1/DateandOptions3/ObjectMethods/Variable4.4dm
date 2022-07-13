//(s) cbPrint2Dis
Case of 
	: (Self:C308->=1) & (rbOrig=0)
		ALERT:C41("This option is only functional for 'Vendor Only' report.")
		Self:C308->:=0
End case 
//