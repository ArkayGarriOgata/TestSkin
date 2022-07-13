//(s) rReal1 [control]directbillink
If (Self:C308-><0)
	ALERT:C41("Quantity to Issue MSUT be positive.")
	Self:C308->:=0
End if 
//