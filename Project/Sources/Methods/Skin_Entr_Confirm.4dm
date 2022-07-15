//%attributes = {}
//Method: Skin_Entr_Confirm()
//Description: This method will ensure there are selected files 
// and convert them to 4-state icons

If (Form:C1466.cSources.count()>=0)
	Skin_Init4State
Else 
	ALERT:C41("No vaild picture files selected")
End if 
