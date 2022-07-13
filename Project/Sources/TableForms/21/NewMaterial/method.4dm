//(LP) [RAW_MATERIALS]Input
<>iLayout:=2100+FORM Get current page:C276
Case of 
	: (Form event code:C388=On Load:K2:1)
		beforeRM
		OBJECT SET ENABLED:C1123(bDelete; False:C215)
	: (Form event code:C388=On Validate:K2:3)
		uUpdateTrail(->[Raw_Materials:21]ModDate:47; ->[Raw_Materials:21]ModWho:48; ->[Raw_Materials:21]ConvertPrice_D:36)
End case 
//EOLP