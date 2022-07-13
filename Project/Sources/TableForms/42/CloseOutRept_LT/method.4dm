//(LOP) [JOB];"CloseoutRept_D"
If (Form event code:C388=On Display Detail:K2:22)
	If (fBold)
		OBJECT SET FONT STYLE:C166(aSubTitle; 1)
	Else 
		OBJECT SET FONT STYLE:C166(aSubTitle; 0)
	End if 
	If (zzi=10)
		OBJECT SET FORMAT:C236(rD4; "##.000;-##.000; ")
		OBJECT SET FORMAT:C236(rD5; "##.000;-##.000; ")
		OBJECT SET FORMAT:C236(rD6; "##.000;-##.000; ")
		OBJECT SET FORMAT:C236(rD9; "##.000;-##.000; ")
	End if 
End if 
//EOLP