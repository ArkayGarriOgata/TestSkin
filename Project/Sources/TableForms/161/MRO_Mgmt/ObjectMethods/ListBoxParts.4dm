
Case of 
	: (Form event code:C388=On Load:K2:1)
		
	: (Form event code:C388=On Selection Change:K2:29)
		Form:C1466.part:=Form:C1466.clickedPart
		
	: (Form event code:C388=On Double Clicked:K2:5)
		
		Form:C1466.part:=Form:C1466.clickedPart
		FORM GOTO PAGE:C247(3)
		
	: (Form event code:C388=On Begin Drag Over:K2:44)
		zwStatusMsg("Dragging"; Form:C1466.clickedPart.Raw_Matl_Code)
		
End case 