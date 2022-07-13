Case of 
	: (Form event code:C388=On Load:K2:1)
		//OBJECT SET FONT(Self->;"%Password")
	Else 
		<>EMAIL_POP3_PASSWORD:=[z_administrators:2]POP3_PASSWORD:28
End case 
