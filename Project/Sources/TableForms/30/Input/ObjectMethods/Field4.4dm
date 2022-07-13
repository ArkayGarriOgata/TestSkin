SELECTION TO ARRAY:C260([Customers_Addresses:31]AddressType:3; $aType)
If (Find in array:C230($aType; "Bill to")>-1)
	CONFIRM:C162("Changing this Prefix could invalidate the existing open A/R."+Char:C90(13)+"Change anyway?"; "Change"; "Cancel")
	If (ok=0)
		Self:C308->:=Old:C35(Self:C308->)
	Else 
		Self:C308->:=Uppercase:C13(Self:C308->)
		[Addresses:30]UpdateDynamics:35:=TSTimeStamp
		If (Length:C16([Addresses:30]FlexwarePrefix:37)=0)
			[Addresses:30]FlexwarePrefix:37:=Invoice_CustomerMapping
		End if 
	End if 
End if 