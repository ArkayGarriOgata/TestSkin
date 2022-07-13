//FM: ColorPicker() -> 
//@author mlb - 3/28/02  10:36

Case of 
	: (Form event code:C388=On Load:K2:1)
		Core_ObjectSetColor(->xText; i3)
		rb1:=1
		rb2:=0
		gridBtn:=(-1*i3)+1
		zwStatusMsg("Color"; String:C10(i1)+" foreground, "+String:C10(i2)+" background")
End case 