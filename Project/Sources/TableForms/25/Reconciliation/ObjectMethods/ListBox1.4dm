// _______
// Method: [Raw_Materials_Locations].Reconciliation.ListBox1   ( ) ->
// Description
// get labels related to this po
// ----------------------------------------------------
// Modified by: MelvinBohince (4/5/22) disable Review RM btn until there is a selection


Case of 
	: (Form event code:C388=On Selection Change:K2:29)
		LOAD RECORD:C52([Raw_Materials_Locations:25])
		RELATE MANY:C262([Raw_Materials_Locations:25]pk_id:32)
		ORDER BY:C49([Raw_Material_Labels:171]; [Raw_Material_Labels:171]Label_id:2; >)
		
		OBJECT SET ENABLED:C1123(*; "reviewRawMaterial"; True:C214)  // must select a po on the left list // Modified by: MelvinBohince (4/5/22) 
		
End case 

