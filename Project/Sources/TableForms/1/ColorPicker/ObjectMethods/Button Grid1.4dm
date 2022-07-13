//OM: Button Grid1() -> 
//@author mlb - 3/28/02  10:46

Case of 
	: (rb1=1)
		i1:=gridBtn-1
	: (rb2=1)
		i2:=gridBtn-1
End case 

i3:=-(i1+(256*i2))
Core_ObjectSetColor(->xText; i3)

zwStatusMsg("Color"; String:C10(i1)+" foreground, "+String:C10(i2)+" background")