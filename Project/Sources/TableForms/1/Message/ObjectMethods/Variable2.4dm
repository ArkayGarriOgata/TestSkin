//(s) [control]message
//• 6/4/97 cs created
util_PAGE_SETUP(->[zz_control:1]; "Portrait")  //setup printing page
PRINT SETTINGS:C106

If (OK=1)
	$text:=xText  //save contents since x_printtext clears xtext
	rPrintText
	xText:=$Text  //redisplay xtext
End if 