//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/12/06, 13:26:26
// ----------------------------------------------------
// Method: $winRef:=OpenFormWindow(filePtr;"Input";->windowTitle{;"useFormTitle";WindowType})
// Description:
// Memic Open Form Window but with offsetting
// ----------------------------------------------------

C_POINTER:C301($1; $3)  //pointer to table of the form
C_TEXT:C284($2; $4; $formTitle)  //name of form, {use form title for window or value passed}
C_LONGINT:C283($left; $top; $right; $bottom; $width; $height; $numPages; $0; $5)
C_BOOLEAN:C305($fixedWidth; $fixedHeight)

$0:=-1

//get set up
If ($2#"*")  //set the input form
	$baseForm:=$2
	FORM SET INPUT:C55($1->; $2)
Else   //use exisiting input form to get the dimensions
	$baseForm:="Input"
End if 

FORM GET PROPERTIES:C674($1->; $baseForm; $width; $height; $numPages; $fixedWidth; $fixedHeight; $formTitle)
//decide on window title bar
$params:=Count parameters:C259
$useThisWindowTitle:=""
Case of 
	: ($params>=4)  //passed the window title
		If (Length:C16($4)>0)
			$useThisWindowTitle:=$4
			//$3->:=$useThisWindowTitle
		Else 
			$useThisWindowTitle:=$3->
		End if 
		
	: ($params=3)  //prefix existing window titles with record count
		If (Length:C16($3->)>0)
			$currentTitle:=$3->
			If (Length:C16(sFile)>0) & (filePtr#<>NIL_PTR)
				$useThisWindowTitle:=fNameWindow(filePtr)+$currentTitle
			Else 
				$useThisWindowTitle:=$currentTitle
			End if 
		Else 
			$useThisWindowTitle:=$formTitle
		End if 
		//$3->:=$useThisWindowTitle
		
	Else   //use the form's title property
		$useThisWindowTitle:=$formTitle
End case 

//set the position of the window
If (($width+<>winX)>Screen width:C187) | (($height+<>winY)>Screen height:C188)  //the window would open off screen, so reset to the upper left
	<>winX:=2
	<>winY:=80
End if 

If (Count parameters:C259>2)
	//$xlPosition:=Position(":";$useThisWindowTitle)-1
	//if($xlPosition>0)
	//$tWinTitle:=Substring($useThisWindowTitle;1;$xlPosition)
	//Else 
	//$tWinTitle:=
	//end if
	If (WindowPositionGet($3->; ->$left; ->$top; ->$right; ->$bottom; $width; $height))  // Added by: Mark Zinke (11/12/12)
	Else 
		$left:=<>winX
		$top:=<>winY
		$right:=$width+<>winX
		$bottom:=$height+<>winY
	End if 
Else 
	$left:=<>winX
	$top:=<>winY
	$right:=$width+<>winX
	$bottom:=$height+<>winY
End if 

//do it!
If (Count parameters:C259=5)  // Added by: Mark Zinke (10/11/13) Allow other types of windows.
	$0:=Open window:C153($left; $top; $right; $bottom; $5; $useThisWindowTitle; "wCloseCancel")
Else 
	$0:=Open window:C153($left; $top; $right; $bottom; Plain form window:K39:10; $useThisWindowTitle; "wCloseCancel")  //wCloseWinBox
End if 
//increment the tiling coordinates
<>winX:=<>winX+20
<>winY:=<>winY+20