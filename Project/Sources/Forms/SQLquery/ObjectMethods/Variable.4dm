// _______
// Method: SQLquery.Variable   ( ) ->
// By: Mel Bohince
// Description
// 
// ----------------------------------------------------
Case of 
	: (Form event code:C388=On Losing Focus:K2:8)
		GET HIGHLIGHT:C209(tText; $startSel; cursorPosition)
		
	: (Form event code:C388=On Getting Focus:K2:7)
		GET HIGHLIGHT:C209(tText; cursorPosition; cursorPosition)
		
	: (Form event code:C388=On Drop:K2:12)
		$phrase:=Get text from pasteboard:C524  // Modified by: Mel Bohince (4/7/20)DRAG_AND_DROP_PROPERTIES is being deprecated
		
		$prefix:=Substring:C12(tText; 1; cursorPosition-1)
		$suffix:=Substring:C12(tText; cursorPosition)
		tText:=$prefix+$phrase+$suffix
		$len:=Length:C16($phrase)+1
		HIGHLIGHT TEXT:C210(tText; cursorPosition; cursorPosition+$len-1)
		GOTO OBJECT:C206(tText)
		
	: (Form event code:C388=On Load:K2:1)
		cursorPosition:=1
		
End case 

