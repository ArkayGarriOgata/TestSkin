C_OBJECT:C1216($oAlert)

$oAlert:=New object:C1471()

$oAlert.tMessage:="Select an Outline#"

Case of   //Validate
		
	: (aOutlineNum<=0)
		
		Core_Dialog_Alert($oAlert)
		
	: (aOutlineNum{aOutlineNum}=CorektBlank)
		
		Core_Dialog_Alert($oAlert)
		
	Else   //Valid
		
		Arts_PlayVideo(aOutlineNum{aOutlineNum})
		
End case   //Done validate

