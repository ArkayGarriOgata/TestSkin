If (Form event code:C388=On Data Change:K2:15)
	If (Length:C16(aDoneBy{ListBox1})>0)
		If (Not:C34(aDone{ListBox1}))
			aDone{ListBox1}:=True:C214
		End if 
		
		If (aDateDone{ListBox1}=!00-00-00!)
			aDateDone{ListBox1}:=4D_Current_date
		End if 
		
	Else 
		aDone{ListBox1}:=False:C215
		aDateDone{ListBox1}:=!00-00-00!
	End if 
End if 