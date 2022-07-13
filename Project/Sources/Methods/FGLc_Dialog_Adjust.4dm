//%attributes = {}
//  Method:  FGLc_Dialog_Adjust()
//  Description:  Displays a dialog for user to give reason why they are making adjustment

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nWindowReference)
	
End if   //Done Initialize

$nWindowReference:=Open form window:C675("FGLc_Adjust")

SET WINDOW TITLE:C213("FG Locations that are Negative"; $nWindowReference)

DIALOG:C40("FGLc_Adjust")

CLOSE WINDOW:C154($nWindowReference)

<>FGLcnProcessAdujst:=0
