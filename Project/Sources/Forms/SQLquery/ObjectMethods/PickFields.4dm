// _______
// Method: SQLquery.PickFields   ( ) ->
// By: Mel Bohince
// Description
// 
// ----------------------------------------------------
Case of 
	: (Form event code:C388=On Double Clicked:K2:5)
		$prefix:=Substring:C12(tText; 1; cursorPosition-1)
		$suffix:=Substring:C12(tText; cursorPosition)
		tText:=$prefix+aFieldNames{Box3}+$suffix
		GOTO OBJECT:C206(tText)
		
	: (Form event code:C388=On Begin Drag Over:K2:44)  // Modified by: Mel Bohince (4/7/20) change to set Text to pasteboard
		SET TEXT TO PASTEBOARD:C523(aFieldNames{Box3})
		
End case 
