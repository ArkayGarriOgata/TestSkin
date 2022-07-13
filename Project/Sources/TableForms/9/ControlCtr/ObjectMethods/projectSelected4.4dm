Pjt_setReferId(pjtId)
ViewSetter(1; ->[Estimates:17])

If (False:C215)
	FORM SET INPUT:C55([Estimates:17]; "OnePage")
	iMode:=1
	filePtr:=->[Estimates:17]
	zDefFilePtr:=->[Estimates:17]
	SET MENU BAR:C67(<>DefaultMenu)  //Apple File Edit Window
	sFile:=Table name:C256(filePtr)
	fileNum:=Table:C252(filePtr)
	GET WINDOW RECT:C443($left; $top; $right; $bottom; pjtWindow)
	$width:=$right-$left
	$height:=$bottom-$top
	SET WINDOW RECT:C444($left; $top; $left+790; $top+430; pjtWindow)
	ADD RECORD:C56([Estimates:17]; *)
	FORM SET INPUT:C55([Estimates:17]; "Input")
	GET WINDOW RECT:C443($left; $top; $right; $bottom; pjtWindow)
	SET WINDOW RECT:C444($left; $top; $left+$width; $top+$height; pjtWindow)
End if 