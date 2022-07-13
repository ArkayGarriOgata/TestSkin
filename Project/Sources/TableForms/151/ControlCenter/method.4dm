Case of 
	: (Form event code:C388=On Load:K2:1)
		Form:C1466.toolDrawers.data:=ds:C1482.Tool_Drawers.all().orderBy("Bin asc")
		
		C_LONGINT:C283(vlWindowCounter)
		vlWindowCounter:=0
		
		C_BOOLEAN:C305(bRedrawList)
		bRedrawList:=False:C215  //set by detail form 
		SET TIMER:C645(60*3)  //check to see if a redraw of the list is necessary
		
	: (Form event code:C388=On Close Detail:K2:24)
		Form:C1466.toolDrawers.data:=ds:C1482.Tool_Drawers.all().orderBy("Bin asc")
		
	: (Form event code:C388=On Timer:K2:25)
		If (bRedrawList)
			Form:C1466.toolDrawers.data:=Form:C1466.toolDrawers.data
			bRedrawList:=False:C215
		End if 
		
End case 
