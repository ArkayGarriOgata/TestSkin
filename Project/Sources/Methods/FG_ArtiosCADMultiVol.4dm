//%attributes = {}
// Method: FG_ArtiosCADMultiVol(tDocumentName)
// Description:  Create the
// ----------------------------------------------------
// User name (OS): Garri Ogata
// Date and time: 09/14/21, 15:38:23
// ----------------------------------------------------

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tDocumentName)
	C_TEXT:C284($tEngDraw; $tEngDraw20182019)
	C_OBJECT:C1216($oAsk)
	
	$tDocumentName:=$1
	
	$tEngDraw:="/EngDraw/"+$tDocumentName+".pdf"
	$tEngDraw20182019:="/EngDraw_before_2018/"+$tDocumentName+".pdf"
	
	$oAsk:=New object:C1471()
	$oAsk.tMessage:="The document "+$tDocumentName+" was not found. Please contact IT and make sure the Engineering Servers are mounted."
	
End if   //Done initialize

Case of   //Launch
		
	: (util_Launch_External_App($tEngDraw)=0)
	: (util_Launch_External_App($tEngDraw20182019)=0)
		
	Else   //Failed
		
		Core_Dialog_Alert($oAlert)
		
End case   //Done launch

