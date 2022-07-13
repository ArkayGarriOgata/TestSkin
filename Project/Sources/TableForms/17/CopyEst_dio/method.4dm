//•051096 MLB
Case of 
	: (Form event code:C388=On Load:K2:1)
		sCriterion1:=String:C10(Year of:C25(Current date:C33)-2000)+"-0000.00"
		HIGHLIGHT TEXT:C210(sCriterion1; 3; (Length:C16(sCriterion1)+1))
		If (Length:C16(<>pjtId)=5)
			sCriterion1:=<>EstNo
		End if 
		rb1:=1
		sb2:=1  //•051096 MLB
End case 
//