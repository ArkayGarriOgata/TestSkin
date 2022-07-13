Case of 
	: (Form event code:C388=On Load:K2:1)
		rb1:=1
		tMessage1:="Starts with:"
		SetObjectProperties("crit@"; -><>NULL; True:C214)
		sCriterion1:=""
		If (Length:C16(<>JobForm)=8)
			sCriterion1:=<>JobForm
		End if 
		GOTO OBJECT:C206(sCriterion1)
		
End case 