//%attributes = {}
//Method:  Core_Window_FitObject
//Description:  This method will fit text objects to full view and resize the window

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nObject; $nNumberOfObjects)
	C_LONGINT:C283($nBestHeight; $nBestWidth; $nMaxWidth)
	C_LONGINT:C283($nLeft; $nTop; $nRight; $nBottom)
	C_LONGINT:C283($nDifference; $nGrowVertically)
	C_LONGINT:C283($nMaxWidth; $nObjectHeight; $nObjectType)
	C_LONGINT:C283($nResizeHorizontal; $nResizeVertical)
	C_LONGINT:C283($nHeight)
	C_LONGINT:C283($nScreenHeight)
	C_LONGINT:C283($nVerticalMargin)
	
	C_TEXT:C284($tObjectName)
	
	ARRAY TEXT:C222($atObjectName; 0)
	
	$nObject:=0
	$nNumberOfObjects:=0
	$nBestHeight:=0
	$nBestWidth:=0
	$nMaxWidth:=0
	$nLeft:=0
	$nTop:=0
	$nRight:=0
	$nBottom:=0
	$nDifference:=0
	$nGrowVertically:=0
	$nMaxWidth:=0
	$nObjectHeight:=0
	$nObjectType:=0
	$nResizeHorizontal:=0
	$nResizeVertical:=0
	$nHeight:=0
	
	$nScreenHeight:=Screen height:C188
	$nVerticalMargin:=20
	
	$tObjectName:=CorektBlank
	
	FORM GET OBJECTS:C898($atObjectName)
	
	$nNumberOfObjects:=Size of array:C274($atObjectName)
	
End if   //Done Initialize

For ($nObject; 1; $nNumberOfObjects)  //Loop thru all the objects on the form
	
	$tObjectName:=$atObjectName{$nObject}
	
	$nObjectType:=OBJECT Get type:C1300(*; $tObjectName)
	
	OBJECT GET RESIZING OPTIONS:C1176(*; $tObjectName; $nResizeHorizontal; $nResizeVertical)
	
	Case of   //Object grows vertically
		: ($nResizeVertical#1)
		: (Not:C34(($nObjectType=Object type listbox:K79:8) | ($nObjectType=Object type text input:K79:4)))
		Else   //Listbox can be resized vertically
			
			OBJECT GET COORDINATES:C663(*; $tObjectName; $nLeft; $nTop; $nRight; $nBottom)
			
			$nObjectHeight:=$nBottom-$nTop
			$nMaxWidth:=$nRight-$nLeft
			
			OBJECT GET BEST SIZE:C717(*; $tObjectName; $nBestWidth; $nBestHeight; $nMaxWidth)
			
			$nDifference:=$nBestHeight-$nObjectHeight
			
			$nGrowVertically:=$nGrowVertically+$nDifference
			
	End case   //Done object grows vertically
	
End for   //Done looping thru all the objects on the form

GET WINDOW RECT:C443($nLeft; $nTop; $nRight; $nBottom; Current form window:C827)

If (($nBottom+$nGrowVertically)>$nScreenHeight)  //Set window or resize window
	
	$nHeight:=(($nBottom+$nGrowVertically)-$nTop)
	
	$nBottom:=($nScreenHeight-$nVerticalMargin)
	
	$nTop:=$nVerticalMargin
	
	SET WINDOW RECT:C444($nLeft; $nTop; $nRight; $nBottom)
	
Else   //Resize window
	
	RESIZE FORM WINDOW:C890(0; $nGrowVertically)
	
End if   //Done set window or resize window
