//%attributes = {}
//Method:  Qury_OM_Button(tButtonName)
//Description:  This method handles the button

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tButtonName)
	
	$tButtonName:=$1
	
End if   //Done Initialize

Case of   //Button
		
	: ($tButtonName="Qury_View_nSearch")
		
		Qury_View_Search(Form:C1466.cQuery)
		
	: ($tButtonName="Qury_View_nRemove")
		
		Qury_View_Remove($pnButton)
		
	: ($tButtonName="Qury_View_nOnLoad")
		
		Qury_View_OnLoad
		
End case   //Done button
