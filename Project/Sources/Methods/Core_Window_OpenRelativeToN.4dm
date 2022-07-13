//%attributes = {}
//Method:  Core_Window_OpenRelativeToN({oWindow})=>nWindowReference
//Description:  This method will open a window relative to a current window or a window passed

//Example:
//   C_OBJECT($oWindow)
//   C_LONGINT($nWindowReference)

//   $oWindow:=New object()

//   $oWindow.tFormName:={Form name defaults to current form name)
//   $oWindow.nRelativeWindowRefeference:={Window Reference defaults to current form window}
//   $oWindow.nWindowType:={WindowType defaults to sheet window}
//   $oWindow.nHeight:={Height to set defaults to form height}
//   $oWindow.tTitle:={Title of Window defaults to blank}
//   $oWindow.tCloseWindow:={Close Window method defaults to no close window}
//.         usually "Core_Window_CloseBox"

//   $nWindowReference:=Core_Window_OpenRelativeToN($oWindow)

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oWindow)  //Properties of both new window and relative window
	C_LONGINT:C283($0; $nWindowReference)  //New window reference
	
	C_LONGINT:C283($nRelativeLeft; $nRelativeTop; $nRelativeRight; $nRelativeBottom)
	C_LONGINT:C283($nRelativeHeigth; $nRelativeWidth)
	
	C_LONGINT:C283($nLeft; $nTop; $nRight; $nBottom)  //Location of new window
	
	C_LONGINT:C283($nWidth; $nHeight)
	
	C_TEXT:C284($tFormName)
	
	C_TEXT:C284($tTitle; $tCloseWindow)
	
	$oWindow:=New object:C1471()
	
	If (Count parameters:C259>=1)
		$oWindow:=$1
	End if 
	
	Case of   //tFormName
			
		: (Not:C34(OB Is defined:C1231($oWindow; "tFormName")))
			
			OB SET:C1220($oWindow; "tFormName"; Current form name:C1298)
			
		: ($oWindow.tFormName=CorektBlank)
			
			OB SET:C1220($oWindow; "tFormName"; Current form name:C1298)
			
	End case   //tFormName
	
	$tFormName:=$oWindow.tFormName  //Use $tFormName where $oWindow.tFormName does not work compiled
	
	$tTitle:=CorektBlank
	$tCloseWindow:=CorektBlank
	
	If (Not:C34(OB Is defined:C1231($oWindow; "nRelativeWindowRefeference")))
		
		OB SET:C1220($oWindow; "nRelativeWindowReference"; Current form window:C827)
		
	End if 
	
	If (Not:C34(OB Is defined:C1231($oWindow; "nWindowType")))
		
		OB SET:C1220($oWindow; "nWindowType"; Sheet window:K34:15)
		
	End if 
	
	If (OB Is defined:C1231($oWindow; "tTitle"))
		$tTitle:=$oWindow.tTitle
	End if 
	
	If (OB Is defined:C1231($oWindow; "tCloseWindow"))
		$tCloseWindow:=$oWindow.tCloseWindow
	End if 
	
	If ($oWindow.nRelativeWindowReference#0)  //Open relative too
		
		GET WINDOW RECT:C443($nRelativeLeft; $nRelativeTop; $nRelativeRight; $nRelativeBottom; $oWindow.nRelativeWindowReference)  //Relative window reference
		
	Else   //Open based on screen size
		
		$nRelativeLeft:=Screen width:C187/2
		$nRelativeRight:=Screen width:C187/2
		$nRelativeTop:=Int:C8(Screen height:C188/3)
		$nRelativeBottom:=Screen height:C188-20
		
	End if   //Done open relative too
	
	FORM GET PROPERTIES:C674($tFormName; $nWidth; $nHeight)
	
	If (OB Is defined:C1231($oWindow; "nHeight"))
		$nHeight:=$oWindow.nHeight
	End if 
	
	$nRelativeWidth:=$nRelativeRight-$nRelativeLeft  //Width of relative window (need to know which is wider relative or new)
	$nRelativeHeigth:=$nRelativeBottom-$nRelativeTop
	
End if   //Done Initialize

Case of   //Set left
		
	: ($nRelativeLeft<10)  //Less than 10
		
		$nLeft:=10  //make it 10
		
	: ($nRelativeLeft>=(Screen width:C187-$nWidth))  //More than screen width
		
		$nLeft:=Screen width:C187-($nWidth+10)
		
	: ($nRelativeWidth>$nWidth)  //Width of relative window is greater than width of new window
		
		$nLeft:=($nRelativeLeft+(($nRelativeWidth-$nWidth)/2))  //Center to relative window
		
	: ($nRelativeWidth<=$nWidth)  //Width of relative window is less than width of new window
		
		$nLeft:=($nRelativeLeft-(($nWidth-$nRelativeWidth)/2))  //Relative window is centered to new window
		
End case   //Done set left

$nRight:=$nLeft+$nWidth

If ($nRight>Screen width:C187)  //Adjust right
	
	$nRight:=Screen width:C187-10
	$nLeft:=$nRight-$nWidth
	
End if   //Done adjust right

//Set Top
$nTop:=Choose:C955(($nRelativeTop<10); 10; $nRelativeTop)

$nBottom:=$nTop+$nHeight

If ($nBottom>Screen height:C188)  //Adjust bottom and top
	
	$nBottom:=Screen height:C188-10
	$nTop:=$nBottom-$nHeight
	
End if   //Done adjust bottom and top

$nWindowReference:=Open window:C153($nLeft; $nTop; $nRight; $nBottom; $oWindow.nWindowType; $tTitle; $tCloseWindow)

$0:=$nWindowReference