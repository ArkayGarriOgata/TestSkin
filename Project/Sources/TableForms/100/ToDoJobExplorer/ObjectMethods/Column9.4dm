If (Form event code:C388=On Data Change:K2:15)
	If (aDateDone{ListBox1}#!00-00-00!)
		If (Not:C34(aDone{ListBox1}))
			aDone{ListBox1}:=True:C214
		End if 
		
		If (Length:C16(aDoneBy{ListBox1})=0)
			aDoneBy{ListBox1}:=<>zResp
		End if 
		
	Else 
		aDone{ListBox1}:=False:C215
		aDoneBy{ListBox1}:=""
	End if 
End if 