//%attributes = {"publishedWeb":true}
//PM:  FG_Display  2/14/00  mlb
//show a fg record in its own process

C_TEXT:C284($1)
C_LONGINT:C283($2; $iMode)

READ ONLY:C145([Finished_Goods:26])
$numfound:=qryFinishedGood("#CPN"; $1)

If ($numfound>0)
	If (Count parameters:C259=2)
		$iMode:=$2
	Else 
		If (iMode=2)
			$iMode:=iMode
		Else 
			$iMode:=3
		End if 
	End if 
	pattern_PassThru(->[Finished_Goods:26])
	ViewSetter($iMode; ->[Finished_Goods:26])
	//$winRef:=OpenFormWindow (->[Finished_Goods];"Input")
	//iMode:=3
	//filePtr:=->[Finished_Goods]
	//zDefFilePtr:=filePtr
	//MENU BAR(◊DefaultMenu)  `Apple File Edit Window
	//sFile:=Table name(filePtr)
	//fileNum:=Table(filePtr)
	//INPUT FORM([Finished_Goods];"Input")
	//OUTPUT FORM([Finished_Goods];"List")
	//DISPLAY SELECTION([Finished_Goods])
	//CLOSE WINDOW($winRef)
	
Else 
	uConfirm($1+" was not found in the Finished Goods file."; "OK"; "Help")
End if 