//FM: TransEvent() -> 
//@author Mel - 5/21/03  11:03

Case of 
	: (Form event code:C388=On Close Box:K2:21)
		<>rmXferInquire:=True:C214
		<>fgXferInquire:=True:C214
		CANCEL:C270
End case 