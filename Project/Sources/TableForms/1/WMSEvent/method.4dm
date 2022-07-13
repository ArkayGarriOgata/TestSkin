If (Form event code:C388=On Load:K2:1)
	OBJECT SET ENABLED:C1123(*; "move"; False:C215)
	If (User in group:C338(Current user:C182; "Physical Inv Manager"))
		OBJECT SET ENABLED:C1123(*; "move"; True:C214)
	End if 
	
	OBJECT SET ENABLED:C1123(*; "amswms@"; False:C215)
	rb1:=1  //wms
	rb2:=0  //iUI
	
	//v0.1.0-JJG (05/10/16) - added block
	WMS_API_LoginLookup
	If (<>fWMS_Use4D)
		WA OPEN URL:C1020(WebArea; <>ttWMS_4D_URL)
	End if 
	OBJECT SET VISIBLE:C603(rb1; <>fWMS_Use4D)
	OBJECT SET VISIBLE:C603(rb2; True:C214)  //Not(<>fWMS_Use4D))
	OBJECT SET ENABLED:C1123(rb2; False:C215)
	//v0.1.0-JJG (05/10/16) - end of added block
	WA OPEN URL:C1020(WebArea; "http://192.168.3.98:8080")
End if 