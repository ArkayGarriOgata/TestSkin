//(LOP) rfq included
If (Form event code:C388=On Display Detail:K2:22)
	RELATE MANY:C262([Estimates_Carton_Specs:19]CartonSpecKey:7)
	N1:=Records in selection:C76([Estimates_FormCartons:48])
End if 
//