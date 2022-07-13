//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 02/01/07, 13:46:02
// ----------------------------------------------------
// Method: trigger_WMS_Compositions()  --> 
// ----------------------------------------------------

If (Length:C16([WMS_Compositions:124]Container:1)>0) & (Length:C16([WMS_Compositions:124]Content:2)>0)
	[WMS_Compositions:124]CompKey:3:=[WMS_Compositions:124]Container:1+":"+[WMS_Compositions:124]Content:2
End if 