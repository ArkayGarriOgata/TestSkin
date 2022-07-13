//%attributes = {}
//Method:  Cust_Color_SetExample
//Description: This method is called when a radio button is clicked.
//. it handles the radio buttons and coloring the text
//. Use form Core_Tmpl_Color to get the decimal value of the color

If (True:C214)  //Initialize
	
	C_BOOLEAN:C305($bSetForeground; $bSetBackground)
	
	C_OBJECT:C1216($oForeground; $oBackground)
	
	C_LONGINT:C283($nForeground; $nBackground)
	
	C_COLLECTION:C1488($cForeground)
	C_COLLECTION:C1488($cBackground)
	
	$bSetForeground:=False:C215
	$bSetBackground:=False:C215
	
	$cForeground:=New collection:C1472()
	
	$cForeground.push(New object:C1471("tColor"; "TextBlack"; "nValue"; 0))
	$cForeground.push(New object:C1471("tColor"; "TextGrey"; "nValue"; 8421504))
	$cForeground.push(New object:C1471("tColor"; "TextPurple"; "nValue"; 8388736))
	$cForeground.push(New object:C1471("tColor"; "TextRed"; "nValue"; 16711680))
	$cForeground.push(New object:C1471("tColor"; "TextBlue"; "nValue"; 205))
	
	$cBackground:=New collection:C1472()
	
	$cBackground.push(New object:C1471("tColor"; "BackWhite"; "nValue"; 16777215))
	$cBackground.push(New object:C1471("tColor"; "BackYellow"; "nValue"; 16776960))
	$cBackground.push(New object:C1471("tColor"; "BackGold"; "nValue"; 16766720))
	$cBackground.push(New object:C1471("tColor"; "BackSteelBlue"; "nValue"; 11650269))
	$cBackground.push(New object:C1471("tColor"; "BackGreen"; "nValue"; 32768))
	
	$tObjectName:="ExampleOfColor"
	
	$bSetForeground:=True:C214
	$bSetBackground:=True:C214
	
End if   //Done initialize

Core_RadioButton  //Set button group

For each ($oForeground; $cForeground) While ($bSetForeground)  //Foreground
	
	If (OBJECT Get pointer:C1124(Object named:K67:5; $oForeground.tColor)->=1)  //Found
		
		$bSetForeground:=False:C215
		$nForeground:=$oForeground.nValue
		
	End if   //Done found
	
End for each   //Done foreground

For each ($oBackground; $cBackground) While ($bSetBackground)  //Background
	
	If (OBJECT Get pointer:C1124(Object named:K67:5; $oBackground.tColor)->=1)  //Found
		
		$bSetBackground:=False:C215
		$nBackground:=$oBackground.nValue
		
	End if   //Done found
	
End for each   //Done background

OBJECT SET RGB COLORS:C628(*; $tObjectName; $nForeground; $nBackground)
