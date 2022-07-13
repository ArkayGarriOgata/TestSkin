<>iLayout:=41  //(LP) [RAW_MATERALS]'Choose
If ((Form event code:C388=On Display Detail:K2:22) & (Not:C34(Form event code:C388=On Load:K2:1)) & (bCancel=0))  //User double-clicked
	ACCEPT:C269
End if 
//EOLP