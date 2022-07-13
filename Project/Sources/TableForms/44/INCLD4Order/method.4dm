If (Form event code:C388=On Display Detail:K2:22)
	If ([Job_Forms_Items:44]Completed:39#!00-00-00!)
		Core_ObjectSetColor(->[Job_Forms_Items:44]Qty_Actual:11; -(Red:K11:4+(256*Light grey:K11:13)); True:C214)
	Else 
		Core_ObjectSetColor(->[Job_Forms_Items:44]Qty_Actual:11; -(Black:K11:16+(256*White:K11:1)); True:C214)
	End if 
End if 