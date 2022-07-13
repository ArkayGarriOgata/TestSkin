//%attributes = {"invisible":true,"shared":true}
//Method:  Core_Window_Resize({nHorizontalPixels;nVerticalPixels})
//Description:  This will resize the frontmost window by nPixels

//   or (else part with no parameters)

//   This method allows a moveable floating window to be resized
//     It works on mouse events so although it works it has some strange behaviors.
//     If the user moves the mouse through the resize box the window may resize depending on
//     the speed of the movement.

//    The way it is intended to work is the user will click on the button and hold the mouse down
//    while moving the mouse to the desired location.  When the mouse is released the window
//    will resize to where the mouse is located.

If (True:C214)  //Initialize
	
	C_BOOLEAN:C305($bResizeWindow)
	
	C_LONGINT:C283($1; $2; $nHorizontalPixels; $nVerticalPixels)
	C_LONGINT:C283($nLeft; $nTop; $nRight; $nBottom)
	C_LONGINT:C283($nHorizontalOffset; $nVerticalOffset)
	C_LONGINT:C283($nTotalRight; $nTotalBottom; $nScreenRight; $nScreenBottom)
	C_LONGINT:C283($nNumberOfParameters)
	
	C_LONGINT:C283($nFormEvent)
	
	C_LONGINT:C283($nObjectLeft; $nObjectTop; CorenObjectRight; CorenObjectBottom)
	C_LONGINT:C283($nMouseX; $nMouseY; $nMouseButton)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$bResizeWindow:=True:C214
	
	If ($nNumberOfParameters=2)  //Reset window
		
		$nHorizontalPixels:=$1
		$nVerticalPixels:=$2
		
		$bResizeWindow:=False:C215
		
		$nHorizontalOffset:=0
		$nVerticalOffset:=0
		
		GET WINDOW RECT:C443($nLeft; $nTop; $nRight; $nBottom)
		
		$nTotalRight:=$nRight+$nHorizontalPixels
		$nTotalBottom:=$nBottom+$nVerticalPixels
		
		$nScreenRight:=Screen width:C187
		$nScreenBottom:=Screen height:C188
		
		If ($nTotalRight>$nScreenRight)  //Horizontal offset
			
			$nHorizontalOffset:=$nTotalRight-$nScreenRight
			
		End if   //Done horizontal offset
		
		If ($nTotalBottom>$nScreenBottom)  //Vertical offset
			
			$nVerticalOffset:=$nTotalBottom-$nScreenBottom
			
		End if   //Done vertical offset
		
	End if   //Done reset window
	
End if   //Done Initialize

If ($bResizeWindow)  //Resize window
	
	$nFormEvent:=Form event code:C388
	
	Case of   //Which mouse event
			
		: ($nFormEvent=On Mouse Enter:K2:33)
			
			OBJECT GET COORDINATES:C663(OBJECT Get pointer:C1124->; $nObjectLeft; $nObjectTop; CorenObjectRight; CorenObjectBottom)  //Get the current size of the resize icon
			
		: ($nFormEvent=On Mouse Leave:K2:34)
			
			GET MOUSE:C468($nMouseX; $nMouseY; $nMouseButton)
			
			RESIZE FORM WINDOW:C890($nMouseX-CorenObjectRight; $nMouseY-CorenObjectBottom)
			
	End case   //Done which mouse event
	
Else   //Set window
	
	SET WINDOW RECT:C444($nLeft-$nHorizontalOffset; $nTop-$nVerticalOffset; $nRight+$nHorizontalPixels-$nHorizontalOffset; $nBottom+$nVerticalPixels-$nVerticalOffset)
	
End if   //Done resize window
